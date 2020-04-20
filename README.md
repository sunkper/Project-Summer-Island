# Project Summer Island
<img src="https://github.com/sunkper/Project-Summer-Island/blob/master/images/CoverArtCDVer.png" data-canonical-src="https://github.com/sunkper/Project-Summer-Island/blob/master/images/CoverArtCDVer.png" width="300" /> <img src="https://github.com/sunkper/Project-Summer-Island/blob/master/images/ScreenFromKitchen.png" data-canonical-src="https://github.com/sunkper/Project-Summer-Island/blob/master/images/ScreenFromKitchen.png" height="264" /> 

Project Summer Island (PSI) is a small 3D scene made with Godot Engine. It is a re-creation of and fan work based on [a scene](https://imgur.com/a/fghC9C2) from 2002 game [Boku no Natsuyasumi 2](https://en.wikipedia.org/wiki/Boku_no_Natsuyasumi_2).

:tv: [Tour video on YouTube](https://www.youtube.com/watch?v=8ZscxvGynzM) | :floppy_disk: [Downloads](https://github.com/sunkper/Project-Summer-Island/releases)

Although you can move around the scene and there are some interactive elements (plus a little puzzle-ish thing or two) this is a non-game scene. You can see controls in the initial screen and you can always bring up the control help with `F1` key. You can take screenshots with `F12` key, and they will be saved to Godot Engine's user folder. (Windows for example, `C:\Users\<username>\AppData\Roaming\Godot\app_userdata\Project Summer Island`)

**This is my first 3D scene!** It's my baby steps into 3D content creation, a learning project. You get the idea. It's fairly unoptimized and, I think, inefficient, as you may can tell from the long loading time and performace.

**System requirements?** With my low-end GPU (GTX 1050Ti), and at 720p, it generally runs at over 40 fps (50 to 60 at less busy view, 30 something at the busiest view). As I said this is pretty unpotimized scene, if your system is weaker than mine this scene may give your system a hard time. So be aware.

**This source release is definitley NOT intended as a good example of 3D scene in Godot or pre-made assets.** Of course you can use assets and code here as per [the license](https://github.com/sunkper/Project-Summer-Island/blob/master/LICENSE.md) if you know what you're doing or don't mind. Also be aware that the tool scripts (like MergeToMultiMesh) I made for this project are for quick and specific tasks and may not be suitable for a general use. I only release this scene so someone can poke around it and see if they can learn anything even from my mistakes. (Also I'd appreciate some advices too ;))

Also see [the issue board](https://github.com/sunkper/Project-Summer-Island/issues) for known issues.

## Tools Used
- I used [Trenchbroom](https://kristianduske.com/trenchbroom/), a Quake map editor, and [Qodot](https://github.com/ShiftyAxel/Qodot), the Quake map importer for Godot, for building the base structure of the house and geometries around it.
- I started to learn [Blender](https://www.blender.org/) for making smaller and more complex props.
- [Material Maker](https://github.com/RodZill4/material-maker) for creating and generating textures and materials.
- [Materialize](http://boundingboxsoftware.com/materialize/) for generating materials from images.

![In-editor](https://github.com/sunkper/Project-Summer-Island/blob/master/images/ScreenEditor.png)

## Some thoughts
- **Performance**: I *think* the majority of performace cost (and load times) came from me abusing GIProbes (the main one uses 256 subdiv) and ReflectionProbes in a rather small area, god rays shader, and probably little objects with unnecessary transparency. And since current version of Godot does not do occlusion-based culling and I did not implemented any custom culling method here, the performance likely will hit hardest when you look at objects in the house and mountains side at the same time, and even more at higher resolution. I'd probably not abuse the probes like this in the actual game project.
- **Why Qodot?**: Since I (unsuccessfully) did some Quake mapping and I am more familiar with Trenchbroom than Blender, as soon as I see Qodot is released, I started tinker with 3D part of Godot (I used to tinker with 2D part almost exclusively), and started this project to learn the ropes of 3D content creation. Qodot made me realize that 3D development is not as scary as it seemed.
- **Is Qodot suitable for making this kind of scene?**: Maybe not? Likely not if you exclusively use brush-based geometry. But even for games with higher details, I imagine you could make use of its general level design features and workflow, mixing assets made by other software and brush geometry, like many Source engine games did.
- **Inconsistency in texel and vertex density**: This is partly due to initial art decision (pixel-y aesthetics) I've deviated from after some time. So most of the assets are low-res (256*256) and low-poly but as I learn more of Blender I started to add more details, made some high"er"-res and high"er"-poly assets. This is also partly due to that this scene is for the show and learning than an actual game. You can see I added fairly unecessary details to areas barely visible from the house.

## Dependency
### Godot version
This project is made with Godot Engine 3.2.1.

### Plugins
Plugins used in this project are not included in the repositary. You should install them yourself. Versions may or may not be relavant for compatibility, look for version history of each plugin.

* [Qodot](https://github.com/ShiftyAxel/Qodot) (1.6.4) - note that I added `transmission` property to automatic PBR texturing. Very few materials actually used if you want to make use of it: in `qodot_texture_loader.gd`, add a constant `PBR_TRANSMISSION := 'transmission'`, and add `[ PBR_TRANSMISSION, SpatialMaterial.TEXTURE_TRANSMISSION, 'transmission_enabled' ]` to `PBR_SUFFICES` array.
* [Godot God Rays Plugin](https://github.com/SIsilicon/Godot-God-Rays-Plugin) (1.0.1)

## License
My original creations are licensed under MIT License. **HOWEVER** as this is a re-creation of a scene from a commerical game, there are important caveats. Please refer to [License file](https://github.com/sunkper/Project-Summer-Island/blob/master/LICENSE.md).

## :sunny: Author
You can follow me on [Twitter](https://twitter.com/SunkPer).
