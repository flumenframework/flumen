import 'package:flumen_runtime/runtime.dart';
import 'package:flumen_config/flumen_config.dart';
import 'package:test/test.dart';

void main() {
  test("Nested configuration without unnamed constructor is an error at compile time", () {
    try {
      RuntimeContext.current;
      fail('unreachable');
    } on StateError catch (e) {
      expect(e.toString(), contains("Failed to compile 'BadConfig'"));
    }
  });
}

class ParentConfig extends Configuration {
  BadConfig badConfig;
}

class BadConfig extends Configuration {
  BadConfig.from(this.id);
  String id;
}