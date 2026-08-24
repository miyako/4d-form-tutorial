---
object: "tool4d"
json_type: null
keywords: ["tool4d", "CLI", "headless", "FORM SCREENSHOT", "print form", "4D CLI", "version", "LTS", "feature release", "21 R3", "CI/CD", "automated testing", "ASSERT", "download"]
summary: "Centralized reference for tool4d / 4D CLI usage: what tool4d is, version requirements, automated testing, download URLs, FORM SCREENSHOT behavior, static template rendering rules, and CLI commands."
---

# tool4d and 4D CLI

Reference: https://developer.4d.com/docs/Admin/cli
Reference: https://blog.4d.com/4d-versioning-feature-releases-lts-releases-explained/

## What is tool4d?

`tool4d` is a CLI version of 4D designed for CI/CD and automated testing:

- **No license activation required** — free to download and use
- Must be compatible with the project's `compatibilityVersion` (see `01-form-concepts.md`). A newer tool4d can safely run an older project; the reverse works too, but the project may use commands or features that do not yet exist in the older tool4d.
- Runs 4D methods headlessly without a GUI

## 4D Versioning: Feature Releases vs. LTS

4D uses two release tracks:

- **Feature releases** (e.g. 21 R2, 21 R3, 21 R4): contain new features **and** bug fixes, released more frequently.
- **LTS (Long Term Support)** releases (e.g. 21.1, 21.2): contain only bug fixes backported from feature releases, intended for production stability.

Bug fixes land in feature releases first and may be backported to LTS later.

## Version Requirements

`FORM SCREENSHOT` works correctly in **both** `tool4d` and the full 4D application (`4D.app`), but requires:

- **tool4d 21 R3 (build 100186) or later**

Earlier builds of `tool4d` (including 21.1 LTS) had a bug that caused `FORM SCREENSHOT` to crash (segfault) or silently produce blank/incorrect output for certain picture formats (SVG, WEBP) and fail to apply conditional form behavior such as dark-mode picture substitution. This was a bug, not a design limitation of `tool4d`. Until there is confirmation that tool4d 21.1 LTS has received the fix, use tool4d **21 R3 or later**; alternatively, the full 4D desktop application works via CLI as a fallback (see below).

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

## Automated Testing

### Running Tests

```bash
/path/to/tool4d --dataless --startup-method=test_all --project=/path/to/{name}.4DProject
```

| Flag | Description |
|---|---|
| `--dataless` | No data file (empty data path). Suitable for tests that don't need records. |
| `--startup-method` | 4D method to execute at startup |
| `--project` | Path to the `.4DProject` file |

### Exit Behavior

- **PASS**: stdout contains "PASS", exit code 0
- **FAIL**: `ASSERT` triggers a dialog → headless auto-abort → non-zero exit code, no "PASS" output

## Downloading tool4d

```
https://resources-download.4d.com/release/{branch}/{version}/latest/{platform}/tool4d_{suffix}.tar.xz
```

| Parameter | Examples |
|---|---|
| branch | `21.x`, `20.x` |
| version | `21.1`, `21 R2` |
| platform | `win`, `mac` |
| suffix | `win`, `x86_64`, `arm64` |

No authentication required for download.

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

### Properties Fully Rendered in the Static Template

- All **visual styling**: `borderStyle`, `borderRadius`, `fill`, `stroke`, `fontFamily`, `fontSize`, `fontWeight`, `fontStyle`, `textDecoration`, `textAlign`
- Hex colors, named colors, and `"transparent"` all honored
- `%password` font shows the literal dataSource text (not masked characters — masking is runtime-only)

### Properties Not Reflected in the Static Template

- `enterable: false` — no visible difference from enterable
- `choiceList` on an input — no pop-up affordance shown
- Runtime values, array contents, `Form.xxx` bindings — always show the literal expression text
- `%password` character masking — literal text shown instead

### Interactive-Only Behaviors

Some behaviors cannot be observed via `FORM SCREENSHOT` at all and require running the form interactively:

- Drop-down / combo box populated/selected state
- Combo box `automaticInsertion`, `excludedList` alerts
- Animated GIF playback in static picture objects
- Any behavior driven by `On Load` / user interaction

## CLI Testing Methodology

Beyond static screenshots, you can test runtime behavior by writing **startup methods** that exercise 4D commands and output results.

### Choosing the Right Engine

| Engine | Mode | Use for |
|--------|------|---------|
| `tool4d` | Always headless | Commands that don't need UI: string manipulation, file I/O, calculations, `FORM LOAD`-based screenshots |
| `4D` (no flags) | GUI mode | Commands that need windows: `Open form window`, `DIALOG`, `FORM SCREENSHOT` after runtime code |
| `4D --headless` | Headless with license | Same as tool4d but with full 4D capabilities (requires license) |

**Key limitation**: In headless mode (tool4d or `4D --headless`), `Open form window` and `DIALOG` are **silently ignored** — they do not raise an error, but the form never opens and the form method never fires.

### Pattern 1: Direct Test (No UI Needed)

For testing commands that operate on variables (not form objects), write a startup method that runs the commands and writes results to a file:

```4d
//%attributes = {"invisible":true}
var $st : Text
$st:="Hello World"
ST SET ATTRIBUTES($st; 1; 6; Attribute bold style; 1)

var $result : Object
$result:={}
$result.styled:=$st
$result.plain:=ST Get plain text($st)
$result.length:=Length($st)

var $file : 4D.File
$file:=File("/RESOURCES/tests/result.json")
$file.parent.create()
$file.setText(JSON Stringify($result; *))

QUIT 4D
```

Invoke with tool4d:
```bash
tool4d --project path/to/project.4DProject --startup-method test_method --dataless
```

### Pattern 2: Form + DIALOG (UI Needed)

For testing form-level behavior (On Load, object methods, Form object population), use `Open form window` + `DIALOG` with a method that serializes the Form object:

```4d
//%attributes = {"invisible":true}
var $formName : Text
$formName:="MyForm"

var $form : Object
$form:={}

var $window : Integer
$window:=Open form window($formName)
DIALOG($formName; $form; *)
CALL FORM($window; Formula(ACCEPT))

// $form now contains all Form.xxx values set during On Load
var $file : 4D.File
$file:=File("/RESOURCES/tests/form_result.json")
$file.parent.create()
$file.setText(JSON Stringify($form; *))

QUIT 4D
```

This pattern **requires 4D** (not tool4d) because it uses `DIALOG`. Invoke with:
```bash
/Applications/4D\ 21\ R3/4D.app/Contents/MacOS/4D --project path/to/project.4DProject --startup-method run_project_form --user-param "FormName:1:/RESOURCES/tests/output.json" --dataless
```

The `--dataless` flag avoids data file locking when the project is also open in the IDE.

### Pattern 3: Parameterized with `--user-param`

Use `Get database parameter(User param value)` to pass arguments:

```4d
var $userParamValue : Text
Get database parameter(User param value; $userParamValue)
var $params : Collection
$params:=Split string($userParamValue; ":")
// $params[0] = form name, $params[1] = page, $params[2] = output path
```

This allows a single generic method (like `run_project_form`) to test any form/page combination.

### Tips

- **`--dataless`**: Always pass when the project may be open elsewhere (avoids lock conflicts)
- **`QUIT 4D`**: Always include at the end — without it, 4D stays open indefinitely in GUI mode
- **`Application info.headless`**: Use to branch behavior (e.g. log to stdout in headless, display UI otherwise)
- **Output format**: JSON is easiest to parse and verify; use `JSON Stringify($obj; *)` for pretty-printing
- **Styled text in JSON**: The HTML markup is preserved in JSON output, letting you verify that ST commands produced the expected `<span style="...">` tags
