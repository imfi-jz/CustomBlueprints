package nl.imfi_jz.customblueprints3.event;

import nl.imfi_jz.minecraft_api.implementation.unchanging.ThreeDimensional.UnchangingThreeDimensional;
import nl.imfi_jz.minecraft_api.MessageReceiver.SeverityGuideline;
import nl.imfi_jz.minecraft_api.Event;

using nl.imfi_jz.customblueprints3.BlueprintItem;

class PlayerInteractEvent implements CancelingEvent {

    public function new() {
        
    }

	public function getName():String {
		return "PlayerInteractEvent";
	}

	public function occur(involvement:EventData) {
        if(isBlueprintInteraction(involvement)){
            final item = involvement.getItems()[0];
            final clickedBlock = involvement.getBlocks()[0];
            final player = involvement.getPlayers()[0];

            if(item.isFinishedBlueprint()){
                final placeCoordinates = clickedBlock.getCoordinates();
                item.placeBlueprintAsMuchAsPossible(player, new UnchangingThreeDimensional(
                    placeCoordinates.getX(),
                    placeCoordinates.getY() + 1,
                    placeCoordinates.getZ()
                ));
                #if mc_debug player.tell("Placing blueprint"); #end
            }
            else if(clickedBlock.isA("CARTOGRAPHY_TABLE") && item.canFinishBlueprint()){
                item.finishBlueprint();
                #if mc_debug player.tell("Finished blueprint"); #end
                player.playSoundByName("ITEM_BOOK_PUT", 1, 1);
                player.playSoundByName("BLOCK_GRASS_STEP", 1.2, 0.8);
            }
            else if(item.canAddBlockToBlueprint(clickedBlock, player.getCoordinates())) {
                item.addBlockToBlueprint(clickedBlock, player.getCoordinates());
                player.playSoundByName("ITEM_BOOK_PAGE_TURN", 1, 1.5);
                #if mc_debug player.tell('Adding ${clickedBlock.getName().toLowerCase()} to blueprint'); #end
            }
            else if(item.canRemoveBlockFromBlueprint(clickedBlock, player.getCoordinates())) {
                item.removeBlockFromBlueprint(clickedBlock, player.getCoordinates());
                player.playSoundByName("BLOCK_WOOL_BREAK", 1, 1);
                #if mc_debug player.tell('Removed ${clickedBlock.getName().toLowerCase()} from blueprint'); #end
            }
            else {
                player.tell("Unable to add block to blueprint", SeverityGuideline.Notice);
            }
        }
    }

    private inline function isBlueprintInteraction(eventData:EventData) {
        if(eventData.getItems().length > 0){
            final item = eventData.getItems()[0];
            return eventData.getEnumValues().contains("RIGHT_CLICK_BLOCK")
                && item.isBlueprint();
        }
        else return false;
    }

	public function shouldCancel(involvement:EventData):Bool {
		return isBlueprintInteraction(involvement);
	}
}