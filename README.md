# Haxe-TypedArray

###done:

- cpp/neko fast accesses where known / applicable
- cpp/neko all unit tests passing, compiles against js/py etc but will test after the feature complete

###todo:

- All data is in bigEndian assumption, by spec (see below)
- DataView has endianness flags, ArrayBufferIO will handle. this isolates platform specific intrinsics etc, as well as handle endianness in one location, not spread out into the code.

###todo:external

- Finish Unit tests for DataView
- Basic performance tests for regression, all types
- port tests to unitstd type and test in haxe folder
- Document user facing API functions and class types according to spec
- peer review
- PR
