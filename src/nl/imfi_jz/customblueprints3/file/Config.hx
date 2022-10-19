package nl.imfi_jz.customblueprints3.file;

import nl.imfi_jz.minecraft_api.KeyValueFile;

abstract Config(NestableKeyValueFile<Any>) from NestableKeyValueFile<Any> {
    public static inline final FileName = "config";

    public static inline final BlueprintCraftingRecipeKey = "Blueprint crafting recipe";
    public static inline final BlueprintMaxSizeKey = "Blueprint max size";
    public static inline final BlueprintMaterialBlacklistKey = "Blueprint material blacklist";
    public static inline final BlueprintMaterialDataWhitelistKey = "Blueprint material state whitelist";

    public inline function isEmpty():Bool {
        return this.getKeys().length <= 0;
    }

    public function generate() {
        final redstoneDust = "Redstone";

        this.setValue(
            BlueprintCraftingRecipeKey, 
            [redstoneDust, redstoneDust, "Lapis Lazuli",
            BlueprintItem.ItemType, "Feather", "Ink Sac"]
        );

        this.setValue(BlueprintMaxSizeKey, 10);

        this.setValue(BlueprintMaterialBlacklistKey, [
            "Bed",
            "Cake",
            "Respawn Anchor",
            "Trutle Egg",
            "Farmland",
            "Mushroom Stem",
            "Red Mushroom Block",
            "Brown Mushroom Block",
        ]);

        this.setValue(BlueprintMaterialDataWhitelistKey, [
            "attached",
            "attachment",
            "axis",
            "bottom",
            "conditional",
            "delay",
            "disarmed",
            "distance",
            "down",
            "east",
            "enabled",
            "extended",
            "face",
            "facing",
            "half",
            "hanging",
            "hinge",
            "in_wall",
            "instrument",
            "inverted",
            "locked",
            "mode",
            "north",
            "note",
            "open",
            "orientation",
            "part",
            "persistent",
            "power",
            "powered",
            "rotation",
            "shape",
            "short",
            "signal_fire",
            "south",
            "triggered",
            "type",
            "unstable",
            "up",
            "west",
        ]);
    }

    public inline function getBlueprintCraftingRecipe():Array<String> {
        return this.getValue(BlueprintCraftingRecipeKey);
    }

    public inline function getBlueprintMaxSize():Int {
        return this.getValue(BlueprintMaxSizeKey);
    }

    public inline function getBlueprintMaterialBlacklist():Array<String> {
        return this.getValue(BlueprintMaterialBlacklistKey);
    }

    public inline function getBlueprintMaterialStateWhitelist():Array<String> {
        return this.getValue(BlueprintMaterialDataWhitelistKey);
    }
}