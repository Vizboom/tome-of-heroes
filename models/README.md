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
- **RPG items pack** (`Objects.zip`; its licence file calls it "LowPoly Models") by [Quaternius](https://quaternius.com), CC0 1.0: the golden variants `Sword_Big_Golden`, `Dagger_Golden`, `Axe_Small_Golden`, `Axe_Double_Golden` and `Hammer_Double_Golden`, used for legendary and artifact gear. These share their meshes with the Medieval Weapons ones, so each was baked with the transform that maps its steel twin onto the existing model (the hammer is matched on its haft, where the hand grips). `Axe_Double_Golden` is a different axe from `Axe_Double`, so it is scaled to the same length with the grip at mid-haft.
- Which item shows which model is `_weaponModel` in `index.html`; wands, crossbows, maces and whips are still built in code.

## Item icons (`icons/`)

- Rendered icons from the same Quaternius RPG items pack, CC0 1.0: trimmed and resized from the pack's 1000px PNGs to 96px WebP. Only the icons the app can pick are kept.
- The pack has no shields or staffs, so `Shield_*`, `Staff`, `IceStaff` and `WoodenStaff` were rendered from the GLBs in `weapons/` (three.js, orthographic three-quarter view, transparent background) and put through the same trim and resize.
- Which item shows which icon is `itemIconName` in `index.html` (by name, then type); shields and staffs pick the same model the paperdoll shows. Items with no fitting icon (wands, rods, spears, crossbows, most wondrous items) keep the type's emoji.
- The original pack (Weapons and Objects zips, with Blender, FBX and OBJ exports) is attached to the `Weapons_Objects` release.
