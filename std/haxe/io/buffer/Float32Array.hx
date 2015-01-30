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
abstract Float32Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Float32 );

    public static inline function fromArray( array:Array<Float> )
        return new ArrayBufferView( null, Float32 ).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null )
        return new ArrayBufferView( null, Float32 ).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView )
        return new ArrayBufferView( null, Float32 ).initTypedArray( view );

//Public API

        //this is required to determine the underlying type in ArrayBufferView
    public function subarray( begin:Int, end:Null<Int> = null) : Float32Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;

    @:noCompletion @:arrayAccess
    public inline function __get(idx:Int) : Float return this.getFloat32(idx);
    @:noCompletion @:arrayAccess
    public inline function __set(idx:Int, val:Float) : Float return this.setFloat32(idx, val);

} //UInt8Array
