package typedarray;

#if js

    @:forward
    @:arrayAccess
    abstract Float64Array(js.html.Float64Array)
        from js.html.Float64Array
        to js.html.Float64Array {

        @:generic
        public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {
            if(elements != null) {
                this = new js.html.Float64Array( elements );
            } else if(array != null) {
                this = new js.html.Float64Array( untyped array );
            } else if(view != null) {
                this = new js.html.Float64Array( untyped view );
            } else if(buffer != null) {
                len = (len == null) ? untyped __js__('undefined') : len;
                this = new js.html.Float64Array( buffer, byteoffset, len );
            } else {
                this = null;
            }
        }

        @:arrayAccess inline function __set(idx:Int, val:Float) return this[idx] = val;
        @:arrayAccess inline function __get(idx:Int) : Float return this[idx];

    }

#else

    import typedarray.ArrayBufferView;
    import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Float64Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 8;

    public var length (get, never):Int;

        @:generic
        public inline function new<T>(
            ?elements:Int,
            ?array:Array<T>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {

            if(elements != null) {
                this = new ArrayBufferView( elements, Float64 );
            } else if(array != null) {
                this = new ArrayBufferView(0, Float64).initArray(array);
            } else if(view != null) {
                this = new ArrayBufferView(0, Float64).initTypedArray(view);
            } else if(buffer != null) {
                this = new ArrayBufferView(0, Float64).initBuffer(buffer, byteoffset, len);
            } else {
                throw "Invalid constructor arguments for Float64Array";
            }
        }

//Public API

        //still busy with this
    public inline function subarray( begin:Int, end:Null<Int> = null) : Float64Array return this.subarray(begin, end);

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) : Float {
        return ArrayBufferIO.getFloat64(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT));
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Float) : Float {
        return ArrayBufferIO.setFloat64(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);
    }

}

#end //!js
