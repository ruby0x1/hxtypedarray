package haxe.io.buffer;

#if js

@:forward()
@:arrayAccess
abstract Int16Array(js.html.Int16Array) from js.html.Int16Array to js.html.Int16Array {

    public inline function new( elements:Int ) {
        this = new js.html.Int16Array(elements);
    }

    public static inline function fromArray( array:Array<Float> ) : Int16Array {
        return new js.html.Int16Array( cast array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int16Array {
        return new js.html.Int16Array( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:js.html.ArrayBufferView ) : Int16Array {
        return new js.html.Int16Array( cast view );
    }

    public function setFromArray( array:Array<Float>, offset : Int = 0 ) {
        this.set(cast array, offset);
    }

}

#else

import haxe.io.buffer.ArrayBufferView;
import haxe.io.buffer.TypedArrayType;


@:forward()
@:arrayAccess
abstract Int16Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Int16 );

    public static inline function fromArray( array:Array<Float> ) : Int16Array
        return new Int16Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Int16Array
        return new Int16Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : Int16Array
        return new Int16Array(0).initTypedArray( view );

//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : Int16Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int)
        return ArrayBufferIO.getInt16(this.buffer, this.byteOffset+(idx*this.BYTES_PER_ELEMENT));

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Int)
        return ArrayBufferIO.setInt16(this.buffer, this.byteOffset+(idx*this.BYTES_PER_ELEMENT), val);

}

#end