# flutter_rust_ffi_example
Flutter + Rust FFI notes.

## Approaches
### Dynamic Library lookup
On the rust side declare a C function, configure the crate to output `cdylib`
```rust
#[no_mangle]
pub extern "C" fn hello_world() {
    println!("Hello world")
}
```

On dart side open the crate and function:
```dart
import 'dart:ffi' as ffi;
import 'dart:ffi';

void main() {
  var library = DynamicLibrary.open("./target/debug/my.dylib");
  var fnHandle = library.lookupFunction<ffi.Void Function(), void Function()>("hello_world");
  fnHandle();
}
```

### Generating bindings
#### Rust side
* Set-up [cbindgen](https://github.com/eqrion/cbindgen).
* Do the above
* You'll now have a generated `C` header file

#### Dart side
* Set-up [ffigen](https://github.com/dart-lang/ffigen)

#### Callbacks
* See [allo-isolate](https://github.com/sunshine-protocol/allo-isolate)
* Callbacks won't work, one needs to use ports
* Structs won't work, need to pass pointer
  * Pointer doesn't _have_ to be opaque, but it'll not be particularly useful
  * This is because we can pass a C repr struct & have Dart code that represents it, but type conversions will be
    manual on Dart's side
  * Passing an opaque pointer can be passed back into Rust & have methods called on it

### Copying message passing
* One alternative to passing pointers through ports is to pass serialized messages
* There's a problem in that there's a serialization step
* Generally it should be much more concise to write
* The overhead might not be meaningful for infrequent messaging