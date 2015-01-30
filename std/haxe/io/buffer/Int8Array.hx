package haxe.io.buffer;

#if js

@:forward()
@:arrayAccess
abstract Int8Array(js.html.Int8Array) from js.html.Int8Array to js.html.Int8Array {

    public inline function new( elements:Int ) {
        this = new js.html.Int8Array(elements);
    }

    public static inline function fromArray( array:Array<Float> ) : Int8Array {
        return new js.html.Int8Array( cast array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int8Array {
        return new js.html.Int8Array( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:js.html.ArrayBufferView ) : Int8Array {
        return new js.html.Int8Array( cast view );
    }

    public function setFromArray( array:Array<Float>, offset : Int = 0 ) {
        this.set(cast array, offset);
    }

}

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;
using haxe.io.buffer.ArrayBufferViewIO;


@:forward()
@:arrayAccess
abstract Int8Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int ) {
        this = new ArrayBufferView( elements, Int8 );
    }

    public static inline function fromArray( array:Array<Float> ) : Int8Array {
        return new Int8Array(0).initArray(array);
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int8Array {
        return new Int8Array(0).initBuffer( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:ArrayBufferView ) : Int8Array {
        return new Int8Array(0).initTypedArray( view );
    }

//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : Int8Array {
        return this.subarray(begin, end);
    }

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) return this.getInt8(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:Int) return this.setInt8(idx, val);

}

#end