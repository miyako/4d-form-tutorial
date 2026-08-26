---
role: appendix
on_demand: true
load_when: ["what have you built", "what can you do", "capability summary", "showcase forms", "what have you learned", "status report", "what's covered so far"]
note: "Do NOT load this file for routine object/task work — it duplicates content already covered per-object in 01-20. Use 00-router.md to find the relevant object file instead. Only open this file for meta questions about overall capabilities/progress."
---

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

### Combo Box Object JSON
- A combo box (`type: "combo"`) is a drop-down list that is also an **enterable** field -- shares the object/array/choice-list data source shapes with drop-down, but has no `index`, no hierarchical mode, no `saveAs`/reference storage, no standard action support, and no `focusable` property (it behaves like an ordinary input for text entry)
- Object-based: `values` (Collection) + `currentValue` only -- no `index`; `currentValue` is bidirectional and simply holds whatever text is typed or selected
- Array-based: typed/selected text is written into **element `0`** of the array -- the array variable itself is not used as a selection index (unlike the drop-down list's array-based mode)
- Choice list: same `choiceList` mechanics as drop-down (inline list or named toolbox list), but always stores the literal text -- no `saveAs: "reference"` option exists for combo box
- Combo-specific properties: `automaticInsertion` (typed values not in the list get added to the in-memory list; works for choice-list, object, and array data sources) and `excludedList` (named values are rejected on entry, with an error message)
- The Combo Box overview page states `requiredList` is **not available** for combo boxes, and this is interactively confirmed: `requiredList` has no effect on a combo box (arbitrary text still validates without error), despite the generic Range of Values property page's "Objects Supported" line listing Combo Box for that property. Use a drop-down list for a real closed/required list
- Interactively confirmed: `excludedList` rejection shows an alert "That value is not allowed."; `automaticInsertion` appends the new value at the bottom of the pop-up list as soon as the entry is validated (Return)
- The official Combo Box overview page's prose recommends `On Data Change` for handling entries, yet that event is **absent** from the same page's own "Supported Events" list -- another documentation inconsistency
- Much of an ordinary input's text-entry behavior applies to the enterable text part of a combo box (its "element 0") the same way -- typing, `entryFilter`, caret/selection mechanics, `On Data Change`/`On After Edit` on validation/edit. **`On Clicked` is absent from the combo box's official "Supported Events" list, but confirmed interactively to fire anyway -- only for a popup-driven selection** (click the chevron, choose an item from the pop-up list), the same click-is-a-data-change semantics as a drop-down list's `On Clicked`. It does not fire for a click into the text-entry part (that's ordinary text editing, tracked by `On Data Change`), nor does it fire if the popup is opened and dismissed without a selection. As usual, it doesn't matter whether the newly clicked value equals the value already there
- Like dropdown: `FORM SCREENSHOT`'s static template renders every combo box kind's literal `dataSource` expression text as its label, never a resolved value

### Picture Pop-up Menu Object JSON
- `type` is `"picturePopup"` (not `"picturePopupMenu"`, despite the doc/object display name) -- a Button Grid rendered as a pop-up menu instead of a static overlay: same `rowCount`/`columnCount` frame grid, but clicking opens a native OS pop-up menu, and choosing an entry assigns its position to the data source
- No animation properties (no `switchBackWhenReleased`, `frameDelay`, etc.) -- only one frame (the current selection) is ever visible on the closed object
- Data source is **1-based** position (0 = no selection), the identical convention to Button Grid's cell value -- unlike Picture Button's 0-based frame index. Bidirectional: assigning selects, user choice writes back. Initialize to `0`
- Supports the `gotoPage` standard action, structurally identical to drop-down's `gotoPage` mode (no `dataSource` needed, Nth entry navigates to Nth page) -- and shares the same one-directional-binding caveat: code-driven `FORM GOTO PAGE` does not update the object's displayed selection
- No `pictureFormat`, no `focusable`, no font/text properties -- pure picture-driven object
- `FORM SCREENSHOT`'s static template always renders **frame 0** of the picture at the object's declared size, regardless of the data source's assigned value and regardless of whether `dataSource` is even present -- unlike drop-down/combo, whose template instead shows the literal `dataSource` expression text. This is because the object's appearance always comes from the picture itself, never from a text fallback
- If the object's declared `width`/`height` differs from the source frame's native pixel size, the frame is always **stretched to fill** the bounding box (both up- and down-scaling) -- no letterboxing, cropping, or aspect-ratio preservation, consistent with there being no `pictureFormat` choice on this object

### Tab Control Object JSON
- A tab control (`type: "tab"`) is structurally close to a drop-down list -- object-based shape is **identical** (`{values, index, currentValue}`, `values` 0-based Collection), array-based shape is **identical** (1-based, array variable itself = selected tab number, bidirectional), and hierarchical-list-by-code is triggered the same way (`dataSourceTypeHint: "integer"` alone) -- but a tab control shows all its choices simultaneously as a row of tabs rather than a closed pop-up
- Fourth kind unique to tab control: **static list** via the `labels` JSON property (a plain inline array/collection of label strings) -- has **no `dataSource` at all**, fully resolved at form-design time; this is the simplest, lowest-effort choice for tabs that don't need icons
- Icons per tab require a real **hierarchical list** built by code (`New list`/`Load list`, `APPEND TO LIST`, `SET LIST ITEM ICON`) attached via `dataSourceTypeHint: "integer"` -- the plain `labels` array does not support icons; use array or `labels` when no icon is needed, they're more intuitive to manage from code
- No `saveAs`/reference-storage option (unlike drop-down choice list), no `focusable`, no plain `choiceList` property (drop-down/combo/hierarchical-list-style) -- only `labels` for a static string list
- Supports `gotoPage` standard action (automatic page navigation matching the clicked tab number) exactly like drop-down/picture-popup/button-grid; without it, the object method must call `FORM GOTO PAGE(dataSource)` on `On Clicked` manually (e.g. for a tab control that drives subform data instead of page navigation)
- `labelsPlacement: "top"`/`"bottom"` (Tab Control Direction) only renders differently on macOS; Windows always reverts to top. The static template honors this correctly, but only visibly so when the object is tall enough to contain the content area below the tab strip -- a thin, strip-only-height object shows no visible difference between the two
- **Width-driven popup collapse**: a static `labels` tab is a native macOS `NSTabView` and inherits its auto-collapse behavior -- if `width` is too small to lay out every label as a full tab, 4D silently renders a single pop-up button (current label + disclosure arrows) instead of a tab strip, confirmed empirically (14 labels: collapsed at `width: 590`/`1400`, full strip at `width: 1300`). This is width-only (height doesn't matter) and has no override property; both presentations remain fully functional for `gotoPage`/`On Clicked`, so verify by rendering rather than guessing a width
- **Page-0 always-visible navigation tab**: placing a `gotoPage` static-`labels` tab on page 0 (index 0) makes it a persistent nav bar, since page-0 objects are always visible regardless of the active page (see input/form-concepts notes on page 0); size the tab's `width`/`height` to enclose the largest `left+width`/`top+height` found across all other pages for a conventional framed-tab look, and give it exactly one label per content page (`gotoPage` maps the *K*-th tab to page *K*)
- **Generalizes to every `gotoPage`-capable multi-value object**: the page-0 always-visible pattern is not tab-specific -- drop-down list, button grid, and picture pop-up menu all auto-populate one submenu entry per form page the same way a tab auto-populates one tab per page, so any of them placed on page 0 becomes an always-visible nav control by the identical page-0 mechanism. A plain **button** has no "selected item" to auto-populate a page list from, but can still jump to one fixed page via the parameterized standard-action syntax `"action": "gotoPage?value=N"` (https://developer.4d.com/docs/commands/invoke-action) -- useful on page 0 as a companion "Home"/fixed-jump control alongside a multi-value nav object, with no method required. The same parameterized string can be run from code via `INVOKE ACTION("gotoPage?value=N")`, the recommended way to drive standard-action navigation programmatically while keeping a bound multi-value object's displayed selection in sync (vs. calling `FORM GOTO PAGE` directly, which does not update it)
- **Every content page needs its own top margin against the page-0 nav header**: a page-0 nav object (tab/dropdown/button-grid/picture-popup) always renders on top of whichever page is active, in the same coordinate space -- it is not offset or nested around the content page's objects, so a content object at a low `top` (e.g. `top: 5`) visually collides with the nav header's label strip. 4D does not auto-reflow or clip for this; the developer must manually shift every content page's objects down by a margin at least as large as the nav header's rendered height (24-30px is a practical starting point for a standard tab/dropdown/button-grid/picture-popup header -- verify by rendering, the exact native-control height isn't documented), and correspondingly grow the nav object's own `height` if it was sized to enclose the pages' max extent
- **Page changes auto-focus the first enterable object on the new page**, which can make a `numberFormat`'d input momentarily show its raw/unformatted value right after a tab switch (see the Input notes above). Handle `On Page Change` in the form method and call `GOTO OBJECT(*; "")` to clear focus immediately after any page change, restoring the formatted display
- **Compiler note**: `dataSourceTypeHint` is only an initialization-time *suggestion* -- it lets 4D auto-create a default value of the suggested shape when the data source doesn't exist yet, but it cannot override an already-typed variable. If the data source is a process variable, it must already be declared (`var varName : Type`) and initialized with the correct shape *before* the form loads -- critical for compiled mode, where types must be statically resolvable; don't rely on the form's own `On Load` to establish a process variable's type
- `FORM SCREENSHOT`'s static template renders a **single tab showing the literal `dataSource` expression text** for object-based, array-based, and hierarchical-list-by-code kinds (same rule as drop-down/combo) -- but for the dataSource-less static `labels` list, the template is the **first observed exception**: it renders the actual real tab strip with every configured label, because the content is fully known at design time with nothing to resolve from a runtime expression

### Group Box Object JSON
- A group box (`type: "groupBox"`) is a purely static, non-interactive framed container for visually assembling other form objects -- **no data source, and no supported events at all** (the only object type studied so far whose official doc page has no "Supported Events" section)
- The official doc's own inline JSON example uses `"title"` as the label key (and that example is itself malformed JSON) -- this is wrong. The actual JSON key, confirmed by CLI rendering, is **`text`** (same generic Title key as Button/Check Box/Radio Button/Text Area). `"title"` renders no label at all
- Font Color's JSON key is `stroke` (not `fontColor`) and Horizontal Alignment's JSON key is `textAlign` (not `horizontalAlign`) -- same generic Text property grammar used by other objects, easy to get wrong by guessing
- The title supports an XLIFF `":xliff:ResName"` reference, resolved correctly in the static template render
- "Containment" of other objects is purely visual overlap (z-order) -- 4D forms are flat, a group box does not truly parent/own the objects placed inside its frame
- No `action` (standard action), no `focusable`, no border-style property -- pure visual/textual styling only (font, color, alignment, bold/italic/underline)

### Input Object JSON
- An input (`type: "input"`) is the general-purpose field/expression object -- its `dataSource` can be Text, Date, Time, Number, Boolean, Picture, or Object, unlike drop-down/combo/tab which are restricted to a small set of shapes
- Each expression type unlocks its own display-format property: `textFormat` (Alpha), `dateFormat`, `timeFormat`, `numberFormat`, `booleanFormat` (text-when-true/false), `pictureFormat` (scaled/truncated/proportional/tiled) -- only one is relevant at a time, matching `dataSourceTypeHint`
- The official Alpha Format property page's "Objects Supported" list **omits Input**, despite Input's own overview page listing Alpha Format as a supported property -- the same class of doc inconsistency previously found with Group Box's Title property. **Confirmed at runtime**: `textFormat` truly never applies to an Input (a `"(###) ### ####"` format on `"5551234567"` still displays the raw digits); `booleanFormat` and `dateFormat` apply correctly and unconditionally (regardless of focus); `numberFormat` applies correctly too, but **only while the object does not have keyboard focus** -- while focused it shows the raw/unformatted value. Since 4D auto-focuses the first enterable object on a page whenever that page becomes active (tab switch, `gotoPage`, etc.), a lone number input on its own page can appear to "not format" simply from that auto-focus; fix by handling `On Page Change` with `GOTO OBJECT(*; "")` to clear the focus immediately (see `19-tab.md`'s Defocusing After a Page Change)
- **Date entry parsing is lenient but not perfectly round-trippable**: typing `1999.1.1` into a `dateFormat`'d input and validating produces `Friday, January 1, 1999` (alternate separators accepted, not strictly the documented `MM/DD/YYYY`), but typing the field's own currently-displayed formatted text back in verbatim (e.g. `Friday, January 1, 1999`) fails to parse and resets the value to a null date (`00/00/00`) -- a formatted display is not guaranteed to be valid as re-entered input, and the object does not switch to a raw/editable representation while being retyped
- `multiline` (`"yes"`/`"no"`/`"automatic"`, text type only) and `wordwrap` (`"normal"`/`"none"`, only active when `multiline: "yes"`) control line-wrapping behavior. **Confirmed at runtime**: `wordwrap: "normal"` wraps at word boundaries (ICU-style, never mid-word) for space-delimited text; wrapping behavior for non-space-delimited scripts (e.g. Japanese) has not been tested
- `entryFilter` constrains data entry character-by-character, defined either inline with 4D's proprietary filter meta-language (`&9` digits-only, `~A` forced-uppercase letters, etc.) or by name (`|myFilter`) referencing a project-level filter declared in `filters.json` -- independent of and complementary to display formats
- An input can carry `choiceList` (same mechanism as drop-down/combo) while remaining `type: "input"`, turning it into a constrained pop-up without changing its object type
- A picture-type input (`dataSourceTypeHint: "picture"`) is the only input variant handling image data; as a **process variable** it has a stricter typing rule than other expression types -- it must be declared (`var varName : Picture`) and initialized *before* the form loads (not in the form's own `On Load`), or it renders incorrectly in interpreted mode
- Expressions can be **assignable or non-assignable** -- a formula or method-name `dataSource` displays and re-evaluates fine but has nothing to write user entry back to, making the object effectively read-only regardless of `enterable`
- `FORM SCREENSHOT`'s static template renders the **literal `dataSource` expression text** for every expression type tested, including `picture` and `boolean` -- a picture-type input shows literal text like `Form.pic1`, never the actual image, in contrast to the static Picture object and Picture Pop-up Menu which always render real image content (frame 0) regardless of data source. `enterable: false` and a `choiceList` produce no visible difference from a plain input in the static template; `fill` renders as expected (background tint). **The "Corner radius" property's JSON key is `borderRadius`, not `cornerRadius`** -- the latter is an unrecognized/silently-ignored key (corners stay square); only `borderRadius` actually rounds the corners (confirmed by zoomed pixel inspection)
- `On Data Change` is the general-purpose **validation** event -- fires when the edit is committed (tab out, Return, click outside the object), not per keystroke/edit-action, and only on **user-interface** edits (never on a code-driven assignment to the same data source); fires even when the newly entered value equals the previous one
- `On Clicked` works on an input regardless of `enterable`/`focusable`. During `On Clicked`, `MOUSEX`/`MOUSEY` are auto-assigned local mouse coordinates **only when the data source is a picture**; for non-picture data sources, use `MOUSE POSITION` instead (`CONVERT COORDINATES` for screen-relative). `MOUSEX`/`MOUSEY` are always auto-updated during `On Mouse Enter`/`On Mouse Leave`/`On Mouse Move`, regardless of data source type -- the picture-only restriction is specific to `On Clicked`
- For an SVG picture data source, the `On Clicked` `MOUSEX`/`MOUSEY` values feed directly into `SVG Find element ID by coordinates`/`SVG Find element IDs by rect` for element-level hit-testing
- `On Mouse Up` fires for an input **only when the data source is a picture** -- never for any other expression type
- The contextual menu only appears when the input is both `enterable` and `contextMenu` is not `"none"`; its exact contents (Import/Save as for pictures, font/style/color commands for multi-style text) depend on the data source's expression type and current Clipboard content
- `keyboardDialect` forces a specific installed keyboard layout on focus; Front-End Processors (FEP, for Chinese/Japanese/Korean and similar composed-character languages) are disabled whenever `keyboardDialect` is set **or** whenever an `entryFilter` is defined -- both are incompatible with FEP's need to defer/compose multiple keystrokes before committing a character
- For a **non-picture** data source, `enterable: false` + `focusable: true` gives a copy-only reading mode: the object can be focused and the user can place a caret/make a selection to copy, but cannot edit. `showSelection` (Selection Always Visible) keeps that selection highlighted even while the window is inactive (normally selection highlighting disappears when the window loses frontmost status)
- `spellcheck` (Auto Spellcheck) uses a platform-dependent engine: Hunspell on Windows, the system spell-checker on macOS (`SPELL SET CURRENT DICTIONARY` configures the active dictionary). `writingTools` (added 21 R4) is a separate, macOS-only, Apple-Intelligence-dependent property exposing AI proofread/rewrite/summarize/tone features on multiline text -- remains visible/settable elsewhere but is inert at runtime (including its standard action) without a compatible Mac + Apple Intelligence enabled
- A 4D text value's line delimiter is always a single **CR**, on both macOS and Windows (never CRLF or LF) -- but only for line breaks entered via the keyboard while editing. The runtime does not strip or normalize LF/CRLF found in programmatically-assigned or pasted/imported text; normalizing imported text to CR before assignment (e.g. after `Document to text`, `File.getText`, `File.open`) is the developer's responsibility
- `On Before Keystroke`/`On After Keystroke` are legacy raw-keystroke events; `On After Edit` is the modern replacement, firing after every **transitional** edit action regardless of mechanism (keystroke, paste, cut, automatic drop, FEP commit, Undo) -- an automatically dropped text/picture fires `On After Edit`, not `On Data Change` (which only fires later, on validation)
- An input's caret is a zero-width selection; `On Selection Change` fires for any selection/caret movement, but only "following a click or a keystroke" (per the reference) -- an automatic drop does not fire it (no click/keystroke moved the selection at the moment of the drop), only a subsequent click or arrow key inside the now-focused input does
- An input supports automatic drag and drop with no extra setup, acting as a mouse-driven substitute for Copy/Cut/Paste (drag text out, drop text/a picture in). Between two text inputs this is a **move (cut)**, not a copy -- text is removed from the source and inserted at the caret where dropped on the destination. Holding **Ctrl** (Windows) / **Option** (macOS) *after the drag has already started* copies instead of moving. Holding that same modifier *from the very start* of the gesture instead switches the whole operation to **custom** drag and drop: 4D skips its built-in text transfer entirely and dispatches `On Drag Over`/`On Drop` to the destination object's method, which alone is responsible for inserting anything -- if the method doesn't (e.g. it only reads `$event.description` for display), nothing is cut, copied, or inserted anywhere. Plain automatic drag and drop (no modifier held from the start) never dispatches `On Drag Over`/`On Drop` at all, even if an object declares `"events": ["onDrop"]`. Custom drag and drop can transfer any pasteboard data type except file promises, between the object and other areas/applications
- **Confirmed via manual test**: dropping onto an `entryFilter`-restricted destination filters the inserted text exactly like keyboard entry -- `"abc123"` dropped onto an `entryFilter: "&9"` (digits only) destination lands as `"123"`, with the non-conforming letters silently discarded and no error raised. `enterable: false` alone (with `dragging`/`dropping` left at their defaults, not explicitly `"none"`) is sufficient to block a drop entirely -- nothing is inserted, since a non-enterable object can't receive any user-driven entry, keyboard or drop alike. Dragging a **picture** out of a picture-type input and dropping it on another picture-type input **copies** it -- the source keeps its own picture rather than being cleared -- the opposite of the move/cut semantics for automatic text drag and drop between two inputs

### Event Cycle Architecture
- Event cycle is **atomic, sequential, cooperative**
- Animations pause during mouse-down waits on clickable objects
- `On Timer` cannot fire between press and release
- Data source updates during event handlers are deferred to end of cycle

- Understand `onLoad`/`onUnload` as gate events
- Understand double-click behavior (replaces On Clicked for 2nd click) and `Clickcount`
- Know the modifier key commands and their cross-platform mappings
- Object-level events (e.g. `On Clicked`, `On Data Change`) only reach the shared form method for a *given object* if that object's own JSON declares `"events": [...]` naming the event; the form's top-level `events` array only governs form-lifecycle events (`onLoad`/`onUnload`), not per-object events. Standard actions (`"action": "gotoPage"`, etc.) are the exception -- 4D handles them internally with no method code or `events` declaration needed. When `action` is left empty (manual/custom behavior), nothing wires the click for you, so the object's `events` declaration is what makes the developer's own `On Clicked` handler actually run
- **The form's own `method.4dm` is not implicitly bound by filename convention** -- writing a `method.4dm` file at the form's standard path and declaring the form's top-level `events` array (`onLoad`/`onUnload`) is not enough by itself: the form's root JSON must *also* declare `"method": "method.4dm"` (see `01-form-concepts.md`) or the shared method never runs at all, regardless of the `events` declaration. A form with `events: ["onLoad", "onUnload"]` but no `"method"` property silently never executes `On Load`/`On Unload`, so any `Form.xxx` initialization code in that file is dead code with no error raised -- caught in this project when a form's `method.4dm` had working `On Load` initialization code that never actually ran because the root `"method"` property was missing

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
- **Never guess constant names.** If I don't know the exact constant name for a command parameter, I must either look it up in the documentation or omit the parameter to use the default. Inventing constant names (e.g. writing `Is SVG` when the real constant is `Copy XML data source`) causes compilation errors.
- **`FORM Event` returns a plain `Object`** — declare it as `var $event : Object`, never as `cs.FormEvent` or any `cs.*` class. There is no built-in event class in 4D's class system (see `01-form-concepts.md`).
- **4D's SVG renderer does not support CSS `rgba()` color notation.** Use separate `fill`/`stroke` color + `fill-opacity`/`stroke-opacity` attributes instead (standard SVG 1.1 approach).
- **`var` declarations are method-scoped**, not block-scoped. Never redeclare the same variable in different `Case of` branches — declare once at the top or in the first branch that uses it.

### Other Form Object Types
- I have studied **button**, **checkbox**, **radio**, **button grid**, **picture button**, **splitter**, **ruler**, **stepper**, **progress indicator**, **spinner**, **static picture**, **dropdown**, **combo box**, **picture pop-up menu**, **tab control**, **group box**, and **input** in depth. The remaining object types (text, listbox, subform, etc.) have not been covered yet.

### Runtime Behavior
- I have not used 4D runtime commands in practice. I know some exist (e.g., `OBJECT SET ENABLED`, `OBJECT SET TITLE`) from documentation links, but I have not tested them or learned their full behavior.
- I cannot run 4D myself — I rely on the user to verify runtime behavior.

### Form Editor
- I can only create and edit the JSON directly. I have no experience with the visual form editor or its features.

### CLI Testing
- See `98-tool4d-cli.md` for version requirements, CLI commands, and `FORM SCREENSHOT` static template rendering rules. Key point: requires `tool4d` **21 R3 (build 100186) or later**.
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

### 11. Combos
Object-based (`values`/`currentValue`, no index), array-based (typed text goes to element 0), plain choice list, `automaticInsertion`, `excludedList`, and a `requiredList`-on-combo edge case (docs disagree on whether this is even valid), one kind per page.

### 12. PicturePopups
Basic 1x5 icon grid (no selection / pre-selected, showing the static template always renders frame 0), `gotoPage` standard action with no data source, `borderStyle`, object-size-vs-frame-size scaling tests (both upscale and downscale), and a generated 2x2 grid image to confirm row-by-row frame numbering.

### 13. TabControls
Object-based, array-based, static `labels` list, `labelsPlacement: "bottom"` (thin and tall variants), manual `FORM GOTO PAGE` (no standard action), and a hierarchical-list-reference placeholder page, one kind per page.

### 14. GroupBoxes
`text` vs. `title` JSON key comparison (resolving the official doc's own key error), a group box visually overlapping input/label objects, font/color/alignment styling (`bold`, `stroke`, `textAlign`), a bare frame with no title, and an XLIFF-referenced title, one variant per page.

### 15. Inputs
Basic text with placeholder, non-enterable display, multiline/wordwrap, entry filter, picture-type with `pictureFormat: "scaled"`, boolean-as-text, date/number formats, `choiceList`, Alpha Format (Objects Supported omission test), and `borderRadius`/borderStyle/fill styling, one variant per page.
