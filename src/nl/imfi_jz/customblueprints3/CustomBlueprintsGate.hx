package nl.imfi_jz.customblueprints3;

import nl.imfi_jz.customblueprints3.BlueprintItem;
import nl.imfi_jz.customblueprints3.file.Config;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.customblueprints3.event.PlayerInteractEvent;
import nl.imfi_jz.minecraft_api.Gate;

@:keep
class CustomBlueprintsGate implements Gate {
    
	public function enable(plugin:Plugin) {
        Debugger.setLogger(plugin.getLoggerHolder());
        plugin.getConsoleLogger().setSeverityLevelMute(Log, true);

        final config:Config = plugin.getFileSystemManager().getYmlFile(
            Config.FileName,
            null,
            "Material state reference (case sensitive): https://minecraft.fandom.com/wiki/Java_Edition_data_values#Block_states"
            + "\nRecipe materials are case insensitive and the order does not affect the recipe."
        );
        if(config.isEmpty()){
            config.generate();
        }

        plugin.getRegisterer().registerEvent(new PlayerInteractEvent());

        plugin.getRegisterer().registerShapelessRecipe(
            BlueprintItem.unfinishedBlueprintRecipe(plugin.getGame().getItemFactory(), config.getBlueprintCraftingRecipe())
        );

        BlueprintItem.blueprintMaxSize = config.getBlueprintMaxSize();
        BlueprintItem.blueprintMaterialBlacklist = config.getBlueprintMaterialBlacklist();
        BlueprintItem.blueprintMaterialStateWhitelist = config.getBlueprintMaterialStateWhitelist();
        BlueprintItem.scheduler = plugin.getScheduler();
        BlueprintItem.sharedMemory = plugin.getSharedPluginMemory().getObjectMemory();
    }

	public function disable(plugin:Plugin) {

    }
}