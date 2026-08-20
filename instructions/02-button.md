# 4D Button Object

Reference: https://developer.4d.com/docs/FormObjects/buttonOverview

## Basic Definition

```json
{
  "MyButton": {
    "type": "button",
    "text": "Click Me",
    "top": 20,
    "left": 20,
    "width": 146,
    "height": 24,
    "events": ["onClick"]
  }
}
```

The object name is the JSON key (e.g., `"MyButton"`). This name is used:
- As the filename for the object method (`ObjectMethods/MyButton.4dm`)
- As the CSS ID selector (`#MyButton { ... }`)
- In code with `FORM Event.objectName`

## Button Styles

Set via the `style` property. Each style has a distinct visual appearance.

| Style | Description |
|-------|-------------|
| `regular` | **(default)** Native macOS/Windows system button. Rounded with light gray background. |
| `flat` | Clean rectangle with thin border and rounded corners. Minimalist. |
| `toolbar` | Transparent background, no border. Appears as plain text until hovered. Designed for toolbars. |
| `bevel` | Rectangular with thin border, square corners. |
| `roundedBevel` | Like bevel but with rounded corners. |
| `gradientBevel` | Rounded with subtle gradient fill. |
| `texturedBevel` | Gray textured background, no visible border. |
| `office` | Light blue background with thin border. |
| `help` | Circular "?" icon. **Ignores the `text` property entirely.** |
| `circular` | Circular outline with text displayed below. |
| `custom` | No visible chrome. Designed for use with `customBackgroundPicture`. |

### Style-Specific Constraints

- **`defaultButton`** is only available for `regular` and `flat` styles.
- **`customBackgroundPicture`**, **`customBorderX`**, **`customBorderY`**, **`customOffset`** are only for `custom` style.
- **`popupPlacement`** works with `toolbar`, `bevel`, `roundedBevel`, `gradientBevel`, `texturedBevel`, `office` styles.

## Visual Properties

### Text and Font

| Property | Values | Description |
|----------|--------|-------------|
| `text` | string | Button label text |
| `textAlign` | `"left"`, `"center"`, `"right"` | Text alignment within the button |
| `fontWeight` | `"normal"`, `"bold"` | Font weight |
| `fontStyle` | `"normal"`, `"italic"` | Font style |
| `textDecoration` | `"none"`, `"underline"` | Text decoration |
| `fontSize` | integer | Font size in points |
| `fontFamily` | string | Font family name (e.g., `"Courier New"`, `"Georgia"`) |
| `stroke` | CSS color | **Text color**. Also affects border color on `flat`-style buttons. Works on all styles. |

All font properties can be combined (bold + italic + underline + custom size + custom font).
Font properties also combine naturally with icons — large `fontSize` scales text but not the icon.

### Appearance

| Property | Values | Description |
|----------|--------|-------------|
| `defaultButton` | boolean | Highlights as the recommended action. Only for `regular` and `flat`. |
| `borderStyle` | `"system"`, `"none"`, `"solid"`, `"dotted"`, `"raised"`, `"sunken"`, `"double"` | Border line style |
| `visibility` | `"visible"`, `"hidden"` | `"hidden"` shows a dashed outline in the editor but is invisible at runtime |
| `display` | boolean | `false` = not rendered at all, but still active |
| `focusable` | boolean | Whether the button can receive keyboard focus. A focusable object is always tabbable. |

#### `defaultButton` Behavior

- **`regular` + `defaultButton`**: blue background with white text (macOS accent). If an icon is present, it renders inside the blue button.
- **`flat` + `defaultButton`**: thick black border. If `stroke` is set, the stroke color is used for both text AND the thick border.

#### `borderStyle` Behavior by Style

- **`flat`**: respects all border styles clearly — `solid`, `raised`, `sunken`, `dotted`, `double` are all visually distinct.
- **`bevel`**: responds to border overrides. `"none"` removes the border entirely.
- **`regular`**: largely ignores border overrides (native capsule shape dominates). `"none"` shows dashed outline (like hidden).

### Icon and Popup

| Property | Values | Description |
|----------|--------|-------------|
| `icon` | path | Path to icon image (e.g., `"/SOURCES/Forms/MyForm/icon.png"`) |
| `textPlacement` | `"left"`, `"right"`, `"top"`, `"bottom"`, `"center"` | Position of text **relative to the icon** |
| `iconFrames` | integer (min 1) | Number of frames in the icon image |
| `imageHugsTitle` | boolean | Whether icon stays close to the text (see below) |
| `popupPlacement` | `"none"`, `"linked"`, `"separated"` | Popup menu indicator (see below) |

#### `textPlacement` Details

- `"right"`: icon on the left, text on the right
- `"left"`: text on the left, icon on the right
- `"top"`: text above, icon below (vertical stacking)
- `"bottom"`: icon above, text below (vertical stacking)
- `"center"`: icon and text overlap in the center

Icons work with all button styles. The `regular` style renders the icon inside its native capsule shape.

#### `imageHugsTitle` Details

Controls how icon and text are positioned within the button area:

- **`false` (default)**: icon is anchored to the edge of the button. Text is centered independently. On wide buttons, icon and text appear far apart.
- **`true`**: icon and text move together as a unit, staying close to each other regardless of button width.

Best demonstrated on wide buttons where the difference is clearly visible.

#### `popupPlacement` Details

- **`"none"` (default)**: no popup menu.
- **`"linked"`**: small triangle indicator in the bottom-right corner. The entire button triggers the popup.
- **`"separated"`**: vertical divider line creating a separate clickable triangle zone on the right. The main button area and the popup trigger are independent click targets.

Works with `toolbar`, `bevel`, `roundedBevel`, `gradientBevel`, `texturedBevel`, `office` styles. Combines with icons — the icon, text, and popup triangle all coexist.

### Special Style Notes

#### `help` Style

- Always renders as a circular "?" button.
- The `text` property is **completely ignored**.
- Scales the circle to fit the smaller of `width`/`height`.
- The question mark appearance is fixed and cannot be customized.

#### `circular` Style

- Renders a circular outline with text displayed **below** the circle.
- If an `icon` is provided, it replaces the circle content.
- `stroke` colors the text below but not the circle outline.
- `fontWeight` and other font properties apply to the text below the circle.

### Custom Style Properties

Only applicable when `style` is `"custom"`:

| Property | Description |
|----------|-------------|
| `customBackgroundPicture` | Path to background image |
| `customBorderX` | Horizontal internal margin (pixels) |
| `customBorderY` | Vertical internal margin (pixels) |
| `customOffset` | Icon offset (pixels) |

## Positioning and Sizing

| Property | Type | Description |
|----------|------|-------------|
| `top` | integer | **Required**. Y position from form top |
| `left` | integer | **Required**. X position from form left |
| `width` | integer | Button width |
| `height` | integer | Button height |
| `bottom` | integer | Bottom position |
| `right` | integer | Right position |
| `sizingX` | enum | `"move"`, `"grow"`, `"fixed"` — horizontal behavior on form resize |
| `sizingY` | enum | `"move"`, `"grow"`, `"fixed"` — vertical behavior on form resize |

## Events

The most important event for a button is **`onClick`** (On Clicked).

- `onClick` fires on **mouse up** (while the cursor is still hovering over the button).
- If the user presses and drags away before releasing, the event does **not** fire.
- The `onClick` event does **not** require the form to also subscribe to `onClick` — it works independently at the object level (unlike `onLoad`/`onUnload`).

### Event Execution Order

When a button is clicked:

1. **Object method** runs first
2. **Form method** runs second
3. **Standard action** runs last

### Click Events in Detail

#### Single and Double Click

- `onClick` (On Clicked) fires on every click.
- `onDoubleClick` (On Double Clicked) fires on the 2nd rapid click **instead of** `onClick` — the click event is consumed/replaced.
- After the double-click, subsequent rapid clicks fire only `onClick` with incrementing `Clickcount`.

Example: 10 rapid clicks produces:

```
On Clicked (Clickcount=1)
On Double Clicked (Clickcount=2, replaces On Clicked)
On Clicked (Clickcount=3)
On Clicked (Clickcount=4)
...
On Clicked (Clickcount=10)
```

#### Clickcount

`Clickcount` (command #1332) returns how many clicks have occurred in a rapid sequence. It keeps incrementing as long as clicks are rapid enough (governed by the system double-click interval). It resets when the user pauses.

Reference: https://developer.4d.com/docs/commands/clickcount

#### Modifier Keys

Detect modifier keys during a click using these commands. Despite platform-specific names, they work **cross-platform**:

| Command | Mac Key | Windows Key |
|---------|---------|-------------|
| `Shift down:C543` | Shift | Shift |
| `Macintosh command down:C546` | ⌘ Command | Ctrl |
| `Macintosh option down:C545` | ⌥ Option | Alt |
| `Macintosh control down:C544` | ⌃ Control | — |
| `Windows Ctrl down` | ⌘ Command | Ctrl |
| `Windows Alt down` | ⌥ Option | Alt |
| `Caps lock down` | Caps Lock | Caps Lock |
| `Contextual click:C713` | Ctrl+click / right-click | Right-click |

References:
- https://developer.4d.com/docs/commands/shift-down
- https://developer.4d.com/docs/commands/macintosh-command-down
- https://developer.4d.com/docs/commands/macintosh-option-down
- https://developer.4d.com/docs/commands/macintosh-control-down
- https://developer.4d.com/docs/commands/windows-ctrl-down
- https://developer.4d.com/docs/commands/windows-alt-down
- https://developer.4d.com/docs/commands/caps-lock-down

#### Recommended Pattern

Test modifiers in a `Case of` with priority ordering — the first match wins:

```4d
var $event:=FORM Event

Case of 
  : (FORM Event.code=On Double Clicked)
    // double-click action

  : ((FORM Event.code=On Clicked) && Contextual click)
    // right-click / Ctrl+click

  : ((FORM Event.code=On Clicked) && Shift down)
    // Shift+click

  : ((FORM Event.code=On Clicked) && Macintosh command down)
    // ⌘+click (Mac) / Ctrl+click (Win)

  : ((FORM Event.code=On Clicked) && Macintosh option down)
    // ⌥+click (Mac) / Alt+click (Win)

  : (FORM Event.code=On Clicked)
    // plain click (fallback)

End case 
```

### Object Method File

The object method file is at `ObjectMethods/<ObjectName>.4dm`.

## Data Source

A button's data source can be an **integer** or **boolean**.

- The value becomes **1** (or `True`) when the button is pressed.
- It returns to **0** (or `False`) after the event cycle completes.
- **During the `onClick` event**, the value is still **1** — it resets after the event methods finish.

### Important Exception

Unlike most form objects, a button can only use a **variable** as its data source (not a `Form.property` expression).

**Recommended**: use a form local (dynamic) variable rather than a process variable. The scope and lifecycle of a dynamic variable matches the form.

```json
{
  "MyButton": {
    "type": "button",
    "dataSource": "myButton",
    "top": 20,
    "left": 20,
    "width": 146,
    "height": 24
  }
}
```

To read the value in code:

```4d
// Get pointer to the button's data source variable
OBJECT Get pointer(Object named; FORM Event.objectName)->
// Returns 1 during onClick, 0 otherwise
```

## Standard Actions

Buttons can have a `action` property for built-in behaviors (e.g., `"accept"`, `"cancel"`, `"gotoPage"`).

Reference: https://developer.4d.com/docs/FormObjects/propertiesAction#standard-action

A button can have **both** a method and a standard action. The method runs first, then the standard action. This allows code to conditionally modify or block the built-in behavior.

## CSS Styling

Button properties can be set via CSS stylesheets.

```css
/* All buttons */
button {
  style: flat;
  text: "Default Label";
}

/* Buttons with class "primary" */
.primary {
  stroke: #FFFFFF;
  fontWeight: bold;
}

/* A specific button by name */
#SubmitButton {
  text: "Submit";
  defaultButton: true;
}

/* Light/dark mode */
@media (prefers-color-scheme: light) {
  button { stroke: #000080; }
}
@media (prefers-color-scheme: dark) {
  button { stroke: #7FFFD4; }
}
```

CSS property names match the JSON property names. Specificity follows the standard cascade: type < class < name/ID < JSON < `!important`.
