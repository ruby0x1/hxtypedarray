package haxe.io.buffer;

/**
    Copyright Sven Bergström 2014
    Created for snow https://github.com/underscorediscovery/snow
    License MIT
**/

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;

using haxe.io.buffer.ArrayBufferViewIO;

@:forward()
@:arrayAccess
abstract UInt8ClampedArray(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, UInt8Clamped );

    public static inline function fromArray( array:Array<Float> )
        return new ArrayBufferView( null, UInt8Clamped ).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null )
        return new ArrayBufferView( null, UInt8Clamped ).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView )
        return new ArrayBufferView( null, UInt8Clamped ).initTypedArray( view );


//Public API

        //this is required to determine the underlying type in ArrayBufferView
    public function subarray( begin:Int, end:Null<Int> = null) : UInt8ClampedArray return this.subarray(begin, end);

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) return this.getUInt8(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:UInt) return this.setUInt8Clamped(idx, val);

} //UInt8ClampedArray