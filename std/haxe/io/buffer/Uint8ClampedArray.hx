package haxe.io.buffer;

#if js

@:forward()
@:arrayAccess
abstract Uint8ClampedArray(js.html.Uint8ClampedArray) from js.html.Uint8ClampedArray to js.html.Uint8ClampedArray {

    public inline function new( elements:Int ) {
        this = new js.html.Uint8ClampedArray(elements);
    }

    public static inline function fromArray( array:Array<Float> ) : Uint8ClampedArray {
        return new js.html.Uint8ClampedArray( cast array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Uint8ClampedArray {
        return new js.html.Uint8ClampedArray( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:js.html.ArrayBufferView ) : Uint8ClampedArray {
        return new js.html.Uint8ClampedArray( cast view );
    }

    public function setFromArray( array:Array<Float>, offset : Int = 0 ) {
        this.set(cast array, offset);
    }

}

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;

@:forward()
@:arrayAccess
abstract Uint8ClampedArray(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public static var BYTES_PER_ELEMENT : Int = 1;

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Uint8Clamped );

    public static inline function fromArray( array:Array<Float> ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initTypedArray( view );


//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : Uint8ClampedArray return this.subarray(begin, end);

//Internal

    function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int)
        return ArrayBufferIO.getUInt8(this.buffer, this.byteOffset+idx);

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:UInt)
        return ArrayBufferIO.setUInt8Clamped(this.buffer, this.byteOffset+idx, val);


} //Uint8ClampedArray

#end