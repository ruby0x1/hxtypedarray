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
    public var byteLength:Int;
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
            byteLength = toByteLength(elements);
            buffer = new ArrayBuffer( byteLength );
            length = elements;

        }

    } //new

//Constructor helpers

    @:allow(haxe.io.buffer)
    #if !no_typedarray_inline inline #end
    function initTypedArray( view:ArrayBufferView ) {

        var srcData = view.buffer;
        var srcLength = view.length;
        var srcByteOffset = view.byteOffset;
        var srcElementSize = view.bytesPerElement;
        var elementSize = bytesPerElement;

        byteLength = bytesPerElement * srcLength;

            //same species, so just blit the data
            //in other words, it shares the same bytes per element etc
        if(view.type == type) {

            cloneBuffer(srcData, srcByteOffset);

        } else {

            buffer = new ArrayBuffer(byteLength);

            var srcByteIndex = srcByteOffset;
            var targetByteIndex = 0;
            var count = srcLength;

            while(count > 0) {

                // var value = getValueFromBuffer( view, srcByteIndex );
                // setValueFromBuffer( buffer, targetByteIndex, value );

                srcByteIndex = srcByteIndex + srcElementSize;
                targetByteIndex = targetByteIndex + elementSize;
                --count;

            }

        }

        byteOffset = 0;
        length = srcLength;

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
        byteLength = newByteLength;
        length = Std.int(newByteLength / bytesPerElement);

        return this;

    } //(buffer [, byteOffset [, length]])


    @:allow(haxe.io.buffer)
    #if !no_typedarray_inline inline #end
    function initArray<T>( array:Array<T> ) {

        byteOffset = 0;
        length = array.length;
        byteLength = toByteLength(length);
        buffer = new ArrayBuffer( byteLength );

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


    #if !no_typedarray_inline inline #end
    function cloneBuffer(src:ArrayBuffer, srcByteOffset:Int = 0) {

        var srcLength = src.length;
        var cloneLength = srcLength - srcByteOffset;

        buffer = new ArrayBuffer( cloneLength );
        buffer.blit( 0, src, srcByteOffset, cloneLength );

    }


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

    static var sU = 'U';
    function getValueFromBuffer( src:ArrayBufferView, byteIndex:Int, ?isLittleEndian:Null<Bool> = null ) : Float {

        if((src.buffer.length - byteIndex) < src.bytesPerElement) throw Error.OutsideBounds;
        if(byteIndex < 0) throw Error.OutsideBounds;

        var block = src.buffer;
        var elementSize = src.bytesPerElement;
        var rawValue : Array<Int> = [];

        var i = 0;
        while( i < elementSize ) {
            rawValue.push( src.buffer.get(byteIndex + i) );
            ++i;
        }

        if(isLittleEndian == null) isLittleEndian = false;

        if(!isLittleEndian) rawValue.reverse();

        if(src.type == Float32) {
            var value = 0.0;
                // Let value be the byte elements of rawValue concatenated and interpreted as a little-endian bit string encoding of an IEEE 754-2008 binary32 value.
                // If value is an IEEE 754-2008 binary32 NaN value, return the NaN Number value.

            return value;
        } else if(src.type == Float64) {
            var value = 0.0;
                // Let value be the byte elements of rawValue concatenated and interpreted as a little-endian bit string encoding of an IEEE 754-2008 binary64 value.
                // If value is an IEEE 754-2008 binary64 NaN value, return the NaN Number value.
            return value;
        } else {

            var intValue = 0;

            if( String.fromCharCode(rawValue[0]) == sU ) {
                // Let intValue be the byte elements of rawValue concatenated
                // and interpreted as a bit string encoding of an unsigned little-endian binary number.

            } else {
                // Let intValue be the byte elements of rawValue concatenated
                // and interpreted as a bit string encoding of a binary
                // little-endian 2’s complement number of bit length elementSize * 8
            }

            return intValue;

        }

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
                case Uint8:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt8(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Uint16:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt16(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Uint32:
                    while(i<len) {
                        var pos = (offset+i)*bytesPerElement;
                        ArrayBufferIO.setUInt32(buffer,
                            pos, Std.int(array[i]));
                        ++i;
                    }
                case Uint8Clamped:
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

private class IEEETools {

    function unpackF64(b)   { return unpackIEEE754(b, 11, 52);  }
    function packF64(v)     { return packIEEE754(v, 11, 52);    }
    function unpackF32(b)   { return unpackIEEE754(b, 8, 23);   }
    function packF32(v)     { return packIEEE754(v, 8, 23);     }

    function packIEEE754(v, ebits:Int, fbits:Int) {

        var bias = (1 << (ebits - 1)) - 1,
            s, f, ln,
            i, bits, str, bytes;
        var e : Float = 0; var s1 : Bool = false;

        inline function roundToEven(n) {
            var w = Math.floor(n), f = n - w;
            if (f < 0.5) return w;
            if (f > 0.5) return w + 1;
            return (w % 2 != 0) ? w + 1 : w;
        }

            // Compute sign, exponent, fraction
        if (v != v) {
            // NaN
            // http://dev.w3.org/2006/webapi/WebIDL/#es-type-mapping
            e = (1 << ebits) - 1; f = Math.pow(2, fbits - 1); s = 0;
        } else if (v == Math.POSITIVE_INFINITY || v == Math.NEGATIVE_INFINITY) {
            e = (1 << ebits) - 1; f = 0; s = (v < 0) ? 1 : 0;
        } else if (v == 0) {
            e = 0; f = 0; s = (1 / v == Math.NEGATIVE_INFINITY) ? 1 : 0;
        } else {
            s1 = v < 0;
            v = Math.abs(v);

            var LN2 = 0.69314718056;
            if (v >= Math.pow(2, 1 - bias)) {
                e = Math.min(Math.floor(Math.log(v) / LN2), 1023);
                f = roundToEven(v / Math.pow(2, e) * Math.pow(2, fbits));
                if (f / Math.pow(2, fbits) >= 2) {
                    e = e + 1;
                    f = 1;
                }
                if (e > bias) {
                    // Overflow
                    e = (1 << ebits) - 1;
                    f = 0;
                } else {
                    // Normalized
                    e = e + bias;
                    f = f - Math.pow(2, fbits);
                }
            } else {
                // Denormalized
                e = 0;
                f = roundToEven(v / Math.pow(2, 1 - bias - fbits));
            }
        }

        // Pack sign, exponent, fraction
        bits = [];

        i = fbits;
        while(i > 0) { bits.push((f % 2 != 0) ? 1 : 0); f = Math.floor(f / 2); --i; }
        i = ebits;
        while(i > 0) { bits.push((e % 2 != 0) ? 1 : 0); e = Math.floor(e / 2); --i; }

        bits.push(s1 ? 1 : 0);
        bits.reverse();
        str = bits.join('');

        // Bits to bytes
        bytes = [];
        while(str.length > 0) {
            //:todo: radix
          // bytes.push(Std.parseInt(str.substr(0, 8), 2));
          str = str.substr(8);
        }
        return bytes;
    }

    function unpackIEEE754(bytes:Array<Int>, ebits:Int, fbits:Int) {
        // Bytes to bits
        var bits = [], i = bytes.length, j = 8,
            b, str, bias, s, e, f;

        while(i > 0) {
            b = bytes[i - 1];
            while(j > 0) {
                bits.push((b % 2 != 0) ? 1 : 0); b = b >> 1;
                --j;
            }
            --i;
        }

        bits.reverse();
        str = bits.join('');

        // Unpack sign, exponent, fraction
        bias = (1 << (ebits - 1)) - 1;

        //:todo: no radix binary
        // s = Std.parseInt(str.substr(0, 1)) ? -1 : 1; //, 2
        // e = Std.parseInt(str.substr(1, 1 + ebits)); //, 2
        // f = Std.parseInt(str.substr(1 + ebits)); //, 2
        e = 0;
        s = 0;
        f = 0;

            // Produce number
        if (e == (1 << ebits) - 1) {
            return f != 0 ? Math.NaN : s * Math.POSITIVE_INFINITY;
        } else if (e > 0) {
            // Normalized
            return s * Math.pow(2, e - bias) * (1 + f / Math.pow(2, fbits));
        } else if (f != 0) {
            // Denormalized
            return s * Math.pow(2, -(bias - 1)) * (f / Math.pow(2, fbits));
        } else {
            return s < 0 ? -0 : 0;
        }

    }

}

#end