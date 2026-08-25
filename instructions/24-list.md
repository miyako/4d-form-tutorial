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
