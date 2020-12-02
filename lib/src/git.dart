import 'dart:io';

/// Git Interface
class Git {
  /// Execute a git command and returns a [ProcessResult].
  static Future<ProcessResult> run(
    List<String> args, {
    bool throwOnError = true,
    String processWorkingDir,
  }) async {
    final result = await Process.run('git', args,
        workingDirectory: processWorkingDir, runInShell: true);

    if (throwOnError) {
      _throwIfProcessFailed(result, 'git', args);
    }
    return result;
  }
}

void _throwIfProcessFailed(
  ProcessResult pr,
  String process,
  List<String> args,
) {
  assert(pr != null);
  if (pr.exitCode != 0) {
    final values = {
      'Standard out': pr.stdout.toString().trim(),
      'Standard error': pr.stderr.toString().trim()
    }..removeWhere((k, v) => v.isEmpty);

    String message;
    if (values.isEmpty) {
      message = 'Unknown error';
    } else if (values.length == 1) {
      message = values.values.single;
    } else {
      message = values.entries.map((e) => '${e.key}\n${e.value}').join('\n');
    }

    throw ProcessException(process, args, message, pr.exitCode);
  }
}
