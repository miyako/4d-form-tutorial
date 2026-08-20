# 4D Checkbox Object

Reference: https://developer.4d.com/docs/FormObjects/checkboxOverview

## Basic Definition

```json
{
  "MyCheckBox": {
    "type": "checkbox",
    "text": "Enable Feature",
    "top": 20,
    "left": 20,
    "width": 150,
    "height": 20,
    "events": ["onClick"]
  }
}
```

A checkbox is a type of button used to enter or display binary (true-false) data. It is either checked or unchecked, with an optional third state for intermediate values.

The object name is the JSON key. As with buttons:
- It is the filename for the object method (`ObjectMethods/MyCheckBox.4dm`)
- It is the CSS ID selector (`#MyCheckBox { ... }`)
- It is available in code via `FORM Event.objectName`

## Relationship to Buttons

Checkboxes are closely related to buttons. They share most of the same visual properties, events, and behavior patterns. Key differences:

| Feature | Button | Checkbox |
|---------|--------|----------|
| Data source value | 1 during click, then 0 | Toggles: 0 (unchecked) / 1 (checked) / 2 (third state) |
| Data source types | Integer or Boolean (variable only) | Integer or Boolean |
| State persistence | Momentary (resets after click) | Persistent (stays checked/unchecked) |
| Three-states | No | Yes (regular and flat styles only, integer variables only) |
| Standard actions | Generic actions (accept, cancel, etc.) | Checkable actions (fontBold, fontItalic, etc.) |
| Available styles | All 11 styles | 9 styles (no `help` or `custom`) |

## Data Source

A checkbox can be associated with an **integer** or **boolean** variable or expression.

Unlike buttons (which can only use variables), checkboxes **can** use `Form.property` expressions as their data source:

```json
{
  "dataSource": "Form.myCheck",
  "threeState": true
}
```

This allows pre-setting the checkbox state before displaying the form:

```4d
$form:=cs.MyController.new()
$form.myCheck:=2  // intermediate state
DIALOG("MyForm"; $form)
```

### Integer data source
- **0** = unchecked
- **1** = checked
- **2** = third state (intermediate)

### Boolean data source
- **False** = unchecked
- **True** = checked
- Three-states is **not available** with boolean expressions

When the form opens, the checkbox variable is initialized to 0 (unchecked).

## Three-States Checkbox

Reference: https://developer.4d.com/docs/FormObjects/propertiesDisplay#three-states

The third state is an intermediate status, typically used for display purposes. For example, indicating that a property is present in some but not all objects in a selection.

Requirements:
- Only available for **regular** and **flat** styles
- Must use a **numeric** (integer) variable or expression (not boolean)
- Set the `threeState` property to `true`

```json
{
  "MyThreeStateCheck": {
    "type": "checkbox",
    "style": "regular",
    "text": "Select All",
    "threeState": true,
    "dataSourceTypeHint": "integer",
    "dataSource": "Form.selectAll",
    "top": 20,
    "left": 20,
    "width": 150,
    "height": 20,
    "events": ["onClick"]
  }
}
```

In entry mode, the three states cycle sequentially: unchecked (0) -> checked (1) -> intermediate (2) -> unchecked (0). The intermediate state is generally not useful in entry mode -- in code, force the value to 0 when it reaches 2 to skip directly from checked to unchecked.

## Checkbox Styles

Checkboxes support the same styles as buttons, except `help` and `custom`:

| Style | Description |
|-------|-------------|
| `regular` | **(default)** Standard system checkbox (square with descriptive title). Supports three-states. |
| `flat` | Minimalist checkbox. Supports three-states. |
| `toolbar` | Transparent background, no border. Usually associated with a 4-state icon. |
| `bevel` | Rectangular with thin border. Usually associated with a 4-state icon. |
| `roundedBevel` | Like bevel but with rounded corners. |
| `gradientBevel` | Rounded with subtle gradient fill. |
| `texturedBevel` | Gray textured background. |
| `office` | Light blue background with thin border. |
| `circular` | Circular outline with text below. |

### Checkbox-Specific Style Notes

- **`regular` and `flat`**: These are the only styles that display the traditional checkbox appearance (a small square with a checkmark next to the label text). They are also the only styles that support three-states. The checkbox square itself retains its native system appearance regardless of text styling (stroke, fontWeight, etc. only affect the label text).
- **Other styles** (toolbar, bevel, roundedBevel, gradientBevel, texturedBevel, office, circular): These render as **toggle buttons** -- visually identical to their button counterparts, with no checkbox square visible. They stay pressed/highlighted when checked. They are usually associated with a multi-state icon (`iconFrames: 4` or more).

### Icon States for Non-Regular Styles

When using bevel-family or toolbar styles with an icon, the icon can have up to 6 states (since v20):

| Frames | States |
|--------|--------|
| 1 | Single image for all states |
| 2 | Unchecked, Checked |
| 3 | Unchecked, Checked, Rollover |
| 4 | Unchecked, Checked, Rollover, Disabled |
| 5 | Unchecked, Checked, True Rollover, False Rollover, Disabled |
| 6 | Unchecked, Checked, True Rollover, False Rollover, True Disabled, False Disabled |

Reference: https://developer.4d.com/docs/FormObjects/propertiesTextAndPicture#number-of-states

## Visual Properties

Checkboxes share most visual properties with buttons:

| Property | Values | Description |
|----------|--------|-------------|
| `text` | string | Checkbox label text |
| `textAlign` | `"left"`, `"center"`, `"right"` | Text alignment (since v20) |
| `fontWeight` | `"normal"`, `"bold"` | Font weight |
| `fontStyle` | `"normal"`, `"italic"` | Font style |
| `textDecoration` | `"none"`, `"underline"` | Text decoration |
| `fontSize` | integer | Font size in points |
| `fontFamily` | string | Font family name |
| `stroke` | CSS color | Text color |
| `icon` | path | Path to icon image |
| `textPlacement` | `"left"`, `"right"`, `"top"`, `"bottom"`, `"center"` | Text position relative to icon |
| `iconFrames` | integer | Number of frames in the icon image |
| `imageHugsTitle` | boolean | Whether icon stays close to text (since v20) |
| `visibility` | `"visible"`, `"hidden"` | Hidden = invisible and inactive |
| `focusable` | boolean | Whether the checkbox can receive keyboard focus |
| `tooltip` | string | Hover text |

## Standard Actions for Checkboxes

Checkboxes can be assigned standard actions that represent true/false (checkable) states. This is especially useful with text formatting areas.

Reference: https://developer.4d.com/docs/FormObjects/propertiesAction#standard-action

| Action | Condition |
|--------|-----------|
| `fontBold` | |
| `fontItalic` | |
| `fontUnderline` | |
| `fontLinethrough` | |
| `fontSubscript` | 4D Write Pro areas only |
| `fontSuperscript` | 4D Write Pro areas only |
| `font/showDialog` | Mac only |
| `spell/enabled` | |
| `spell/autoCorrectionEnabled` | |
| `spell/autoSubstitutionsEnabled` | |
| `spell/showDialog` | Mac only |
| `spell/grammarEnabled` | Mac only |
| `visibleBackground` | 4D Write Pro areas only |
| `visibleHeaders` | 4D Write Pro areas only |
| `visibleFooters` | 4D Write Pro areas only |
| `visibleHiddenChars` | 4D Write Pro areas only |
| `visibleHorizontalRuler` | 4D Write Pro areas only |
| `visiblePageFrames` | 4D Write Pro areas only |
| `visibleReferences` | |

When associated with a text area, the checkbox automatically reflects and toggles the attribute state -- no code is needed.

## Events

Checkboxes support the same click events as buttons:

- `onClick` (On Clicked) -- fires when the checkbox is toggled
- `onDoubleClick` (On Double Clicked)
- Modifier key detection works the same way (Shift down, Macintosh command down, etc.)

### Event Execution Order

Same as buttons:
1. **Object method** runs first
2. **Form method** runs second
3. **Standard action** runs last

### Object Method Pattern

```4d
var $event:=FORM Event

Case of 
  : ($event.code=On Clicked)
    If (Form.myCheck=1)
      // checked
    Else
      // unchecked
    End if
End case 
```

## Positioning and Sizing

| Property | Type | Description |
|----------|------|-------------|
| `top` | integer | **Required**. Y position |
| `left` | integer | **Required**. X position |
| `width` | integer | Checkbox width |
| `height` | integer | Checkbox height — **also scales the checkbox square** on regular/flat styles |
| `sizingX` | enum | `"move"`, `"grow"`, `"fixed"` |
| `sizingY` | enum | `"move"`, `"grow"`, `"fixed"` |

**Note**: Unlike buttons where height only affects the clickable area, for regular/flat checkboxes the `height` property controls the visual size of the checkbox square itself. Larger height = larger checkbox.

## CSS Styling

Same selectors and specificity rules as buttons:

```css
/* All checkboxes */
checkbox {
  style: regular;
}

/* By class */
.toggleOption {
  style: flat;
  stroke: #333333;
}

/* By name */
#EnableNotifications {
  fontWeight: bold;
}
```

## Localization

Same as buttons -- use `:xliff:` references in the `text` property:

```json
{ "text": ":xliff:CheckboxEnable" }
```

Works in both JSON and CSS.
