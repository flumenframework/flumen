import 'package:wildfire/wildfire.dart';
import 'package:flumen_test/flumen_test.dart';

export 'package:wildfire/wildfire.dart';
export 'package:flumen_test/flumen_test.dart';
export 'package:test/test.dart';
export 'package:flumen/flumen.dart';

/// A testing harness for wildfire.
///
/// A harness for testing an flumen application. Example test file:
///
///         void main() {
///           Harness harness = Harness()..install();
///
///           test("GET /path returns 200", () async {
///             final response = await harness.agent.get("/path");
///             expectResponse(response, 200);
///           });
///         }
///
class Harness extends TestHarness<WildfireChannel> {
  @override
  Future onSetUp() async {

  }

  @override
  Future onTearDown() async {

  }
}
