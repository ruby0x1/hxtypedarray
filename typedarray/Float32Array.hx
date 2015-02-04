package typedarray;

#if js

    typedef Float32Array = js.html.Float32Array;

#else

    import typedarray.ArrayBufferView;
    import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Float32Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 4;

    public var length (get, never):Int;

        public inline function new(
            ?elements:Int,
            ?array:Array<Float>,
            ?view:ArrayBufferView,
            ?buffer:ArrayBuffer, ?byteoffset:Int = 0, ?len:Null<Int>
        ) {

            if(elements != null) {
                this = new ArrayBufferView( elements, Float32 );
            } else if(array != null) {
                this = new ArrayBufferView(0, Float32).initArray(array);
            } else if(view != null) {
                this = new ArrayBufferView(0, Float32).initTypedArray(view);
            } else if(buffer != null) {
                this = new ArrayBufferView(0, Float32).initBuffer(buffer, byteoffset, len);
            } else {
                throw "Invalid constructor arguments for Float32Array";
            }
        }

//Public API

        //still busy with this
    public inline function subarray( begin:Int, end:Null<Int> = null) : Float32Array return this.subarray(begin, end);

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) : Float {
        return ArrayBufferIO.getFloat32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT) );
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Float) : Float {
        return ArrayBufferIO.setFloat32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);
    }

}

#end //!js
