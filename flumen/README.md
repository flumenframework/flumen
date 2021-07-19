# Flumen

Join our slack [slack](https://join.slack.com/t/flumenframework/shared_invite/zt-oy7hutk3-7h59BltMed_TUM0Tj7CQBg).

Flumen is a fork of the Aqueduct framework in response of the [sunset](https://stablekernel.com/article/announcing-the-sunsetting-of-aqueduct-our-open-source-server-side-framework-in-googles-dart/) of the original project.announcement

Flumen is a modern Dart HTTP server framework. The framework is composed of libraries for handling and routing HTTP requests, object-relational mapping (ORM), authentication and authorization (OAuth 2.0 provider) and documentation (OpenAPI). These libraries are used to build scalable REST APIs that run on the Dart VM.

## Getting Started

1. [Install Dart](https://www.dartlang.org/install).
2. Activate Flumen

        dart pub global activate flumen

3. Create a new project.

        flumen create my_project

Open the project directory in [IntelliJ IDE](https://www.jetbrains.com/idea/download/), [Atom](https://atom.io) or [Visual Studio Code](https://code.visualstudio.com). All three IDEs have a Dart plugin. For IntelliJ IDEA users, there are [file and code templates](https://aqueduct.io/docs/intellij/) for Flumen.

## Tutorials, Documentation and Examples
For the near future we will use the original aqueduct documentation and tutorials. When you see a reference to `aqueduct` substitute it with `flumen` and you should be gine:

If this is your first time viewing Flumen, check out [the tour](https://aqueduct.io/docs/tour/).

Step-by-step tutorials for beginners are available [here](https://aqueduct.io/docs/tut/getting-started).

You can find the API reference [here](https://pub.dev/documentation/flumen/latest/) or you can install it in [Dash](https://kapeli.com/docsets#dartdoc).

You can find in-depth and conceptual guides [here](https://aqueduct.io/docs/).

An ever-expanding repository of Flumen examples is [here](https://github.com/Reductions/flumen/flumen/aqueduct_examples).

## Aqueduct to Flumen migration

1. You will need at least `dart v2.9.0`.
2. Run `dart pub global activate flumen` and use `flumen` executable instead of `aqueduct`.
3. In your `pubspec.yaml` make sure to set your sdk to ">=2.9.0 <3.0.0" and rename `aqueduct` to `flumen` and `aqueduct_test` to `flumen_test`:

```yaml
environment:
  sdk: ">=2.9.0 <3.0.0"
...

dependencies:
  flumen: ^1.0.0
...

dev_dependencies:
  flumen_test: ^1.0.0
...
```
4. Delete your `pubspec.lock` file and run `dart pub get`;

5. Find and replace all occurrence of:
  - `package:aqueduct/aqueduct.dart` with `package:flumen/flumen.dart`
  - `package:aqueduct/managed_auth.dart` with `package:flumen/managed_auth.dart`
  - `package:aqueduct_test/aqueduct_test.dart` with `package:flumen_test/flumen_test.dart`
  - `package:safe_config/safe_config.dart` with `package:flumen_config/flumen_config.dart`

6. Rename the `_aqueduct_version_pgsql` table to  `_flumen_schema_migration`:

```sql
ALTER TABLE _aqueduct_version_pgsql RENAME TO _flumen_schema_migration;
```

7. Run test.
