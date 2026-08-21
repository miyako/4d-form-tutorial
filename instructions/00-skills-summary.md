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

### Static Picture Object JSON
- Create static pictures with `pictureFormat`: `scaled` (distorts if box isn't proportional), `tiled`, `truncatedCenter`, `truncatedTopLeft`
- Reference pictures via `/RESOURCES/Images/...` or a form-relative path (bare filename or `Images/...` next to `form.4DForm`) -- both work
- Understand `@nx` high-resolution and `_dark` dark-mode picture naming conventions; dark-mode `_dark` substitution activates when the form's `colorScheme` is `"dark"`
- Know `vector-effect="non-scaling-stroke"` (SVG) keeps stroke width constant under scaling -- 4D's substitute for shape-primitive grid lines
- SVG and WEBP are natively supported picture formats and render correctly

### Dropdown Object JSON
- Five kinds distinguished by JSON properties, not a separate `type`: object-based (`dataSourceTypeHint: "object"`, `Form.xxx` = `{values, index, currentValue}`), array-based (`dataSourceTypeHint: "arrayText"/"arrayNumber"/"arrayDate"/"arrayTime"`, `dataSource` names the array directly), choice list value/reference (`choiceList` + `saveAs: "value"|"reference"`), hierarchical (`dataSourceTypeHint: "integer"` alone), and standard action submenu (`action: "gotoPage"`, no data source)
- Underlying data source is always object, array, or list -- object is the modern/recommended shape. For object: `values` is a 0-based Collection; `index` is bidirectional (assign to select, user selection writes back); `currentValue` is read-only (assignments other than at init time are ignored and revert) -- initialize with `index:=-1` + `currentValue:=` placeholder message
- For array (1-based, unlike Collection): element `0` is the "no selection" placeholder, the array variable itself holds the current element number (bidirectional), `arr{arr}` is the current selected value -- initialize by setting the array variable to `0`
- For choice list (`choiceList`, inline or a named toolbox list from `lists.json`, auto-instantiated/cleared with the form): `saveAs: "value"|"reference"` picks whether the bidirectional data source holds the literal text or a numeric item reference (via `APPEND TO LIST`'s `itemRef`/`SET LIST ITEM`, not position) -- initialize to `0` (reference) or a placeholder message (value). `OBJECT SET LIST BY NAME` sets a toolbox list at runtime, equivalent to naming it in `choiceList`
- Hierarchical drop-down (`dataSourceTypeHint: "integer"` alone, the "List reference" Data Type (list) option) is backed by a hierarchical list reference (integer) attached via `OBJECT SET LIST BY NAME` (auto-cleared with the form) or `OBJECT SET LIST BY REFERENCE` with a `New list`/`Load list` reference (dropdown retains its own ref count, so `Clear list` can be called immediately after assigning); resolving the selected item requires Hierarchical Lists commands (`Selected list items`, etc.)
- General rule across all data source shapes: if the "no selection" placeholder is never set, the control simply renders blank until the user selects; once selected, the "no selection" state can only be restored by resetting the data source by code, never through the UI
- Standard actions use `standardActionName{?nameParameter=valueParameter}` syntax (e.g. `gotoPage?value=5`); when both a method and a standard action are set, the method runs first and the standard action after (except `deleteRecord`, which runs before the method); style-related standard actions (`fontSize`, `backgroundColor`, `bold`...) trigger `On After Edit`. Drop-downs (and hierarchical choice lists) can only be bound directly to standard actions that generate a submenu (`gotoPage`, `backgroundColor`, `fontSize`); custom per-item actions can replace the automatic submenu values via `SET LIST ITEM PARAMETER` on the choice list
- Standard-action dropdown binding is one directional: selecting an item executes the action, but code-driven state changes (e.g. `FORM GOTO PAGE`) do not update the dropdown back -- resync explicitly (`FORM Get current page`/`FORM Get properties`) or drive the change via `INVOKE ACTION` instead. This is unworkable for open-ended targets like `fontSize` on styled text/Write Pro areas, where the current value may not even be one of the dropdown's fixed choices
- Choice list dropdown cannot be combined with object/array data source -- binding a field/variable directly always forces choice-list mode
- Like button/checkbox/radio: `On Clicked` fires on mouse-down, not mouse-up; supports `focusable` with Return/Tab, Shift+Return/Shift+Tab, and Space-to-click keyboard behavior. Like progress/ruler: data source can be a live expression with bidirectional binding. OS may render at a different height than declared
- Know that `FORM SCREENSHOT` on a form name renders the Form Editor's static template: every drop-down kind (object/array/choice-list/hierarchical) renders the literal `dataSource` expression text as its label, never a resolved value, first-choiceList-item, or blank; only a `dataSource`-less standard-action dropdown (e.g. `gotoPage`) shows its own object name in quotes as placeholder
- `Button Style` (`style`) is officially listed as supported for drop-down lists and accepts the full button style enum, but empirically produces **no visible difference** -- every style renders as the same native pop-up-menu chrome; unlike buttons/checkboxes/radio buttons, a drop-down's appearance is controlled by the platform, not this property

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
- I have studied **button**, **checkbox**, **radio**, **button grid**, **picture button**, **splitter**, **ruler**, **stepper**, **progress indicator**, **spinner**, **static picture**, and **dropdown** in depth. The remaining object types (input, text, listbox, subform, picturePopupMenu, etc.) have not been covered yet.

### Runtime Behavior
- I have not used 4D runtime commands in practice. I know some exist (e.g., `OBJECT SET ENABLED`, `OBJECT SET TITLE`) from documentation links, but I have not tested them or learned their full behavior.
- I cannot run 4D myself — I rely on the user to verify runtime behavior.

### Form Editor
- I can only create and edit the JSON directly. I have no experience with the visual form editor or its features.

### CLI Testing
- **`FORM SCREENSHOT` must be driven via the real 4D application binary (`4D.app/Contents/MacOS/4D --headless --user-param ... --startup-method ...`), never via `tool4d`.** `tool4d` is not a valid substitute for verifying rendering: it segfaults on some builds, and can silently produce blank/wrong output for certain picture formats (SVG, WEBP) or miss conditional form behavior (dark-mode substitution) even when it doesn't crash.
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

### 10. Dropdowns
Object-based (indexed selection + `-1` placeholder), array-based, choice list (`saveAs` value vs. reference), standard action (`gotoPage`), and hierarchical drop-down lists, one kind per page.
