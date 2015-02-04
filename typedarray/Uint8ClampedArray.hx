package typedarray;

#if js

    @:forward
    @:arrayAccess
    abstract Uint8ClampedArray(js.html.Uint8ClampedArray)
        from js.html.Uint8ClampedArray
        to js.html.Uint8ClampedArray {

        @:generic
         public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {
            if(elements != null) {
                this = new js.html.Uint8ClampedArray( elements );
            } else if(array != null) {
                this = new js.html.Uint8ClampedArray( untyped array );
            } else if(view != null) {
                this = new js.html.Uint8ClampedArray( untyped view );
            } else if(buffer != null) {
                len = (len == null) ? untyped __js__('undefined') : len;
                this = new js.html.Uint8ClampedArray( buffer, byteoffset, len );
            } else {
                this = null;
            }
        }

        @:arrayAccess inline function __set(idx:Int, val:UInt) return this[idx] = _clamp(val);
        @:arrayAccess inline function __get(idx:Int) : UInt return this[idx];

        //clamp a Int to a 0-255 Uint8
        static function _clamp(_in:Float) : Int {
            var _out = Std.int(_in);
            _out = _out > 255 ? 255 : _out;
            return _out < 0 ? 0 : _out;
        } //_clamp

    }

#else

    import typedarray.ArrayBufferView;
    import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Uint8ClampedArray(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 1;

    public var length (get, never):Int;

        @:generic
       public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {

            if(elements != null) {
                this = new ArrayBufferView( elements, Uint8Clamped );
            } else if(array != null) {
                this = new ArrayBufferView(0, Uint8Clamped).initArray(array);
            } else if(view != null) {
                this = new ArrayBufferView(0, Uint8Clamped).initTypedArray(view);
            } else if(buffer != null) {
                this = new ArrayBufferView(0, Uint8Clamped).initBuffer(buffer, byteoffset, len);
            } else {
                throw "Invalid constructor arguments for Uint8ClampedArray";
            }
        }

//Public API

        //these enforce the types needed
    public inline function subarray( begin:Int, end:Null<Int> = null) : Uint8ClampedArray return this.subarray(begin, end);

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) {
        return ArrayBufferIO.getUint8(this.buffer, this.byteOffset+idx);
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:UInt) {
        return ArrayBufferIO.setUint8Clamped(this.buffer, this.byteOffset+idx, val);
    }


}

#end //!js
