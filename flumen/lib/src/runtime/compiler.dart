import 'dart:convert';
import 'dart:io';
import 'dart:mirrors';
import 'package:flumen/flumen.dart';
import 'package:flumen/src/application/channel.dart';
import 'package:flumen/src/runtime/orm/data_model_compiler.dart';

import 'package:flumen/src/runtime/impl.dart';
import 'package:runtime/runtime.dart';

class FlumenCompiler extends Compiler {
  @override
  Map<String, dynamic> compile(MirrorContext context) {
    final m = <String, dynamic>{};

    m.addEntries(context
        .getSubclassesOf(ApplicationChannel)
        .map((t) => MapEntry(_getClassName(t), ChannelRuntimeImpl(t))));
    m.addEntries(context
        .getSubclassesOf(Serializable)
        .map((t) => MapEntry(_getClassName(t), SerializableRuntimeImpl(t))));
    m.addEntries(context
        .getSubclassesOf(Controller)
        .map((t) => MapEntry(_getClassName(t), ControllerRuntimeImpl(t))));

    m.addAll(DataModelCompiler().compile(context));

    return m;
  }

  String _getClassName(ClassMirror mirror) {
    return MirrorSystem.getName(mirror.simpleName);
  }

  @override
  List<Uri> getUrisToResolve(BuildContext context) {
    return context.context
        .getSubclassesOf(ManagedObject)
        .map((c) => c.location.sourceUri)
        .toList();
  }

  @override
  void deflectPackage(Directory destinationDirectory) {
    final libFile = File.fromUri(
        destinationDirectory.uri.resolve("lib/").resolve("flumen.dart"));
    final contents = libFile.readAsStringSync();
    libFile.writeAsStringSync(contents.replaceFirst(
        "export 'package:flumen/src/runtime/compiler.dart';", ""));
  }

  @override
  void didFinishPackageGeneration(BuildContext context) {
    if (context.forTests) {
      print("Copying flumen_test...");
      copyDirectory(
          src: context.sourceApplicationDirectory.uri
              .resolve("../")
              .resolve("test/"),
          dst: context.buildPackagesDirectory.uri.resolve("test/"));
      final targetPubspecFile =
          File.fromUri(context.buildDirectoryUri.resolve("pubspec.yaml"));
      final pubspecContents = json.decode(targetPubspecFile.readAsStringSync());
      pubspecContents["dev_dependencies"]["flumen_test"]["path"] =
          "packages/test";
      pubspecContents["dependency_overrides"]["flumen"] =
          pubspecContents["dependencies"]["flumen"];
      targetPubspecFile.writeAsStringSync(json.encode(pubspecContents));
    }
  }
}
