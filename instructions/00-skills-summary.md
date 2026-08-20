# 4D Forms & Buttons — Skills Summary

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

### Events (Concepts Only)
- Understand **event execution order**: object method → form method → standard action
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
- I have only studied the **button** object in depth. The remaining 25 object types (input, checkbox, radio, dropdown, listbox, subform, etc.) have not been covered yet.

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
