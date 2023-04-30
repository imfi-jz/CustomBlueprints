package nl.imfi_jz.customblueprints3;

import nl.imfi_jz.minecraft_api.MessageReceiver;
import nl.imfi_jz.minecraft_api.GameObject.Player;
import nl.imfi_jz.minecraft_api.Gate.SharedMemory;
import nl.imfi_jz.minecraft_api.Gate.Scheduler;
import haxe.ds.List;
import nl.imfi_jz.minecraft_api.GameObject.Encounter;
import nl.imfi_jz.minecraft_api.implementation.Debugger;
import nl.imfi_jz.minecraft_api.Recipe.ShapelessRecipe;
import nl.imfi_jz.minecraft_api.implementation.Recipe.ConstructableShapelessRecipe;
import nl.imfi_jz.minecraft_api.GameObject.Block;
import nl.imfi_jz.minecraft_api.GameObjectFactory.ConstructingItemFactory;
import nl.imfi_jz.minecraft_api.implementation.unchanging.ThreeDimensional.UnchangingThreeDimensional;
import nl.imfi_jz.minecraft_api.ThreeDimensional;
import nl.imfi_jz.minecraft_api.GameObject.Item;

class BlueprintItem {
    public static inline final ItemType = "Paper";
    
    private static inline final Blueprint = "Blueprint";
    private static inline final UnfinishedBlueprintItemCaption = "Unfinished " + Blueprint;
    private static inline final FinishedBlueprintItemCaption = "Finished " + Blueprint;

    private static inline final CenterCoordinatesKey = "BlueprintCenterCoordinates";
    private static inline final CoordinateSerializationSeparator = "_";
    private static inline final StatesAndValuesKey = "StatesAndValues";
    private static inline final StateValuePairSeparator = ",";
    private static inline final StateValueSeparator = ">";

    public static var blueprintMaxSize:Int;
    public static var blueprintMaterialBlacklist:Array<String>;
    public static var blueprintMaterialStateWhitelist:Array<String>;
    public static var scheduler:Scheduler;

    public static var objMemory:SharedMemory<Dynamic>;
    public static var strMemory:SharedMemory<String>;
    public static var floatMemory:SharedMemory<Float>;
    public static var boolMemory:SharedMemory<Bool>;

    public static inline function unfinishedBlueprintRecipe(itemFactory:ConstructingItemFactory, recipeMaterials:Array<String>):ShapelessRecipe {
        final result = itemFactory.createGameObject(ItemType);
        result.setCaption([UnfinishedBlueprintItemCaption]);
        result.setDisplayName('Untitled ${Blueprint}');
        
        return new ConstructableShapelessRecipe(
            recipeMaterials,
            result
        );
    }

    public static inline function isBlueprint(item:Item):Bool {
        Debugger.log('${item.getName()} is a blueprint: ${item.isA(ItemType)
            && item.getCaption().filter(c -> c.indexOf(Blueprint) >= 0).length > 0}');

        return item.isA(ItemType)
            && item.getCaption().filter(c -> c.indexOf(Blueprint) >= 0).length > 0;
    }
    
    public static inline function isFinishedBlueprint(item:Item):Bool {
        Debugger.log('${item.getName()} is a finished blueprint: ${item.isA(ItemType)
            && item.getCaption().indexOf(FinishedBlueprintItemCaption) >= 0}');
            
        return item.isA(ItemType)
            && item.getCaption().indexOf(FinishedBlueprintItemCaption) >= 0;
        /* final captionPrefixIndex = item.getCaption().indexOf(ItemCaptionPrefix);
        return item.isA(ItemType)
            && captionPrefixIndex >= 0
            && item.getCaption().indexOf(ItemCaptionIdPrefix) > captionPrefixIndex; */
    }

    public static inline function finishBlueprint(item:Item) {
        final caption = item.getCaption();
        caption[0] = FinishedBlueprintItemCaption;
        item.setCaption(caption);

        Debugger.log('Set ${item.getName()}s caption to ${item.getCaption()}');
    }

    private static inline function serializeCoordinates(coordinates:ThreeDimensional):String {
        /* Debugger.log('Serialized 3D to: ${Std.int(coordinates.getX())
            + CoordinateSerializationSeparator
            + Std.int(coordinates.getY())
            + CoordinateSerializationSeparator
            + Std.int(coordinates.getZ())}'); */

        return Math.floor(coordinates.getX())
            + CoordinateSerializationSeparator
            + Math.floor(coordinates.getY())
            + CoordinateSerializationSeparator
            + Math.floor(coordinates.getZ());
    }

    private static function serializeWhitelistedStateValues(block:Block):String {
        final strBuff = new List<String>();

        for(state in blueprintMaterialStateWhitelist){
            final value = block.getValue(state);
            if(value != null){
                strBuff.add('$state$StateValueSeparator$value');
            }
        }

        Debugger.log('Serialized block states: ' + strBuff.join(StateValuePairSeparator));

        return strBuff.join(StateValuePairSeparator);
    }

    private static function deserializeWhitelistedStateValues(statesAndValues:String):Map<String, String> {
        final map = new Map<String, String>();

        if(statesAndValues != null){
            for(pair in statesAndValues.split(StateValuePairSeparator)){
                final keyValue = pair.split(StateValueSeparator);
                map.set(keyValue[0], keyValue[1]);
            }
        }
        return map;
    }

    private static inline function deserializeCoordinates(coordinates:String):UnchangingThreeDimensional {
        final coordinateValues = coordinates.split(CoordinateSerializationSeparator);
        //Debugger.log('Deserializing: $coordinateValues');
        return new UnchangingThreeDimensional(
            Std.parseInt(coordinateValues[0]),
            Std.parseInt(coordinateValues[1]),
            Std.parseInt(coordinateValues[2])
        );
    }

    private static inline function getBlueprintBlockNameAt(item:Item, serializedRelativeCoordinates:String):String {
        //Debugger.log('Got block name at $relativeCoordinates: ${item.getValue(serializeCoordinate(relativeCoordinates))}');

        return item.getValue(serializedRelativeCoordinates);
    }

    private static inline function getBlueprintBlockStateValuesAt(item:Item, serializedRelativeCoordinates:String):Map<String, String> {
        return deserializeWhitelistedStateValues(item.getValue(serializedRelativeCoordinates + StatesAndValuesKey));
    }

    private static inline function setBlueprintBlockNameAt(item:Item, serializedRelativeCoordinates:String, name:String):Void {
        item.setValue(serializedRelativeCoordinates, name);
    }

    private static function setBlueprintBlockStateValuesAt(item:Item, serializedRelativeCoordinates:String, block:Block):Void {
        final serializedStatesAndValues = serializeWhitelistedStateValues(block);
        if(serializedStatesAndValues.length > 0){
            item.setValue(serializedRelativeCoordinates + StatesAndValuesKey, serializedStatesAndValues);
        }
    }

    private static function getBlueprintCreationCenter(item:Item, newCenterIfMissing:ThreeDimensional):UnchangingThreeDimensional {
        final coordinatesValue:String = item.getValue(CenterCoordinatesKey);
        if(coordinatesValue == null){
            setBlueprintCreationCenter(item, newCenterIfMissing);
            return getBlueprintCreationCenter(item, newCenterIfMissing);
        }
        else {
            Debugger.log('Got blueprint center: ${deserializeCoordinates(coordinatesValue)}');
            return deserializeCoordinates(coordinatesValue);
        }
    }

    private static inline function threeDimDifference(a:ThreeDimensional, b:ThreeDimensional):ThreeDimensional {
        return new UnchangingThreeDimensional(
            b.getX() - a.getX(),
            b.getY() - a.getY(),
            b.getZ() - a.getZ()
        );
    }

    private static inline function setBlueprintCreationCenter(item:Item, coordinates:ThreeDimensional) {
        item.setValue(CenterCoordinatesKey, serializeCoordinates(coordinates));

        Debugger.log('Set blueprint center to: ${serializeCoordinates(coordinates)}');
    }

    public static function canAddBlockToBlueprint(item:Item, block:Block, creatorCoordinates:ThreeDimensional):Bool {
        final center = getBlueprintCreationCenter(item, creatorCoordinates);
        final blockCoordinates = new UnchangingThreeDimensional(block.getCoordinates());
        final relativeBlockCoordinates = threeDimDifference(center, blockCoordinates);

        for(blacklistedMaterial in blueprintMaterialBlacklist){
            if(block.isA(blacklistedMaterial)){
                Debugger.log('${block.getName()} can be added to blueprint: false, is blacklisted');
                return false;
            }
        }

        Debugger.log('${block.getName()} can be added to blueprint: ${blockCoordinates.isWithin(blueprintMaxSize, center)
            && getBlueprintBlockNameAt(item, serializeCoordinates(relativeBlockCoordinates)) == null}');

        return blockCoordinates.isWithin(blueprintMaxSize, center)
            && getBlueprintBlockNameAt(item, serializeCoordinates(relativeBlockCoordinates)) == null;
    }

    public static function addBlockToBlueprint(item:Item, block:Block, creatorCoordinates:ThreeDimensional) {
        final coordinatesDifference = threeDimDifference(getBlueprintCreationCenter(item, creatorCoordinates), block.getCoordinates());
        final coordinatesKey = serializeCoordinates(coordinatesDifference);
        setBlueprintBlockNameAt(item, coordinatesKey, block.getName().toUpperCase());
        setBlockBlueprintCount(item, getBlockBlueprintCount(item) + 1);
        setBlueprintBlockStateValuesAt(item, coordinatesKey, block);

        Debugger.log('Added ${block.getName().toUpperCase()} to blueprint at: ${serializeCoordinates(coordinatesDifference)}');
    }

    public static function canRemoveBlockFromBlueprint(item:Item, block:Block, creatorCoordinates:ThreeDimensional):Bool {
        final center = getBlueprintCreationCenter(item, creatorCoordinates);
        final reltiveBlockCoordinates = threeDimDifference(center, block.getCoordinates());

        Debugger.log('Can remove ${block.getName()} from blueprint: ${getBlueprintBlockNameAt(item, serializeCoordinates(reltiveBlockCoordinates)) != null}');

        return getBlueprintBlockNameAt(item, serializeCoordinates(reltiveBlockCoordinates)) != null;
    }

    public static function removeBlockFromBlueprint(item:Item, block:Block, creatorCoordinates:ThreeDimensional) {
        final coordinatesDifference = threeDimDifference(getBlueprintCreationCenter(item, creatorCoordinates), block.getCoordinates());
        item.setValue(serializeCoordinates(coordinatesDifference), null);
        setBlockBlueprintCount(item, getBlockBlueprintCount(item) - 1);

        Debugger.log('Set ${serializeCoordinates(coordinatesDifference)} to null');
    }

    public static inline function canFinishBlueprint(item:Item):Bool {
        return item.getValue(CenterCoordinatesKey) != null;
    }

    private static function getBlockBlueprintCount(item:Item):Int {
        final caption = item.getCaption();
        if(caption.length < 2){
            return 0;
        }
        else return Std.parseInt(caption[1].substring(0, caption[1].indexOf(" ")));
    }

    private static function setBlockBlueprintCount(item:Item, count:Int) {
        final caption = item.getCaption();
        if(caption.length < 2){
            caption.insert(1, '$count blocks');
        }
        else {
            caption[1] = '$count blocks';
        }
        item.setCaption(caption);
    }

    public static function placeBlueprintAsMuchAsPossible(item:Item, placer:Encounter, placingCoordinates:ThreeDimensional) {
        final inventory = placer.getInventory();
        final world = placer.getWorld();
        var placedAny = false;
        var cancelled = false;
        
        final wrapUp = () -> {
            if(placedAny){
                placer.playSoundByName('BLOCK_WOOD_PLACE', 1, 0.5);
            }

            boolMemory.valueChanged(getLastPlacedBlueprintSharedMemoryKey('Cancelled'));
            boolMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Done'), true);
        };

        Debugger.log('Building blueprint');

        boolMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Cancelled'), false);
        boolMemory.valueChanged(getLastPlacedBlueprintSharedMemoryKey('Cancelled'), (prev, curr) -> cancelled = curr);
        boolMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Done'), false);
        objMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Player'), placer);
        floatMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('X'), placingCoordinates.getX());
        floatMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Y'), placingCoordinates.getY());
        floatMemory.setValue(getLastPlacedBlueprintSharedMemoryKey('Z'), placingCoordinates.getZ());

        final soundsPlayed = [];

        for (y in -blueprintMaxSize...blueprintMaxSize){
            for (x in -blueprintMaxSize...blueprintMaxSize){
                for (z in -blueprintMaxSize...blueprintMaxSize){
                    if(cancelled){
                        if(placer is MessageReceiver){
                            cast(placer, MessageReceiver).tell("§oYour blueprint placement was cancelled");
                        }
                        wrapUp();
                        return;
                    }

                    final relativeBlockCoordinates = new UnchangingThreeDimensional(x, y, z);
                    final worldBlockCoordinates = new UnchangingThreeDimensional(
                        placingCoordinates.getX() + relativeBlockCoordinates.getX(),
                        placingCoordinates.getY() + relativeBlockCoordinates.getY(),
                        placingCoordinates.getZ() + relativeBlockCoordinates.getZ()
                    );
                    final block = world.getBlockAt(worldBlockCoordinates);

                    if(canPlaceBlockAt(block)){
                        final serializedCoordinates = serializeCoordinates(relativeBlockCoordinates);
                        final itemNameAtCoordinates = getBlueprintBlockNameAt(item, serializedCoordinates);
    
                        if(itemNameAtCoordinates != null){
                            for(inventorySlot in inventory.occupiedSlots()){
                                final placeForFree = !shouldConsumeRequiredItemsFromPlacer(placer);
                                final invItem = inventory.getItem(inventorySlot);
                                Debugger.log('Placing $itemNameAtCoordinates for free');
                                
                                if(placeForFree || itemEquals(invItem, itemNameAtCoordinates)){
                                    Debugger.log('Found item at slot: $inventorySlot');
                                    if(placeForFree || inventory.setQuantity(inventorySlot, inventory.getQuantity(inventorySlot) - 1)){
                                        scheduler.executeInParallel(() ->
                                            if(block.setType(itemNameAtCoordinates)){
                                                for(stateValuePair in getBlueprintBlockStateValuesAt(item, serializedCoordinates).keyValueIterator()){
                                                    Debugger.log('Setting property ${stateValuePair.key} to ${stateValuePair.value}');
                                                    if(!block.setValue(stateValuePair.key, stateValuePair.value)){
                                                        Debugger.warn('Failed to set property');
                                                    }
                                                }
                                                placedAny = true;
                                                if(!soundsPlayed.contains(itemNameAtCoordinates)){
                                                    block.playSoundByName('BLOCK_${itemNameAtCoordinates}_PLACE', 0.5, 0.5);
                                                    soundsPlayed.push(itemNameAtCoordinates);
                                                }
                                                // break;
                                            }
                                            else Debugger.warn('Failed to set item type $itemNameAtCoordinates')
                                        );
                                        break;
                                    }
                                    else Debugger.warn('Failed to reduce item quantity of $itemNameAtCoordinates');
                                }
                            }
                        }
                    }
                }
            }
        }

        wrapUp();
    }

    private static inline function getLastPlacedBlueprintSharedMemoryKey(addition:String){
        return 'LastPlacedBlueprint$addition';
    }

    private static function itemEquals(item:Item, name:String):Bool {
        if(item == null || name == null){
            return false;
        }
        else {
            final itemName = StringTools.replace(item.getName().toUpperCase(), ' ', '_');
            
            name = StringTools.trim(
                StringTools.replace(
                    StringTools.replace(name, "WALL_", " "),
                    "_OFF",
                    " "
                )
            );
            //Debugger.log('Checking $itemName == $name');

            return itemName == name;
        }
    }

    private static inline function canPlaceBlockAt(block:Block):Bool {
        return block.isA("empty") || block.isA("liquid");
    }

    private static inline function shouldConsumeRequiredItemsFromPlacer(placer:Encounter) {
        if(placer is Player){
            return cast(placer, Player).getGameMode().toLowerCase() != "creative";
        }
        else return true;
    }
}