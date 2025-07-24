# Starbound WEdit

This is a fork of [WEdit](https://github.com/Silverfeelin/Starbound-WEdit) for OpenStarbound client, where I made some QoL features. Check the [wiki](#wiki) to see the changes.

WEdit is a mod that allows you to edit the world around you on a larger scale through various functions and features not present in the game.

## Table of Contents

- [Wiki](#wiki)
- [Features](#features)
- [Planned](#planned)
- [Potential Issues](#potential-issues)
- [Contributing](#contributing)
- [Licenses](#licenses)

## Features

* Edit terrain in-game on a large scale.
* Copy and paste structures, even between planets.
* Many [tools](https://github.com/Silverfeelin/Starbound-WEdit/wiki/Features) accessible from a [compact interface](https://github.com/Silverfeelin/Starbound-WEdit/wiki/Compact-Interface).
* Configure settings in a Quickbar interface.

A full list of features with their usage can be found on the [Wiki](https://github.com/Silverfeelin/Starbound-WEdit/wiki).

## Wiki
Clarifications:
- This is not the tech mod anymore, its work through generic script context, that allow mod to work without tech equipping.
- To enable the mod, you need to install it and open the WEdit interface in quickbar, then check the "Enable WEdit" checkbox.
- The mod is not compatible with the original WEdit tech, so you need to remove it from your game first.
- The mod is not compatible with the original starbound client.
- Added a material collision cycling feature from OpenStarbound. It uses the same key as the OpenStarbound. Open menu, then press the "Settings" -> "Mod Binds" -> "OpenStarbound" -> "Building" -> "Cycle Material Collision". WORKS ONLY IF YOU HAVE THE OPENSB BOTH CLIENT AND SERVER INSTALLED. [WEdit Material Cycling Demonstration](https://youtu.be/k671rlXsyts)
- Refactored the Material and Matmod pickers. Now they have the search bar and category sorting. [WEdit sort demonstration](https://youtu.be/_xUhWmV3Lg0)
- Blocks and Matmods are automatically added to WEdit, so it no longer requires third-party mods to add blocks from them. 

The Wiki covers just about everything you need to know and do to use WEdit.  
https://github.com/Silverfeelin/Starbound-WEdit/wiki

## Planned

See the [Issues page](https://github.com/Silverfeelin/Starbound-WEdit/labels/enhancement). You can post your own suggestions here too!

## Potential Issues

* Blocks can not be placed directly in front of or behind empty space, when there are no adjacent blocks on the same layer. Some actions may not yield the result you expected initially because of this. The script tries to work around this issue by running the same actions multiple times.
* Server lag can cause synchronization issues; the script continues working while the world hasn't updated yet. You can compensate by slowing down WEdit in the [settings](https://github.com/Silverfeelin/Starbound-WEdit/wiki/Settings-Interface).
* The Undo Tool should not be relied upon; it's probably pretty buggy. It is recommended to **back up worlds** before making any major changes!

## Contributing

If you have any suggestions or feedback that might help improve this mod, please do post them by creating a [new Issue](https://github.com/Silverfeelin/Starbound-WEdit/issues/new).

You can also create pull requests to contribute directly to the mod!

## Licenses

WEdit is licensed under the MIT license. Please see: [LICENSE](https://github.com/Silverfeelin/Starbound-WEdit/blob/master/LICENSE).


Most of the icons used for the tools are courtesy of [Yusuke Kamiyamane](http://p.yusukekamiyamane.com/about/), and can be found in his [Fugue Icons](http://p.yusukekamiyamane.com/) pack. Some have been modified slightly to fit better into the game.  
Fugue Icons falls under the [Creative Commons 3.0 license](http://creativecommons.org/licenses/by/3.0/).
