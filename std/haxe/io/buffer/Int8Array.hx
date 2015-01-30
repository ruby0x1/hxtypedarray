package haxe.io.buffer;

#if js

typedef Int16Array = js.html.Int8Array;

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;
using haxe.io.buffer.ArrayBufferViewIO;


@:forward()
@:arrayAccess
abstract Int8Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Int8 );

    public static inline function fromArray( array:Array<Float> )
        return new ArrayBufferView( null, Int8 ).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null )
        return new ArrayBufferView( null, Int8 ).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView )
        return new ArrayBufferView( null, Int8 ).initTypedArray( view );

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