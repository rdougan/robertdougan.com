# Dougan wordmark

The lowercase **dougan** wordmark, exported for print and merch (e.g. Stickermule hats).

| File | Colour | Use on |
| --- | --- | --- |
| `dougan-logo-white.png` | `#FFFFFF` | Dark backgrounds / dark hats |
| `dougan-logo-black.png` | `#000000` | Light backgrounds / light hats |

Both files are 4454 × 1681 px PNGs tagged at 300 DPI, with a transparent background and 200 px of padding on every side.

## Typography

- **Font:** Helvetica Neue Condensed Bold (PostScript name `HelveticaNeue-CondensedBold`)
- **Tracking:** −0.01 em (−10 in Figma/Photoshop/Illustrator units)
- **Case:** all lowercase, the single word `dougan`
- **Colour:** solid, with no gradients, shadows or outlines, so it embroiders and prints cleanly

These settings match the `.logo` rule in `../index.html`, so the PNGs look the same as the logo on the website. On devices without Helvetica Neue, the site falls back to Archivo condensed (`assets/archivo.woff2`). The PNGs always use the real font.

The font was identified by rendering each Helvetica Neue face on macOS and comparing it, letter by letter, with a screenshot of the existing logo. Condensed Bold differed from the screenshot by about 3% per letter, which is a pixel-level match. Regular Bold and Condensed Black were clearly off.

## Regenerating

Helvetica Neue ships with macOS and is licensed by Apple, so the font is not committed here. To regenerate the PNGs on a Mac, or to render other colours or sizes:

```sh
cd brand
swiftc -O render.swift -o render
./render HelveticaNeue-CondensedBold 780 -0.01 dougan-logo-white.png ffffff none 200
./render HelveticaNeue-CondensedBold 780 -0.01 dougan-logo-black.png 000000 none 200
```

Arguments: `<font> <x-height px> <tracking em> <output> <text hex> <background hex|none> <padding px>`. Scale the x-height to scale the whole logo; 780 gives a width of about 4450 px.
