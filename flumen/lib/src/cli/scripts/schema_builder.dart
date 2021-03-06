import 'dart:async';

import 'package:flumen/flumen.dart';
import 'package:flumen/src/cli/migration_source.dart';
import 'package:flumen_isolator/flumen_isolator.dart';

class SchemaBuilderExecutable extends Executable<Map<String, dynamic>> {
  SchemaBuilderExecutable(Map<String, dynamic> message)
      : inputSchema = Schema.fromMap(message["schema"] as Map<String, dynamic>),
        sources = (message["sources"] as List<Map>)
            .map((m) => MigrationSource.fromMap(m as Map<String, dynamic>))
            .toList(),
        super(message);

  SchemaBuilderExecutable.input(this.sources, this.inputSchema)
      : super({
          "schema": inputSchema.asMap(),
          "sources": sources.map((source) => source.asMap()).toList()
        });

  final List<MigrationSource> sources;
  final Schema inputSchema;

  @override
  Future<Map<String, dynamic>> execute() async {
    hierarchicalLoggingEnabled = true;
    PostgreSQLPersistentStore.logger.level = Level.ALL;
    PostgreSQLPersistentStore.logger.onRecord
        .listen((r) => log("${r.message}"));
    try {
      var outputSchema = inputSchema;
      for (var source in sources) {
        Migration instance = instanceOf(
          source.name,
          positionalArguments: const [],
          namedArguments: const <Symbol, dynamic>{},
          constructorName: const Symbol(""),
        );
        instance.database = SchemaBuilder(null, outputSchema);
        await instance.upgrade();
        outputSchema = instance.currentSchema;
      }
      return outputSchema.asMap();
    } on SchemaException catch (e) {
      return {
        "error":
            "There was an issue with the schema generated by replaying this project's migration files. Reason: ${e.message}"
      };
    }
  }

  static List<String> get imports => [
        "package:flumen/flumen.dart",
        "package:flumen/src/cli/migration_source.dart",
        "package:flumen_runtime/runtime.dart"
      ];
}
