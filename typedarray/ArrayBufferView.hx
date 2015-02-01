package typedarray;

import typedarray.TypedArrayType;

class ArrayBufferView {

    public var type = TypedArrayType.None;
    public var bytesPerElement (default,null) : Int = 0;
    public var buffer:ArrayBuffer;
    public var byteOffset:Int;
    public var byteLength:Int;
    public var length:Int;

    @:allow(typedarray)
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
            byteLength = toByteLength(elements);
            #if js
            buffer = initJSArray( untyped elements );
            #else
            buffer = new ArrayBuffer( byteLength );
            #end
            length = elements;

        }

    } //new

//Constructor helpers

    @:allow(typedarray)
    #if !no_typedarray_inline inline #end
    function initTypedArray( view:ArrayBufferView ) {

        var srcData = view.buffer;
        var srcLength = view.length;
        var srcByteOffset = view.byteOffset;
        var srcElementSize = view.bytesPerElement;
        var elementSize = bytesPerElement;

        #if js
            buffer = initJSArray(untyped view.buffer.b);
        #else
                //same species, so just blit the data
                //in other words, it shares the same bytes per element etc
            if(view.type == type) {
                cloneBuffer(srcData, srcByteOffset);
            } else {
                //see :note:1: below use FPHelper!
                throw ("unimplemented");
            }
        #end

        byteLength = bytesPerElement * srcLength;
        byteOffset = 0;
        length = srcLength;

        return this;

    } //(typedArray)

    @:allow(typedarray)
    #if !no_typedarray_inline inline #end
    function initBuffer( in_buffer:ArrayBuffer, ?in_byteOffset:Int = 0, len:Null<Int> = null ) {

        if(in_byteOffset < 0) throw TAError.RangeError;
        if(in_byteOffset % bytesPerElement != 0) throw TAError.RangeError;

        #if js
        var bufferByteLength = untyped in_buffer.b.byteLength;
        #else
        var bufferByteLength = in_buffer.length;
        #end

        var elementSize = bytesPerElement;
        var newByteLength = bufferByteLength;

        if( len == null ) {

            newByteLength = bufferByteLength - in_byteOffset;

            if(bufferByteLength % bytesPerElement != 0) throw TAError.RangeError;
            if(newByteLength < 0) throw TAError.RangeError;

        } else {

            newByteLength = len * bytesPerElement;

            var newRange = in_byteOffset + newByteLength;
            if( newRange > bufferByteLength ) throw TAError.RangeError;

        }

        buffer = in_buffer;
        byteOffset = in_byteOffset;
        byteLength = newByteLength;
        length = Std.int(newByteLength / bytesPerElement);

        return this;

    } //(buffer [, byteOffset [, length]])


    @:allow(typedarray)
    #if !no_typedarray_inline inline #end
    function initArray<T>( array:Array<T> ) {

        byteOffset = 0;
        length = array.length;
        byteLength = toByteLength(length);

        #if js
        buffer = initJSArray(untyped array);
        #else
        buffer = new ArrayBuffer( byteLength );
        copyFromArray(cast array);
        #end

        return this;

    }


//Public shared APIs
    #if !no_typedarray_inline inline #end
    public function set( view:ArrayBufferView, offset:Int = 0 ) : Void {

        #if js
        untyped buffer.b.set(cast view.buffer.b,offset);
        #else
        buffer.blit( toByteLength(offset), view.buffer, view.byteOffset, view.buffer.length );
        #end

    }

    @:generic
    #if !no_typedarray_inline inline #end
    public function setFromArray<T>( ?array:Array<T>, offset:Int = 0 ) {

        #if js
        untyped buffer.b.set(cast array,offset);
        #else
        copyFromArray(cast array, offset);
        #end

    }


//Internal TypedArray api

    //mimicks the 4 return constructor types
    #if js
    inline function initJSArray(a0,?a1,?a2) {

        var data = switch(type) {
            case Int8:
                untyped new js.html.Int8Array(a0,a1,a2);
            case Int16:
                untyped new js.html.Int16Array(a0,a1,a2);
            case Int32:
                untyped new js.html.Int32Array(a0,a1,a2);
            case Uint8:
                untyped new js.html.Uint8Array(a0,a1,a2);
            case Uint8Clamped:
                untyped new js.html.Uint8ClampedArray(a0,a1,a2);
            case Uint16:
                untyped new js.html.Uint16Array(a0,a1,a2);
            case Uint32:
                untyped new js.html.Uint32Array(a0,a1,a2);
            case Float32:
                untyped new js.html.Float32Array(a0,a1,a2);
            case Float64:
                untyped new js.html.Float64Array(a0,a1,a2);
            case None:
                throw "operation on a base type ArrayBuffer";
        }

        return haxe.io.Bytes.ofData( cast data );
    }
    #end

    #if !no_typedarray_inline inline #end
    function cloneBuffer(src:ArrayBuffer, srcByteOffset:Int = 0) {

        var srcLength = src.length;
        var cloneLength = srcLength - srcByteOffset;

        buffer = new ArrayBuffer( cloneLength );
        buffer.blit( 0, src, srcByteOffset, cloneLength );

    }


    @:generic
    @:allow(typedarray)
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

                case Uint8:
                     Uint8Array.fromBuffer(buffer, byte_offset, len);

                case Uint8Clamped:
                     Uint8ClampedArray.fromBuffer(buffer, byte_offset, len);

                case Uint16:
                     Uint16Array.fromBuffer(buffer, byte_offset, len);

                case Uint32:
                     Uint32Array.fromBuffer(buffer, byte_offset, len);

                case Float32:
                     Float32Array.fromBuffer(buffer, byte_offset, len);

                case Float64:
                     Float64Array.fromBuffer(buffer, byte_offset, len);

                case None:
                    throw "subarray on a blank ArrayBufferView";
            }

        return cast view;

    }

    #if !no_typedarray_inline inline #end
    function bytesForType( type:TypedArrayType ) : Int {

        return
            switch(type) {

                case Int8:
                     Int8Array.BYTES_PER_ELEMENT;

                case Uint8:
                     Uint8Array.BYTES_PER_ELEMENT;

                case Uint8Clamped:
                     Uint8ClampedArray.BYTES_PER_ELEMENT;

                case Int16:
                     Int16Array.BYTES_PER_ELEMENT;

                case Uint16:
                     Uint16Array.BYTES_PER_ELEMENT;

                case Int32:
                     Int32Array.BYTES_PER_ELEMENT;

                case Uint32:
                     Uint32Array.BYTES_PER_ELEMENT;

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

    #if !no_typedarray_inline #end
    function copyFromArray(array:Array<Float>, ?offset : Int = 0 ) {

        //Ideally, native semantics could be used, like cpp.NativeArray.blit
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
            case Uint8:
                while(i<len) {
                    var pos = (offset+i)*bytesPerElement;
                    ArrayBufferIO.setUint8(buffer,
                        pos, Std.int(array[i]));
                    ++i;
                }
            case Uint16:
                while(i<len) {
                    var pos = (offset+i)*bytesPerElement;
                    ArrayBufferIO.setUint16(buffer,
                        pos, Std.int(array[i]));
                    ++i;
                }
            case Uint32:
                while(i<len) {
                    var pos = (offset+i)*bytesPerElement;
                    ArrayBufferIO.setUint32(buffer,
                        pos, Std.int(array[i]));
                    ++i;
                }
            case Uint8Clamped:
                while(i<len) {
                    var pos = (offset+i)*bytesPerElement;
                    ArrayBufferIO.setUint8Clamped(buffer,
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
                throw "copyFromArray on a base type ArrayBuffer";

        }

    }

} //ArrayBufferView
