# ekyc-jp — plugin eval suites (triggering)

115 cases across the 19 skills. Each skill has 4 **fire** cases
(the skill *should* be consulted) and 2 **no-fire** near-misses (a related
request a sibling skill — or no skill — should handle); `signature-verification`
has a 3rd no-fire case guarding its boundary with `ekyc-session-orchestration`.

## Layout

```
evals/<skill>/fire-NN/   (or neg-NN)
  prompt.md            # frontmatter + the user prompt
  graders/*.md         # one grader per file (type: in frontmatter)
```

Grader format (from `claude plugin eval`, CLI 2.1.x):

| type | frontmatter | body |
|---|---|---|
| `tool_used` | `tool`, `input_match`, `min`, `max`, `arm: with-only\|both` | — |
| `llm` | `focus: last_message\|trace\|files`, `weight` | rubric |
| `regex` | `target`, `match: contains\|not_contains\|count:N`, `flags` | pattern |
| `file_exists` | `path`, `exists` | — |
| `tool_order` | `before`, `after` | — |

- **fire** cases: `skill-fires.md` is a `tool_used` check on the `Skill` tool
  with `input_match: <skill>` — `arm` is omitted, so under `--ablation
  with-without` it is a *display-only* plugin-fired indicator (not scored).
  `answer-is-grounded.md` is the scored `llm` outcome grader: with the plugin
  loaded the answer should reflect that skill's specific guidance; without it,
  the baseline arm cannot, so the Δ measures the uplift.
- **no-fire** cases: `skill-stays-quiet.md` (`min: 0, max: 0, arm: both`) is the
  scored "must not over-trigger this skill" check; `right-response-instead.md`
  is a scored `llm` grader that the right thing happened.

## Run

```bash
cd ekyc-jp
claude plugin eval . --ablation with-without --judge-model sonnet
# one skill only:
claude plugin eval . --case 'jpki-overview/*' --ablation with-without
# local report, no publish:
claude plugin eval . --ablation with-without --no-publish --report /tmp/ekyc-eval.html
```

`plugin eval` is currently early-access; if the CLI rejects a grader key,
check `claude plugin eval --help` for the current schema and adjust the
grader frontmatter (the case/prompt layout is stable).

## Notes for maintainers

- Prompts are realistic end-user asks (mostly Japanese, some English) covering
  ≥2 distinct shapes per skill, per the eval-authoring floor invariants
  (≥1 no-fire case per skill, ≥1 outcome grader per case, `runs: 3`).
- `answer-is-grounded.md` rubrics are per-skill and check the plugin's
  distinctive framing (no invented APDU/AID/PIN values, method letters only via
  honnin-kakunin-houhou, never call J-LIS directly). Tighten them against real
  regressions you see, not against SKILL.md's own wording.
- These are **triggering** suites. To also benchmark answer *quality*, add
  `regex`/`file_exists` graders or raise the `llm` rubric specificity.
- `input_match` for the router (`evals/ekyc-jp/`) is the bare string `ekyc-jp`,
  which matches *any* `ekyc-jp:*` skill invocation, not only the router. The
  fire indicator is display-only and the no-fire assertion ("no ekyc-jp skill
  fired at all") is still correct. For a router-specific check set
  `input_match: "ekyc-jp:ekyc-jp"` after a pilot confirms the serialisation.
