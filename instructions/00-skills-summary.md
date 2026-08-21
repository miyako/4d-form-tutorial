# 4D Forms — Skills Summary

## What I Can Do

### Form JSON Structure
- Create **project forms** from scratch with proper JSON structure (`$4d` metadata, pages, events, margins, window sizing)
- Set up the correct file/directory structure: `Forms/<Name>/form.4DForm`, `ObjectMethods/`, `method.4dm`
- Configure form-level properties: `windowTitle`, `destination`, `windowSizingX/Y`, margins
- Subscribe forms to events: `onLoad`, `onUnload`, `onClick`, `onDoubleClick`
- Associate a **form class** via the `formClass` property

### Button Object JSON
- Create buttons with all **11 styles**: regular, flat, toolbar, bevel, roundedBevel, gradientBevel, texturedBevel, office, help, circular, custom
- Apply **visual properties**: stroke, fontWeight, fontStyle, textDecoration, fontSize, fontFamily, textAlign, borderStyle
- Set **defaultButton**, **keyboard shortcuts**, **popup placement**, **focusable**, **tooltip**
- Configure **sizing** (sizingX/sizingY) with awareness of the widget resize caveat on non-visible pages
- Set icon, textPlacement, imageHugsTitle for icon+text layouts

### Checkbox Object JSON
- Create checkboxes with all **12 styles**: same as button except no `help`, plus `disclosure` and `collapseExpand`
- Configure **three-states** mode (regular/flat only, integer data source only, cycle 0→1→2→0)
- Use `Form.property` as data source (unlike buttons)
- Set standard actions (fontBold etc.) with non-focusable for text formatting reflection
- Understand height-based size variants (OS-dependent)

### Radio Button Object JSON
- Create radios with all **12 styles** (same as checkbox)
- Configure **radioGroup** (string) for mutual exclusion (UI-only, same-page only)
- Understand that Form Editor groups ≠ radioGroup (editor groups have no runtime effect)
- Use `Form.property` as data source
- Know that no default selection is set — developer must explicitly select one

### Button Grid Object JSON
- Create button grids with `rowCount`/`columnCount` defining the grid overlay
- Understand transparent overlay concept (placed on top of background graphics)
- Cell numbering is **1-based** (top-left = 1, bottom-right = rows×cols)
- Configure `gotoPage` standard action (click cell N → page N)

### Picture Button Object JSON
- Create picture buttons with `picture` property pointing to a multi-frame source image
- Configure grid layout with `rowCount`/`columnCount` for frame slicing
- Frame numbering is **0-based** (different from button grid)
- Set up **command button** mode: `switchBackWhenReleased`, `switchWhenRollover`, `useLastFrameAsDisabled`
- Set up **choice selector** mode: `loopBackToFirstFrame`
- Configure animation: `frameDelay`, `switchContinuously`
- Create properly sized source images with frames arranged in rows/columns

### Splitter Object JSON
- Create splitters with `borderStyle` options (dotted, solid, raised, sunken, none)
- Understand orientation: `height > width` = vertical, `width > height` = horizontal
- Configure **pusher** mode (`splitterMode: "move"`)
- Understand **coverage rule**: splitter only affects objects fully within its height/width span
- Understand **sizing interaction**: `"grow"` = resize, `"move"` = move/stop, `"fixed"` = pushed (not immune)
- Know stop rules: edge-to-edge contact, margins on right/bottom only
- Data source = distance traveled (resets), must be variable (not `Form.property`)

### Ruler Object JSON
- Create rulers with scale properties (`min`, `max`, `step`, `showGraduations`, `graduationStep`, `labelsPlacement`)
- Understand orientation: same as splitter (width vs height)
- Values are **integer only** — use code conversion for decimals
- `Form.property` allowed as data source; multiple rulers sync via shared data source
- Event model: On Data Change fires repeatedly during drag (requires Execute Object Method); On Clicked fires on release
- Mouse wheel interaction when focusable; `enterable: false` = non-interactive (no visual difference)

### Stepper Object JSON
- Create steppers with `min`, `max`, `step` properties
- **Vertical only** — no horizontal variant
- `Form.property` allowed; syncs with inputs and other objects via shared data source
- Arrow keys (up/right = increase, down/left = decrease) when focusable
- Date/time support via `dataSourceTypeHint`

### Progress Indicator Object JSON
- Create progress indicators (thermometers) with same scale properties as ruler
- **Barber shop mode**: omit `max` property; data source 1 = running, 0 = stopped
- When `enterable: true`, behaves like a ruler (click, drag, scroll)
- Visual: filled bar (vs ruler's track-with-cursor)

### Spinner Object JSON
- Create spinners with binary state: non-zero = running, 0 = stopped
- Circular shape, no scale properties, minimal configuration
- Functionally identical to barber shop progress but circular

### Event Cycle Architecture
- Event cycle is **atomic, sequential, cooperative**
- Animations pause during mouse-down waits on clickable objects
- `On Timer` cannot fire between press and release
- Data source updates during event handlers are deferred to end of cycle

- Understand `onLoad`/`onUnload` as gate events
- Understand double-click behavior (replaces On Clicked for 2nd click) and `Clickcount`
- Know the modifier key commands and their cross-platform mappings

### Form Classes (Concepts Only)
- Understand two approaches: `formClass` property vs passing object to `DIALOG`
- Understand precedence: passed object > formClass property
- Understand lifecycle differences between the two approaches

### CSS Stylesheets
- Write 4D CSS stylesheets (type, class, ID selectors)
- Apply light/dark mode via `@media (prefers-color-scheme: light/dark)`
- Use `:xliff:` references in CSS property values
- Understand specificity cascade: type < class < ID < JSON < !important

### XLIFF Localization
- Create XLIFF 1.2 files with proper structure and naming (`{name}{LANG}.xlf`)
- Set up `Resources/{lang}.lproj/` directory structure
- Use `:xliff:` notation in form JSON and CSS

## What I Cannot Yet Do

### 4D Language
- I have **not learned the 4D language** systematically. The code I write mimics patterns I observed from the user's examples but I don't know the full syntax, type system, or command set.
- I should **never invent command names or guess syntax** — always refer to documentation or existing project code.
- Token suffixes (`:CNNN`, `:KNN:NN`) are added by the IDE automatically — I must never write them.

### Other Form Object Types
- I have studied **button**, **checkbox**, **radio**, **button grid**, **picture button**, **splitter**, **ruler**, **stepper**, **progress indicator**, and **spinner** in depth. The remaining object types (input, text, dropdown, listbox, subform, picturePopupMenu, etc.) have not been covered yet.

### Runtime Behavior
- I have not used 4D runtime commands in practice. I know some exist (e.g., `OBJECT SET ENABLED`, `OBJECT SET TITLE`) from documentation links, but I have not tested them or learned their full behavior.
- I cannot run 4D myself — I rely on the user to verify runtime behavior.

### Form Editor
- I can only create and edit the JSON directly. I have no experience with the visual form editor or its features.

### CLI Testing
- `FORM SCREENSHOT` is not supported by tool4d — must use 4D via CLI
- The helper methods used in this project (`project_form_to_image`, `print_form_to_file`) are project-specific, not built-in
- Reference: https://developer.4d.com/docs/Admin/cli

## Showcase Forms Created

### 1. ButtonStyleShowcase
All 11 button styles side by side, plus border style variations (solid, dotted, raised, sunken), popup placement demos (linked, separated), and font variations (bold, italic, underline). OK button uses `:xliff:CommonOK` and standard `accept` action.

### 2. EventShowcase
Interactive form with a form class (`EventShowcaseController`) that logs click events. Demonstrates:
- Single/double/Shift/⌘/contextual click detection with `Case of` priority
- `Clickcount` tracking
- Form class functions for event handling
- Non-focusable "Clear Log" button
- Keyboard shortcut (⌘K)
- Tooltip and localized button text via XLIFF

### 3. FormClassShowcase
Demonstrates the form class lifecycle:
- `formClass` property for auto-instantiation
- `test_formclass_showcase.4dm` method showing approach 2 (pass instance to DIALOG, read state after close)
- Class with typed properties
- Live data binding (`Form.clickCount`, `Form.message` as data sources)

### 4. PopupMenuDemo
Demonstrates linked and separated popup placement for buttons.

### 5. RadioButtons
All 12 radio button styles including disclosure and collapseExpand.

### 6. ButtonGridDemo
Button grids with 4×4 and 8×8 layouts demonstrating the transparent overlay concept.

### 7. PictureButtonDemo
Two picture buttons with generated source images:
- **Command button** (4-state: default/clicked/rollover/disabled) using `cmdButton.png`
- **Choice selector** (5 language flags, looping) using `langSelector.png`
- Labels on page 0 for always-visible descriptions

### 8. SplitterDemo
Vertical/horizontal/invisible/pusher splitter variants, plus edge case tests (fixed objects, grow on both sides, object between two splitters).

### 9. RulerDemo
All ruler display options: plain, graduation, labels top/bottom, custom step/max, vertical with labels, and non-enterable with static value.
