# Project Summer Island
Project Summer Island (PSI) is a small 3D scene made with Godot Engine. It is a re-creation of and fan work based on [a scene](https://imgur.com/a/fghC9C2) from 2002 game [Boku no Natsuyasumi 2](https://en.wikipedia.org/wiki/Boku_no_Natsuyasumi_2).

Although there are some interactive elements (and a little puzzle-ish thing) this is a non-game scene.

**This is my first 3D scene!** It's baby steps into 3D content creation, a learning project. You get the idea. It's fairly unoptimized and, I think, inefficient, as you may can tell from the long loading time and performace.

**This source release is definitley not intended as a good example of 3D scene in Godot or pre-made assets.** Though you can use assets and code here as per [the license](https://github.com/sunkper/Project-Summer-Island/blob/master/LICENSE.md) if you know what you're doing or don't mind. Also be aware that the tools (like MergeToMultiMesh) I made for this are made for quick and specific uese and may not suitable for general use. I release this scene so someone can poke around it and see if they can learn anything even from my mistakes.

## Some thoughts
- **Why Qodot?**: Since I (unsuccessfully) did some Quake mapping and I am more familiar with Trenchbroom than Blender,  as soon as I see Qodot, a Quake map importer plugin for Godot, is released, I started tinker with 3D part of Godot. (I used to tinker with 2D part almost exclusively.) Qodot made me realize that 3D development is not as scary as it seemed.
- **Is Qodot suitable for making this kind of scene?**: Maybe not? Likely not if you exclusively use brush-based geometry. But even for games with higher details, I imagine you could make use of its general level design features, mixing assets made by other software and brush geometry, like many Source engine games did.
- **Inconsistency in texel and vertex density**: This is partly due to initial art decision (pixel-y aesthetics) I've deviated from after some time. So most of the assets are low-res (256*256) and low-poly but as I was adding more details, I made some higher-res and higher-poly assets. This is also partly due to that this scene is for the show and learning than an actual game. You can see I added fairly unecessary details to areas barely visible from the house.

## Dependency
### Godot version
This project is made with Godot Engine 3.2.1.

### Plugins
Plugins used in this project are not included in the repositary. You should install them yourself. Versions may or may not be relavant for compatibility, look for version history of each plugin.

* [Qodot](https://github.com/ShiftyAxel/Qodot) (1.6.4) - note that I added `transmission` property to automatic PBR texturing. Very few materials actually used if you want to make use of it: in `qodot_texture_loader.gd`, add a constant `PBR_TRANSMISSION := 'transmission'`, and add `[ PBR_TRANSMISSION, SpatialMaterial.TEXTURE_TRANSMISSION, 'transmission_enabled' ]` to `PBR_SUFFICES` array.
* [Godot God Rays Plugin](https://github.com/SIsilicon/Godot-God-Rays-Plugin) (1.0.1)

## License
My original creations are licensed under MIT License. **HOWEVER** as this is a re-creation of a scene from a commerical game, there are important caveats. Please refer to [License file](https://github.com/sunkper/Project-Summer-Island/blob/master/LICENSE.md).
