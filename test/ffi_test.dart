import 'dart:ffi' as ffi;
import 'dart:ffi';

import 'package:flutter_rust_ffi_example/rust_bindings.dart';
import 'package:flutter_test/flutter_test.dart';

typedef HelloWorldRustFunction = ffi.Void Function();
typedef HelloWorldFunction = void Function();

void nativeCallbackSample() {
  print("Hello world");
}

void main() {
  test("dart_hello_world", () {
    print("Hello world");
  });

  test("rust_hello_world", () {
    var library =
        DynamicLibrary.open("./target/debug/libflutter_rust_ffi_example.dylib");
    var fnHandle =
        library.lookupFunction<HelloWorldRustFunction, HelloWorldFunction>(
            "hello_world");
    fnHandle();
  });

  test("generated_hello_world", () {
    var dynamicLibrary =
        DynamicLibrary.open("./target/debug/libflutter_rust_ffi_example.dylib");
    var rustBinding = RustBinding(dynamicLibrary);
    rustBinding.hello_world();
  });
}
