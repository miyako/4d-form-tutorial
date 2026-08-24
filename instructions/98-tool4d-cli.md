---
object: "tool4d"
json_type: null
keywords: ["tool4d", "CLI", "headless", "FORM SCREENSHOT", "print form", "4D CLI", "version", "LTS", "feature release", "21 R3"]
summary: "Centralized reference for tool4d / 4D CLI usage: version requirements, FORM SCREENSHOT behavior, static template rendering rules, and CLI commands for testing forms."
---

# tool4d and 4D CLI

Reference: https://developer.4d.com/docs/Admin/cli
Reference: https://blog.4d.com/4d-versioning-feature-releases-lts-releases-explained/

## 4D Versioning: Feature Releases vs. LTS

4D uses two release tracks:

- **Feature releases** (e.g. 21 R2, 21 R3, 21 R4): contain new features **and** bug fixes, released more frequently.
- **LTS (Long Term Support)** releases (e.g. 21.1, 21.2): contain only bug fixes backported from feature releases, intended for production stability.

Bug fixes land in feature releases first and may be backported to LTS later.

## Version Requirements

`FORM SCREENSHOT` works correctly in **both** `tool4d` and the full 4D application (`4D.app`), but requires:

- **tool4d 21 R3 (build 100186) or later**

Earlier builds of `tool4d` (including 21.1 LTS) had a bug that caused `FORM SCREENSHOT` to crash (segfault) or silently produce blank/incorrect output for certain picture formats (SVG, WEBP) and fail to apply conditional form behavior such as dark-mode picture substitution. This was a bug, not a design limitation of `tool4d`.

### Workaround for Older Builds

If you must use an older build (e.g. 21.1 LTS before the fix is backported), use the full 4D application in headless mode instead of `tool4d`:

```
/Applications/4D\ 21.1/4D.app/Contents/MacOS/4D --headless ...
```

This is a workaround only — prefer upgrading to 21 R3+ where `tool4d` works correctly.

### Binary Paths

| Binary | Typical path |
|--------|-------------|
| `tool4d` (21 R3) | `/Applications/4D 21 R3/tool4d.app/Contents/MacOS/tool4d` |
| `4D` (21 R3) | `/Applications/4D 21 R3/4D.app/Contents/MacOS/4D` |
| `4D` (21.1 LTS) | `/Applications/4D 21.1/4D.app/Contents/MacOS/4D` |

## CLI Commands for Testing

### Screenshot (`FORM SCREENSHOT` — no CSS applied)

```bash
/Applications/4D\ 21\ R3/tool4d.app/Contents/MacOS/tool4d \
  --startup-method=project_form_to_image \
  --dataless \
  --project=<path>/example.4DProject \
  --user-param=<FormName>:<PageNumber>:<OutputPath.png>
```

### Print to PDF (CSS applied)

```bash
/Applications/4D\ 21\ R3/tool4d.app/Contents/MacOS/tool4d \
  --startup-method=print_form_to_file \
  --dataless \
  --project=<path>/example.4DProject \
  --user-param=<FormName>:<PageNumber>:<OutputPath.pdf>
```

Note: `FORM SCREENSHOT` does **not** apply CSS stylesheets. Use print form output to verify CSS styling.

The helper methods used in this project (`project_form_to_image`, `print_form_to_file`) are project-specific, not built-in 4D commands.

## `FORM SCREENSHOT` Static Template Behavior

`FORM SCREENSHOT` called with a form name (`FORM SCREENSHOT(formName; formPict; pageNum)`) renders the **Form Editor's static template** for that page, not a live/running form. It never executes `On Load` and never reflects any `Form.xxx` value, array content, or field value assigned by form-object-method code.

### What the Static Template Renders per Object Type

| Object type | Static template shows |
|-------------|----------------------|
| **Input** (all expression types, including picture/boolean) | Literal `dataSource` expression text (e.g. `Form.myText`) — never the actual value/image |
| **Drop-down list** (object/array/choice-list/hierarchical) | Literal `dataSource` expression text — never a resolved value or first list item |
| **Drop-down list** (`gotoPage`, no `dataSource`) | Object name in quotes (e.g. `"dropGotoPage"`) |
| **Combo box** (all kinds) | Literal `dataSource` expression text |
| **Tab control** (object/array/hierarchical) | Literal `dataSource` expression text (single tab) |
| **Tab control** (static `labels` list, no `dataSource`) | **Real tab strip with all configured labels** (the one exception — content is fully known at design time) |
| **Picture pop-up menu** | **Frame 0** of the picture at the object's declared size — never literal text |
| **Static picture** | Real image content |
| **Group box** | True runtime appearance (static by nature) |
| **Button / Checkbox / Radio** | True runtime appearance (label, style) |

### Properties Not Reflected in the Static Template

- `enterable: false` — no visible difference from enterable
- `choiceList` on an input — no pop-up affordance shown
- Runtime values, array contents, `Form.xxx` bindings — always show the literal expression text

### Interactive-Only Behaviors

Some behaviors cannot be observed via `FORM SCREENSHOT` at all and require running the form interactively:

- Drop-down / combo box populated/selected state
- Combo box `automaticInsertion`, `excludedList` alerts
- Animated GIF playback in static picture objects
- Any behavior driven by `On Load` / user interaction
