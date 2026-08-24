---
role: router
always_load: true
---

# Instructions Router — Read This First

This directory holds one file per 4D form topic/object. **Do not read all of them.**
Identify the object(s)/topic(s) the current task touches, open only the matching
file(s) from the table below, then proceed. Each target file has front matter
(`object`, `json_type`, `keywords`, `summary`) — skim that first if you need to
confirm relevance before reading the full body.

## Prerequisite Loading (`requires` front matter)

Some instruction files declare a `requires` list in their front matter:

```yaml
---
requires: ["01-form-concepts.md", "98-tool4d-cli.md"]
---
```

**Rule**: when you load a file that has `requires`, also load each listed
prerequisite — but **only once per session**. If you have already read a
prerequisite (for a previous task, or because another file also required it),
do not re-read it. This is analogous to C/C++ `#pragma once`.

Track which files you have loaded in this session. Before reading any
prerequisite, check whether you have already loaded it. Skip if yes.

## Route Table

| Task involves...                                              | Open |
|-----------------------------------------------------------------|------|
| Form-level structure: pages, events, window sizing, form class, project/table form, file layout | `01-form-concepts.md` |
| Button | `02-button.md` |
| Checkbox / three-state | `03-checkbox.md` |
| Radio button / radioGroup | `04-radio-button.md` |
| Button grid | `05-button-grid.md` |
| Picture button (animated/frame-based) | `06-picture-button.md` |
| Splitter | `07-splitter.md` |
| Ruler | `08-ruler.md` |
| Stepper | `09-stepper.md` |
| Progress indicator / thermometer | `10-progress-indicator.md` |
| Spinner | `11-spinner.md` |
| Rectangle shape | `12-rectangle.md` |
| Line shape | `13-line.md` |
| Oval shape | `14-oval.md` |
| Static picture | `15-picture.md` |
| Dropdown list | `16-dropdown.md` |
| Combo box | `17-combo.md` |
| Picture pop-up menu | `18-picture-popup.md` |
| Tab control | `19-tab.md` |
| Group box | `20-group-box.md` |
| Input / field / text entry | `21-input.md` |
| tool4d, CLI, headless, `FORM SCREENSHOT`, version requirements, LTS vs feature release | `98-tool4d-cli.md` |
| Meta questions: "what have you built", capability/status summary, showcase form catalog | `99-skills-summary.md` (on-demand only, see its own front matter — do not load by default) |

If a task spans multiple objects, open only the files for those objects — do not
open unrelated ones "just in case."

## Always Relevant (apply regardless of object)

- **Never invent 4D command names or guess syntax.** Refer to documentation or
  existing project code. IDE-added token suffixes (`:CNNN`, `:KNN:NN`) must
  never be written by hand.
- **CLI rendering/testing**: see `98-tool4d-cli.md` for version requirements,
  `FORM SCREENSHOT` behavior, and CLI commands. Key point: requires tool4d
  **21 R3 (build 100186) or later**.
- **Form Editor**: only the JSON is edited directly here; there is no visual
  form editor experience/behavior to draw on.
- 4D language knowledge is **not systematic** — code patterns are inferred from
  the user's existing project code, not full language mastery.
