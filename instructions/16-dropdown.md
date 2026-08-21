# 4D Dropdown List Object

Reference: https://developer.4d.com/docs/FormObjects/dropdownListOverview
Also: https://developer.4d.com/docs/FormObjects/propertiesDataSource (JSON grammar for data source properties)
Also: https://developer.4d.com/docs/Desktop/standard-actions (standard action syntax, `gotoPage`)

## Basic Definition

```json
{
  "myDrop": {
    "type": "dropdown",
    "top": 20,
    "left": 20,
    "width": 180,
    "height": 20,
    "dataSource": "Form.myDrop",
    "dataSourceTypeHint": "object"
  }
}
```

A drop-down list is a closed list of items presented as a single-line control; clicking it opens a list/menu of choices. On macOS it is rendered as a native pop-up menu (same object, platform-specific chrome only). Available only in 4D **projects**, not in 4D classic databases (for the object/array-based variants below; choice-list variants work in both).

There are five distinct kinds of drop-down list, distinguished entirely by which JSON properties are present -- not by a separate `type` value. `"type"` is always `"dropdown"`.

## The Five Kinds

| Kind | Trigger (JSON) | Data source shape |
|------|-----------------|--------------------|
| Object-based | `dataSourceTypeHint: "object"` | `Form.xxx` = `{ values, index, currentValue }` |
| Array-based | `dataSourceTypeHint: "arrayText"` / `"arrayNumber"` / `"arrayDate"` / `"arrayTime"` | `dataSource` names a 4D array variable directly (e.g. `"asColor"`) |
| Choice list (value) | `choiceList: [...]` + `saveAs: "value"` (default) | `dataSource` is a plain field/variable holding the literal selected value |
| Choice list (reference) | `choiceList: [...]` + `saveAs: "reference"` | `dataSource` is a plain field/variable holding a 1-based numeric reference into the list |
| Hierarchical | `dataSourceTypeHint: "integer"` **alone** (no `choiceList`, `list`, object, or array) | Managed via `list`/hierarchical-list language commands |

Only one kind can be active on a given object. Binding `dataSource` directly to a field/variable (rather than to an object or array) always forces choice-list behavior; it cannot be combined with `dataSourceTypeHint: "object"` or an array hint.

### Object-based

```json
"dropFruit": {
  "type": "dropdown",
  "dataSource": "Form.dropFruit",
  "dataSourceTypeHint": "object"
}
```

```4d
Form.dropFruit:=New object
Form.dropFruit.values:=New collection("Apple"; "Banana"; "Cherry")
Form.dropFruit.index:=1
Form.dropFruit.currentValue:="Banana"
```

- `values` (Collection, mandatory): all elements must be the same scalar type (text, number, date, or time).
- `index` (Integer, 0-based): the selected element's position in `values`. `-1` means "no selection" -- the control displays `currentValue` instead, acting as a placeholder (e.g. `"Select a fruit"`).
- `currentValue`: the currently selected value (kept in sync with `index` at runtime), or the placeholder text when `index` is `-1`.

### Array-based

```json
"dropColor": {
  "type": "dropdown",
  "dataSource": "asColor",
  "dataSourceTypeHint": "arrayText"
}
```

```4d
ARRAY TEXT(asColor; 3)
asColor{1}:="Red"
asColor{2}:="Green"
asColor{3}:="Blue"
```

The `dataSource` string is the array's own name (not `Form.xxx`); the object name and the array name do not need to match, but the array must exist as a form-local array. Populate it (and clear it) in `On Load` / `On Unload`. The `arrayNumber`/`arrayDate`/`arrayTime` hints work the same way for arrays of other scalar types.

### Choice list (value vs. reference)

```json
"dropSaveValue": {
  "type": "dropdown",
  "dataSource": "Form.dropSaveValue",
  "choiceList": ["Red", "Green", "Blue"],
  "saveAs": "value"
},
"dropSaveReference": {
  "type": "dropdown",
  "dataSource": "Form.dropSaveReference",
  "choiceList": ["Red", "Green", "Blue"],
  "saveAs": "reference"
}
```

`choiceList` is a static list/collection of items attached directly to the object -- no runtime population needed. `saveAs` controls what the bound field/variable stores:

- `"value"` (default): the literal selected item (e.g. the text `"Blue"`).
- `"reference"`: a 1-based numeric position into `choiceList` (e.g. `3` for `"Blue"`). The bound field/variable must be Number type.

A choice list dropdown cannot be combined with an object or array data source -- entering a field/variable name directly in "Variable or Expression" always forces this mode.

### Hierarchical

Setting only `"dataSourceTypeHint": "integer"` (with `"type": "dropdown"` and no `choiceList`/`list`/object/array data source) declares a **hierarchical** drop-down list, limited to two levels in forms. Hierarchical lists are built and assigned with the dedicated Hierarchical Lists language commands (e.g. `List item parent`) rather than plain JSON literals, and are attached via the `list` JSON property.

### Standard action (submenu-style)

```json
"dropGotoPage": {
  "type": "dropdown",
  "action": "gotoPage"
}
```

Drop-down lists (and hierarchical choice lists) can only be directly associated with standard actions that generate a submenu, such as `gotoPage`, `backgroundColor`, or `fontSize`. With `action: "gotoPage"` the list is auto-populated with the form's page numbers; selecting item *N* navigates to page *N*. No `dataSource` is required or used for this mode. Custom per-item actions (e.g. `backgroundColor?value="red"`) can replace the automatic values by setting them on a choice list via `SET LIST ITEM PARAMETER` and assigning that list as the object's choice list.

## `Data Type (list)` Properties

| Property | JSON Name | Type | Notes |
|----------|-----------|------|-------|
| Choice list | `choiceList` | list / collection | Static list of selectable items |
| Hierarchical list | `list` | list / collection | Hierarchical lists only |
| Data source hint | `dataSourceTypeHint` | text | `"object"`, `"arrayText"`, `"arrayNumber"`, `"arrayDate"`, `"arrayTime"`, or `"integer"` (hierarchical trigger) |
| Save as | `saveAs` | text | `"value"` (default) or `"reference"` |

## Supported Properties Summary

Alpha Format, Bold, Bottom, Button Style, Choice List, Class, Data Type (expression type), Data Type (list), Date Format, Expression Type, Focusable, Font, Font Color, Font Size, Height, Help Tip, Horizontal Alignment, Horizontal Sizing, Italic, Left, Not rendered, Object Name, Right, Standard action, Save value, Time Format, Top, Type, Underline, Variable or Expression, Vertical Sizing, Visibility, Width.

## Supported Events

On After Edit, On After Keystroke, On Before Keystroke, On Begin Drag Over, On Clicked, On Data Change, On Drag Over, On Drop, On Header, On Load, On Mouse Enter, On Mouse Leave, On Mouse Move, On Printing Break, On Printing Detail, On Printing Footer, On Unload.

## CLI Verification Caveat

`FORM SCREENSHOT` called with a form name (`FORM SCREENSHOT(formName; formPict; pageNum)`) renders the **Form Editor's static template** for that page, not a live/running form. It never executes `On Load` and never reflects any `Form.xxx` value assigned by form-object-method code. Concretely:

- Object-based and array-based dropdowns, whose displayed value is only ever set at runtime, render **blank** in a CLI screenshot -- there is no way to preview their populated state without actually running the form interactively (`4D.app/Contents/MacOS/4D` in normal, non-headless mode; never `tool4d`).
- Choice list dropdowns (`choiceList` is static JSON, not runtime data) *do* preview correctly: the CLI screenshot shows the **first item** of `choiceList` as the rendered value, regardless of `saveAs` mode and regardless of any runtime assignment.
- A dropdown with no `dataSource` at all (e.g. the `gotoPage` standard-action form) renders its own **object name in quotes** as a placeholder (e.g. `"dropGotoPage"`), the generic fallback 4D uses for an unbound object in the editor template.
- An object/array-hinted dropdown whose `dataSource` cannot be resolved statically renders the **literal `dataSource` expression text** (e.g. `Form.dropFruit`) instead of a value.

This mirrors the general rule already established for this project: CLI-driven `FORM SCREENSHOT` verification only ever shows declarative, load-time state, never anything that depends on interactive execution.
