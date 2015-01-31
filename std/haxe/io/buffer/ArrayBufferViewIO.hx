package haxe.io.buffer;

#if !js

class ArrayBufferViewIO {

    public static inline function getInt8( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx;

        #if cpp
            return untyped __global__.__hxcpp_memory_get_byte(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            var val:Int = view.buffer.get(view.byteOffset + pos);
            return ((val & 0x80) != 0) ?(val - 0x100) : val;
        #end

    }

    public static inline function setInt8( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx;

        #if cpp
            untyped __global__.__hxcpp_memory_set_byte(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            untyped __dollar__sset(view.buffer.b, view.byteOffset + pos, value & 0xff);
        #end

        return value;

    }

    public static inline function getUInt8( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx;

        #if cpp
            return untyped __global__.__hxcpp_memory_get_byte(view.buffer.getData(), view.byteOffset + pos) & 0xff;
        #elseif neko
            return view.buffer.get( view.byteOffset + pos );
        #end

    }

    public static inline function setUInt8Clamped( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        return setUInt8( view, idx, _clamp(value) );

    }

    public static inline function setUInt8( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx;

        #if cpp
            untyped __global__.__hxcpp_memory_set_byte(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            view.buffer.set( view.byteOffset + pos, value );
        #end

        return value;

    }

    public static  function getInt16( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx << 1;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_i16(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            var b = view.buffer;
            var offsetpos = view.byteOffset + pos;
            var ch1 = b.get(offsetpos    );
            var ch2 = b.get(offsetpos + 1);
            var val = ((ch1 << 8) | ch2);
            return
                ((val & 0x8000) != 0) ?
                    ( val - 0x10000 ) : ( val );
        #end

    }

    public static  function setInt16( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx << 1;
        var offsetpos = view.byteOffset + pos;

        #if cpp
            untyped __global__.__hxcpp_memory_set_i16(view.buffer.getData(), offsetpos, value);
        #elseif neko
            untyped var b = view.buffer.b;
            untyped __dollar__sset(b, offsetpos  , (value >> 8) & 0xff);
            untyped __dollar__sset(b, offsetpos+1, (value     ) & 0xff);
        #end


        return value;

    }

    public static inline function getUInt16( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx << 1;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_ui16(view.buffer.getData(), view.byteOffset + pos) & 0xffff;
        #elseif neko
            var b = view.buffer;
            var offsetpos = view.byteOffset + pos;
            var ch1 = b.get(offsetpos    );
            var ch2 = b.get(offsetpos + 1);
            return (ch1 << 8) | ch2;
        #end

    }

    public static inline function setUInt16( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx << 1;

        #if cpp
            untyped __global__.__hxcpp_memory_set_ui16(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            setInt16(view, idx, value);
        #end

        return value;

    }

    public static inline function getInt32( view:ArrayBufferView, idx:Int ) : Int {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_i32(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            return view.buffer.getI32( view.byteOffset + pos );
        #end

    }

    public static inline function setInt32( view:ArrayBufferView, idx:Int, value:Int ) {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_i32(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            view.buffer.setI32( view.byteOffset + pos, value );
        #end

        return value;

    }

    public static inline function getUInt32( view:ArrayBufferView, idx:Int ) : Null<UInt> {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_ui32(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            return view.buffer.getI32( view.byteOffset + pos );
        #end

    }

    public static inline function setUInt32( view:ArrayBufferView, idx:Int, value:UInt ) : UInt {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_ui32(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            view.buffer.setI32( view.byteOffset + pos, value );
        #end

        return value;

    }

    public static inline function getFloat32( view:ArrayBufferView, idx:Int ) : Float {

        var pos = idx << 2;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_float(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            return view.buffer.getFloat( view.byteOffset + pos );
        #end

    }

    public static inline function setFloat32( view:ArrayBufferView, idx:Int, value:Float ) : Float {

        var pos = idx << 2;

        #if cpp
            untyped __global__.__hxcpp_memory_set_float(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            view.buffer.setFloat( view.byteOffset + pos, value );
        #end

        return value;

    }

    public static inline function getFloat64( view:ArrayBufferView, idx:Int ) : Float {

        var pos = idx << 3;

        #if cpp
            untyped return __global__.__hxcpp_memory_get_double(view.buffer.getData(), view.byteOffset + pos);
        #elseif neko
            return view.buffer.getDouble( view.byteOffset + pos );
        #end

    }

    public static inline function setFloat64( view:ArrayBufferView, idx:Int, value:Float ) : Float {

        var pos = idx << 3;

        #if cpp
            untyped __global__.__hxcpp_memory_set_double(view.buffer.getData(), view.byteOffset + pos, value);
        #elseif neko
            view.buffer.setDouble( view.byteOffset + pos, value );
        #end

        return value;

    }

//Non-spec

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
                    setFloat32(view, offset+i, array[i]); ++i;
                }
            case Float64:
                while(i<len) {
                    setFloat64(view, offset+i, array[i]); ++i;
                }
            case None: throw Error.Custom("copyFromArray on a blank ArrayBufferView");
        } //switch

    }

//Internal

        //clamp a Int to a 0-255 UInt8 (for Uint8Clamped array)
   static inline function _clamp(_in:Float) : Int {

        var _out = Std.int(_in);
        _out = _out > 255 ? 255 : _out;
        return _out < 0 ? 0 : _out;

    } //_clamp

}

#end