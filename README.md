## haxe typedarrays

----

This is an near-full es6 compatible implementation of the [TypedArrays](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/TypedArray) specification for binary data views. Differences listed below.

### aims:
- low level (use target specific optimization)
- lightweight (use abstracts where possible etc)
- spec compatible
- haxe 3.1.3 compatible
- supports all targets

###targets:

Compatible targets, passing all tests (on 3.2 current):

- js
- neko
- cpp

Targets compiling, but not passing:
Failing tests are related to negative int values, will be addressed.

- php (13/72 fail)
- python (4/72 fail)
- java (5/72 fail)
- swf (4/72 fail)

Targets not compiling:
- csharp (@.value errors, will investigate)

###todo:

- Lower footprint where possible (BytesData wrapping atm)
- Endianness handling is not fully yet
  - structure is set up for it, some are done, but ArrayBufferIO should implement all cases
  - unit tests for endianness correctness and usage
  - defaults to little endian or underlying platform/haxe code
- add unit tests for DataView [examples](https://github.com/inexorabletash/polyfill/blob/master/tests/typedarray_tests.js)
- use haxe.unit for agnostic tests instead of moxha
- throughput performance tests for regression
- Document user facing API according to differences with spec

#### Structure:
- All IO operations go through the ArrayBufferIO path only, this allows for platform specific+endian changing  code to be easy to maintain, and not scattered across the rest.
- on JS targets where types are native, those are used instead
- where possible (c++/neko) fast/direct memory access is used

#### Included Types:

- [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer)
  - data store, haxe.io.Bytes abstract
- [ArrayBufferView](https://developer.mozilla.org/en-US/docs/Web/API/ArrayBufferView)
  - lightweight class, handles all underlying types
- ArrayBufferIO
  - encapsulated platform read/write
  - handles endianness and platform specifics
  - can use `using` on ArrayBuffers
- [DataView](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView)
- [Int8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int8Array)
- [Int16Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int16Array)
- [Int32Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Int32Array)
- [UInt8Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/UInt8Array)
- [UInt8ClampedArray](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/UInt8ClampedArray)
- [UInt16Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/UInt16Array)
- [UInt32Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/UInt32Array)
- [Float32Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float32Array)
- [Float64Array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Float64Array)

###Differences with spec

- (will implement in future) Spec allows Type1.set(Type2) and new Type1(Type2), with conversion between bytes
  - [spec for allowance](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-%typedarray%-typedarray), if A != B type, section 22.2.1.2 #17
  - should use FPHelper in future
  - spec for conversion, [get](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-getvaluefrombuffer)/[set](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-setvalueinbuffer)
- ArrayBufferView includes `bytesPerElement` as a local instance variable for code simplification and convenience
- variadic constructors broken down into statics, i.e
  - new(len) || new(buffer, offset, len) || new(array) || new(typedarray)
  - becomes new(len) consistently for all types and super types
  - Float32Array.fromArray/fromTypedArray/fromBuffer

### Contributors

Thanks to the following contributors for their input over time:

- Hugh Sanderson (Original ByteArray, nme code)
- Thomas Hourdel (Original Unit test code from spec)
- Michael Bickel (Code contributions and sparring)
- Joshua Granick (Work on lime versions)
