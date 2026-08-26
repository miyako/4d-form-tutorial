---
object: "list"
json_type: "list"
keywords: ["list", "hierarchical list", "ListRef", "New list", "APPEND TO LIST", "EDIT ITEM", "sublist", "choice list", "expand", "collapse", "itemRef"]
summary: "Hierarchical list form object — displays data as expandable/collapsible tree. Managed via ListRef (language object in memory). Supports unlimited nesting, single/multiple selection, enterable items, drag-and-drop, and choice list initialization. Dual identity: language object (ListRef) vs. form object (object name)."
requires: ["01-form-concepts.md", "98-tool4d-cli.md", "22-property-reference.md"]
---

# Hierarchical List

Reference: https://developer.4d.com/docs/FormObjects/listOverview

## Purpose

A hierarchical list displays data as a tree with one or more levels that can be
expanded or collapsed. Each item can have child items (sublists) to an unlimited
depth. The expand/collapse icon appears automatically to the left of items that
have children.

Hierarchical lists are used for:
- Tree navigation (file systems, categories, org charts)
- Multi-level selection (pick from a structured taxonomy)
- Outline views (table of contents, configuration panels)
- Choice list display (design-time lists rendered at runtime)

## Dual Identity: Language Object vs. Form Object

This is a key concept unique to hierarchical lists.

### Language Object (ListRef)

A hierarchical list exists **in memory** as a language object, identified by a
unique `ListRef` (Integer). This reference is returned by:

| Command | Purpose |
|---------|---------|
| `New list` | Create a new, empty list in memory |
| `Copy list` | Duplicate an existing list |
| `Load list` | Load a choice list defined in the Design-mode List editor |
| `BLOB to list` | Recreate a list from a BLOB |

**Important**: lists are held in memory. When finished, you **must** dispose of
them with `CLEAR LIST` to free memory. Forgetting this causes memory leaks.

There is only **one instance** of the language object in memory. Any modification
is immediately reflected in all places where it is used.

### Form Object (Object Name)

The same list can have **multiple representations** as form objects in the same
form or across different forms. Each representation has its own:
- Selection state
- Expanded/collapsed state
- Scroll position

Properties like font, color, and list contents are **shared** across all
representations — modifying them via any representation affects all.

### Connecting the Two

You connect them by assigning the `ListRef` to the variable associated with the
form object:

```4d
// mylist is the variable associated with the form object
mylist:=New list
```

### Targeting in Commands

- Use `ListRef` (Integer) when you want to address the **language object** in memory
- Use `(*; "objectName")` when you want to address a specific **form representation**

Commands based on expanded/collapsed state or current item must specify which
representation to use — different form objects showing the same list can have
different selections and expand states.

## Basic Definition (JSON Schema)

```json
{
  "myHierList": {
    "type": "list",
    "left": 20,
    "top": 20,
    "width": 250,
    "height": 300,
    "dataSource": "Form.listRef",
    "dataSourceTypeHint": "integer",
    "focusable": true,
    "enterable": false,
    "selectionMode": "single",
    "scrollbarVertical": "automatic",
    "borderStyle": "system",
    "events": ["onLoad", "onUnload", "onClick", "onDoubleClick",
               "onExpand", "onCollapse", "onSelectionChange"]
  }
}
```

The `dataSource` holds a variable/expression that receives/provides the `ListRef`.
`dataSourceTypeHint: "integer"` reflects that `ListRef` is an Integer.

## Supported Properties (per JSON Schema)

### Direct Properties

| JSON Key | Type / Enum | Notes |
|----------|-------------|-------|
| `type` | `"list"` | Required |
| `dataSource` | string | Variable/expression for the ListRef |
| `dataSourceTypeHint` | `"integer"` | Type hint for the data source |
| `method` | string | Object method path |
| `tooltip` | string | Help tip text |
| `focusable` | boolean | Whether the list can receive focus |
| `hideFocusRing` | boolean | Hide focus rectangle |
| `enterable` | boolean | Whether items can be edited in-place |
| `selectionMode` | `"single"`, `"multiple"` | Selection behavior |
| `entryFilter` | string | Filter for in-place editing |
| `list` | object | Choice list reference (design-time list) |
| `scrollbarHorizontal` | `"visible"`, `"hidden"`, `"automatic"` | Horizontal scrollbar |
| `scrollbarVertical` | `"visible"`, `"hidden"`, `"automatic"` | Vertical scrollbar |
| `dragging` | `"none"`, `"custom"` | Drag source behavior |
| `dropping` | `"none"`, `"custom"` | Drop target behavior |

### From Shared Types

Inherits from: `objectCommon` (position, size, sizing, visibility, class),
`events`, `borderStyle`, `drawingSpec` (fill, stroke), `fontSpec` (fontFamily,
fontSize, fontStyle, fontWeight, textDecoration).

## Data Source Initialization

### Option 1: Choice List (Design-Time)

Associate an existing choice list (created in the List editor in Design mode)
with the `list` property. The list contents are loaded automatically.

### Option 2: Programmatic (ListRef)

Build the list at runtime using `New list` + `APPEND TO LIST` / `INSERT IN LIST`,
then assign the `ListRef` to the form object's variable:

```4d
// In On Load
var $list : Integer
$list:=New list
APPEND TO LIST($list; "Fruits"; 1)
APPEND TO LIST($list; "Vegetables"; 2)

// Add sublists for hierarchy
var $sublist : Integer
$sublist:=New list
APPEND TO LIST($sublist; "Apple"; 10)
APPEND TO LIST($sublist; "Banana"; 11)
APPEND TO LIST($sublist; "Cherry"; 12)
// Attach sublist to "Fruits" item, expanded
SET LIST ITEM($list; 1; "Fruits"; 1; $sublist; True)

Form.listRef:=$list
```

**Memory management**: always `CLEAR LIST` when done (typically in `On Unload`):

```4d
// In On Unload
If (Is a list(Form.listRef))
  CLEAR LIST(Form.listRef; *)  // * clears sublists too
  Form.listRef:=0
End if
```

## Item Reference Numbers (itemRef)

Each item has an `itemRef` (Integer) passed when creating items. This is a
user-defined identifier — 4D simply maintains it. Rules:

- **0 is reserved**: means "last item added" in most commands. Never use 0 as
  a real reference.
- **Uniqueness is optional** but recommended for direct access to any item.

### Strategies for itemRef

| Level | Strategy | When to use |
|-------|----------|-------------|
| Beginner | Pass any non-zero value | Only need selected item (position-based access) |
| Intermediate | Use record numbers | Map items to database records |
| Advanced | Maintain a global counter (never decrement) | Need unique identification of every item |

### Position vs. Reference Access

- **By position**: relative to visible/expanded items on screen. Position changes
  when items are expanded/collapsed. Each form representation has its own positions.
- **By reference**: uses `itemRef`, independent of display state. Consistent across
  representations.

## Supported Events

| Event | When |
|-------|------|
| `onLoad` | Form loads |
| `onUnload` | Form unloads — **clean up lists here** |
| `onClick` | Item clicked |
| `onDoubleClick` | Item double-clicked |
| `onExpand` | Item expanded (disclosure triangle) |
| `onCollapse` | Item collapsed |
| `onSelectionChange` | Selected item changes |
| `onDataChange` | Item text modified (when enterable) |
| `onAfterEdit` | After in-place editing completes |
| `onDeleteAction` | Delete key pressed |
| `onGettingFocus` / `onLosingFocus` | Focus enters/leaves the list |
| `onBeginDragOver` / `onDragOver` / `onDrop` | Drag-and-drop events |
| `onMouseEnter` / `onMouseLeave` / `onMouseMove` | Mouse tracking |
| `onHeader` / `onPrintingDetail` / `onPrintingBreak` / `onPrintingFooter` | Printing events |
| `onValidate` | Form validation |

## Key Commands

Reference: https://developer.4d.com/docs/commands/theme/Hierarchical-Lists

### Creating and Destroying

| Command | Purpose |
|---------|---------|
| `New list` | Create empty list; returns `ListRef` |
| `Copy list` | Duplicate a list |
| `Load list` | Load a design-time choice list |
| `CLEAR LIST` | Free memory. Pass `*` to also clear sublists |
| `Is a list` | Returns `True` if the value is a valid `ListRef`. Use before `CLEAR LIST` (ref: https://developer.4d.com/docs/commands/is-a-list) |
| `SAVE LIST` | Save list back to List editor |
| `BLOB to list` / `LIST TO BLOB` | Serialize/deserialize to BLOB |

### List-Level Properties

| Command | Purpose |
|---------|---------|
| `SET LIST PROPERTIES` | Set list-level properties (ref: https://developer.4d.com/docs/commands/set-list-properties) |
| `GET LIST PROPERTIES` | Read list-level properties back |

`SET LIST PROPERTIES(list; appearance; icon {; lineHeight {; doubleClick {; multiSelections {; editable}}}})`

- `appearance` and `icon`: **deprecated**, always pass `0`
- `lineHeight`: minimum row height in pixels (0 = default from font)
- `doubleClick`: `0` = expand/collapse on double-click (default), `1` = disable
  (users can still click the disclosure triangle)
- `multiSelections`: `0` = single selection (default), `1` = enable multi-select
  (Shift+click for continuous, Ctrl/Cmd+click for discontinuous)
- `editable`: `1` = list is editable as a choice list (default — shows "Modify"
  button), `0` = not editable as a choice list

**Note**: `editable` here is a **list-level** property that controls whether the
list shows a "Modify" button when used as a choice list in data entry. This is
distinct from the per-item `enterable` in `SET LIST ITEM PROPERTIES` which
controls in-place text editing.

**Persistence**: only `lineHeight` and `editable` are saved to `lists.json`
(at the list level, outside `items`). `doubleClick` and `multiSelections` are
**runtime-only** — set them after `Load list`.

### Adding and Removing Items

| Command | Purpose |
|---------|---------|
| `APPEND TO LIST` | Add item at end. Optional sublist + expanded params |
| `INSERT IN LIST` | Insert item at specific position |
| `DELETE FROM LIST` | Remove item by position or reference |

`APPEND TO LIST` signature:
```
APPEND TO LIST(list; itemText; itemRef {; sublist; expanded})
```

### Getting and Setting Items

| Command | Purpose |
|---------|---------|
| `GET LIST ITEM` | Get text, ref, sublist, expanded state of an item |
| `SET LIST ITEM` | Change text, ref, sublist, expanded state |
| `GET LIST ITEM PROPERTIES` | Get enterable, style, icon, color |
| `SET LIST ITEM PROPERTIES` | Set enterable, style, icon, color |
| `SET LIST ITEM FONT` | Set font for a specific item |
| `SET LIST ITEM ICON` | Set icon for a specific item |
| `Count list items` | Count items (optionally only visible/expanded) |
| `List item position` | Get position of item by reference |
| `List item parent` | Get parent reference of an item |

### Item Parameters

| Command | Purpose |
|---------|---------|
| `SET LIST ITEM PARAMETER` | Set a named parameter on an item (ref: https://developer.4d.com/docs/commands/set-list-item-parameter) |
| `GET LIST ITEM PARAMETER` | Read a named parameter back |
| `GET LIST ITEM PARAMETER ARRAYS` | Get all parameter names and values for an item |

**Built-in selectors** (constants in `Hierarchical Lists` theme):

| Constant | Selector string | Value type | Purpose |
|----------|----------------|------------|---------|
| `Additional text` | `"4D_additional_text"` | Text | Displays secondary text right-aligned in the list row |
| `Associated standard action` | `"4D_standard_action_name"` | Text | Associates a standard action (e.g. `"fontSize?value=12pt"`) |

**Custom selectors**: pass any text string as selector with a Text, Number, or
Boolean value. Retrieved via `GET LIST ITEM PARAMETER`. Useful for attaching
metadata (record IDs, categories, flags) to items without subclassing.

## lists.json Structure and Persistence

`SAVE LIST` writes to `Project/Sources/lists.json`. Each named list is a top-level
key containing an `items` array. Each item can have:

### Compiled Mode and Read-Only Structures

**Important**: when a 4D project is compiled, the entire `Project/Sources/` folder
(including `lists.json`) is packaged inside a `.4DZ` file as **read-only**. This
means `SAVE LIST` **cannot be used in compiled mode**.

**Rule of thumb**:
- Use `lists.json` (and the List editor) for **static or default lists** — lists
  whose structure is known at design time and does not change at runtime
- Use `New list` + `APPEND TO LIST` (programmatic) for **mutable lists** — lists
  built from data, user input, or any source that changes at runtime
- `Load list` creates a **copy in memory** — you can modify the copy freely at
  runtime, but you cannot save it back in compiled mode

### List-level properties stored in lists.json

These appear at the top level of each named list, outside the `items` array:

| JSON Key | Source | Persisted? | Notes |
|----------|--------|------------|-------|
| `lineHeight` | `SET LIST PROPERTIES` lineHeight param | ✅ Yes | Minimum row height in pixels; omitted when 0 (default) |
| `editable` | `SET LIST PROPERTIES` editable param | ✅ Yes | `false` = list not editable as choice list; omitted when `true` (default) |
| `doubleClick` | `SET LIST PROPERTIES` doubleClick param | ❌ No | Runtime-only — set after `Load list` |
| `multiSelections` | `SET LIST PROPERTIES` multiSelections param | ❌ No | Runtime-only — set after `Load list` |

### Properties stored per item

| JSON Key | Source | Type | Notes |
|----------|--------|------|-------|
| `text` | item text | string | Display text |
| `ref` | itemRef | integer | Reference number |
| `editable` | `SET LIST ITEM PROPERTIES` enterable param | boolean | Per-item editability |
| `collapsed` | expand/collapse state | boolean | `true` = collapsed |
| `fontWeight` | styles bitmask bit 0 (Bold=1) | `"bold"` | Only present when bold |
| `fontStyle` | styles bitmask bit 1 (Italic=2) | `"italic"` | Only present when italic |
| `textDecoration` | styles bitmask bit 2 (Underline=4) | `"underline"` | Only present when underline |
| `stroke` | color param (0x00RRGGBB) | `"#RRGGBB"` | CSS hex string — note the format conversion from integer! |
| `action` | `SET LIST ITEM PARAMETER` with `Associated standard action` | string | Standard action name |
| `subTree` | attached sublist | object with `items` | Nested hierarchy |

### What is NOT persisted to lists.json

**Important**: most `SET LIST ITEM PARAMETER` values are **runtime-only** (in memory).
They are **not saved** by `SAVE LIST`:

- `"4D_additional_text"` — ❌ not saved
- Custom parameters (any user-defined selector) — ❌ not saved
- `SET LIST ITEM FONT` — ❌ not saved (the font set via this command is not persisted)
- `SET LIST ITEM ICON` (Picture-based icons) — ❌ not saved (only `path:`-based icons
  via `SET LIST ITEM PROPERTIES` are saved as the `"icon"` key)

### Icon persistence: two approaches

| Method | `icon` param | Persisted to lists.json? |
|--------|-------------|--------------------------|
| `SET LIST ITEM PROPERTIES($l; ref; True; 0; "path:/RESOURCES/icon.svg")` | File path string | ✅ Yes → `"icon": "/RESOURCES/icon.svg"` (prefix stripped) |
| `SET LIST ITEM ICON($l; ref; $pictureVariable)` | In-memory Picture | ❌ No |

Use `path:` references for design-time icons; use `SET LIST ITEM ICON` for
runtime-generated icons (SVG, loaded images, etc.).

Only `"4D_standard_action_name"` persists as the `"action"` key.

This means: if you need additional text, custom parameters, or per-item fonts/icons,
you must set them **programmatically after `Load list`** — they cannot be defined
in the List editor or `lists.json` alone.

### Style integer → JSON decomposition

The `styles` parameter in `SET LIST ITEM PROPERTIES` is an integer bitmask:

| Value | Constant | JSON keys added |
|-------|----------|-----------------|
| 0 | Plain | (none) |
| 1 | Bold | `"fontWeight": "bold"` |
| 2 | Italic | `"fontStyle": "italic"` |
| 4 | Underline | `"textDecoration": "underline"` |
| 3 | Bold+Italic | both `fontWeight` + `fontStyle` |
| 5 | Bold+Underline | both `fontWeight` + `textDecoration` |
| 7 | All three | all three keys |

### Color integer → CSS hex conversion

The color param (integer `0x00RRGGBB`) is stored as CSS hex `"#RRGGBB"` in the
`stroke` key. This is the **opposite** of `ST SET ATTRIBUTES` which does NOT
accept CSS strings — in `lists.json`, 4D converts for you.

### Selection

| Command | Purpose |
|---------|---------|
| `Selected list items` | Get selected item(s) — returns position or fills array |
| `SELECT LIST ITEMS BY POSITION` | Select by position |
| `SELECT LIST ITEMS BY REFERENCE` | Select by reference |

### In-Place Editing

When `enterable: true`, items can be edited via Alt+click (Windows) /
Option+click (macOS), or a long click on the item text.

The `EDIT ITEM` command (ref: https://developer.4d.com/docs/commands/edit-item)
programmatically puts an item into edit mode:

```4d
// After inserting a new item, make it immediately editable
vlUniqueRef:=vlUniqueRef+1
INSERT IN LIST(hList; *; "New_item"; vlUniqueRef)
EDIT ITEM(*; "MyList")  // edits the current (last inserted) item
```

`EDIT ITEM` also works with list box columns and subforms. If the list is not
enterable, it only selects the item without entering edit mode.

For items created in the List editor, the **Modifiable Element** option
(in the Lists editor properties) controls whether individual items can be edited
(ref, legacy URL: https://doc.4d.com/4Dv20/4D/20.2/Setting-list-properties.300-6750359.en.html).

## Property Priority

When the same property is set in multiple ways, this priority applies:

1. **Hierarchical Lists commands** (highest) — e.g. `SET LIST ITEM PROPERTIES`
2. **Generic object property commands** — e.g. `OBJECT SET COLOR`
3. **Form property** (lowest) — JSON definition

Once an item property is set by a hierarchical list command, the equivalent
generic object command has no effect on that item.

## Modifiable Elements

You can control whether items are editable:

- **Object-level**: the `enterable` property (JSON or `OBJECT SET ENTERABLE`)
  controls the whole list
- **Item-level** (for choice-list-based lists): the "Modifiable Element" flag
  in the List editor controls individual items

Editing is triggered by:
- **Alt+click** (Windows) / **Option+click** (macOS)
- **Long click** on the item text
- `EDIT ITEM` command

## Generic Commands for Hierarchical Lists

These generic object commands also work with hierarchical list form objects:

| Command | Notes |
|---------|-------|
| `OBJECT SET FONT` | Affects all representations |
| `OBJECT SET FONT STYLE` | Affects all representations |
| `OBJECT SET FONT SIZE` | Affects all representations |
| `OBJECT SET COLOR` | Affects all representations |
| `OBJECT SET RGB COLORS` | Affects all representations |
| `OBJECT SET SCROLL POSITION` | Affects **only** the specified representation |
| `OBJECT SET ENTERABLE` | Affects all representations |
| `OBJECT SET VISIBLE` | Affects the specified representation |

**Note**: except `OBJECT SET SCROLL POSITION`, these commands modify **all**
representations of the same list, even when targeting by object name.

## CLI Verification Notes

Hierarchical lists require runtime initialization (programmatic `ListRef`
assignment). Static screenshots (`FORM SCREENSHOT` alone) will show an empty
list object. Use the `dialog_screenshot` pattern (Pattern 4 in `98-tool4d-cli.md`)
with `On Load` initialization to capture a populated list.

Since hierarchical lists are interactive (expand/collapse), capturing different
states may require chained `CALL FORM` calls to programmatically expand items
and then screenshot.
