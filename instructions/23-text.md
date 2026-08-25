---
object: "text"
json_type: "text"
keywords: ["text", "static text", "label", "title", "fontTheme", "textAngle", "rotation", "dynamic reference"]
summary: "Static text object for labels, titles, and instructions. Supports rotation, font themes, border styles, and dynamic references. No events, no method, no data source — purely a display element."
requires: ["01-form-concepts.md", "98-tool4d-cli.md", "22-property-reference.md"]
---

# Text (Static Text)

Reference: https://developer.4d.com/docs/FormObjects/text

## Purpose

A text object displays static written content — labels, titles, instructions, section headings. It is the simplest form object: no events, no method, no data source. It cannot receive focus, cannot be edited, and does not participate in the tab order.

Despite being "static," text objects can include **dynamic references** that resolve at runtime (see below).

## Basic Definition

```json
{
  "myLabel": {
    "type": "text",
    "text": "Hello World!",
    "left": 60,
    "top": 160,
    "width": 100,
    "height": 20
  }
}
```

The `text` property (string) holds the displayed content. This is a design-time value — there is no runtime data source binding.

## Supported Properties (per JSON Schema)

The text object's properties come from five sources in the schema:

### Direct Properties

| JSON Key | Type / Enum | Notes |
|----------|-------------|-------|
| `type` | `"text"` | Required. Identifies the object type |
| `text` | string | The displayed text content |
| `fontTheme` | `"normal"`, `"main"`, `"additional"` | Platform-adaptive font theme (see below) |
| `textAlign` | `"automatic"`, `"right"`, `"center"`, `"justify"`, `"left"` | Horizontal text alignment |
| `textAngle` | `0`, `90`, `180`, `270` | Rotation angle in degrees (see Rotation below) |
| `borderRadius` | integer (≥ 0) | Corner radius for rounded borders |

### From `objectCommon`

| JSON Key | Type / Enum | Notes |
|----------|-------------|-------|
| `left` | integer | X position |
| `top` | integer | Y position |
| `width` | integer | Width in pixels |
| `height` | integer | Height in pixels |
| `right` | integer | Right anchor (alternative to width) |
| `bottom` | integer | Bottom anchor (alternative to height) |
| `sizingX` | `"move"`, `"grow"`, `"fixed"` | Horizontal resizing behavior |
| `sizingY` | `"move"`, `"grow"`, `"fixed"` | Vertical resizing behavior |
| `visibility` | `"visible"`, `"hidden"`, `"selectedRows"`, `"unselectedRows"` | Object visibility |
| `class` | string | CSS class name for styling |

### From `drawingSpec`

| JSON Key | Type | Notes |
|----------|------|-------|
| `fill` | color | Background color |
| `stroke` | color | Text color (foreground) |

### From `borderStyle`

| JSON Key | Enum | Notes |
|----------|------|-------|
| `borderStyle` | `"system"`, `"none"`, `"solid"`, `"dotted"`, `"raised"`, `"sunken"`, `"custom"`, `"double"` | Border appearance |

### From `fontSpec`

| JSON Key | Type / Enum | Notes |
|----------|-------------|-------|
| `fontFamily` | string | Font family name (e.g. `"Helvetica Neue"`, `"Courier New"`) |
| `fontSize` | integer | Font size in points |
| `fontStyle` | `"normal"`, `"italic"` | Italic style |
| `fontWeight` | `"normal"`, `"bold"` | Bold weight |
| `textDecoration` | `"none"`, `"underline"` | Underline decoration |

## No Events, No Method

The text object has **no events** and **no method property** in the schema. It cannot respond to clicks, mouse-overs, or any user interaction. It is a pure display element.

If you need a label that responds to clicks, use a **button** styled to look like text (flat appearance, no border), or an **input** with `enterable: false`.

## Font Theme (`fontTheme`)

Reference: https://developer.4d.com/docs/FormObjects/propertiesText#font-theme

`fontTheme` applies a platform-adaptive font style:

| Value | macOS | Windows |
|-------|-------|---------|
| `"normal"` | San Francisco Regular 13pt | Segoe UI Regular 12pt |
| `"main"` | San Francisco Regular 10pt | Segoe UI Semibold 10pt |
| `"additional"` | San Francisco Regular 9pt | Segoe UI Regular 9pt |

When `fontTheme` is set, `fontFamily`, `fontSize`, `fontWeight`, and `fontStyle` are ignored — the theme overrides them. To use custom font properties, leave `fontTheme` unset or set it to the value that matches the desired base, then override individual properties.

## Rotation (`textAngle`)

Reference: https://developer.4d.com/docs/FormObjects/propertiesText#orientation

`textAngle` rotates the text by the specified degrees. Only four values are valid: `0` (default), `90` (bottom-to-top), `180` (upside down), `270` (top-to-bottom).

```json
{
  "verticalLabel": {
    "type": "text",
    "text": "Sidebar",
    "textAngle": 90,
    "left": 10,
    "top": 50,
    "width": 20,
    "height": 120
  }
}
```

**Important**: the `width` and `height` properties define the bounding box, **not** the rotated dimensions. A 90° rotated text with `width: 20, height: 120` occupies a tall narrow space — the width/height refer to the **un-rotated** frame dimensions, which 4D then rotates.

Rotation can also be set at runtime with `OBJECT SET TEXT ORIENTATION`.

## Dynamic References in Static Text

Reference: https://doc.4d.com/4Dv20/4D/20.2/Using-references-in-static-text.300-6750154.en.html

Although text objects have no data source, their `text` property can contain **dynamic references** that resolve at runtime. These are expressions enclosed in special delimiters that 4D evaluates when the form is displayed.

This makes text objects useful for displaying computed values (dates, user names, record counts) in label-style layouts without needing an input object.

## Visual Display Properties

Text objects share the same visual properties as input objects (see `21-input.md` for detailed descriptions):

- **`borderStyle`**: `"none"` (default for labels), `"solid"`, `"dotted"`, `"raised"`, `"sunken"`, etc.
- **`borderRadius`**: rounded corners
- **`fill`**: background color
- **`stroke`**: text (foreground) color
- **`fontFamily`**, **`fontSize`**, **`fontStyle`**, **`fontWeight`**, **`textDecoration`**: standard font properties

### Styling Tips

For section headers:
```json
{
  "SectionTitle": {
    "type": "text",
    "text": "Personal Information",
    "fontFamily": "Helvetica Neue",
    "fontSize": 16,
    "fontWeight": "bold",
    "stroke": "#2C3E50",
    "textAlign": "left"
  }
}
```

For subtle labels:
```json
{
  "FieldLabel": {
    "type": "text",
    "text": "First Name:",
    "fontTheme": "additional",
    "stroke": "#7F8C8D",
    "textAlign": "right"
  }
}
```

## Runtime Commands

Although text objects have no events, several commands can modify them at runtime:

| Command | Purpose |
|---------|---------|
| `OBJECT SET VALUE` | Change the displayed text |
| `OBJECT SET FONT` | Change font family |
| `OBJECT SET FONT SIZE` | Change font size |
| `OBJECT SET FONT STYLE` | Change bold/italic |
| `OBJECT SET COLOR` | Change text color |
| `OBJECT SET RGB COLORS` | Change text and/or background color |
| `OBJECT SET TEXT ORIENTATION` | Change rotation angle |
| `OBJECT SET VISIBLE` | Show/hide |
| `OBJECT MOVE` | Reposition |

These commands target text objects by name (using `*` and the object name string).

## Text vs. Input for Labels

| Need | Use |
|------|-----|
| Static label with no interaction | **Text** object |
| Label that updates from a data source | **Input** with `enterable: false` |
| Label that responds to clicks | **Button** (flat style) or **Input** with method |
| Label with styled text (bold/italic ranges) | **Input** with `styledText: true` |
| Dynamic computed value in a label | **Text** with dynamic reference, or **Input** bound to expression |

## CLI Verification Notes

**Known `FORM SCREENSHOT` limitations with text objects (tested with 4D 21 R3):**

1. **Default text color is invisible** — text objects without an explicit `stroke`
   color do not appear in `FORM SCREENSHOT` output. Always set `stroke` when you
   need screenshot verification.

2. **Rotated text (`textAngle` ≠ 0) does not render** in `FORM SCREENSHOT`. The
   bounding box is captured but the text itself is absent. Rotation must be verified
   visually in the IDE.

3. **`borderStyle: "raised"` and `"sunken"`** render with very subtle relief that
   may be invisible in screenshots. `"solid"` and `"dotted"` work well.

4. **Colors (`stroke` + `fill`)** render correctly in screenshots. Font properties
   (`fontWeight`, `fontStyle`, `fontSize`, `fontFamily`, `textDecoration`) also render
   when `stroke` is explicitly set.

**Recommendation**: for any text object you intend to verify via CLI screenshots,
always set `stroke` to a visible color (e.g. `"#000000"` for black).

The `dialog_screenshot` pattern (Pattern 4 in `98-tool4d-cli.md`) works for text
objects — if runtime code changes text via `OBJECT SET VALUE`, the screenshot captures
the updated content (provided `stroke` is set).
