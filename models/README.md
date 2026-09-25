# 3D paperdoll models

Used by the Equip tab's 3D paperdoll (see the `3D PAPERDOLL` module near the end of `index.html`).

- **Universal Base Characters** (Standard) and **Modular Character Outfits – Fantasy** (Source: Knight, Noble, Wizard, Ranger and Peasant, first colourway) by [Quaternius](https://quaternius.com), licensed [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
- Converted from the packs' glTF exports: textures stripped out of the models (they are shared and live in `tex/`; UVs are kept), meshes quantized and meshopt-compressed; textures resized to 1024px WebP.
- The original packs are attached to the `Models-raw` release.

`Base_*` are the full-body characters; the viewer uses only their skeleton and draws a plain, faceless mannequin head and neck in code. `Female_*`/`Male_*` are outfit parts on the same skeleton.
