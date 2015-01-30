package haxe.io.buffer;

using haxe.io.buffer.ArrayBufferViewIO;
import haxe.io.buffer.TypedArrayType;

/**
    Copyright Sven Bergström 2014
    Created for snow https://github.com/underscorediscovery/snow
    License MIT
**/

class ArrayBufferView {

    public var type = TypedArrayType.None;
    public var BYTES_PER_ELEMENT (default,null): Int = 1;
    public var buffer:ArrayBuffer;
    public var byteOffset:Int;
    public var length:Int;


    @:allow(haxe.io.buffer)
    inline function new( ?elements:Null<Int> = null, in_type:TypedArrayType) {

        type = in_type;

        BYTES_PER_ELEMENT =
            switch(type) {
                case Int8:          1;
                case UInt8:         1;
                case UInt8Clamped:  1;
                case Int16:         2;
                case UInt16:        2;
                case Int32:         4;
                case UInt32:        4;
                case Float32:       4;
                case _: 1;
            };


            //other constructor types use
            //the static init calls below
        if(elements != null) {

            if(elements < 0) elements = 0;
            //:note:spec: also has, platform specific max int?
            //elements = min(elements,maxint);

            byteOffset = 0;
            length = elements;
            buffer = new ArrayBuffer( toByteLength(elements) );

        }

    } //new

//Constructor helpers

    @:allow(haxe.io.buffer)
    inline function initTypedArray( view:ArrayBufferView ) {

        var viewByteLength = view.buffer.length;
        var srcByteOffset = view.byteOffset;
        var srcLength = viewByteLength - srcByteOffset;
        var cloneLength = srcLength - srcByteOffset;

            //new storage
        buffer = new ArrayBuffer(cloneLength);
        byteOffset = 0;
        length = view.length;

            //same species, so just blit the data
            //in other words, it shares the same bytes per element etc
        if(view.type == type) {

            buffer.blit( 0, view.buffer, srcByteOffset, cloneLength );

        } else {

            throw "UnimplementedError: data type conversion from TypedArray is pending";

        } //type != type

        return this;

    } //(typedArray)

    @:allow(haxe.io.buffer)
    inline function initBuffer( in_buffer:ArrayBuffer, ?in_byteOffset:Int = 0, len:Null<Int> = null ) {

        if(in_byteOffset < 0) throw Error.OutsideBounds;
        if(in_byteOffset % BYTES_PER_ELEMENT != 0) throw Error.OutsideBounds;

        var bufferByteLength = in_buffer.length;
        var newByteLength = bufferByteLength;

        if( len == null ) {

            newByteLength = bufferByteLength - in_byteOffset;

            if(bufferByteLength % BYTES_PER_ELEMENT != 0) throw Error.OutsideBounds;
            if(newByteLength < 0) throw Error.OutsideBounds;

        } else {

            newByteLength = len * BYTES_PER_ELEMENT;

            var newRange = in_byteOffset + newByteLength;
            if( newRange > bufferByteLength ) throw Error.OutsideBounds;

        }

        buffer = in_buffer;
        byteOffset = in_byteOffset;
        length = Std.int(newByteLength / BYTES_PER_ELEMENT);

        return this;

    } //(buffer [, byteOffset [, length]])


    @:allow(haxe.io.buffer)
    inline function initArray<T>( array:Array<T> ) {

        buffer = new ArrayBuffer( toByteLength(array.length) );
        byteOffset = 0;
        length = array.length;

        copyFromArray(cast array);

        return this;

    }


//Public shared APIs

    public inline function set( view:ArrayBufferView, offset:Int = 0  ) : Void {
        buffer.blit( toByteLength(offset), view.buffer, view.byteOffset, view.buffer.length );
    }

    @:generic
    public inline function setFromArray<T>( ?array:Array<T>, offset:Int = 0 ) {
        copyFromArray(cast array, offset);
    }


//Internal TypedArray api

    @:generic
    @:allow(haxe.io.buffer)
    inline function subarray<T_subarray>( begin:Int, end:Null<Int> = null ) : T_subarray {

        if (end == null) end == length;
        var len = end - begin;
        var byte_offset = toByteLength(begin);

        var view : ArrayBufferView =
            switch(type) {
                case Int8:
                    Int8Array.fromBuffer(buffer, byte_offset, len);
                case Int16:
                    Int16Array.fromBuffer(buffer, byte_offset, len);
                case Int32:
                    Int32Array.fromBuffer(buffer, byte_offset, len);
                case UInt8:
                    UInt8Array.fromBuffer(buffer, byte_offset, len);
                case UInt16:
                    UInt16Array.fromBuffer(buffer, byte_offset, len);
                case UInt32:
                    UInt32Array.fromBuffer(buffer, byte_offset, len);
                case Float32:
                    Float32Array.fromBuffer(buffer, byte_offset, len);
                case UInt8Clamped:
                    UInt8ClampedArray.fromBuffer(buffer, byte_offset, len);

                case None: throw Error.Custom("subarray on a blank ArrayBufferView");
            }

        return cast view;

    }

    inline function toByteLength( elemCount:Int ) : Int {

        return elemCount * BYTES_PER_ELEMENT;

    }

} //ArrayBufferView
