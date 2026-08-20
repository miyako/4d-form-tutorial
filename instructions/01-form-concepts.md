# 4D Form Concepts

## What is a Form

A Form is the basic unit of user interface definition in 4D. Forms are defined in JSON (file extension `.4DForm`).

- **Project form**: not associated with any data table.
- **Table form**: associated with a specific data table.
- **Subform**: a form embedded in another form (like an iframe in HTML). Subforms create a local coordinate system within their container. Subforms can themselves contain subforms.

Reference: https://developer.4d.com/docs/FormEditor/forms
JSON schema: https://developer.4d.com/docs/FormEditor/jsonReference

## File Structure

### Project Forms

```
Project/Sources/Forms/<FormName>/form.4DForm
```

Each form gets its own folder. The folder name **is** the form name. Naming is arbitrary but subject to filesystem constraints (unique within scope, no special characters).

### Table Forms

```
Project/Sources/TableForms/<TableNumber>/<FormName>/form.4DForm
```

Table forms are organized by **table number** (not table name). The table number is defined in `catalog.4DCatalog`.

### Methods

- **Form method**: `Forms/<FormName>/method.4dm`
- **Object methods**: `Forms/<FormName>/ObjectMethods/<ObjectName>.4dm`

### Example Directory Layout

```
Project/
  Sources/
    Forms/
      MyProjectForm/
        form.4DForm
        method.4dm
        ObjectMethods/
          Button.4dm
    TableForms/
      1/
        Input/
          form.4DForm
        Output/
          form.4DForm
    styleSheets.css
    styleSheets_mac.css
    styleSheets_windows.css
```

## Minimal Form JSON

Every form must have:

- `$4d` metadata (`version`, `kind`)
- Window sizing properties
- At least one event in the `events` array (typically `onLoad`)
- A `destination` value
- A `pages` array with at least 2 entries (page 0 and page 1)

```json
{
  "$4d": {
    "version": "1",
    "kind": "form"
  },
  "windowSizingX": "variable",
  "windowSizingY": "variable",
  "windowMinWidth": 0,
  "windowMinHeight": 0,
  "windowMaxWidth": 32767,
  "windowMaxHeight": 32767,
  "rightMargin": 20,
  "bottomMargin": 20,
  "events": ["onLoad", "onUnload"],
  "windowTitle": "window title",
  "destination": "detailScreen",
  "pages": [
    { "objects": {} },
    { "objects": {} }
  ]
}
```

### Key Properties

| Property | Description |
|----------|-------------|
| `$4d` | Metadata: `version` and `kind` (always `"form"`) |
| `windowSizingX/Y` | `"fixed"` or `"variable"` |
| `windowMinWidth/Height` | Minimum window dimensions |
| `windowMaxWidth/Height` | Maximum window dimensions (32767 = effectively unlimited) |
| `rightMargin` / `bottomMargin` | Define form size relative to rightmost/bottommost object |
| `width` / `height` | Explicit form size (alternative to margins) |
| `destination` | `"detailScreen"`, `"listScreen"`, `"detailPrinter"`, `"listPrinter"` |
| `geometryStamp` | Incremented by the form editor on each save |
| `method` | Path to the form method (e.g., `"method.4dm"`) |

### Destination

- **`detailScreen`**: a detail form for screen display (used for both project forms and table input forms).
- **`listScreen`**: a list form for screen display (used for table output forms). Includes markers (`markerHeader`, `markerBody`) to define header/body row heights.

## Pages

The `pages` array defines logical rendering layers.

- **Index 0 = Page 0**: objects here are **always visible** regardless of which page is displayed.
- **Index 1+ = Pages 1, 2, ...**: only the active page's objects are rendered.

Each page contains an `objects` map (keyed by object name) and an optional `entryOrder` array.

```json
"pages": [
  {
    "objects": { }
  },
  {
    "objects": {
      "Button": {
        "type": "button",
        "text": "Click Me",
        "top": 20,
        "left": 20,
        "width": 146,
        "height": 24
      }
    }
  }
]
```

## Form Events

Forms subscribe to events via the `events` array. Only subscribed events will trigger a form event cycle.

Reference: https://developer.4d.com/docs/Events/overview

### Special Events: `onLoad` and `onUnload`

These two events are special **gate events**:

- `onLoad`: fires before the form is loaded. Used for initialization.
- `onUnload`: fires before the form is destroyed from memory. Used for cleanup.

**Critical rule**: Individual form objects can subscribe to `onLoad` or `onUnload`, but these events are **only processed for objects if the form itself also subscribes to them**. If an object needs `onLoad`, the form must have `onLoad` in its `events` array.

All other events (e.g., `onClick`) can be enabled independently at the object level — they do not require the form to also subscribe.

### Event Execution Order

When an event fires on an object:

1. **Object method** executes first
2. **Form method** executes second
3. **Standard action** executes last

This means code always runs before any built-in standard action, allowing you to conditionally modify or block the action.

## Form Objects

Every form object has a `type` property and positioning via `top` and `left` (required).

### Common Properties (`objectCommon`)

| Property | Type | Description |
|----------|------|-------------|
| `top` | integer | **Required**. Y position |
| `left` | integer | **Required**. X position |
| `width` | integer | Object width |
| `height` | integer | Object height |
| `bottom` | integer | Bottom position |
| `right` | integer | Right position |
| `visibility` | enum | `"visible"`, `"hidden"`, `"selectedRows"`, `"unselectedRows"` |
| `sizingX` | enum | `"move"`, `"grow"`, `"fixed"` — horizontal resizing behavior |
| `sizingY` | enum | `"move"`, `"grow"`, `"fixed"` — vertical resizing behavior |
| `class` | string | CSS class name(s) for stylesheet selectors |

### Available Object Types

`text`, `input`, `button`, `checkbox`, `radio`, `dropdown`, `combo`, `groupBox`, `tab`, `line`, `rectangle`, `oval`, `picture`, `write`, `view`, `webArea`, `subform`, `listbox`, `plugin`, `splitter`, `progress`, `ruler`, `spinner`, `stepper`, `list`, `buttonGrid`, `pictureButton`, `picturePopup`

## CSS Stylesheets

4D supports CSS for styling form objects. This uses CSS **syntax** but is not the web CSS specification.

Reference: https://developer.4d.com/docs/FormEditor/stylesheets

### Specificity (lowest → highest)

1. Object **type** selector: `button { ... }`
2. Object **class** selector: `.myClass { ... }` (matches the object's `class` property)
3. Object **name/ID** selector: `#MyButton { ... }` (matches the object's JSON key name)
4. **JSON property** defined directly on the object (strongest)
5. `!important` declaration overrides the default priority

### System Stylesheets (always loaded)

```
/SOURCES/styleSheets.css
/SOURCES/styleSheets_mac.css
/SOURCES/styleSheets_windows.css
```

### Custom Stylesheets

Additional stylesheets can be loaded via the form's `css` property. They must use **file system paths** with reserved prefixes:

- `/DATA/`, `/LOGS/`, `/PACKAGE/`, `/PROJECT/`, `/RESOURCES/`, `/SOURCES/`

A CSS file adjacent to the `.4DForm` file can be referenced by filename only.

### Media Queries

```css
@media (form-theme: mac-classic) { }
@media (form-theme: win-classic) { }
@media (form-theme: fluent-ui) {
  @media (prefers-color-scheme: light) { }
  @media (prefers-color-scheme: dark) { }
}
@media (form-theme: liquid-glass) { }
```

| Theme | Minimum Version |
|-------|----------------|
| `fluent-ui` | 4D 21 R2 |
| `liquid-glass` | 4D 21 R3 |

### CSS Example

```css
button {
  text: "Click Me";
  style: flat;
}

@media (prefers-color-scheme: light) {
  button {
    stroke: #000080;
  }
}

@media (prefers-color-scheme: dark) {
  button {
    stroke: #7FFFD4;
  }
}
```

## Data Sources

Interactive form objects can have an associated data source.

Reference: https://developer.4d.com/docs/FormObjects/propertiesDataSource

It is recommended to use **form local variables** (dynamic variables) rather than process variables, because the scope and lifecycle of a form local variable matches that of the form.

Reference: https://developer.4d.com/docs/FormObjects/propertiesObject#dynamic-variables

Use `OBJECT Get pointer` to dereference the dynamic variable data source of a form object.

Reference: https://developer.4d.com/docs/commands/object-get-pointer

## Version Encoding

The `.4DProject` file's `compatibilityVersion` encodes the 4D version:

| Value | Version |
|-------|---------|
| `2101` | 21.1 |
| `2009` | 20.9 |
| `2120` | 21 R2 |
| `20A0` | 20 R10 |

## CLI Commands for Testing

### Screenshot (no CSS applied)

```bash
/Applications/4D\ 21.1/4D.app/Contents/MacOS/4D \
  --startup-method=project_form_to_image \
  --dataless --headless \
  --project=<path>/example.4DProject \
  --user-param=<FormName>:<PageNumber>:<OutputPath.png>
```

### Print to PDF (CSS applied)

```bash
/Applications/4D\ 21\ R3/4D.app/Contents/MacOS/4D \
  --startup-method=print_form_to_file \
  --dataless --headless \
  --project=<path>/example.4DProject \
  --user-param=<FormName>:<PageNumber>:<OutputPath.pdf>
```

Note: `FORM SCREENSHOT` does **not** apply CSS stylesheets. Use print form output to verify CSS styling.
