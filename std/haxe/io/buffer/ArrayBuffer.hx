package haxe.io.buffer;


#if js

typedef ArrayBuffer = js.html.ArrayBuffer;

#else

import haxe.io.Bytes;

@:forward()
abstract ArrayBuffer(Bytes) from Bytes to Bytes {
    public inline function new( nElements:Int ) {
        this = Bytes.alloc( nElements );
    }
}

#end