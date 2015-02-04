package typedarray;

#if js

    @:forward
    @:arrayAccess
    abstract Int16Array(js.html.Int16Array)
        from js.html.Int16Array
        to js.html.Int16Array {

        public inline function new(
            ?elements:Int,
            ?array:Array<Float>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {
            if(elements != null) {
                this = new js.html.Int16Array( elements );
            } else if(array != null) {
                this = new js.html.Int16Array( untyped array );
            } else if(view != null) {
                this = new js.html.Int16Array( untyped view );
            } else if(buffer != null) {
                len = (len == null) ? untyped __js__('undefined') : len;
                this = new js.html.Int16Array( buffer, byteoffset, len );
            } else {
                this = null;
            }
        }

        @:arrayAccess inline function __set(idx:Int, val:UInt) return this[idx] = val;
        @:arrayAccess inline function __get(idx:Int) : UInt return this[idx];

    }

#else

    import typedarray.ArrayBufferView;
    import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Int16Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 2;

    public var length (get, never):Int;

        public inline function new(
            ?elements:Int,
            ?array:Array<Float>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {

            if(elements != null) {
                this = new ArrayBufferView( elements, Int16 );
            } else if(array != null) {
                this = new ArrayBufferView(0, Int16).initArray(array);
            } else if(view != null) {
                this = new ArrayBufferView(0, Int16).initTypedArray(view);
            } else if(buffer != null) {
                this = new ArrayBufferView(0, Int16).initBuffer(buffer, byteoffset, len);
            } else {
                throw "Invalid constructor arguments for Int16Array";
            }
        }

//Public API

        //still busy with this
    public inline function subarray( begin:Int, end:Null<Int> = null) : Int16Array return this.subarray(begin, end);

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) {
        return ArrayBufferIO.getInt16(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT));
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Int) {
        return ArrayBufferIO.setInt16(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);
    }

}

#end //!js
