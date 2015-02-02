package typedarray;

import typedarray.ArrayBufferView;
import typedarray.TypedArrayType;

@:forward()
@:arrayAccess
abstract Uint8ClampedArray(ArrayBufferView) from ArrayBufferView to ArrayBufferView {

    public inline static var BYTES_PER_ELEMENT : Int = 1;

    public var length (get, never):Int;

    public inline function new( elements:Int )
        this = new ArrayBufferView( elements, Uint8Clamped );

    public static inline function fromArray( array:Array<Float> ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initArray( array );

    public static inline function fromBuffer( buffer:ArrayBuffer, ? byteOffset:Int = 0, count:Null<Int> = null ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initBuffer( buffer, byteOffset, count );

    public static inline function fromTypedArray( view:ArrayBufferView ) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initTypedArray( view );

//Public API

        //still busy with this
    public inline function subarray( begin:Int, end:Null<Int> = null) : Uint8ClampedArray return this.subarray(begin, end);

//Compatibility

#if js
    @:from static function fromArrayBufferView(a:js.html.ArrayBufferView) {
        switch(untyped a.constructor) {
            case js.html.Uint8Array, js.html.Uint8ClampedArray:
                return new ArrayBufferView(0, Uint8Clamped).initTypedArray(untyped a);
            case _: return throw "unimplemented";
        }
    }
    @:from static function fromUint8Array(a:Uint8Array)
        return new Uint8Array(0).initTypedArray(untyped a);
    @:from static function fromUint8ClampedArray(a:Uint8ClampedArray) : Uint8ClampedArray
        return new Uint8ClampedArray(0).initTypedArray(untyped a);

    @:to function toArrayBufferView(): js.html.ArrayBufferView
        return untyped this.buffer.b;
    @:to function toUint8ClampedArray(): js.html.Uint8ClampedArray
        return untyped this.buffer.b;
#end

//Internal

    inline function get_length() return this.length;


    @:noCompletion
    @:arrayAccess
    public inline function __get(idx:Int) {
        #if js
        untyped return (untyped this.buffer.b)[(this.byteOffset/BYTES_PER_ELEMENT)+idx];
        #else
        return ArrayBufferIO.getUint8(this.buffer, this.byteOffset+idx);
        #end
    }

    @:noCompletion
    @:arrayAccess
    public inline function __set(idx:Int, val:UInt) {
        #if js
        untyped return (untyped this.buffer.b)[(this.byteOffset/BYTES_PER_ELEMENT)+idx] = val;
        #else
        return ArrayBufferIO.setUint8Clamped(this.buffer, this.byteOffset+idx, val);
        #end
    }


}

