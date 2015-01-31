package haxe.io.buffer;

#if js

typedef ArrayBufferView = js.html.ArrayBufferView;

#else

import haxe.io.buffer.TypedArrayType;

class ArrayBufferView {

    public var type = TypedArrayType.None;
    public var bytesPerElement (default,null) : Int = 0;
    public var buffer:ArrayBuffer;
    public var byteOffset:Int;
    public var length:Int;

    @:allow(haxe.io.buffer)
    #if !no_typedarray_inline inline #end
    function new( ?elements:Null<Int> = null, in_type:TypedArrayType) {

        type = in_type;
        bytesPerElement = bytesForType(type);

            //other constructor types use
            //the init calls below
        if(elements != null && elements != 0) {

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
    #if !no_typedarray_inline inline #end
    function initTypedArray( view:ArrayBufferView ) {

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
    #if !no_typedarray_inline inline #end
    function initBuffer( in_buffer:ArrayBuffer, ?in_byteOffset:Int = 0, len:Null<Int> = null ) {

        if(in_byteOffset < 0) throw Error.OutsideBounds;
        if(in_byteOffset % bytesPerElement != 0) throw Error.OutsideBounds;

        var elementSize = bytesPerElement;
        var bufferByteLength = in_buffer.length;
        var newByteLength = bufferByteLength;

        if( len == null ) {

            newByteLength = bufferByteLength - in_byteOffset;

            if(bufferByteLength % bytesPerElement != 0) throw Error.OutsideBounds;
            if(newByteLength < 0) throw Error.OutsideBounds;

        } else {

            newByteLength = len * bytesPerElement;

            var newRange = in_byteOffset + newByteLength;
            if( newRange > bufferByteLength ) throw Error.OutsideBounds;

        }

        buffer = in_buffer;
        byteOffset = in_byteOffset;
        length = Std.int(newByteLength / bytesPerElement);

        return this;

    } //(buffer [, byteOffset [, length]])


    @:allow(haxe.io.buffer)
    #if !no_typedarray_inline inline #end
    function initArray<T>( array:Array<T> ) {

        buffer = new ArrayBuffer( toByteLength(array.length) );
        byteOffset = 0;
        length = array.length;

        copyFromArray(cast array);

        return this;

    }


//Public shared APIs
    #if !no_typedarray_inline inline #end
    public function set( view:ArrayBufferView, offset:Int = 0  ) : Void {
        buffer.blit( toByteLength(offset), view.buffer, view.byteOffset, view.buffer.length );
    }

    @:generic
    #if !no_typedarray_inline inline #end
    public function setFromArray<T>( ?array:Array<T>, offset:Int = 0 ) {
        copyFromArray(cast array, offset);
    }


//Internal TypedArray api

    @:generic
    @:allow(haxe.io.buffer)
    #if !no_typedarray_inline inline #end
    function subarray<T_subarray>( begin:Int, end:Null<Int> = null ) : T_subarray {

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

                case UInt8Clamped:
                     UInt8ClampedArray.fromBuffer(buffer, byte_offset, len);

                case UInt16:
                     UInt16Array.fromBuffer(buffer, byte_offset, len);

                case UInt32:
                     UInt32Array.fromBuffer(buffer, byte_offset, len);

                case Float32:
                     Float32Array.fromBuffer(buffer, byte_offset, len);

                case Float64:
                     Float64Array.fromBuffer(buffer, byte_offset, len);

                case None:
                    throw Error.Custom("subarray on a blank ArrayBufferView");
            }

        return cast view;

    }

    #if !no_typedarray_inline inline #end
    function bytesForType( type:TypedArrayType ) : Int {

        return
            switch(type) {

                case Int8:
                     Int8Array.BYTES_PER_ELEMENT;

                case UInt8:
                     UInt8Array.BYTES_PER_ELEMENT;

                case UInt8Clamped:
                     UInt8ClampedArray.BYTES_PER_ELEMENT;

                case Int16:
                     Int16Array.BYTES_PER_ELEMENT;

                case UInt16:
                     UInt16Array.BYTES_PER_ELEMENT;

                case Int32:
                     Int32Array.BYTES_PER_ELEMENT;

                case UInt32:
                     UInt32Array.BYTES_PER_ELEMENT;

                case Float32:
                     Float32Array.BYTES_PER_ELEMENT;

                case Float64:
                     Float64Array.BYTES_PER_ELEMENT;

                case _: 1;
            }

    }

    #if !no_typedarray_inline inline #end
    function toByteLength( elemCount:Int ) : Int {

        return elemCount * bytesPerElement;

    }


//Non-spec

    #if !no_typedarray_inline inline #end
    function copyFromArray(array:Array<Float>, ?offset : Int = 0 ) {

        //Ideally, native semantics could be used for a blit,
        //like cpp.NativeArray.blit

            var i = 0, len = array.length;

            switch(type) {
                case Int8:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setInt8(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Int16:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setInt16(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Int32:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setInt32(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case UInt8:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt8(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case UInt16:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt16(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case UInt32:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt32(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case UInt8Clamped:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt8Clamped(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Float32:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setFloat32(buffer,
                            pos, array[i]);
                        ++i;
                    }
                case Float64:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setFloat64(buffer,
                            pos, array[i]);
                        ++i;
                    }

                case None:
                    throw Error.Custom("copyFromArray on a blank ArrayBuffer");

            }

    }

} //ArrayBufferView

#end