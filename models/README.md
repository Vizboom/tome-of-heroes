# 3D paperdoll models

Used by the Equip tab's 3D paperdoll (see the `3D PAPERDOLL` module near the end of `index.html`).

- **Universal Base Characters** (Standard) and **Modular Character Outfits – Fantasy** (Source: Knight, Noble, Wizard, Ranger and Peasant, first colourway) by [Quaternius](https://quaternius.com), licensed [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).
- Converted from the packs' glTF exports: textures stripped out of the models (they are shared and live in `tex/`; UVs are kept), meshes quantized and meshopt-compressed; textures resized to 1024px WebP.
- The original packs are attached to the `Models-raw` release.

`Base_*` are the full-body characters; the viewer uses only their skeleton and draws a plain, faceless mannequin head and neck in code. `Female_*`/`Male_*` are outfit parts on the same skeleton.

## Weapons (`weapons/`)

- **Medieval Weapons** by [Quaternius](https://quaternius.com), CC0 1.0 (licence file in the pack): swords, claymore, daggers, axes, hammers, spear, scythe, bows and shields.
- **RPG Asset Pack** by [Quaternius](https://quaternius.com), CC0 1.0 per the pack's listing (the zip itself carries no licence file): `IceStaff`, `Staff`, `WoodenStaff`. Its exports have no material colours (they live in the Blender node materials), so these were coloured by material name (Wood, Gem, Ice, Staff).
- Converted from the packs' OBJ exports: each weapon merged to one mesh, then welded and meshopt-compressed. The originals are attached to the `Models-raw` release.
- Every file is baked to the doll's convention: metres, grip at the origin, length along +Y, blade edges along ±X; bows bulge toward +X with the string on -X; shields face +X. Staffs are 1.6 m with the grip a third of the way up.
- Which item shows which model is `_weaponModel` in `index.html`; wands, crossbows, maces and whips are still built in code.
