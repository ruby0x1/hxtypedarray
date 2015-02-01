package typedarray;

import typedarray.ArrayBufferView;
import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Int8Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 1;

    public var length (get, never):Int;

    public inline function new( elements:Int ) {
        this = new ArrayBufferView( elements, Int8 );
    }

    public static inline function fromArray( array:Array<Float> ) : Int8Array {
        return new Int8Array(0).initArray( array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int8Array {
        return new Int8Array(0).initBuffer( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:ArrayBufferView ) : Int8Array {
        return new Int8Array(0).initTypedArray( view );
    }

//Public API

        //still busy with this
    public inline function subarray( begin:Int, end:Null<Int> = null) : Int8Array return this.subarray(begin, end);

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) {
        #if js
        untyped return (untyped this.buffer.b)[(this.byteOffset/BYTES_PER_ELEMENT)+idx];
        #else
        return ArrayBufferIO.getInt8(this.buffer, this.byteOffset+idx);
        #end
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Int) {
        #if js
        untyped return (untyped this.buffer.b)[(this.byteOffset/BYTES_PER_ELEMENT)+idx] = val;
        #else
        return ArrayBufferIO.setInt8(this.buffer, this.byteOffset+idx, val);
        #end
    }

}