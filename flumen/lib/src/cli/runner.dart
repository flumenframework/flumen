import 'dart:async';

import 'package:flumen/src/cli/commands/auth.dart';
import 'package:flumen/src/cli/command.dart';
import 'package:flumen/src/cli/commands/build.dart';
import 'package:flumen/src/cli/commands/create.dart';
import 'package:flumen/src/cli/commands/db.dart';
import 'package:flumen/src/cli/commands/document.dart';
import 'package:flumen/src/cli/commands/serve.dart';
import 'package:flumen/src/cli/commands/setup.dart';

class Runner extends CLICommand {
  Runner() {
    registerCommand(CLITemplateCreator());
    registerCommand(CLIDatabase());
    registerCommand(CLIServer());
    registerCommand(CLISetup());
    registerCommand(CLIAuth());
    registerCommand(CLIDocument());
    registerCommand(CLIBuild());
  }

  @override
  Future<int> handle() async {
    printHelp();
    return 0;
  }

  @override
  String get name {
    return "flumen";
  }

  @override
  String get description {
    return "Flumen is a tool for managing Flumen applications.";
  }
}
