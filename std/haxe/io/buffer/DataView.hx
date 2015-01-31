package haxe.io.buffer;

#if js

typedef DataView = js.html.DataView;

#else

import haxe.io.buffer.ArrayBuffer;

class DataView {

    public var buffer:ArrayBuffer;
    public var byteLength:Int;
    public var byteOffset:Int;

    #if !no_typedarray_inline inline #end
    public function new( buffer:ArrayBuffer, byteOffset:Int = 0, byteLength:Null<Int> = null ) {

        if(byteOffset < 0) throw Error.OutsideBounds;

        var bufferByteLength = buffer.length;
        var viewByteLength = bufferByteLength - byteOffset;

        if(byteOffset > bufferByteLength) throw Error.OutsideBounds;

        if(byteLength != null) {

            if(byteLength < 0) throw Error.OutsideBounds;

            viewByteLength = byteLength;

            if(byteOffset + viewByteLength > bufferByteLength) throw Error.OutsideBounds;

        }

        this.buffer = buffer;
        this.byteLength = viewByteLength;
        this.byteOffset = byteOffset;

    }


    #if !no_typedarray_inline inline #end
    public function getInt8( byteOffset:Int ) : Int {

        return ArrayBufferIO.getInt8(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getInt16( byteOffset:Int, ?littleEndian:Bool = false ) : Int {

        return ArrayBufferIO.getInt16(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getInt32( byteOffset:Int, ?littleEndian:Bool = false ) : Int {

        return ArrayBufferIO.getInt32(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getUInt8( byteOffset:Int ) : UInt {

        return ArrayBufferIO.getUInt8(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getUInt16( byteOffset:Int, ?littleEndian:Bool = false ) : UInt {

        return ArrayBufferIO.getUInt16(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getUInt32( byteOffset:Int, ?littleEndian:Bool = false ) : UInt {

        return ArrayBufferIO.getUInt32(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getFloat32( byteOffset:Int, ?littleEndian:Bool = false ) : Float {

        return ArrayBufferIO.getFloat32(buffer, byteOffset);

    }

    #if !no_typedarray_inline inline #end
    public function getFloat64( byteOffset:Int, ?littleEndian:Bool = false ) : Float {

        return ArrayBufferIO.getFloat64(buffer, byteOffset);

    }




    #if !no_typedarray_inline inline #end
    public function setInt8( byteOffset:Int, value:Int ) {

        ArrayBufferIO.setInt8(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setInt16( byteOffset:Int, value:Int, ?littleEndian:Bool = false) {

        ArrayBufferIO.setInt16(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setInt32( byteOffset:Int, value:Int, ?littleEndian:Bool = false) {

        ArrayBufferIO.setInt32(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setUInt8( byteOffset:Int, value:UInt ) {

        ArrayBufferIO.setUInt8(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setUInt16( byteOffset:Int, value:UInt, ?littleEndian:Bool = false) {

        ArrayBufferIO.setUInt16(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setUInt32( byteOffset:Int, value:UInt, ?littleEndian:Bool = false) {

        ArrayBufferIO.setUInt32(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setFloat32( byteOffset:Int, value:Float, ?littleEndian:Bool = false) {

        ArrayBufferIO.setFloat32(buffer, byteOffset, value);

    }

    #if !no_typedarray_inline inline #end
    public function setFloat64( byteOffset:Int, value:Float, ?littleEndian:Bool = false) {

        ArrayBufferIO.setFloat64(buffer, byteOffset, value);

    }


}

#end
