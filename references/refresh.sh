#!/bin/bash
# 一次資料の再取得と差分チェック。SKILL.md は変更しない。
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
cd "$here"
UA='Mozilla/5.0'
JP='https://www.digital.go.jp/policies/mynumber/private-business/jpki-introduction'
EN='https://www.digital.go.jp/en/policies/mynumber/private-business/jpki-introduction'
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT

echo "== ページ取得 =="
if ! curl -fsSL -A "$UA" "$JP" -o "$tmp/jp.html"; then
  echo "!! 日本語ページの取得に失敗しました: $JP"; exit 1
fi
if ! curl -fsSL -A "$UA" "$EN" -o "$tmp/en.html"; then
  echo "!! 英語ページの取得に失敗しました: $EN"; exit 1
fi

echo "== PDF リンク抽出 =="
grep -oE 'href="[^"]*\.pdf"' "$tmp/jp.html" "$tmp/en.html" \
  | sed -E 's/.*href="//; s/"$//' \
  | sed -E 's#^/#https://www.digital.go.jp/#' | sort -u > "$tmp/live_urls.txt" || true
if [ ! -s "$tmp/live_urls.txt" ]; then
  echo "!! ページから PDF リンクを 1 件も抽出できませんでした。ページ構造が変わった可能性があります。"
  exit 1
fi
grep -oE 'https?://[^ |)]+\.pdf' sources.md | sort -u > "$tmp/known_urls.txt"

echo "-- 新規（sources.md に無い）--"
comm -23 "$tmp/live_urls.txt" "$tmp/known_urls.txt" || true
echo "-- 消滅（ページに無い）--"
comm -13 "$tmp/live_urls.txt" "$tmp/known_urls.txt" || true

echo "== 既知 PDF の再取得と SHA256 比較 =="
# PDF は第三者の著作物のためリポジトリに含めない。pdfs/ はローカルキャッシュ（.gitignore 対象）で、
# 比較の基準は sources.md に記録した SHA256。
mkdir -p pdfs
while read -r url; do
  [ -z "$url" ] && continue
  row=$(grep -F "$url" sources.md | head -1 || true)
  f=$(printf '%s\n' "$row" | grep -oE 'pdfs/[^ |]+\.pdf' | head -1 || true)
  [ -z "$f" ] && { echo "?? ファイル未対応: $url"; continue; }
  if ! curl -fsSL -A "$UA" "$url" -o "$tmp/new.pdf"; then
    echo "!! 取得失敗（HTTP エラー等）: $f  <- $url"
    continue
  fi
  if ! head -c 5 "$tmp/new.pdf" | grep -q '%PDF' || [ "$(wc -c < "$tmp/new.pdf")" -lt 1000 ]; then
    echo "!! PDF ではない/小さすぎる応答: $f  <- $url （上書きしない）"
    continue
  fi
  old=$(printf '%s\n' "$row" | grep -oE '[0-9a-f]{64}' | head -1 || true)
  new=$(shasum -a 256 "$tmp/new.pdf" | awk '{print $1}')
  cp "$tmp/new.pdf" "$f"
  if [ "$old" != "$new" ]; then
    echo "CHANGED  $f"
    echo "  old=${old:-（sources.md に記録なし）}"
    echo "  new=$new"
  else
    echo "same     $f"
  fi
done < "$tmp/known_urls.txt"

echo
echo "== e-Gov 法令リビジョンの確認（hourei-eKYC.md との突合。上書きはしない）=="
# hourei-eKYC.md に記録した「取得リビジョン: <id>」と、e-Gov 法令検索 API v2 が現在返す
# リビジョン ID を突き合わせる。ズレていたら hourei-eKYC.md / method-map.md /
# honnin-kakunin-houhou の号記号を人が見直す。
# 同じ LawId が複数節に現れる（現行版と未施行版）ため、記録リビジョンは第 4 引数の節
# （`## <番号>.` 見出し）内の「取得リビジョン」行からのみ読む。
check_law() {
  local lawid="$1" asof="$2" label="$3" sec="$4" url recorded live
  url="https://laws.e-gov.go.jp/api/2/law_data/${lawid}"
  [ -n "$asof" ] && url="${url}?asof=${asof}"
  recorded=$(awk -v s="## ${sec}." 'index($0, s) == 1 { f = 1; next } f && /^## / { exit } f && /取得リビジョン/ { print; exit }' hourei-eKYC.md \
    | grep -oE "${lawid}_[0-9]{8}_[0-9A-Za-z]+" | head -1 || true)
  if [ -z "$recorded" ]; then
    echo "?? 記録リビジョンが見つからない: ${label}（hourei-eKYC.md の「## ${sec}.」節に ${lawid} の取得リビジョン行が無い）"
    return
  fi
  if ! curl -fsSL -A "$UA" "$url" -o "$tmp/law.json"; then
    echo "!! 取得失敗: ${label} (${url})"
    return
  fi
  live=$(grep -oE "${lawid}_[0-9]{8}_[0-9A-Za-z]+" "$tmp/law.json" | head -1 || true)
  if [ -z "$live" ]; then
    echo "?? リビジョン ID を抽出できず: ${label}（API 応答形式が変わった可能性）"
  elif [ "$live" = "$recorded" ]; then
    echo "same     ${label}  (${live})"
  else
    echo "CHANGED  ${label}"
    echo "  記録 = ${recorded:-なし}"
    echo "  現在 = ${live}"
    echo "  → hourei-eKYC.md の抜粋・method-map.md・honnin-kakunin-houhou の号記号を人が再確認"
  fi
}
check_law "420M60000F5A001" ""           "犯収法施行規則（現行）"                1
check_law "420M60000F5A001" "2027-04-01" "犯収法施行規則（2027-04-01 未施行版）" 2
check_law "417M60000008167" ""           "携帯法施行規則（現行）"                3
check_law "414AC0000000153" ""           "公的個人認証法（現行）"                4
check_law "407M50400000010" ""           "古物営業法施行規則（現行）"            5

echo
echo "次の手順:"
echo " 1. CHANGED の行を CHANGELOG-sources.md に記録"
echo " 2. sources.md の SHA256 と取得日を更新"
echo " 3. CHANGED 資料の『使用スキル』列のスキルを見直し（このスクリプトは SKILL.md を変更しない）"
echo " 4. e-Gov 法令が CHANGED の場合は hourei-eKYC.md の抜粋とリビジョン ID を取り直し、"
echo "    method-map.md / honnin-kakunin-houhou の号記号を人が突合"
