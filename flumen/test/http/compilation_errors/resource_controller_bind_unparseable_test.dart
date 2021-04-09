import 'dart:async';
import 'dart:io';

import 'package:flumen/flumen.dart';
import 'package:flumen_runtime/runtime.dart';
import "package:test/test.dart";

void main() {
  test("Cannot bind invalid type to default implementation", () {
    try {
      RuntimeContext.current;
      fail('unreachable');
    } on StateError catch (e) {
      expect(e.toString(),
          "Bad state: Invalid binding 'x' on 'ErrorDefault.get1': Parameter type does not implement static parse method.");
    }
  });
}

class ErrorDefault extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.header("foo") HttpHeaders x) async {
    return Response.ok(null);
  }
}
