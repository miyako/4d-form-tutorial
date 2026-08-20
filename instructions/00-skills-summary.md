# 4D Forms & Buttons — Skills Summary

## What I Can Do

### Form Creation
- Create **project forms** from scratch with proper JSON structure (`$4d` metadata, pages, events, margins, window sizing)
- Set up the correct file/directory structure: `Forms/<Name>/form.4DForm`, `ObjectMethods/`, `method.4dm`
- Configure form-level properties: `windowTitle`, `destination`, `windowSizingX/Y`, margins, `geometryStamp`
- Subscribe forms to events: `onLoad`, `onUnload`, `onClick`, `onDoubleClick`
- Associate a **form class** via the `formClass` property for auto-instantiation and IDE support

### Button Objects
- Create buttons with all **11 styles**: regular, flat, toolbar, bevel, roundedBevel, gradientBevel, texturedBevel, office, help, circular, custom
- Apply **visual properties**: stroke (text/border color), fontWeight, fontStyle, textDecoration, fontSize, fontFamily, textAlign, borderStyle
- Set **defaultButton** (regular → blue background; flat → thick border)
- Configure **keyboard shortcuts** with modifier combinations (shortcutAccel, shortcutShift, shortcutAlt, shortcutControl, shortcutKey)
- Set **popup placement** (linked vs separated) for bevel-family styles
- Configure **focusable** behavior (claim focus vs non-disruptive)
- Add **tooltips** with runtime configuration (delay, duration)
- Handle **sizing** (sizingX/sizingY: fixed, move, grow) with awareness of the widget resize caveat on non-visible pages
- Set icon, textPlacement, imageHugsTitle for icon+text layouts

### Events & Click Handling
- Handle **single click** (`On Clicked`) — fires on mouse up
- Handle **double click** (`On Double Clicked`) — replaces On Clicked for the 2nd rapid click
- Use **Clickcount** to detect triple-click and beyond (keeps incrementing in rapid sequence)
- Detect **modifier keys**: Shift, ⌘/Ctrl, ⌥/Alt, ⌃Control, Contextual click (cross-platform)
- Implement proper **priority ordering** in `Case of` for modifier detection
- Understand **event execution order**: object method → form method → standard action

### Form Classes
- Create **user classes** with properties and functions (`Class constructor`, `Function`)
- Associate classes with forms via **`formClass` property** (approach 1: auto-instantiation)
- Pass class instances to **`DIALOG`** command (approach 2: explicit lifecycle control)
- Understand **precedence**: passed object > formClass property
- Return `This` from functions for **method chaining**
- Use `Form` command to access the class instance in methods

### Data Sources
- Use **dynamic variables** for button data sources (not `Form.property` — button exception)
- Use `Form.property` expressions for other form objects (input fields)
- Dereference with `OBJECT Get pointer(Object named; objectName)->`
- Understand button value lifecycle: 1 during click event, 0 after

### CSS Styling
- Write 4D CSS stylesheets (type, class, ID selectors)
- Apply **light/dark mode** via `@media (prefers-color-scheme: light/dark)`
- Use `:xliff:` references in CSS property values
- Understand specificity cascade: type < class < ID < JSON < !important
- Theme media queries: `mac-classic`, `win-classic`, `fluent-ui`, `liquid-glass`

### Localization (XLIFF)
- Create XLIFF 1.2 files with proper structure and naming (`{name}{LANG}.xlf`)
- Set up `Resources/{lang}.lproj/` directory structure
- Use `:xliff:` notation in form JSON and CSS
- Use `Localized string` command in 4D code
- Reference 4D built-in Common IDs (CommonOK, CommonCancel, etc.)

### Runtime Commands
- `OBJECT SET ENABLED`, `OBJECT SET TITLE`, `OBJECT SET FORMAT` (title + icon), `OBJECT SET FONT`, `OBJECT SET ACTION`, `OBJECT SET VISIBLE`
- Know which commands **don't apply** to buttons (ENTERABLE, CORNER RADIUS, FILTER)

### 4D Code Patterns
- Command token syntax: `CommandName:CNNN`
- Constant syntax: `ConstantName:KNN:NN`
- `Case of ... : (condition) ... End case`
- `FORM Event` object (code, description, objectName)
- Mandatory token verification by grepping project sources before using any `:C` suffix

### CLI Testing
- Screenshot: `4D --startup-method=project_form_to_image --dataless --headless --project=<path> --user-param=<Form>:<Page>:<output.png>`
- Print (CSS-aware): `4D --startup-method=print_form_to_file --dataless --headless --project=<path> --user-param=<Form>:<Page>:<output.pdf>`

## Showcase Forms Created

### 1. ButtonStyleShowcase
All 11 button styles side by side, plus border style variations (solid, dotted, raised, sunken), popup placement demos (linked, separated), and font variations (bold, italic, underline). OK button uses `:xliff:CommonOK` and standard `accept` action.

### 2. EventShowcase
Interactive form with a form class (`EventShowcaseController`) that logs all click events. Demonstrates:
- Single/double/Shift/⌘/contextual click detection with proper `Case of` priority
- `Clickcount` tracking
- Form class functions for event handling (`onClicked`, `onDoubleClicked`, `onShiftClicked`, etc.)
- Non-focusable "Clear Log" button (won't steal focus from other inputs)
- Keyboard shortcut (⌘K) on a button
- Tooltip on hover
- Localized button text via XLIFF

### 3. FormClassShowcase
Demonstrates the form class lifecycle:
- `formClass` property for auto-instantiation
- `test_formclass_showcase.4dm` method showing approach 2 (pass instance to DIALOG, read state after close)
- Class with typed properties (`clickCount: Integer`, `message: Text`)
- Method chaining via `return This`
- Live data binding (`Form.clickCount`, `Form.message` as data sources)
