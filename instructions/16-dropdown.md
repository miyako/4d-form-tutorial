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

A drop-down list is a closed list of items presented as a single-line control; clicking it opens a list/menu of choices. On macOS it is rendered as a native pop-up menu (same object, platform-specific chrome only); the OS may render the control at a different height than the object's declared `height` depending on platform conventions. Available only in 4D **projects**, not in 4D classic databases (for the object/array-based variants below; choice-list variants work in both).

## Interaction Model

A drop-down list is an active object like button, checkbox, and radio button:

- `On Clicked` fires **on mouse-down** (press), not on mouse-up (release) -- same timing as buttons, checkboxes, and radio buttons.
- It supports `focusable` like a button. When focused: `Return`/`Tab` moves to the next object in tab order, `Shift+Return`/`Shift+Tab` moves to the previous object in tab order, and `Space` is equivalent to clicking it (opens the list).

Like progress indicators and rulers, a drop-down list's data source can be a live expression, and the binding is **bidirectional**: the object reads its displayed state from the expression, and user interaction writes the selection back into the expression -- there is no need to trap `On Clicked`/`On Data Change` just to copy the value back manually (though those events are still available for reacting to a change).

There are five distinct kinds of drop-down list, distinguished entirely by which JSON properties are present -- not by a separate `type` value. `"type"` is always `"dropdown"`. The underlying data source is always one of three shapes -- **object**, **array**, or **list** (choice list / hierarchical list) -- with **object being the modern, recommended shape** (see https://blog.4d.com/use-collections-and-lists-within-forms-objects/).

## The Five Kinds

| Kind | Trigger (JSON) | Data source shape |
|------|-----------------|--------------------|
| Object-based | `dataSourceTypeHint: "object"` | `Form.xxx` = `{ values, index, currentValue }` |
| Array-based | `dataSourceTypeHint: "arrayText"` / `"arrayNumber"` / `"arrayDate"` / `"arrayTime"` | `dataSource` names a 4D array variable directly (e.g. `"asColor"`) |
| Choice list (value) | `choiceList: [...]` + `saveAs: "value"` (default) | `dataSource` is a plain field/variable holding the literal selected value |
| Choice list (reference) | `choiceList: [...]` + `saveAs: "reference"` | `dataSource` is a plain field/variable holding a numeric item reference into the list |
| Hierarchical | `dataSourceTypeHint: "integer"` **alone** (no `choiceList`, `list`, object, or array) | `dataSource` is the hierarchical list reference itself; resolved via Hierarchical Lists language commands |

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

- `values` (Collection, mandatory): all elements must be the same scalar type (text, number, date, or time). Collections are always **0-based**, so `index` is 0-based too (see https://developer.4d.com/docs/API/CollectionClass).
- `index` (Integer, 0-based): **bidirectional**. Assigning it selects the specified item (e.g. `Form.dropFruit.index:=2` programmatically selects the 3rd item); when the user selects an item, 4D assigns its position back into `index`. `-1` means "no selection" -- the control displays `currentValue` instead, acting as a placeholder.
- `currentValue`: **read-only** from the form's perspective. Assigning it directly is ignored -- the value reverts to whatever the actual selection is (or to the placeholder when `index` is `-1`). When the user selects an item, 4D assigns that item's value into `currentValue`. It only has a meaningful assignable role once, as the placeholder text, at initialization time (see below).

To initialize an object-based drop-down list, set `index` to `-1` and, optionally, `currentValue` to a placeholder message (e.g. `"Select a fruit"`) -- this is the only time `currentValue` should be assigned.

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
asColor{1}:="item 1"
asColor{2}:="item 2"
asColor{3}:="item 3"
asColor{0}:="please select item"
asColor:=0
```

The `dataSource` string is the array's own name (not `Form.xxx`); the object name and the array name do not need to match, but the array must exist as a form-local array. Populate it (and clear it) in `On Load` / `On Unload`. The `arrayNumber`/`arrayDate`/`arrayTime` hints work the same way for arrays of other scalar types.

4D arrays are **1-based** (see https://developer.4d.com/docs/Concepts/arrays), unlike the 0-based `values` Collection used by the object-based kind:

- `asColor{1}`, `asColor{2}`, `asColor{3}` are the three selectable items.
- `asColor{0}` is reserved for the "no selection" placeholder message (e.g. `"please select item"`).
- The **current element number** is held by the array variable itself, not by a separate index property: `asColor:=1` selects element 1. The idiom `asColor{asColor}` therefore always yields the currently selected value.
- The array reference is **bidirectional**: assigning a number to the array variable selects that item; when the user selects an item, 4D assigns the selected element's number back into the array variable.

To initialize an array-based drop-down list, set the array variable to `0` and, optionally, populate element `0` with an initialization message.

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

`choiceList` can be either a static list/collection of items inlined directly in the object's JSON, or the name of a list defined in the project's toolbox (`lists.json` -- see https://developer.4d.com/docs/Project/architecture). A named toolbox list is automatically instantiated when the form is loaded and cleared when the form is unloaded -- no manual lifecycle code is needed for it, unlike array-based or hierarchical-by-code data sources. `OBJECT SET LIST BY NAME` (https://developer.4d.com/docs/commands/object-set-list-by-name) achieves the same effect at runtime as setting a toolbox list's name directly in `choiceList`.

`saveAs` (the "Data Type (list)" property) defines what is stored in the data source, and the on-screen behavior is identical either way -- only the code working with the data source is affected:

- `"value"` (default, "Selected item value"): the data source holds the literal selected item's text (e.g. `"Blue"`) directly -- no need to resolve which position/item-reference is selected.
- `"reference"` ("Selected item reference"): the data source holds a numeric item reference associated with the selected item (via `APPEND TO LIST`'s `itemRef` parameter, `SET LIST ITEM`, or the list editor -- not necessarily the item's 1-based position). The bound field/variable must be Number type. This decouples the displayed text (which a user sees, and which can be relabeled or localized) from the reference code actually keys off of.

The data source is **bidirectional**: assigning a value (or reference number) to it selects the corresponding item; when the user selects an item, its value (or reference number) is assigned back into the data source.

To initialize a choice list drop-down list: set the data source to `0` when using `saveAs: "reference"`, or to an initialization message (e.g. `"please select item"`) when using `saveAs: "value"`.

A choice list dropdown cannot be combined with an object or array data source -- entering a field/variable name directly in "Variable or Expression" always forces this mode.

### Hierarchical

Setting only `"dataSourceTypeHint": "integer"` (with `"type": "dropdown"` and no `choiceList`/object/array data source) declares a **hierarchical** drop-down list ("List reference" mode of the "Data Type (list)" property), limited to two levels in forms. In this mode the data source itself is the **hierarchical list reference** (an integer) -- resolving the actual selected item requires the Hierarchical Lists language commands (e.g. `Selected list items`, `Select list items by reference`, `Select list items by position`), unlike the `"value"`/`"reference"` choice-list modes above where the data source already holds a usable selected value or item reference.

A hierarchical list can be attached in two ways:

- **By name**: `OBJECT SET LIST BY NAME` (https://developer.4d.com/docs/commands/object-set-list-by-name) attaches a toolbox-defined list by name -- equivalent to setting that list's name directly in `choiceList`/`list`. 4D instantiates it when the form loads and clears it when the form unloads; no manual `Clear list` call is needed.
- **By reference**: build the list at runtime with `New list` (https://developer.4d.com/docs/commands/new-list) or `Load list` (https://developer.4d.com/docs/commands/load-list), each returning an integer list reference, and assign that reference directly to the object via `OBJECT SET LIST BY REFERENCE` (https://developer.4d.com/docs/commands/object-set-list-by-reference) or by assigning it to the data source expression. The dropdown retains its own reference count on the list, so the caller may call `Clear list` (https://developer.4d.com/docs/commands/clear-list) immediately after assigning it -- the list itself is only actually released once the dropdown's reference count reaches zero, which happens when the form is unloaded.

### Standard action (submenu-style)

```json
"dropGotoPage": {
  "type": "dropdown",
  "action": "gotoPage"
}
```

Drop-down lists (and hierarchical choice lists) can only be directly associated with standard actions that generate a submenu, such as `gotoPage`, `backgroundColor`, or `fontSize`. With `action: "gotoPage"` the list is auto-populated with the form's page numbers; selecting item *N* navigates to page *N*. No `dataSource` is required or used for this mode. Custom per-item actions (e.g. `backgroundColor?value="red"`) can replace the automatic values by setting them on a choice list via `SET LIST ITEM PARAMETER` and assigning that list as the object's choice list.

## `Data Type (list)` Properties

Reference: https://developer.4d.com/docs/FormObjects/propertiesDataSource#data-type-list

Three named options, all controlled by the same `saveAs` JSON property:

| Option | `saveAs` value | Data source holds |
|--------|-----------------|--------------------|
| List reference | *(omit `saveAs`; use `dataSourceTypeHint: "integer"` alone instead)* | The hierarchical list reference (integer) -- declares the drop-down hierarchical |
| Selected item value (default) | `"value"` | The literal selected item's value |
| Selected item reference | `"reference"` | A numeric item reference (via `APPEND TO LIST`'s `itemRef`, `SET LIST ITEM`, or the list editor); requires a Number-type field/variable |

| Property | JSON Name | Type | Notes |
|----------|-----------|------|-------|
| Choice list | `choiceList` | list / collection | Inline static list, or the name of a toolbox list (`lists.json`) -- auto-instantiated on load, auto-cleared on unload |
| Hierarchical list reference | `list` | list / collection | Also used when a hierarchical list is built by code (`New list`/`Load list`) and assigned by integer reference |
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
