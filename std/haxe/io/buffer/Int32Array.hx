package haxe.io.buffer;

#if js

typedef Int16Array = js.html.Int32Array;

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;
using haxe.io.buffer.ArrayBufferViewIO;


@:forward()
@:arrayAccess
abstract Int32Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Int32 );

    public static inline function fromArray( array:Array<Float> ) : Int32Array
        return new Int32Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int32Array
        return new Int32Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : Int32Array
        return new Int32Array(0).initTypedArray( view );

//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : Int32Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) return this.getInt32(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:Int) return this.setInt32(idx, val);

}

#end