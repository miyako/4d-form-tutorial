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
| `stroke` | CSS color | **Text color** (also affects border on flat-style buttons) |

All font properties can be combined (bold + italic + underline + custom size + custom font).

### Appearance

| Property | Values | Description |
|----------|--------|-------------|
| `defaultButton` | boolean | Highlights as the recommended action. Regular style turns blue; flat style gets thick border. Only for `regular` and `flat`. |
| `borderStyle` | `"system"`, `"none"`, `"solid"`, `"dotted"`, `"raised"`, `"sunken"`, `"double"` | Border line style |
| `visibility` | `"visible"`, `"hidden"` | `"hidden"` shows a dashed outline in the editor but is invisible at runtime |
| `display` | boolean | `false` = not rendered at all, but still active |
| `focusable` | boolean | Whether the button can receive keyboard focus. A focusable object is always tabbable. |

### Icon and Popup

| Property | Values | Description |
|----------|--------|-------------|
| `icon` | path | Path to icon image (e.g., `"/SOURCES/Forms/MyForm/icon.png"`) |
| `textPlacement` | `"left"`, `"right"`, `"top"`, `"bottom"`, `"center"` | Position of text **relative to the icon** |
| `iconFrames` | integer (min 1) | Number of frames in the icon image |
| `imageHugsTitle` | boolean | Keep icon close to the text rather than at a fixed position |
| `popupPlacement` | `"none"`, `"linked"`, `"separated"` | Popup menu indicator. `"linked"` = triangle in corner, whole button triggers popup. `"separated"` = separate clickable triangle area with divider. |

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

### Object Method Pattern

```4d
var $event:=FORM Event

Case of 
  : (FORM Event.code=On Clicked)
    // handle click
End case 
```

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
