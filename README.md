# Haxe-TypedArray

#### Structure:
- All IO operations go through the ArrayBufferIO path only, for platform specific+endian isolated code to be easy to maintain, and not scattered across the code. 

#### Included Types:

- [ArrayBuffer](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/ArrayBuffer) 
  - data store, haxe.io.Bytes abstract
- [ArrayBufferView](https://developer.mozilla.org/en-US/docs/Web/API/ArrayBufferView) 
  - view into buffer, lightweight class, requires members
- ArrayBufferIO
  - encapsulated platform intrinsics+endianness, 
  - can use `using` on ArrayBuffers
  - called static direct in this code
- [DataView](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DataView) 
  - R/W ops on ArrayBuffer, handles endianness etc
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

Aside from todo below:

- (will implement) Spec allows Float32ArrayInst.set(Int8ArrayInstance) and similar with conversion
  - [spec for allowance](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-%typedarray%-typedarray), if A != B type, section 22.2.1.2 #17 , [example implementation in js polyfill](https://github.com/inexorabletash/polyfill/blob/master/typedarray.js#L734)
  - spec for conversion, [get](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-getvaluefrombuffer)/[set](http://people.mozilla.org/~jorendorff/es6-draft.html#sec-setvalueinbuffer) 
- ArrayBufferView includes bytesPerElement as a local instance variable for code simplification and convenience of not switch(type) where it is used
- variadic constructors broken down into statics, i.e
  - new(len) || new(buffer, offset, len) || new(array) || new(typedarray)
  - becomes new(len) consistently for all types and super types
  - Float32Array.fromArray/fromTypedArray/fromBuffer

###done:

- cpp/neko fast accesses where known / applicable
- cpp/neko all unit tests passing, compiles against js/py etc but will test after the feature complete

###todo:

- conversion notes above in Differences
- All data is in bigEndian by default, by spec (see next point)
- DataView has endianness flags that need to be handled in ArrayBufferIO.

Wondering:

- Error class has OutsideBounds for mapping to RangeError
  - Bad idea to add reason string in #debug? This would be super useful, has saved me hours before
  - Error.custom is used a few places, to account for non bounds errors

###todo:external

- Finish Unit tests for DataView [examples](https://github.com/inexorabletash/polyfill/blob/master/tests/typedarray_tests.js)
- Basic performance tests for regression, all types
- port tests to unitstd type and test in haxe folder
- Document user facing API functions and class types according to spec
- peer review
- PR
