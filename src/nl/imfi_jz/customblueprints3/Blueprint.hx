package nl.imfi_jz.customblueprints3;

import nl.imfi_jz.minecraft_api.ThreeDimensional;
import haxe.ds.Vector;

@:deprecated
abstract Blueprint(String) from String to String {
    public function toVector():Vector<ThreeDimensional> {
        // todo
        return null;
    }
}