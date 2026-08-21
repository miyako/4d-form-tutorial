# 4D Combo Box Object

Reference: https://developer.4d.com/docs/FormObjects/comboBoxOverview
Also: https://developer.4d.com/docs/FormObjects/dropdownList_Overview (shared data source mechanics)
Also: https://developer.4d.com/docs/FormObjects/properties_DataSource, https://developer.4d.com/docs/FormObjects/properties_RangeOfValues

## Basic Definition

```json
{
  "myCombo": {
    "type": "combo",
    "top": 20,
    "left": 20,
    "width": 180,
    "height": 20,
    "dataSource": "Form.myCombo",
    "dataSourceTypeHint": "object"
  }
}
```

A combo box is a drop-down list that also accepts free-form keyboard text entry: it is fundamentally an **enterable input area** that happens to offer a pop-up list of default values (from an object, array, or choice list) as a convenience, not a closed/finite selection control like a drop-down list. `"type"` is `"combo"`.

## Combo vs. Dropdown

A combo box shares its three data source shapes (object, array, choice list) with the drop-down list, but differs in fundamental ways:

| Aspect | Drop-down list | Combo box |
|--------|----------------|-----------|
| Keyboard text entry | Not enterable -- closed list only | **Enterable** -- user can type any value, not just list items |
| Object data source | `values`, `index` (bidirectional), `currentValue` (read-only except init) | `values`, **`currentValue` only** -- no `index`; `currentValue` receives whatever the user types |
| Array data source | Array variable itself holds the current **element number** (1-based selection index) | Typed text is written into **element `0`** of the array -- the array variable is not used as a selection index |
| Hierarchical choice list | Supported (`dataSourceTypeHint: "integer"` alone) | **Not supported** -- only the first level of a hierarchical list is shown/selectable, and there is no dedicated hierarchical mode |
| `saveAs` / Data Type (list) (reference storage) | Supported -- data source can hold a numeric item reference instead of the literal value | **Not supported** -- `saveAs` is not in the combo box's supported properties list; a choice-list combo box always stores the literal typed/selected text |
| Standard action | Supported (`gotoPage`, submenu actions) | **Not supported** -- not listed as a combo box feature at all |
| `Required List` (`requiredList`) | N/A (drop-down is already a closed list) | Documented as **not available** for combo boxes in the Combo Box overview page -- to force a finite, keyboard-entry-free list of required values, use a drop-down list instead. (Note: the generic Range of Values property page's "Objects Supported" line for `requiredList` also lists Combo Box, which conflicts with this explicit statement -- treat the dedicated combo box page as authoritative until interactively verified otherwise.) |
| `Focusable` | Explicit `focusable` property (like a button) | Not a listed property -- a combo box is an ordinary enterable field and is always part of the tab order the same way an input is |
| `On Clicked` | Fires on mouse-down, like a button | **Not a supported event at all** -- a combo box is not an "active" object; use `On Data Change`/`On Validate` like a normal input |
| Combo-specific options | -- | `automaticInsertion` (add typed-but-unlisted values to the in-memory list) and `excludedList` (reject specific values from being typed/selected), neither of which exists for drop-down lists |

## Object-based

```json
"comboFruit": {
  "type": "combo",
  "dataSource": "Form.comboFruit",
  "dataSourceTypeHint": "object"
}
```

```4d
Form.comboFruit:=New object
Form.comboFruit.values:=New collection("Apple"; "Banana"; "Cherry")
Form.comboFruit.currentValue:="Banana"
```

- `values` (Collection, mandatory): same rules as the drop-down list's object data source -- all elements must be the same scalar type; an empty/undefined collection means an empty combo box.
- `currentValue`: unlike the drop-down list, this is the **only** selection-tracking property (there is no `index`), and it is **writable** both ways -- it holds the initial/displayed text, and when the user types or selects a value, 4D assigns that text into `currentValue`. There is no equivalent of the drop-down's "-1 index means placeholder" convention; a combo box's `currentValue` is just its current text.

## Array-based

```json
"comboArr": {
  "type": "combo",
  "dataSource": "asFruit",
  "dataSourceTypeHint": "arrayText"
}
```

```4d
ARRAY TEXT(asFruit; 3)
asFruit{1}:="Apple"
asFruit{2}:="Banana"
asFruit{3}:="Cherry"
```

The array is populated the same way as for a drop-down list (see https://developer.4d.com/docs/FormObjects/dropdownList_Overview#using-an-array), and the same `arrayNumber`/`arrayDate`/`arrayTime` hints apply. The key behavioral difference: since a combo box has no notion of a "currently selected element number" (the user can type text that matches no element at all), **the array variable itself is not used as an index** -- instead, whatever the user types or picks is written into **element `0`** of the array (`asFruit{0}`), regardless of what `asFruit{0}` held before. Read the current combo box value from `asFruit{0}` rather than `asFruit{asFruit}`.

## Choice list

```json
"comboPlain": {
  "type": "combo",
  "dataSource": "Form.comboPlain",
  "choiceList": ["Red", "Green", "Blue"]
}
```

Works the same way as a drop-down list's choice-list mode (inline array/collection, or the name of a toolbox list from `lists.json`, auto-instantiated/cleared with the form). The data source is bound directly to a field/variable, and the on-screen behavior lets the user either pick from the pop-up list or type any text. Unlike the drop-down list, there is **no `saveAs`/"Data Type (list)" option** -- the data source always holds the literal text, never a numeric item reference; this property simply is not in the combo box's supported properties set.

### Automatic Insertion

```json
"comboAutoIns": {
  "type": "combo",
  "dataSource": "Form.comboAutoIns",
  "choiceList": ["Red", "Green", "Blue"],
  "automaticInsertion": true
}
```

Reference: https://developer.4d.com/docs/FormObjects/properties_DataSource#automatic-insertion

When `automaticInsertion` is `true` and the user types a value not already present in the associated list, that value is added to the **in-memory** list (so it appears as a pop-up choice from then on). When `false` (default), the typed value is stored in the data source but the list itself is left unchanged. This applies both to a choice-list combo box and to one whose list comes from an object/array data source. If the choice list originated from a Design-mode-defined toolbox list, the on-disk list definition is never modified by automatic insertion -- only the form's in-memory copy changes.

### Excluded List

```json
"comboExcluded": {
  "type": "combo",
  "dataSource": "Form.comboExcluded",
  "choiceList": ["Red", "Green", "Blue"],
  "excludedList": ["Green"]
}
```

Reference: https://developer.4d.com/docs/FormObjects/properties_RangeOfValues#excluded-list

`excludedList` names values that cannot be entered into the combo box -- if the user types (or otherwise enters) an excluded value, 4D rejects it and displays an error message. If the excluded list is hierarchical, only its first-level items are considered. This property has no drop-down list equivalent (a drop-down list only ever offers items already in its own list, so there is nothing to "exclude").

## Supported Properties Summary

Alpha Format, Bold, Bottom, Choice List, Class, Draggable, Droppable, Date Format, Expression Type, Font, Font Color, Font Size, Height, Help Tip, Horizontal Sizing, Italic, Left, Object Name, Right, Time Format, Top, Type, Underline, Variable or Expression, Vertical Sizing, Visibility, Width.

Notably absent compared to the drop-down list's property set: **Focusable** (a combo box is an ordinary enterable field, always focusable), **Standard action** (not supported at all), **Data Type (list)**/`saveAs` (no reference-storage mode), **Horizontal Alignment**, **Not rendered**, and **Save value**. Combo box adds **Draggable**/**Droppable**, which the drop-down list does not support.

## Supported Events

On Getting focus, On Load, On Losing focus, On Mouse Enter, On Mouse Leave, On Mouse Move, On Printing Break, On Printing Detail, On Printing Footer, On Unload, On Validate.

Notably absent compared to the drop-down list's event set: **On Clicked** (a combo box is not an "active" object -- there is no discrete click-to-open moment worth trapping the same way), **On After Edit**, **On After/Before Keystroke**, **On Begin Drag Over**, **On Data Change**, **On Drag Over**, **On Drop**, **On Header**. Use `On Data Change` (https://developer.4d.com/docs/Events/onDataChange) to react to entries as with any ordinary input area -- despite `On Data Change` being present in the descriptive text of the official Combo Box overview page, it is **not** listed in that same page's own "Supported Events" enumeration, an inconsistency in the source documentation worth noting; behavior should be confirmed interactively if this event is depended upon.

## CLI Verification Caveat

Like the drop-down list, `FORM SCREENSHOT` called with a form name (`FORM SCREENSHOT(formName; formPict; pageNum)`) renders the **Form Editor's static template** for a given page, not a live/running form -- it never executes `On Load` and never reflects any `Form.xxx`/array/field value assigned by form-object-method code. Every combo box kind (object-based, array-based, choice list, with or without `automaticInsertion`/`excludedList`) renders the **literal `dataSource` expression text** as its label in a CLI screenshot (e.g. `Form.comboFruit`, `asFruit`), never a resolved value.

Some combo-box-specific behaviors are inherently interactive and **cannot** be observed via `FORM SCREENSHOT` at all, no matter how the harness is invoked -- they require actually running the form in the interactive 4D application (`4D.app/Contents/MacOS/4D`, launched normally, not headless; never `tool4d`, and never the static-template screenshot path):

- Whether typing an excluded value into an `excludedList` combo box is actually rejected, and what the resulting error message looks like.
- Whether `automaticInsertion` actually adds a newly typed value to the in-memory list (observable by reopening the pop-up after typing a new value).
- Whether a `requiredList` on a combo box behaves as "not available" (per the Combo Box overview page) or actually restricts entry to list values with keyboard typing disabled (per the generic Range of Values page) -- the two official doc pages disagree, and only interactive testing resolves it.
- The visual difference in chrome between a combo box (plain bordered rectangle with a small trailing chevron, since it is fundamentally an input) and a drop-down list (native OS pop-up-menu/pill chrome).
