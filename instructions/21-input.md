---
object: "input"
json_type: "input"
keywords: ["input", "field", "text", "multiline", "wordwrap", "entry filter", "placeholder", "picture format", "boolean format", "date format", "number format", "choice list", "enterable"]
summary: "Input object: general-purpose field/expression display and entry, all expression types (text/date/time/number/boolean/picture/object), format-per-type properties, entry filter, multiline/wordwrap, static template always shows literal dataSource text regardless of expression type."
---

# 4D Input Object

Reference: https://developer.4d.com/docs/FormObjects/inputOverview
Also: https://developer.4d.com/docs/FormObjects/properties_Entry (Enterable, Multiline, Placeholder, Entry Filter, Context Menu, Auto Spellcheck, Selection always visible, Writing Tools)
Also: https://developer.4d.com/docs/FormObjects/properties_Display (Alpha/Date/Number/Time/Picture/Boolean Format, Wordwrap, Visibility)
Also: https://developer.4d.com/docs/FormObjects/properties_Object.md#variable-or-expression, properties_Object.md#expression-type
Also: https://developer.4d.com/docs/FormObjects/properties_RangeOfValues (Default value, Choice List, Excluded List, Required List)
Also: https://developer.4d.com/docs/Concepts/quick-tour.md#assignable-vs-non-assignable-expressions

## Basic Definition

```json
{
  "myText": {
    "type": "input",
    "dataSource": "Form.myText",
    "dataSourceTypeHint": "text",
    "top": 20,
    "left": 20,
    "width": 220,
    "height": 20
  }
}
```

An input is the general-purpose object for displaying and entering a field or expression. Unlike drop-down/combo/tab, an input is not restricted to any one data shape -- its `dataSource` can be Text, Integer, Numeric, Date, Time, Picture, Boolean, or Object, and each type unlocks a different set of display-format properties (`dateFormat`, `numberFormat`, `pictureFormat`, `booleanFormat`, etc.). `dataSourceTypeHint` (Expression Type) declares which one, exactly as it does for drop-down/combo/tab; the same compiler caveat applies (see `19-tab.md`'s Compiler Note) -- it is only an initialization hint for dynamic variables and picture variables, and does not retype an already-declared variable.

## Enterable vs. Non-Enterable

```json
{ "enterable": false }
```

Objects are enterable by default. A non-enterable input only displays its value -- the user cannot edit it directly, but `On Clicked`, `On Double Clicked`, `On Drag Over`, `On Drop`, `On Getting Focus`, and `On Losing Focus` still fire, which supports custom context menus, drag-and-drop, or click-to-select-only interfaces. An input is always focusable when it is enterable (per the generic Focusable property page); disabling Enterable does not disable focus by itself.

For a **non-picture** data source, `enterable: false` can be combined with `focusable: true`: the object can receive focus, and the user can place a caret or make a text selection within it (e.g. to copy the value), while still being prohibited from editing the content. This is a copy-only reading mode, distinct from a fully inert non-enterable, non-focusable display.

### Selection Always Visible

```json
{ "showSelection": true }
```

Reference: https://developer.4d.com/docs/FormObjects/propertiesEntry#selection-always-visible

By default, a text selection made inside an object is cleared from view once the window becomes inactive (loses frontmost status to another window or application) -- even though the object itself may still conceptually hold the selection. `showSelection` (Selection Always Visible) keeps the selection highlighted on screen even while the window is inactive, which is particularly useful for a non-enterable-but-focusable copy-only input, or for building interfaces where a style-editing toolbar must keep showing which text is selected while the user interacts with a floating palette window.

## Assignable vs. Non-Assignable Expressions

An input's `dataSource` can be any valid 4D expression (field, variable, object property, formula, or method name), not only a plain variable. Only an **assignable** expression (a simple variable, field, or object/collection property) can be written back into by user data entry; a **non-assignable** expression (e.g. a formula or a method call) can still be displayed and re-evaluated on every form event, but user keystrokes have nothing to write back to and the object behaves as effectively read-only regardless of the `enterable` setting.

## Multiline and Wordwrap

```json
{ "multiline": "yes", "wordwrap": "normal" }
```

`multiline` (Text-type expressions only): `"yes"`, `"no"`, or `"automatic"` (default). `"automatic"` wraps text with automatic line returns only when the object is tall enough to be treated as a multiline area; `"no"` forces a single line and strips everything after the first carriage return as soon as the value is edited. `wordwrap` only takes effect once `multiline` is `"yes"`: `"normal"` wraps long lines to fit the object's width; `"none"` truncates instead.

With `multiline: "no"`, the object continues on a single visual line and breaks only on explicit carriage returns already present in the value (any further line breaks the user types are stripped). With `multiline: "yes"`/`"automatic"` and `wordwrap: "normal"`, the object also wraps automatically at the object's width, in addition to breaking on explicit carriage returns.

### Line Break Encoding: CR, Not CRLF or LF

A 4D text value uses a single **carriage return (CR)** character as its line delimiter, on both macOS and Windows -- never CRLF (Windows) or LF-only (Unix/macOS native). This is a deliberate cross-platform normalization internal to 4D, independent of the host OS's native text-file convention. When the user presses Return/Enter while editing a multiline input, 4D inserts a CR.

This CR rule is only enforced for line breaks entered **through the keyboard** while editing. The runtime does not prevent an LF (or other) character from being inserted into a text value programmatically, and it does not normalize text that is copied in from an external source (clipboard paste, imported document, or read from a file). A pasted or command-populated text value can therefore contain a mix of CR, LF, or CRLF, and 4D will not silently rewrite it.

It is the developer's responsibility to normalize line breaks in imported text to CR before assigning it to a text/input data source, typically after reading with `Document to text`, `File.getText`, or `File.open`, replacing LF/CRLF sequences with CR (e.g. `Change string`/`Replace string` or a regex-based cleanup) as needed:

https://developer.4d.com/docs/commands/document-to-text
https://developer.4d.com/docs/API/FileClass#gettext
https://developer.4d.com/docs/API/FileClass#open

## Entry Filter

```json
{ "entryFilter": "&9" }
```

Restricts what characters can be typed, evaluated one character at a time as the user types (invalid keystrokes are simply rejected, not corrected after the fact). A filter is defined one of two ways:

- **Inline, using 4D's proprietary filter meta-language**: a short code string such as `~A` (letters, forced uppercase), `&9` (digits only), `&A` (capital letters only), `&a` (any letters), `&@` (alphanumeric only), plus a number of pre-built date/phone/SSN patterns (see the property reference for the full table).
- **By name, defined in `filters.json`**: a project-level filter defined once in the project's `filters.json` (see Project Architecture) and referenced from any object by name, prefixed with a vertical bar, e.g. `"|myFilter"`. This is the reusable/shareable equivalent of writing the meta-language code inline on every object.

https://developer.4d.com/docs/Project/architecture

An entry filter only constrains data entry -- it has no effect on how the value is displayed after the user leaves the object; combine it with a matching display format (`textFormat`, `dateFormat`, etc.) for both.

Defining an entry filter also **disables Front-End Processors (FEP)** for the object -- see Keyboard Layout, below, for why.

## Keyboard Layout and Front-End Processors (FEP)

```json
{ "keyboardDialect": "ar-ma" }
```

Reference: https://developer.4d.com/docs/FormObjects/propertiesEntry#keyboard-layout, https://developer.4d.com/docs/commands/object-get-keyboard-layout, https://developer.4d.com/docs/commands/object-set-keyboard-layout

`keyboardDialect` forces a specific installed keyboard layout (e.g. `"ar-ma"`, `"cs"`) to become active automatically whenever the object gets focus -- useful when a particular field must always be typed in a given language/layout regardless of the user's current system layout.

Front-End Processors (FEP) -- the input method system used by Chinese, Japanese, Korean, and other languages that require composing a character from multiple keystrokes before committing it -- are **disabled** on an object in two cases:

- A specific `keyboardDialect` is assigned to the object (FEP composition is incompatible with forcing a fixed non-FEP layout on focus)
- The object has an `entryFilter` defined (see above) -- an entry filter operates on raw, individual keystrokes as they are typed, which is fundamentally incompatible with FEP composition, where multiple keystrokes must be deferred and combined before a character is actually committed

## Spell Check and Writing Tools

```json
{ "spellcheck": true, "writingTools": true }
```

Reference: https://developer.4d.com/docs/FormObjects/propertiesEntry#auto-spellcheck, https://developer.4d.com/docs/FormObjects/propertiesEntry#writing-tools, https://developer.4d.com/docs/commands/spell-set-current-dictionary, https://blog.4d.com/apple-writing-tools-now-available-in-4d-write-pro-and-text-input/

`spellcheck` (Auto Spellcheck, Text type only) performs a spell-check automatically during data entry, using a **platform-dependent spelling engine**: Hunspell on Windows, the system spell-checking service on macOS (also invocable per-object via the `SPELL CHECKING` language command, and configured via `SPELL SET CURRENT DICTIONARY` for the active dictionary/language).

`writingTools` is a separate, newer property (added **21 R4**) that exposes Apple Intelligence Writing Tools (proofread, rewrite, summarize, change tone) inside a multiline input's context menu, and through the `writingTools` standard action assignable to a button/menu item. It is **macOS-only** and additionally requires Apple Intelligence & Siri to be enabled in System Settings on a compatible Mac; on Windows, or on a Mac without Apple Intelligence enabled, the property remains visible/settable in the Property List but the feature and its standard action are both inert at runtime (invoking the action does nothing). Where Auto Spellcheck is a basic, cross-platform, always-available dictionary check, Writing Tools is an AI-assisted, system-dependent, opt-in enhancement layered on top for macOS users specifically.

## Placeholder


```json
{ "placeholder": "Enter your name" }
```

Watermark text shown when the object's value is empty (string types), or for date/time when **Blank if null** is enabled; disappears once the user types a character and reappears if the value is cleared again. Supports an XLIFF reference (`":xliff:ResName"`), but a reference cannot be combined with static text -- it is one or the other.

## Choice List

```json
{ "choiceList": ["Red", "Green", "Blue"] }
```

An input can carry the same `choiceList` property used by drop-down list/combo box/hierarchical list (inline array/collection, or a named list from the toolbox). This turns the input into a value-constrained pop-up at runtime while keeping the object type `"input"` rather than `"combo"`. See Default value/Excluded List/Required List (`properties_RangeOfValues.md`) for the related "list of acceptable values" properties that also apply to inputs.

## Display Formats by Expression Type

| Expression type (`dataSourceTypeHint`) | Format property (JSON key) | Notes |
|---|---|---|
| `text` | `textFormat` (Alpha Format) | `#` placeholder characters plus literal punctuation, e.g. `"(###) ### ####"`. **The official Alpha Format property page's own "Objects Supported" list omits Input** (it lists only Drop-down List, Combo Box, List Box Column/Footer), despite Input's own overview page listing Alpha Format as a supported property -- the same kind of doc inconsistency seen previously with Group Box's Title property (see `20-group-box.md`) |
| `date` | `dateFormat` | Built-in (`systemShort`, `systemLong`, `iso8601`, etc.) or custom pattern; append `" blankIfNull"` to display an empty area instead of a zero date |
| `time` | `timeFormat` | Similar built-in/custom pattern support |
| `number` | `numberFormat` | Built-in or custom numeric pattern |
| `boolean` | `booleanFormat` | `"<textWhenTrue>;<textWhenFalse>"`, e.g. `"Assigned;Unassigned"` -- displays a boolean expression as text instead of a check box |
| `picture` | `pictureFormat` | `"scaled"`, `"truncatedCenter"`, `"truncatedTopLeft"`, `"proportionalTopLeft"`, `"proportionalCenter"`, `"tiled"` -- identical vocabulary to List Box Column/Footer picture display |

## Picture-Type Input

A picture-type input (`dataSourceTypeHint: "picture"`) is the only input variant that displays and accepts image data (pasted from the Clipboard or dragged in) rather than character data. Its context menu (unless disabled) adds **Import...** and **Save as...** commands, plus temporary, non-persistent overrides of the display format (Truncated non-centered / Scaled to fit / Scaled to fit centered proportional). Per `properties_Object.md#expression-type`, a picture variable used as a process variable has a stricter typing requirement than other expression types: it must already be declared (`var varName : Picture`) and initialized *before* the form loads (in the method that calls `DIALOG`, not the form's own `On Load`) for correct display in interpreted mode -- otherwise the picture variable will not render correctly.

## Supported Properties

| Property | JSON Name | Notes |
|----------|-----------|-------|
| Variable or Expression | `dataSource` | Field, variable, or any expression; empty string leaves it to a dynamic variable |
| Expression Type | `dataSourceTypeHint` | `"text"`, `"date"`, `"time"`, `"number"`, `"boolean"`, `"picture"`, `"integer"`, `"object"`, array variants, `"collection"`, `"undefined"` |
| Enterable | `enterable` | Default `true` |
| Multiline | `multiline` | `"yes"` / `"no"` / `"automatic"` (default) -- Text type only |
| Wordwrap | `wordwrap` | `"normal"` / `"none"` -- only active when `multiline: "yes"` |
| Placeholder | `placeholder` | String type, or date/time with Blank if null |
| Entry Filter | `entryFilter` | Built-in code, custom string, or `\|namedFilter` |
| Context Menu | `contextMenu` | `"automatic"` (default) / `"none"` |
| Auto Spellcheck | `spellcheck` | Text type only; Hunspell on Windows, system spell-check on macOS -- see above |
| Writing Tools | `writingTools` | Added 21 R4; macOS + Apple Intelligence only; multiline text -- inert elsewhere, see above |
| Keyboard Layout | `keyboardDialect` | e.g. `"ar-ma"`, `"cs"` -- disables FEP, see above |
| Selection always visible | `showSelection` | Keeps selection highlighted when the window is inactive, see above |
| Choice List | `choiceList` | Same mechanism as drop-down/combo |
| Default value | `defaultValue` (see `properties_RangeOfValues.md`) | |
| Excluded List / Required List | `excludedList` / `requiredList` | Same convention as combo box (see `17-combo.md`) |
| Alpha Format | `textFormat` | See caveat above (Objects Supported omission) |
| Date/Time/Number/Boolean/Picture Format | `dateFormat` / `timeFormat` / `numberFormat` / `booleanFormat` / `pictureFormat` | One active per expression type |
| Font / Font Size / Bold / Italic / Underline | `font` / `fontSize` / `bold` / `italic` / `underline` | |
| Font Color | `stroke` | Same generic Text property key as other objects |
| Horizontal Alignment | `textAlign` | |
| Background/Fill Color | `fill` | |
| Border Line Style | `borderStyle` | |
| Corner radius | `cornerRadius` | Added 19 R7 |
| Horizontal/Vertical Scroll Bar | `horizontalScrollBar` / `verticalScrollBar` | |
| Multi-style | `multistyle` | Rich per-character styling |
| Store with default style tags | -- | Persists style tags with the value |
| Orientation | `orientation` | |
| Allow font/color picker | -- | Multi-style context menu extension |
| Print Frame | `printFrame` | |
| Draggable / Droppable | `draggable` / `droppable` | |
| Visibility | `visibility` | `"visible"` / `"hidden"` |
| Horizontal/Vertical Sizing | `horizontalSizing` / `verticalSizing` | |
| CSS Class | `class` | |
| Top/Left/Right/Bottom/Width/Height | `top`, `left`, `right`, `bottom`, `width`, `height` | |
| Object Name | (JSON key) | |
| Type | `"type": "input"` | Fixed |

## Supported Events

`onAfterEdit`, `onAfterKeystroke`, `onBeforeKeystroke`, `onBeginDragOver`, `onClicked`, `onDataChange`, `onDoubleClicked`, `onDragOver`, `onDrop`, `onGettingFocus`, `onHeader`, `onLoad`, `onLosingFocus`, `onMouseEnter`, `onMouseLeave`, `onMouseMove`, `onMouseUp` (Picture type only), `onPrintingBreak`, `onPrintingDetail`, `onPrintingFooter`, `onScroll` (Picture type only), `onSelectionChange`, `onUnload`, `onValidate`.

## On Data Change: The General-Purpose Event

Reference: https://developer.4d.com/docs/Events/onDataChange

`On Data Change` is the general-purpose event for reacting to a value change on an input. Two rules govern when it fires:

- It fires only when the data source is touched **through the user interface** (typing, pasting, dragging in a value). A code-driven assignment to the same variable/field/object property (e.g. `Form.myText:="new value"` in a method) does **not** trigger `On Data Change`.
- It fires even when the newly entered value is **identical** to the previous value -- unlike a typical "changed" semantics, `On Data Change` really means "the user interface touched this data source," not "the value is different from before."

## Keystroke Events vs. `On After Edit`

Reference: https://developer.4d.com/docs/Events/onAfterKeystroke, https://developer.4d.com/docs/Events/onBeforeKeystroke, https://developer.4d.com/docs/Events/onAfterEdit

`On Before Keystroke` and `On After Keystroke` were designed for an era of applications/languages that work primarily with raw, individual keystrokes -- they fire once per physical key. This model does not map cleanly onto every way an input's content can change: a paste, a cut, an FEP (Front-End Processor) composition commit, or an Undo all modify the content without corresponding to a single discrete keystroke.

A modern application should use `On After Edit` instead: it fires after **every** edit action, whether that action was a single keystroke, a paste, a cut, an FEP-composed edit, or an Undo -- one consistent event regardless of the mechanism that produced the change, rather than needing to separately special-case pastes/cuts/FEP/Undo alongside keystroke handling.

## On Clicked on Input

An input can also process `On Clicked`, and this works regardless of whether the input is `enterable` or `focusable` -- a non-enterable, non-focusable input still receives `On Clicked` when clicked, which is one of the mechanisms that makes non-enterable inputs useful for click-driven, display-only UI (see Enterable, above).

### Mouse Coordinates: `MOUSEX`/`MOUSEY`

Reference: https://developer.4d.com/docs/Concepts/variables#system-variables

During `On Clicked` on an input, the system variables `MOUSEX` and `MOUSEY` are **automatically assigned the local (object-relative) mouse coordinates only when the data source is a picture**. If the data source is not a picture, `MOUSEX`/`MOUSEY` are not updated by the click, and the current mouse position must instead be obtained with `MOUSE POSITION` (https://developer.4d.com/docs/commands/mouse-position).

To convert the object-relative coordinates to screen-relative coordinates, use `CONVERT COORDINATES` (https://developer.4d.com/docs/commands/convert-coordinates).

`MOUSEX`/`MOUSEY` are also automatically updated during the mouse-tracking events regardless of data source type: `On Mouse Enter`, `On Mouse Leave`, `On Mouse Move` (https://developer.4d.com/docs/Events/onMouseEnter, onMouseLeave, onMouseMove) -- the picture-only restriction is specific to `On Clicked`.

### SVG Hit-Testing

If the picture data source is an SVG document, `MOUSEX`/`MOUSEY` from `On Clicked` are ready to pass directly into the SVG hit-testing commands:

- `SVG Find element ID by coordinates` -- https://developer.4d.com/docs/commands/svg-find-element-id-by-coordinates
- `SVG Find element IDs by rect` -- https://developer.4d.com/docs/commands/svg-find-element-ids-by-rect

This is the standard pattern for making an SVG picture input clickable/interactive by element (e.g. a clickable map or diagram).

## On Mouse Up: Picture-Only

Reference: https://developer.4d.com/docs/Events/onMouseUp

`On Mouse Up` fires for an input **only when the data source is a picture**. It never fires for a non-picture input, regardless of `enterable`/`focusable` settings. Combined with `On Mouse Move`/`On Mouse Enter`/`On Mouse Leave`, this makes a picture-type input the natural object for building custom mouse-tracked interactions (e.g. drag-to-select on an image, or completing an SVG click-and-release gesture).

## Context Menu Behavior

Reference: https://developer.4d.com/docs/FormObjects/propertiesEntry#context-menu, https://developer.4d.com/docs/commands/object-set-context-menu, https://developer.4d.com/docs/commands/object-get-context-menu

The contextual menu (`contextMenu: "automatic"`, the default) only appears on Control+click or right-click when **both** conditions hold: the `contextMenu` property is not set to `"none"`, and the input is `enterable`. A non-enterable input does not show the contextual menu even if `contextMenu` is `"automatic"`.

The exact contents of the menu are not fixed -- they depend on the data source's expression type (plain text vs. picture vs. multi-style/styled text) and on the current Clipboard/pasteboard content (e.g. whether Paste is enabled depends on what is currently on the Clipboard). A picture-type input's menu adds **Import...** and **Save as...** commands (plus temporary picture-format overrides); a multi-style text input's menu adds font/size/style/color commands, generating `On After Edit` when a style attribute is changed through the menu.

## Drag and Drop

Reference: https://developer.4d.com/docs/Desktop/drag-and-drop

An input supports **automatic drag and drop** with no extra configuration: dragging selected text out of the object, or dropping text/a picture into it, works as a mouse-driven substitute for the Copy/Cut/Paste edit actions -- the data source is read/written the same way it would be via the keyboard/menu equivalents.

Automatic drag and drop between two text inputs is a **move (cut), not a copy**: dragging a selection out of the source object removes it from the source, and dropping it on the destination object inserts it at the caret position created where the mouse pointer is released -- the same end result as a Cut on the source followed by a Paste at that caret position on the destination, done in a single mouse gesture.

Automatic drag and drop is handled **entirely internally by 4D** and does not dispatch `On Drag Over`/`On Drop` to the object method, even if the object declares `"events": ["onDrop"]` and has its own object method file -- those events, and the ability to inspect/accept/reject the pasteboard data (e.g. via `$event.description`), are only fired for **custom** drag and drop, not for the automatic built-in text/picture transfer. An input with both automatic dragging/dropping left enabled and an `onDrop` object method wired will still complete the automatic move silently; the object method's `On Drag Over`/`On Drop` code simply never runs for that transfer.

Beyond this automatic behavior, the developer can implement **custom drag and drop** to transfer arbitrary pasteboard data (any type except file promises) between the object and other areas of the application, or other applications entirely. Custom drag and drop is covered separately in more detail later.

## Input Alternatives

The overview page notes several cases where a different object type is a better fit than a plain input:

- List-type data in a selection-type List Box column, instead of a field/variable input
- Drop-down List or Combo Box, for representing a list field/variable with a closed or semi-open set of choices
- Check Box or Radio Button, for a boolean expression

## CLI Verification Notes

`FORM SCREENSHOT` renders the Form Editor's static template. For an input with a `dataSource`, the template renders the **literal `dataSource` expression text** as a placeholder label -- the same rule already established for drop-down list, combo box, and tab control. This holds for **every** expression type tested, including `picture` and `boolean`: a picture-type input with `dataSourceTypeHint: "picture"` shows the literal text `Form.pic1`, not the actual image content and not a blank frame -- a contrast with the static Picture object and Picture Pop-up Menu, both of which render real image content (frame 0) in their static templates regardless of data source. This is because those two object types own their appearance directly from a `picture` source property, whereas an input's appearance is always driven through its `dataSource` expression, textual placeholder included.

`enterable: false` and a `choiceList` array produce **no visible difference** from a plain enterable text input in the static template -- both the disabled-entry affordance and the pop-up-list affordance are runtime-only behaviors not reflected in the design-time render. `cornerRadius` and `fill` are honored visually (rounded corners, background tint) in the static template, confirming purely visual/static properties render as expected while behavioral properties do not.

## Comparison with Drop-down List / Combo Box

| Feature | Input | Drop-down List | Combo Box |
|---------|-------|----------------|-----------|
| Expression types supported | Text, Date, Time, Number, Boolean, Picture, Object | Object, array, or list (choice-list) shapes only | Object, array, or plain choice list |
| Free-text entry | Yes (unless constrained by filter/format) | No -- closed list only | Yes, plus optional choice list |
| `choiceList` | Yes (turns it into a constrained pop-up while remaining `type: "input"`) | Yes (its primary mechanism) | Yes |
| Picture display | Yes (`dataSourceTypeHint: "picture"`, dedicated `pictureFormat` values) | No | No |
| Multiline text | Yes | No | No |
| CLI static template rendering | Literal `dataSource` text, for every expression type including picture | Literal `dataSource` text | Literal `dataSource` text |
