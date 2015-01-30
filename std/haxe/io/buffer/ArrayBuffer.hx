package haxe.io.buffer;

import haxe.io.Bytes;

@:forward()
abstract ArrayBuffer(Bytes) from Bytes to Bytes {
    public inline function new( nElements:Int ) {
        this = Bytes.alloc( nElements );
    }
}

