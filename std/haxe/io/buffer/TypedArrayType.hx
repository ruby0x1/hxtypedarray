package haxe.io.buffer;

@:enum
abstract TypedArrayType(Int) from Int to Int {
    var None            = 0;
    var Int8            = 1;
    var Int16           = 2;
    var Int32           = 3;
    var UInt8           = 4;
    var UInt8Clamped    = 5;
    var UInt16          = 6;
    var UInt32          = 7;
    var Float32         = 8;
    var Float64         = 9;
}

