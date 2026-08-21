# 4D Ruler Object

Reference: https://developer.4d.com/docs/FormObjects/ruler

## Basic Definition

```json
{
  "myRuler": {
    "type": "ruler",
    "left": 10,
    "top": 25,
    "width": 300,
    "height": 25,
    "min": 0,
    "max": 100,
    "events": ["onDataChange"]
  }
}
```

A ruler is an interactive slider control that allows the user to set or view a numeric value by dragging a cursor along a graduated track. The ruler is bidirectional -- dragging changes the data source, and updating the data source by code moves the cursor.

## Orientation

Like splitters, orientation is determined by dimensions:
- **Horizontal**: `width > height`
- **Vertical**: `height > width`

The height (horizontal) or width (vertical) also determines the size variant of the cursor, similar to how button/checkbox height selects size variants.

## Data Source

Unlike splitters, a ruler **can use `Form.property` expressions** as data sources. This makes rulers more flexible for form-based data binding.

Multiple rulers can share the same data source and they will **stay in sync** -- moving one ruler updates all others bound to the same expression. This is different from splitters, where one splitter cannot drive another via a shared data source.

```json
{
  "ruler1": {
    "type": "ruler",
    "dataSource": "Form:C1466.ruler",
    ...
  },
  "ruler2": {
    "type": "ruler",
    "dataSource": "Form:C1466.ruler",
    ...
  }
}
```

The data source value represents the current position within the min/max range.

## Scale Properties

| Property | JSON Name | Type | Description |
|----------|-----------|------|-------------|
| Minimum | `min` | number | Minimum value of the ruler (left/top end) |
| Maximum | `max` | number | Maximum value of the ruler (right/bottom end) |
| Step | `step` | integer | Minimum interval between selectable values (snapping). Minimum: 1 |

### Step

The `step` property controls the granularity of value selection. For example, with `min: 0`, `max: 50`, `step: 5`, the user can only select values 0, 5, 10, 15, ..., 50.

## Display Properties

### Graduation

| Property | JSON Name | Type | Description |
|----------|-----------|------|-------------|
| Display graduation | `showGraduations` | boolean | Show/hide tick marks along the track |
| Graduation step | `graduationStep` | integer | Interval between graduation tick marks |

Graduation ticks are small marks along the ruler track. They are purely visual and independent of the `step` property (though typically they match or are multiples of `step`).

### Labels

| Property | JSON Name | Type | Description |
|----------|-----------|------|-------------|
| Label location | `labelsPlacement` | string | Where to display numeric labels |

Values for `labelsPlacement`:
- `"none"` -- no labels (default)
- `"top"` -- labels above (horizontal) or to the left (vertical)
- `"bottom"` -- labels below (horizontal) or to the right (vertical)
- `"left"` -- labels to the left
- `"right"` -- labels to the right

Labels display the numeric values at each graduation mark. Labels require `showGraduations: true` and a `graduationStep` to know where to place them.

**Note**: The ruler needs sufficient height (horizontal) or width (vertical) to accommodate labels. A height of ~40px works well for horizontal rulers with labels.

## Other Properties

| Property | JSON Name | Type | Description |
|----------|-----------|------|-------------|
| Border line style | `borderStyle` | string | Border around the ruler |
| Enterable | `enterable` | boolean | Whether the user can interact with the ruler |
| Bold | `fontWeight` | string | Bold text for labels |
| Horizontal sizing | `sizingX` | string | Resize behavior with form |
| Vertical sizing | `sizingY` | string | Resize behavior with form |
| Help Tip | `tooltip` | string | Tooltip text |
| Class | `class` | string | CSS class |
| Visibility | `visibility` | string | `"visible"` or `"hidden"` |
| Number Format | `numberFormat` | string | Format for label values |
| Expression Type | `dataSourceTypeHint` | string | Type hint for the data source |

## Events

- `onDataChange` (On Data Change) -- fires when the value changes (primary event)
- `onClick` (On Clicked) / `onDoubleClick` (On Double Clicked)
- `onLoad` / `onUnload`
- `onGettingFocus` / `onLosingFocus`
- `onMouseEnter` / `onMouseLeave` / `onMouseMove`
- `onBeginDragOver` / `onDragOver` / `onDrop`
- `onHeader` / `onPrintingBreak` / `onPrintingDetail` / `onPrintingFooter`
- `onValidate`

## Comparison with Splitter

| Feature | Ruler | Splitter |
|---------|-------|----------|
| Purpose | Set/display a value | Resize form areas |
| Data source value | Current position in min/max range | Distance traveled (resets) |
| `Form.property` allowed | Yes | No (must use variable) |
| Sync multiple instances | Yes (shared data source syncs all) | No (can't drive another splitter) |
| Affects other objects | No | Yes (moves/resizes neighbors) |
| Orientation | width vs height | width vs height |
| Visual options | Graduations, labels, track | Border line only |
| Scale control | min, max, step, graduationStep | None |

## Relationship to Thermometer / Progress Indicator

The ruler and thermometer (progress indicator) share the same scale properties (`min`, `max`, `step`, `showGraduations`, `graduationStep`, `labelsPlacement`). The difference is:

- **Ruler**: always interactive (user drags cursor)
- **Thermometer**: typically display-only (set by code), though it can be made enterable

Reference: https://developer.4d.com/docs/FormObjects/progressIndicator#using-indicators
