package haxe.io.buffer;

#if js

typedef UInt16Array = js.html.Uint16Array;

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;
using haxe.io.buffer.ArrayBufferViewIO;


@:forward()
@:arrayAccess
abstract UInt16Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, UInt16 );

    public static inline function fromArray( array:Array<Float> ) : UInt16Array
        return new UInt16Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : UInt16Array
        return new UInt16Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : UInt16Array
        return new UInt16Array(0).initTypedArray( view );


//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : UInt16Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) return this.getUInt16(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:UInt) return this.setUInt16(idx, val);

}

#end