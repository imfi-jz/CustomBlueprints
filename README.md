<img alt="CustomBlueprints bar" width="100%" src="https://user-images.githubusercontent.com/10811551/196730564-c873c7c6-f2a6-4579-a408-62caeb9c4a08.png">

# Custom Blueprints
Custom Blueprints is a Minecraft plugin that can run on Spigot servers. The plugin is written in the [Haxe programming language](https://haxe.org/), using the **[Haxe Minecraft API](https://github.com/imfi-jz/hx-mc-api)**. The plugin can be downloaded [from SpigotMC](https://www.spigotmc.org/resources/custom-blueprints.105864/), along with the [Haxe Minecraft plugin loader](https://www.spigotmc.org/resources/haxe-plugin-loader.103369/), which is **required** for this plugin to work on a Spigot server.

## Showcase
The following video showcases [the plugin's features in-game](https://youtu.be/O6vdADBGdGM):
[<img alt="Showcase video thumbnail" src="https://user-images.githubusercontent.com/10811551/197231452-03175580-62ee-44c6-b4e1-61f91d8dc063.png" width="400" border="1">](https://youtu.be/O6vdADBGdGM)

# Purpose
This GitHub hosts the source code of the plugin for learning purposes. The project is by no means neatly structured, but it is fairly small and shows you how to do various things with the API. 

It uses the **event system** (PlayerInteractEvent), creates and reads a **YML** config file, modifies **inventories** and **blocks** in the world, stores **persistant data** inside items and works with the **coordinate system** extensively. Furthermore the plugin uses the API's **debugger** and it uses the shared memory system to allow other plugins to cancel blueprints based on player or coordinates (see [code examples](https://github.com/imfi-jz/CustomBlueprints/releases/tag/d0.5)). Lastly the project shows what **compilation flags** can be used in a Haxe Minecraft plugin (see `build.hxml`).

Feel free to browse the source code, ask questions and copy it if you like.

# Contributions
This repository was not created with the intention to receive contribution but suggestions are always welcome.

## Contact
Join my Discord server to chat, ask questions or make suggestions.

[<img alt="QR code to join the Discord" src="https://user-images.githubusercontent.com/10811551/206906483-77755f2f-0e19-4e22-9274-449d083a3b77.png" width="320">](https://discord.gg/2KedGjpQMR)

## Support
This project is free to use as stated by the license. If you would like to support this project you can [donate to the developer](https://www.paypal.com/donate/?hosted_button_id=TZRUV2B66PZKQ).

[![QR code to donate](https://panels.twitch.tv/panel-28008197-image-30c20ce1-8c4c-455a-9f74-950cdf9ead76)](https://www.paypal.com/donate/?hosted_button_id=TZRUV2B66PZKQ)

# License
GNU Lesser General Public License (LGPL) (see LICENSE.txt).

<img alt="CustomBlueprints bar" width="100%" src="https://user-images.githubusercontent.com/10811551/196730564-c873c7c6-f2a6-4579-a408-62caeb9c4a08.png">