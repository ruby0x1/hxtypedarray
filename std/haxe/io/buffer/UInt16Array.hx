package haxe.io.buffer;

#if js

@:forward()
@:arrayAccess
abstract UInt16Array(js.html.Uint16Array) from js.html.Uint16Array to js.html.Uint16Array {

    public inline function new( elements:Int ) {
        this = new js.html.Uint16Array(elements);
    }

    public static inline function fromArray( array:Array<Float> ) : UInt16Array {
        return new js.html.Uint16Array( cast array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : UInt16Array {
        return new js.html.Uint16Array( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:js.html.ArrayBufferView ) : UInt16Array {
        return new js.html.Uint16Array( cast view );
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
abstract UInt16Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public static var BYTES_PER_ELEMENT : Int = 2;

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, UInt16 );

    public static inline function fromArray( array:Array<Float> ) : UInt16Array
        return new UInt16Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : UInt16Array
        return new UInt16Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : UInt16Array
        return new UInt16Array(0).initTypedArray( view );


//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : UInt16Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int)
        return ArrayBufferIO.getUInt16(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT));

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:UInt)
        return ArrayBufferIO.setUInt16(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);

}

#end