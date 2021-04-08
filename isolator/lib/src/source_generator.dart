import 'dart:io';
import 'dart:isolate';
import 'dart:mirrors';
import 'dart:async';

import 'package:analyzer/analyzer.dart';
import 'package:flumen_isolator/src/executable.dart';

class SourceGenerator {
  SourceGenerator(
    this.executableType, {
    this.imports,
    this.additionalContents,
    this.additionalTypes,
    this.nullSafe = false,
  });

  Type executableType;

  String get typeName =>
      MirrorSystem.getName(reflectType(executableType).simpleName);
  final List<String> imports;
  final String additionalContents;
  final List<Type> additionalTypes;
  final bool nullSafe;

  Future<String> get scriptSource async {
    final typeSource = (await _getClass(executableType)).toSource();
    var builder = new StringBuffer();

    if (!nullSafe) {
      builder.writeln("// @dart = 2.9");
    }

    builder.writeln("import 'dart:async';");
    builder.writeln("import 'dart:isolate';");
    builder.writeln("import 'dart:mirrors';");
    imports?.forEach((import) {
      builder.writeln("import '$import';");
    });
    builder.writeln("""
Future main (List<String> args, Map<String, dynamic> message) async {
  final sendPort = message['_sendPort'];
  final executable = new $typeName(message);
  final result = await executable.execute();
  sendPort.send({"_result": result});
}
    """);
    builder.writeln(typeSource);

    builder.writeln((await _getClass(Executable)).toSource());
    for (var type in additionalTypes ?? []) {
      final source = await _getClass(type);
      builder.writeln(source.toSource());
    }

    if (additionalContents != null) {
      builder.writeln(additionalContents);
    }

    return builder.toString();
  }

  static Future<ClassDeclaration> _getClass(Type type) async {
    final uri =
        await Isolate.resolvePackageUri(reflectClass(type).location.sourceUri);
    final fileUnit = parseDartFile(uri.toFilePath(windows: Platform.isWindows));
    final typeName = MirrorSystem.getName(reflectClass(type).simpleName);

    return fileUnit.declarations
        .whereType<ClassDeclaration>()
        .firstWhere((classDecl) => classDecl.name.name == typeName);
  }
}
