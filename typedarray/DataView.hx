package typedarray;

import typedarray.ArrayBuffer;

class DataView {

    public var buffer:ArrayBuffer;
    public var byteLength:Int;
    public var byteOffset:Int;

    #if js
    var dataView : js.html.DataView;
    #end

    #if !no_typedarray_inline inline #end
    public function new( buffer:ArrayBuffer, byteOffset:Int = 0, byteLength:Null<Int> = null ) {

        #if js
        dataView = new js.html.DataView(untyped buffer.b.buffer, byteOffset, byteLength);
        #end

        if(byteOffset < 0) throw TAError.RangeError;

        var bufferByteLength = buffer.length;
        var viewByteLength = bufferByteLength - byteOffset;

        if(byteOffset > bufferByteLength) throw TAError.RangeError;

        if(byteLength != null) {

            if(byteLength < 0) throw TAError.RangeError;

            viewByteLength = byteLength;

            if(byteOffset + viewByteLength > bufferByteLength) throw TAError.RangeError;

        }

        this.buffer = buffer;
        this.byteLength = viewByteLength;
        this.byteOffset = byteOffset;

    }


    #if !no_typedarray_inline inline #end
    public function getInt8( byteOffset:Int ) : Int {

        #if js
        return dataView.getInt8(byteOffset);
        #else
        return ArrayBufferIO.getInt8(buffer, byteOffset);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getInt16( byteOffset:Int, ?littleEndian:Bool = true ) : Int {

        #if js
        return dataView.getInt16(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getInt16(buffer, byteOffset, littleEndian);
        #end
    }

    #if !no_typedarray_inline inline #end
    public function getInt32( byteOffset:Int, ?littleEndian:Bool = true ) : Int {

        #if js
        return dataView.getInt32(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getInt32(buffer, byteOffset, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getUint8( byteOffset:Int ) : UInt {

        #if js
        return dataView.getUint8(byteOffset);
        #else
        return ArrayBufferIO.getUint8(buffer, byteOffset);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getUint16( byteOffset:Int, ?littleEndian:Bool = true ) : UInt {

        #if js
        return dataView.getUint16(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getUint16(buffer, byteOffset, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getUint32( byteOffset:Int, ?littleEndian:Bool = true ) : UInt {

        #if js
        return dataView.getUint32(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getUint32(buffer, byteOffset, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getFloat32( byteOffset:Int, ?littleEndian:Bool = true ) : Float {

        #if js
        return dataView.getFloat32(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getFloat32(buffer, byteOffset, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function getFloat64( byteOffset:Int, ?littleEndian:Bool = true ) : Float {

        #if js
        return dataView.getFloat64(byteOffset, littleEndian);
        #else
        return ArrayBufferIO.getFloat64(buffer, byteOffset, littleEndian);
        #end

    }




    #if !no_typedarray_inline inline #end
    public function setInt8( byteOffset:Int, value:Int ) {

        #if js
        dataView.setInt8(byteOffset, value);
        #else
        ArrayBufferIO.setInt8(buffer, byteOffset, value);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setInt16( byteOffset:Int, value:Int, ?littleEndian:Bool = true) {

        #if js
        dataView.setInt16(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setInt16(buffer, byteOffset, value, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setInt32( byteOffset:Int, value:Int, ?littleEndian:Bool = true) {

        #if js
        dataView.setInt32(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setInt32(buffer, byteOffset, value, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setUint8( byteOffset:Int, value:UInt ) {

        #if js
        dataView.setUint8(byteOffset, value);
        #else
        ArrayBufferIO.setUint8(buffer, byteOffset, value);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setUint16( byteOffset:Int, value:UInt, ?littleEndian:Bool = true) {

        #if js
        dataView.setUint16(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setUint16(buffer, byteOffset, value, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setUint32( byteOffset:Int, value:UInt, ?littleEndian:Bool = true) {

        #if js
        dataView.setUint32(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setUint32(buffer, byteOffset, value, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setFloat32( byteOffset:Int, value:Float, ?littleEndian:Bool = true) {

        #if js
        dataView.setFloat32(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setFloat32(buffer, byteOffset, value, littleEndian);
        #end

    }

    #if !no_typedarray_inline inline #end
    public function setFloat64( byteOffset:Int, value:Float, ?littleEndian:Bool = true) {

        #if js
        dataView.setFloat64(byteOffset, value, littleEndian);
        #else
        ArrayBufferIO.setFloat64(buffer, byteOffset, value, littleEndian);
        #end

    }


}