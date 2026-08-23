---
object: "tab"
json_type: "tab"
keywords: ["tab control", "labels", "dataSourceTypeHint", "hierarchical list", "gotoPage", "labelsPlacement", "compiler"]
summary: "Tab control object: object/array/hierarchical/static-labels data-source kinds, gotoPage, labelsPlacement, compiler typing note."
---

# 4D Tab Control Object

Reference: https://developer.4d.com/docs/FormObjects/tabControl
Also: https://developer.4d.com/docs/FormObjects/dropdownListOverview (shared data source shapes and conventions)
Also: https://developer.4d.com/docs/FormObjects/propertiesDataSource (JSON grammar for `labels`, `choiceList`)
Also: https://developer.4d.com/docs/FormObjects/properties_Object.md#expression-type (`dataSourceTypeHint` semantics)
Also: https://developer.4d.com/docs/Project/compiler, https://developer.4d.com/docs/Concepts/data-types, https://developer.4d.com/docs/Concepts/variables (typed/process variable and compilation background for the note below)
Also: https://blog.4d.com/use-collections-and-lists-within-forms-objects/ (object as the modern, recommended data source shape)

## Basic Definition

```json
{
  "myTab": {
    "type": "tab",
    "top": 20,
    "left": 20,
    "width": 300,
    "height": 24,
    "dataSource": "Form.myTab",
    "dataSourceTypeHint": "object",
    "action": "gotoPage"
  }
}
```

A tab control presents a set of virtual screens ("pages") as a row of clickable tabs; clicking a tab selects it and, typically, navigates to the corresponding form page. Structurally it is close to a drop-down list -- both are "active" pop-up-style selectors whose data source can take several shapes, with **object being the modern, recommended shape** -- but a tab control lays all of its choices out simultaneously and visibly, rather than hiding them behind a closed control that opens on click.

## The Three Data Source Kinds

| Kind | Trigger (JSON) | Data source shape | Icon support |
|------|-----------------|--------------------|---------------|
| Object-based | `dataSourceTypeHint: "object"` | `Form.xxx` = `{ values, index, currentValue }` | No |
| Array-based | `dataSource` names a Text array directly (`dataSourceTypeHint: "arrayText"`) | Array variable itself holds the 1-based selected tab number | No |
| Static list | `labels: [...]` (no `dataSource`) | Inline JSON collection/list of label strings, resolved entirely at form-load time | No |
| Hierarchical list (by code) | `dataSourceTypeHint: "integer"` **alone**, list built with Hierarchical Lists commands | `dataSource` is the hierarchical list reference itself | Yes |

Only one kind is active on a given object -- there is no `saveAs`/reference-storage option (unlike drop-down list's choice-list mode), and no `On Clicked`-only choice-list-without-icons mode either: for a plain compile-time-known list of labels with no icons, use `labels`; for a list that needs icons, build a real hierarchical list by code.

### Object-based (recommended)

```json
"tabObj": {
  "type": "tab",
  "dataSource": "Form.tabObj",
  "dataSourceTypeHint": "object",
  "action": "gotoPage"
}
```

```4d
Form.tabObj:=New object
Form.tabObj.values:=New collection("Page 1"; "Page 2"; "Page 3")
Form.tabObj.index:=0 //start on page 1
```

`values` is a **0-based** Collection of strings (only string values are supported; if invalid, empty, or undefined, the tab control is empty). `index` selects the active tab (0 to `values.length-1`); `currentValue` holds the label text of the currently selected tab. This initialization must run before the form is presented to the user (typically `On Load`).

### Array-based

```json
"tabArr": {
  "type": "tab",
  "dataSource": "arrPages",
  "dataSourceTypeHint": "arrayText",
  "action": "gotoPage"
}
```

```4d
ARRAY TEXT(arrPages; 3)
arrPages{1}:="Page 1"
arrPages{2}:="Page 2"
arrPages{3}:="Page 3"
```

Same convention as drop-down list's array-based mode: the array is **1-based**, and the array variable itself (not an element of it) holds the currently selected tab number, bidirectionally -- assigning to `arrPages` selects a tab, and clicking a tab writes its number back to `arrPages`. Populate the array on `On Load` and clear it on `On Unload` (`CLEAR VARIABLE`).

### Static list (no icons)

```json
"tabLabels": {
  "type": "tab",
  "labels": ["Home", "Profile", "Settings"],
  "action": "gotoPage"
}
```

`labels` (a plain JSON array/collection of strings) is the most intuitive and lowest-effort option when no per-tab icon is needed: the labels are fixed at form-design time, directly in the JSON, with **no `dataSource` and no initialization code required at all**. This is the tab-control-specific "Choice List (static list)" property -- distinct from the generic `choiceList` property used by drop-down list/combo box/hierarchical list, which is **not** in the tab control's supported property set.

### Hierarchical list (icons)

The tab control overview page describes assigning "a choice list... through a collection (static list) or a JSON pointer to a json list", noting that icons associated with list items in the Lists editor are displayed in the tab. In practice, per-tab icons require a real **hierarchical list**, not just the plain `labels` string array -- built and managed through the Hierarchical Lists language commands (`New list`, `Load list`, `APPEND TO LIST`, `SET LIST ITEM ICON`, etc., see https://developer.4d.com/docs/commands/theme/Hierarchical_Lists), then attached with `dataSourceTypeHint: "integer"` alone (the same trigger used by drop-down list's hierarchical mode):

```json
"tabIcons": {
  "type": "tab",
  "dataSource": "Form.tabIcons",
  "dataSourceTypeHint": "integer"
}
```

```4d
Form.tabIcons:=New list
APPEND TO LIST(Form.tabIcons; "Home"; 1)
SET LIST ITEM ICON(Form.tabIcons; 1; someIconPicture)
```

Remember to `CLEAR LIST` when the list is no longer needed (`On Unload`), same lifecycle discipline as a code-built hierarchical drop-down list. For tabs that do not need an icon, the array-based or static `labels` list is more intuitive and easier to manage from code -- reach for the hierarchical list only when an icon per tab is actually required.

## Goto Page: Automatic vs. Manual

### `gotoPage` standard action (automatic)

```json
{ "action": "gotoPage" }
```

When set, 4D automatically displays the form page matching the number of the selected tab (e.g. selecting the 3rd tab shows page 3) -- no method code is required. This works with any of the data source kinds above, including the dataSource-less static `labels` list.

### `FORM GOTO PAGE` (manual)

Without a standard action, the object method must call `FORM GOTO PAGE` explicitly on `On Clicked`, passing the tab control's own data source (array or object), then clean up on `On Unload`:

```4d
Case of 
  : (FORM Event.code=On Load)
    ARRAY TEXT(arrPages; 3)
    arrPages{1}:="Name"
    arrPages{2}:="Address"
    arrPages{3}:="Notes"
  : (FORM Event.code=On Clicked)
    FORM GOTO PAGE(arrPages)
  : (FORM Event.code=On Unload)
    CLEAR VARIABLE(arrPages)
End case
```

Manual navigation is the natural choice when the tab control does something other than plain page navigation -- e.g. driving a subform's displayed data (the official example: an alphabet-letter Rolodex tab control that reloads a subform's data set instead of switching form pages).

Reference: https://developer.4d.com/docs/commands/form-goto-page, https://developer.4d.com/docs/Desktop/standard-actions

## `labelsPlacement`

`"labelsPlacement": "top"` (default) or `"bottom"`. Available on all platforms but only actually renders differently on **macOS** -- under Windows, a `"bottom"` tab control silently reverts to the standard top position. This only has a visible effect when the tab control's declared height is tall enough to contain the underlying content area in addition to the tab strip itself; on a thin, tab-strip-only-height object, top and bottom placement render identically because there is no space for the strip to move within.

## Compiler Note: `dataSourceTypeHint` Is Only an Initialization Hint

Because a tab control's data source can be an object, an array, or an integer (hierarchical list reference), 4D needs to know the intended shape both to auto-initialize a default value for the property list preview and, more importantly, to satisfy the compiler's static-typing requirements (https://developer.4d.com/docs/Project/compiler). `dataSourceTypeHint` communicates this shape, but it is only a **suggestion**: it lets 4D automatically create and assign a default value of the suggested type when the data source has not been created yet, but it has **no power to override an already-typed variable**.

In particular, if the data source is a **process variable** (see https://developer.4d.com/docs/Concepts/variables#local-process-and-interprocess-variables), it must already be declared with the correct type (`var varName : Type`, see https://developer.4d.com/docs/Concepts/data-types) and initialized with a value of the correct shape *before* the form is loaded -- `dataSourceTypeHint` cannot retroactively change or coerce an already-typed variable's declared type at `On Load` time. This matters most in compiled mode, where every variable's type must be statically resolvable: declare and initialize the process variable in a method that runs prior to `DIALOG`/form load (not inside the form's own `On Load`, which runs too late for compiler-time typing purposes), then let the tab control simply consume it.

## Supported Properties

| Property | JSON Name | Notes |
|----------|-----------|-------|
| Variable or Expression | `dataSource` | Object, array, or hierarchical list reference, depending on kind |
| Expression Type | `dataSourceTypeHint` | `"object"`, `"arrayText"`, or `"integer"` (hierarchical trigger) -- initialization hint only, see above |
| Choice List (static list) | `labels` | Inline list/collection of label strings; no `dataSource` needed |
| Standard action | `action` | e.g. `"gotoPage"` |
| Tab Control Direction | `labelsPlacement` | `"top"` (default) / `"bottom"` -- macOS only |
| Bold / Underline / Italic | `bold` / `underline` / `italic` | Text style of the tab labels |
| Font / Font Size | `font` / `fontSize` | |
| Save value | `saveValue` | Persists the selection across sessions if the form's Save Geometry option is enabled |
| Border Line Style | -- | Not listed as supported (unlike Picture Button/Picture Pop-up Menu) |
| Top/Left/Right/Bottom/Width/Height | `top`, `left`, `right`, `bottom`, `width`, `height` | Standard coordinates/sizing |
| Horizontal/Vertical Sizing | `horizontalSizing` / `verticalSizing` | Resizing behavior |
| Visibility | `visibility` | `"visible"` / `"hidden"` |
| CSS Class | `class` | CSS class hook |
| Help Tip | `tooltip` | |
| Object Name | (JSON key) | Object identifier |
| Type | `"type": "tab"` | Fixed |

Notably absent compared to drop-down list: no `focusable`, no `saveAs`/reference storage, and no plain `choiceList` (drop-down/combo/hierarchical-list-style) property.

## Supported Events

`onClick` (On Clicked) -- primary event, fires when a tab is selected -- plus `onBeginDragOver`, `onDragOver`, `onDrop`, `onHeader`, `onLoad`, `onUnload`, `onMouseEnter`, `onMouseLeave`, `onMouseMove`, `onPrintingBreak`, `onPrintingDetail`, `onPrintingFooter`, `onValidate`.

## CLI Verification Notes

`FORM SCREENSHOT` renders the Form Editor's static template, never a live/running form: it does not execute `On Load` and does not reflect any `Form.xxx` value, array content, or field value assigned by code. For a tab control, the rendering rule depends on whether the object has a `dataSource` at all:

- **Object-based, array-based, and hierarchical-list-by-code** tabs (all of which have a `dataSource`) render a **single tab** showing the **literal `dataSource` expression text** (e.g. `Form.tabObj`, `arrPages`, `Form.tabHierarchical`) -- consistent with the same rule already established for drop-down list and combo box (see `16-dropdown.md`, `17-combo.md`).
- The **static `labels`** list, which has **no `dataSource` at all**, is the first case among these pop-up/tab-style objects where the static template renders the object's **actual configured content**: the real tab strip, with every label from the `labels` array shown as its own tab, exactly as it will appear at runtime. This is possible because the labels are fully known at form-design time, embedded directly in the JSON, with nothing left to resolve from a runtime expression.
- `labelsPlacement: "bottom"` is correctly honored in the static template render: with a tall test object, the tab strip visibly renders at the bottom edge of the object's frame, with the enclosed content area rendered above it as a plain rectangle. On a tab-strip-height-only object there is no visible difference between `"top"` and `"bottom"` since there is no space for the strip to move.

## Comparison with Drop-down List

| Feature | Drop-down List | Tab Control |
|---------|----------------|--------------|
| Presentation | Closed pop-up; opens on click | Always-visible row of tabs |
| Object-based shape | `{ values, index, currentValue }`, `values` 0-based | `{ values, index, currentValue }`, `values` 0-based (identical shape) |
| Array-based shape | 1-based; array variable = selected element number, bidirectional | 1-based; array variable = selected tab number, bidirectional (identical convention) |
| Choice list (no icons) | `choiceList` (inline or named toolbox list) | `labels` (inline only; no toolbox-list-by-name option documented) |
| Choice list `saveAs` (value/reference) | Yes | No -- not a supported tab control property |
| Hierarchical list (icons) | `dataSourceTypeHint: "integer"` alone | `dataSourceTypeHint: "integer"` alone (identical trigger) |
| `focusable` / keyboard interaction | Yes | No |
| Standard action | Yes (`gotoPage` and others, submenu-generating actions only) | Yes (`gotoPage` only) |
| Manual code-driven navigation | N/A (drop-down doesn't represent form pages by default) | `FORM GOTO PAGE(dataSource)` in `On Clicked`, when no standard action is set |
| CLI static template rendering | Literal `dataSource` expression text, always | Literal `dataSource` text for object/array/hierarchical; **real content** for the dataSource-less static `labels` list |

Both share the same one-directional standard-action binding caveat noted for drop-down list (`16-dropdown.md`): selecting a tab with `gotoPage` navigates the page, but a code-driven page change (`FORM GOTO PAGE` called directly, bypassing the tab control) does not update which tab the control displays as selected -- keep it in sync explicitly (e.g. re-assign `index`/the array value to match the new page) if the form's logic can change pages by other means.
