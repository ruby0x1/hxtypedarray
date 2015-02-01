
/**
WIP conversion code from

    :note:1:


    inline function convertTypedArray(from) {

        var into = new ArrayBuffer(byteLength);

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

        return info;
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

            //:todo: should use platform value
        if(isLittleEndian == null) isLittleEndian = true;

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

*/