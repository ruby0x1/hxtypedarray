package haxe.io.buffer;

#if js

typedef UInt8Array = js.html.Uint8Array;

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;
using haxe.io.buffer.ArrayBufferViewIO;


@:forward()
@:arrayAccess
abstract UInt8Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, UInt8 );

    public static inline function fromArray( array:Array<Float> ) : UInt8Array
        return new UInt8Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : UInt8Array
        return new UInt8Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : UInt8Array
        return new UInt8Array(0).initTypedArray( view );


//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : UInt8Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) return this.getUInt8(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:UInt) return this.setUInt8(idx, val);

}

#end