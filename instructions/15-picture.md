# 4D Static Picture Object

Reference: https://developer.4d.com/docs/FormObjects/staticPicture
Also: https://developer.4d.com/docs/FormEditor/pictures (native picture format support, high-res, dark mode)

## CLI verification note (important)

**`FORM SCREENSHOT` must be run through the real 4D application binary (`4D.app/Contents/MacOS/4D --headless ...`), not through `tool4d`.** `tool4d` either segfaults outright (the 4D 21.1 build) or silently produces blank/incorrect screenshots for several picture formats (SVG, WEBP) and misses conditional behavior (dark-mode substitution) even when it doesn't crash -- it is not a trustworthy renderer for this object type. Every finding below was produced (or re-produced) with:

```
"/Applications/4D 21.1/4D.app/Contents/MacOS/4D" \
  --project ".../example/Project/example.4DProject" \
  --headless \
  --user-param "FormName:pageNumber:/tmp/out.png" \
  --startup-method test
```

which drives the project's own `test`/`project_form_to_image` helper methods (see `00-skills-summary.md`). Do not reach for `tool4d` when verifying picture rendering -- use this real-4D CLI path.

## Basic Definition

```json
{
  "myPicture": {
    "type": "picture",
    "top": 20,
    "left": 20,
    "width": 180,
    "height": 120,
    "picture": "/RESOURCES/Images/logo.png",
    "pictureFormat": "scaled"
  }
}
```

A static picture is a **static object** (no data source, no interaction). It is stored **outside the form**, referenced by path, and inserted by reference rather than embedded. Placing it on **page 0** makes it a background shared by all pages of the form (and reusable across inherited forms) -- cheaper than duplicating the picture on every page.

## Pathname

The `picture` property is a POSIX-syntax path. Three forms:

| Form | Example | Resolution |
|------|---------|------------|
| Resources folder | `"/RESOURCES/Images/logo.png"` | Shared across forms in the project |
| Form-local folder | `"4D.png"` / `"Images/logo.png"` | Resolved relative to the form's own folder; keeps the form portable/movable |
| Picture variable | `"var:myPictureVar"` | Picture must already be loaded into the named variable at runtime |

**Confirmed by rendering (real 4D CLI)**: a pre-existing form in this project (`Pictures/form.4DForm`) references a bare filename `"4D.png"` sitting directly next to its `form.4DForm`, with no `/RESOURCES/` prefix at all -- it renders correctly (the 4D logo appears exactly as stored on disk). So both `/RESOURCES/Images/...` and form-relative bare/`Images/...` filenames are genuinely supported; there is no CLI-specific restriction here. (My earlier belief that form-relative paths "don't render in the CLI" was an artifact of testing with `tool4d` instead of real 4D -- see the CLI note above.)

## Display (`pictureFormat`)

| JSON value | Effect |
|------------|--------|
| `"scaled"` | **Scaled to fit**: picture is resized to exactly fill the object's width/height. Not aspect-ratio aware -- if the box's aspect ratio differs from the source picture, the image visibly distorts (stretches/squashes). |
| `"tiled"` | **Replicated**: picture repeats (tiles) to fill an enlarged area, undistorted. If the box is smaller than the source, it is truncated (non-centered). |
| `"truncatedCenter"` | **Center**: picture is centered at its native pixel size; anything beyond the box is cropped equally from all edges. |
| `"truncatedTopLeft"` | **Truncated (non-centered)**: picture's top-left corner is pinned to the box's top-left at native pixel size; overflow is cropped from right/bottom only. Scrollbars can be added to this format. |

Only these four values are supported for the static picture object (`OBJECT Get format` / `OBJECT SET FORMAT` commands). **Confirmed by rendering**: the same 100x100 SVG (a circle) placed into a non-proportional 180x120 box -- `scaled` visibly turned the circle into an ellipse, `tiled` repeated it (cropped at the box edge, not centered), and both `truncatedCenter`/`truncatedTopLeft` kept it a true circle at native size, differing only in crop anchor.

## High-Resolution Pictures (`@nx`)

Add `@2x`, `@3x`, etc. to a filename placed **next to** the base picture (`icon.png`, `icon@2x.png`, `icon@3x.png`) to supply pre-rendered high-DPI variants. 4D automatically substitutes the highest-resolution variant available for the current screen -- you still reference only the base name (`"picture": "/RESOURCES/Images/icon.png"`) in the JSON; you never reference the `@nx` file directly. This prioritization only happens for on-screen display, never for printing.

**Confirmed by rendering**: a headless CLI render (no physical high-DPI display attached) always picked the `1x` (base) variant, even with `@2x`/`@3x` files present alongside it -- consistent with the documented "prioritizes highest resolution for the current screen" behavior, since a headless render has no high-res screen to prioritize for. This is an environment characteristic of headless rendering, not a bug.

## PNG / picture DPI metadata

Per the 4D docs, embedded picture DPI only affects **interactive** operations: Drop/Paste in the Form Editor, and the "Automatic Size" context-menu command -- both of which compute the object's box size from `(picture pixels * screen dpi) / picture dpi`. It is **not** a factor in declarative rendering once `width`/`height` are already set in the JSON.

**Confirmed empirically, two ways**:
1. Generated four 100x100px PNGs, each with a distinct baked-in text label ("72dpi"/"96dpi"/"144dpi"/"300dpi") and a different embedded DPI tag, placed side by side in identically-sized (100x100) `truncatedTopLeft` objects. All rendered showing only their own baked-in label -- i.e. the DPI tag had no effect on scale/position, only the deliberately different pixel content differed.
2. To rule out any doubt, generated a **second, more rigorous pair**: two PNGs with **byte-for-byte identical drawn content** (same circle, no label), one tagged 72 DPI, one tagged 300 DPI, placed side by side at native size (`truncatedTopLeft`, no scaling). Rendered screenshot crops of the two boxes diffed as **completely pixel-identical** (`ImageChops.difference` bounding box: `None`). This confirms DPI metadata has zero effect on rendering when the object's box size is fixed in the form JSON -- it only matters at picture-drop time in the editor, never at form-render time.

## SVG Pictures

SVG is a documented native format, and **renders correctly** as a static picture source in this project once tested through the real 4D CLI (not `tool4d` -- see the CLI note above). I authored the SVG files as plain text (`<?xml version="1.0"?><svg xmlns="...">...</svg>`), referenced them from `"picture"` exactly like a PNG/JPEG, and confirmed via screenshot that the vector content (rects, circles, text) is faithfully rasterized into the PNG screenshot output, including at non-native box sizes with distortion/cropping behavior matching the raster formats above.

### `vector-effect="non-scaling-stroke"`

Reference: https://blog.4d.com/svg-non-scaling-stroke-attribute-support/

By default, an SVG's stroke width scales along with the rest of the shape when the containing object is enlarged -- fine for filled shapes, but wrong for things like grid lines or map overlays that should stay a constant on-screen thickness regardless of zoom/scale. Adding `vector-effect="non-scaling-stroke"` to a stroked element keeps its stroke width fixed under scaling:

```xml
<svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
  <line x1="0" y1="20" x2="100" y2="20" stroke="black" stroke-width="1"
        vector-effect="non-scaling-stroke"/>
</svg>
```

**Confirmed by rendering**: built two 100x100-viewBox SVGs with a 5x5 grid of lines, one with plain `stroke-width="1"` and one with `vector-effect="non-scaling-stroke"` added to every line, both placed in a `scaled` picture object stretched to 320x320 (a 3.2x enlargement). The plain-stroke grid rendered with visibly thick (~3px) lines that scaled up proportionally with the box; the `non-scaling-stroke` grid rendered with lines that stayed hairline-thin (~1px), unaffected by the 3.2x enlargement. This is exactly the documented behavior, and it's the mechanism 4D recommends as a substitute for drawing grid lines with shape primitives/4D drawing code -- author the grid as an SVG with `non-scaling-stroke`, drop it into a static picture object with `pictureFormat: "scaled"`, and the line weight will not visually thicken as the box is resized.

### `ns4d:DPI` attribute (4D-specific)

4D defines a proprietary namespaced attribute on the root `<svg>` element to declare the image's DPI, used by 4D-authored SVG (e.g. plugin-generated barcodes/QR codes):

```xml
<svg width="100%" height="100%" viewBox="0 0 100 100"
     xmlns="http://www.w3.org/2000/svg"
     xmlns:ns4d="http://www.4d.com" ns4d:DPI="300">
  ...
</svg>
```

Source confirming the exact syntax: https://github.com/miyako/4d-plugin-qrencode-v2/blob/master/4DPlugin-qrencode.cpp (`toSVGs`, building `xmlns:ns4d="http://www.4d.com" ns4d:DPI="<n>"` on the `<svg>` root).

**Tested by rendering**: two otherwise-identical SVGs (`viewBox="0 0 100 100"`, same circle/label content), one with `ns4d:DPI="72"` and one with `ns4d:DPI="300"`, placed in identically-sized 100x100 objects with both `truncatedTopLeft` and `scaled` formats. The SVGs rendered without error (proving the `ns4d:DPI` attribute does not break/blank the SVG), but the two DPI variants were pixel-identical apart from their (deliberately different) baked-in text labels -- **no visible size/scale difference attributable to `ns4d:DPI` was observed** when the object's box size is explicitly fixed in the form JSON. This is consistent with the PNG DPI finding above: like raster DPI, `ns4d:DPI` most plausibly affects native/intrinsic-size calculations (e.g. "Automatic Size", or how a plugin/host asks for the image's natural point size before it's placed in a fixed box) rather than how the picture is rasterized into an already-sized static picture object. I was not able to construct a JSON-only scenario where the object's size is *not* pre-fixed (there is no "auto size" JSON property to test against), so I could not observe a case where `ns4d:DPI` changes rendering -- but its presence is confirmed not to prevent normal SVG rendering.

## Dark Mode Pictures (`_dark` suffix)

Reference: form-level `colorScheme` property (`"dark"` / `"light"`), https://developer.4d.com/docs/FormEditor/propertiesForm#color-scheme

Placing `theme.png` and `theme_dark.png` side by side in the same folder, and referencing only `theme.png` in the JSON, makes 4D substitute `theme_dark.png` automatically whenever the form's current color scheme is dark.

**Confirmed by rendering**: built two otherwise-identical forms, one with `"colorScheme": "light"` and one with `"colorScheme": "dark"` at the form level, both referencing `theme.png` (with `theme_dark.png` present alongside it, containing different baked-in text). Rendered via the real-4D CLI: the `light` form's window background rendered light and the picture object showed the `theme.png` ("light") content; the `dark` form's window background rendered dark (confirming `colorScheme` itself took effect) and the picture object showed the `theme_dark.png` ("dark") content -- the automatic `_dark` substitution **did** trigger correctly. (My earlier "does not trigger" finding was, again, a `tool4d` artifact -- see the CLI note above.)

## Other Native Formats

**Confirmed by rendering** (macOS, real 4D CLI):

| Format | Result |
|--------|--------|
| PNG | Renders correctly |
| JPEG | Renders correctly |
| BMP | Renders correctly |
| TIFF | Renders correctly |
| SVG | Renders correctly (see SVG section above) |
| GIF (single frame) | Renders correctly |
| GIF (animated) | Renders correctly as a static frame in the screenshot (see caveat below) |
| WEBP | Renders correctly on macOS |
| PDF | Renders, but noticeably faint/lower-fidelity than the raster formats (first page only, as documented, macOS only) |

Exact codec availability is queryable at runtime via `PICTURE CODEC LIST`; the table above reflects what actually rendered in this project's macOS environment.

## Animated GIF

An animated GIF placed in a static picture object plays its animation **at runtime** in the live 4D application/interpreter. `FORM SCREENSHOT` only captures a single static frame -- it cannot show the animation, and is not a reliable way to verify animated-GIF playback timing. This mirrors the general caveat that `FORM SCREENSHOT` gives a static snapshot: motion, timers, and other time-based behavior must be checked interactively.

## Supported Properties Summary

| Property | JSON Name | Notes |
|----------|-----------|-------|
| Pathname | `picture` | POSIX path; `/RESOURCES/...`, form-relative, or `var:name` |
| Display | `pictureFormat` | `"scaled"`, `"tiled"`, `"truncatedCenter"`, `"truncatedTopLeft"` |
| Top/Left/Width/Height | `top`, `left`, `width`, `height` | Standard coordinates/sizing |
| Horizontal/Vertical Sizing | `sizingX` / `sizingY` | Resizing behavior, same as other objects |
| Visibility | `visibility` | `"visible"` / `"hidden"` |
| CSS Class | `class` | CSS class hook |
| Object Name | (JSON key) | Object identifier |
| Type | `"type": "picture"` | Fixed |

Static pictures have **no data source** and no configurable event set of their own beyond the generic object identity/positioning properties -- they are purely visual/static, unlike picture buttons or picture pop-up menus which share the same `picture`/pathname mechanics but add interactivity.

## Comparison with Related Picture-Based Objects

| Feature | Static Picture | Picture Button | Picture Pop-up Menu |
|---------|----------------|----------------|----------------------|
| Interactive | No | Yes | Yes |
| Multi-frame grid (`rowCount`/`columnCount`) | No -- single image only | Yes | Yes |
| `pictureFormat` (scaled/tiled/truncated) | Yes | No (uses frame grid instead) | No |
| Typical use | Decoration, background, logos | Buttons with custom art | Icon-driven popup selection |
| Data source | None | 0-based frame index | Selection value |

## Findings Recap

- **Verified by screenshot (real 4D CLI, not `tool4d`)**: all four `pictureFormat` values and their visual differences; PNG DPI metadata has no effect on declarative rendering (confirmed twice, including a byte-identical-content pixel-diff test); `@nx` picks 1x in a headless/no-real-screen context; PNG/JPEG/BMP/TIFF/SVG/GIF (static and animated-as-static-frame)/WEBP all render; PDF renders faintly (1st page, macOS); SVG `non-scaling-stroke` keeps line weight constant under scaling; `ns4d:DPI` does not break SVG rendering (though no visual scale effect was observable with a JSON-fixed box size); dark-mode `_dark` picture auto-substitution triggers correctly with `colorScheme: "dark"`.
- **Root cause of prior wrong findings**: an earlier pass at this investigation used `tool4d` to drive `FORM SCREENSHOT`, which is unreliable for this object type -- it segfaults on some builds and silently produces blank output for others (SVG, WEBP) and misses conditional form behavior (dark mode) even without crashing. **Always use the real `4D` binary via `--headless --user-param ... --startup-method ...`, never `tool4d`, when verifying `FORM SCREENSHOT` output.**
