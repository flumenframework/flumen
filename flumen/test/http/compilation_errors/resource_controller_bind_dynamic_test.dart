import 'dart:async';

import 'package:flumen/flumen.dart';
import 'package:flumen_runtime/runtime.dart';
import "package:test/test.dart";

void main() {
  test("Cannot bind dynamic to header", () {
    try {
      RuntimeContext.current;
      fail('unreachable');
    } on StateError catch (e) {
      expect(e.toString(),
        contains("Invalid binding 'x' on 'ErrorDynamic.get1'"));
    }
  });
}

class ErrorDynamic extends ResourceController {
  @Operation.get()
  Future<Response> get1(@Bind.header("foo") dynamic x) async {
    return Response.ok(null);
  }
}