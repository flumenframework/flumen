import 'package:flumen_test/flumen_test.dart';
import 'package:flumen/flumen.dart';
import 'package:test/test.dart';

void main() {
  final harness = TestHarness<App>()..install();

  test("GET /example returns simple map", () async {
    final response = await harness.agent.get("/example");
    expectResponse(response, 200, body: {"key": "value"});
  });
}

class App extends ApplicationChannel {
  @override
  Controller get entryPoint {
    final router = Router();
    router.route("/example").linkFunction((req) async => Response.ok({"key": "value"}));
    return router;
  }
}