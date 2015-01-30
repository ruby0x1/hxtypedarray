package haxe.io.buffer;

#if !js

class ArrayBufferViewIO {

    public static function copyFromArray( view:ArrayBufferView, array:Array<Float>, ?offset : Int = 0 ) {

        var len = array.length;
        var i = 0, idx = 0;

        switch(view.type) {
            case Int8:
                while(i<len) {
                    setInt8(view, offset+i, Std.int(array[i])); ++i;
                }
            case Int16:
                while(i<len) {
                    setInt16(view, offset+i, Std.int(array[i])); ++i;
                }
            case Int32:
                while(i<len) {
                    setInt32(view, offset+i, Std.int(array[i])); ++i;
                }
            case UInt8:
                while(i<len) {
                    setUInt8(view, offset+i, Std.int(array[i])); ++i;
                }
            case UInt16:
                while(i<len) {
                    setUInt16(view, offset+i, Std.int(array[i])); ++i;
                }
            case UInt32:
                while(i<len) {
                    setUInt32(view, offset+i, Std.int(array[i])); ++i;
                }
            case UInt8Clamped:
                while(i<len) {
                    setUInt8(view, offset+i, _clamp(array[i])); ++i;
                }
            case Float32:
                while(i<len) {
                    setFloat32(view,offset+i,array[i]); ++i;
                }
            case None: throw Error.Custom("subarray on a blank ArrayBufferView");
        } //switch

    }

    public static inline function getInt8( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx;

        #if cpp
            return untyped __global__.__hxcpp_memory_get_byte(view.buffer.getData(), pos + view.byteOffset);
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readByte();
        #end

    }

    public static inline function setInt8( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx;

        #if cpp
            untyped __global__.__hxcpp_memory_set_byte(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeByte(value);
        #end

        return value;

    }

    public static inline function getUInt8( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx;

        #if cpp
            return untyped __global__.__hxcpp_memory_get_byte(view.buffer.getData(), pos + view.byteOffset) & 0xff;
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readUnsignedByte();
        #end

    }

    public static inline function setUInt8Clamped( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        return setUInt8(view, idx, _clamp(value));

    }

    public static inline function setUInt8( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx;

        #if cpp
            untyped __global__.__hxcpp_memory_set_byte(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeByte(value);
        #end

        return value;

    }

    public static inline function getInt16( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx << 1;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_i16(view.buffer.getData(), pos + view.byteOffset);
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readShort();
        #end

    }

    public static inline function setInt16( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx << 1;

        #if cpp
            untyped __global__.__hxcpp_memory_set_i16(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeShort(Std.int(value));
        #end

        return value;

    }

    public static inline function getUInt16( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx << 1;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_ui16(view.buffer.getData(), pos + view.byteOffset) & 0xffff;
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readUnsignedShort();
        #end

    }

    public static inline function setUInt16( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx << 1;

        #if cpp
            untyped __global__.__hxcpp_memory_set_ui16(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeShort(Std.int(value));
        #end

        return value;

    }

    public static inline function getInt32( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_i32(view.buffer.getData(), pos + view.byteOffset);
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readInt();
        #end

    }

    public static inline function setInt32( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_i32(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeInt(Std.int(value));
        #end

        return value;

    }

    public static inline function getUInt32( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_ui32(view.buffer.getData(), pos + view.byteOffset);
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readUnsignedInt();
        #end

    }

    public static inline function setUInt32( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_ui32(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            buffer.position = pos + view.byteOffset;
            buffer.writeUnsignedInt(Std.int(value));
        #end

        return value;

    }

    public static inline function getFloat32( view:ArrayBufferView, idx:Int ) : Float {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_float(view.buffer.getData(), pos + view.byteOffset);
        #else
            view.buffer.position = pos + view.byteOffset;
            return view.buffer.readFloat();
        #end

    }

    public static inline function setFloat32( view:ArrayBufferView, idx:Int, value:Float ) : Float {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_float(view.buffer.getData(), pos + view.byteOffset, value);
        #else
            view.buffer.position = pos + view.byteOffset;
            view.buffer.writeFloat(value);
        #end

        return value;

    }


//Internal

//:todo: the .blit calls are using elements counts, where getData()
//will always return 1 because its bytes underneath, need a blit with byte values counts
//cpp.NativeArray.blit( view.buffer, offset, cast array, 0, array.length);

        //clamp a Int to a 0-255 UInt8 (for Uint8Clamped array)
   static inline function _clamp(_in:Float) : Int {

        var _out = Std.int(_in);
        _out = _out > 255 ? 255 : _out;
        return _out < 0 ? 0 : _out;

    } //_clamp

} //ArrayBufferViewIO

#end