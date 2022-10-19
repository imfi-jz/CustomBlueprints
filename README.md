<img alt="CustomBlueprints bar" src="https://user-images.githubusercontent.com/10811551/196730564-c873c7c6-f2a6-4579-a408-62caeb9c4a08.png">

# Custom Blueprints
Custom Blueprints is a Minecraft plugin that can run on Spigot servers. The plugin is written in the [Haxe programming language](https://haxe.org/), using the **[Haxe Minecraft API](https://github.com/imfi-jz/hx-mc-api)**. The plugin can be downloaded [from SpigotMC](<!-- TODO -->), along with the [Haxe Minecraft plugin loader](https://www.spigotmc.org/resources/haxe-plugin-loader.103369/), which is **required** for this plugin to work on a Spigot server.
<!-- TODO
## Showcase
The following video showcases the plugin's features in-game:
-->

# Purpose
This GitHub hosts the source code of the plugin for learning purposes. The project is by no means neatly structured, but it is fairly small and shows you how to do various things with the API. 

It uses the **event system** (PlayerInteractEvent), creates and reads a **YML** config file, modifies **inventories** and **blocks** in the world, stores **persistant data** inside items and works with the **coordinate system** extensively. Furthermore the plugin uses the API's **debugger** and lightly touches upon the shared memory system (used for plugin to plugin communication). Lastly the project shows what **compilation flags** can be used in a Haxe Minecraft plugin (see `build.hxml`).

Feel free to browse the source code, ask questions and copy it if you like.

# Contributions
This repository was not created with the intention to receive contribution but suggestions are always welcome.

# License
GNU Lesser General Public License (LGPL) (see LICENSE.txt).

# Support
This project is free to use as stated by the license. If you would like to support this project you can [donate to the developer](https://www.paypal.com/donate/?hosted_button_id=TZRUV2B66PZKQ).

[![QR code to donate](https://panels.twitch.tv/panel-28008197-image-30c20ce1-8c4c-455a-9f74-950cdf9ead76)](https://www.paypal.com/donate/?hosted_button_id=TZRUV2B66PZKQ)
