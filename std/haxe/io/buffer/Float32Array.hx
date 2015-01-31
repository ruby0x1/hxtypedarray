package haxe.io.buffer;

#if js

@:forward()
@:arrayAccess
abstract Float32Array(js.html.Float32Array) from js.html.Float32Array to js.html.Float32Array {

    public inline function new( elements:Int ) {
        this = new js.html.Float32Array(elements);
    }

    public static inline function fromArray( array:Array<Float> ) : Float32Array {
        return new js.html.Float32Array( cast array );
    }

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Float32Array {
        return new js.html.Float32Array( buffer, byteOffset, count );
    }

    public static inline function fromTypedArray( view:js.html.ArrayBufferView ) : Float32Array {
        return new js.html.Float32Array( cast view );
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
abstract Float32Array(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public static var BYTES_PER_ELEMENT : Int = 4;

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Float32 );

    public static inline function fromArray( array:Array<Float> ) : Float32Array
        return new Float32Array(0).initArray(array);

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Float32Array
        return new Float32Array(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : Float32Array
        return new Float32Array(0).initTypedArray( view );

//Public API

        //still busy with this
    public function subarray( begin:Int, end:Null<Int> = null) : Float32Array return this.subarray(begin, end);

//Internal

    function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) : Float
        return ArrayBufferIO.getFloat32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT) );

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:Float) : Float
        return ArrayBufferIO.setFloat32(this.buffer, this.byteOffset+(idx*BYTES_PER_ELEMENT), val);

}

#end