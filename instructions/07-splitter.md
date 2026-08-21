# 4D Splitter Object

Reference: https://developer.4d.com/docs/FormObjects/splitters

## Basic Definition

```json
{
  "mySplitter": {
    "type": "splitter",
    "left": 150,
    "top": 20,
    "width": 6,
    "height": 200,
    "borderStyle": "dotted"
  }
}
```

A splitter divides a form into two areas, allowing the user to resize them by dragging. Splitters interact with neighboring objects based on those objects' resizing properties (`sizingX`, `sizingY`).

## Orientation

The orientation is determined automatically by the object's dimensions:

- **Vertical splitter**: `height > width` -- divides left and right areas
- **Horizontal splitter**: `width > height` -- divides top and bottom areas

There is no explicit orientation property. The convention is to use a narrow dimension (e.g., 6px) for the draggable axis.

## Visual Appearance

### Border Styles

| `borderStyle` | Appearance |
|---------------|------------|
| `"dotted"` | Dotted line, centered in the object region |
| `"solid"` | Solid line |
| `"raised"` | Raised 3D line |
| `"sunken"` | Sunken 3D line |
| `"none"` | Invisible -- no visible line, but still functional |

The line is drawn **centered** within the object's rectangular region. For example, a splitter at `left: 150, width: 6` draws its line at approximately x=153.

### Line Color

The `stroke` property sets the line color (same as other form objects).

### Mouse Cursor

Regardless of visibility, the mouse cursor changes to a resize cursor when hovering over the splitter's area. This is how users discover invisible splitters.

## Splitter Mode

| Mode | JSON `splitterMode` | Behavior |
|------|---------------------|----------|
| Standard | (omitted or default) | Stops when meeting another splitter or the window border |
| Pusher | `"move"` | No stops when moving right/down -- can push objects indefinitely |

A **pusher** splitter does not encounter stops when moving toward the right or downward. Objects are pushed continuously with no boundary constraint.

```json
{
  "mySplitter": {
    "type": "splitter",
    "splitterMode": "move",
    "left": 280,
    "top": 20,
    "width": 6,
    "height": 200,
    "borderStyle": "solid"
  }
}
```

## Data Source

The splitter's variable holds the **distance traveled** from its initial position, in pixels.

- Negative value: moved toward top (horizontal) or left (vertical)
- Positive value: moved toward bottom (horizontal) or right (vertical)
- Zero: at original position

**Important characteristics:**
- The value is **not cumulative** -- it resets with each mouse move event
- Assigning a value programmatically moves the splitter (move happens at end of method execution)
- The data source **must be a variable** (process variable), not an expression like `Form.splitter`
  - This is because 4D automatically writes to the variable during drag operations

### Shared Data Source

Multiple form objects can share the same data source. For example:

```json
{
  "splitter1": {
    "type": "splitter",
    "left": 23,
    "top": 90,
    "width": 6,
    "height": 166,
    "borderStyle": "dotted",
    "dataSource": "s1"
  },
  "Input": {
    "type": "input",
    "left": 14,
    "top": 25,
    "width": 72,
    "height": 17,
    "dataSource": "s1",
    "dataSourceTypeHint": "integer"
  }
}
```

In this configuration:
- Moving the splitter updates the input field with the travel distance
- Typing a value in the input and pressing Tab/Return moves the splitter by that amount

**Limitation**: A splitter's data source cannot be used to drive another splitter -- only non-splitter objects respond to the shared variable.

## Interaction with Neighboring Objects

Splitters resize or move neighboring objects based on those objects' `sizingX`/`sizingY` properties:

### Objects above/left of the splitter

| Object's sizing | Effect |
|-----------------|--------|
| `"fixed"` (None) | Remain as is |
| `"grow"` (Resize) | Keep position, resize according to splitter's new position |
| `"move"` (Move) | Move with the splitter |

Objects above/left act as stops -- you cannot drag the splitter past them.

### Objects below/right of a **standard** splitter

| Object's sizing | Effect |
|-----------------|--------|
| `"fixed"` (None) | Moved with the splitter until the next stop (window border or another splitter) |
| `"grow"` (Resize) | Keep position, resize according to splitter's new position |
| `"move"` (Move) | Move with the splitter |

### Objects below/right of a **pusher** splitter

| Object's sizing | Effect |
|-----------------|--------|
| `"fixed"` (None) | Moved with the splitter indefinitely (no stops) |
| `"grow"` (Resize) | Keep position, resize according to splitter's new position |
| `"move"` (Move) | Move with the splitter |

### Coverage Rule

A splitter only affects objects that are **completely covered** by the splitter's span:

- **Vertical splitter**: only objects whose full height falls within the splitter's top-to-bottom range are affected
- **Horizontal splitter**: only objects whose full width falls within the splitter's left-to-right range are affected

Objects that are only partially covered are **not moved or resized** by the splitter, even if they are positioned to its left/right or above/below.

For example, if a vertical splitter spans top=91 to bottom=257, a button at top=54, height=49 (bottom=103) extends above the splitter's top edge and is therefore **not affected**. A button at top=111, height=49 (bottom=160) is fully within range and **will be affected**.

### Stops

For objects to the left/above (standard and pusher), the splitter cannot be dragged past them.

For objects to the right/below of a **standard** splitter, the splitter stops as soon as its edge reaches the near edge of the object (e.g., splitter's right edge touches the object's left edge). No overlapping occurs. Affected objects with `"move"` sizing move with the splitter; objects with `"grow"` sizing resize.

For objects to the right/below of a **pusher** splitter, objects with `"move"` sizing are pushed along with the splitter. They keep moving until they run out of room — i.e., they hit the form margin (`rightMargin` or `bottomMargin`). The pusher does not respect other splitters or objects as stops, but pushed objects cannot leave the form's margin boundary.

## Events

- `onClick` (On Clicked) -- fires throughout the entire drag movement, not just on click
- `onDoubleClick` (On Double Clicked)
- `onLoad` / `onUnload`
- `onMouseEnter` / `onMouseLeave` / `onMouseMove`
- `onBeginDragOver` / `onDragOver` / `onDrop`
- `onHeader` / `onPrintingBreak` / `onPrintingDetail` / `onPrintingFooter`
- `onValidate`

## Supported Properties

| Property | JSON Name | Type | Description |
|----------|-----------|------|-------------|
| Border line style | `borderStyle` | string | `"none"`, `"solid"`, `"dotted"`, `"raised"`, `"sunken"` |
| Line color | `stroke` | string | Color of the splitter line |
| Pusher | `splitterMode` | string | `"move"` for pusher mode; omit for standard |
| Horizontal sizing | `sizingX` | string | How the splitter itself resizes with the form |
| Vertical sizing | `sizingY` | string | How the splitter itself resizes with the form |
| Variable | `dataSource` | string | Process variable name (integer) |
| Visibility | `visibility` | string | `"visible"` or `"hidden"` |
| Help Tip | `tooltip` | string | Tooltip text |
| Class | `class` | string | CSS class |
| Coordinates | `left`, `top`, `width`, `height`, `right`, `bottom` | integer | Position and size |

## Key Differences from Other Objects

| Aspect | Splitter | Button | Button Grid |
|--------|----------|--------|-------------|
| Visual | Line or invisible | System-drawn styles | Transparent overlay |
| Data source | Distance traveled (resets) | 0 or 1 toggle | Cell number (1-based) |
| Must use variable | Yes | Yes (buttons) | Yes |
| Orientation | Determined by width vs height | N/A | N/A |
| User interaction | Drag | Click | Click |

## Important Notes

- Form dimensions are **not saved** after splitter movement -- when the form closes, the initial layout is restored
- You can place multiple splitters (both horizontal and vertical) in the same form
- A splitter can cross (overlap) objects -- those objects will resize when the splitter moves
- Splitter stops are calculated automatically to keep objects visible and prevent overlap with other splitters (except in pusher mode)
