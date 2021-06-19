import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

void initLogger({String? prefix}) {
  Logger.root.level = Level.ALL;

  const separator = ' | ';
  const horizontalSeparator = '--------------------------------';

  Logger.root.onRecord.listen((rec) {
    final content = <String>[
      if (prefix != null) ...<String>[
        prefix,
        separator,
      ],
      rec.level.name.padRight(7),
      separator,
      rec.loggerName.padRight(40),
      separator,
      rec.message,
    ];

    print(content.join());

    if (rec.error != null) {
      print(horizontalSeparator);
      print('ERROR');

      if (rec.error is Response) {
        print((rec.error as Response).data);
      } else {
        print(rec.error.toString());
      }

      print(horizontalSeparator);

      if (rec.stackTrace != null) {
        print('STACK TRACE');
        rec.stackTrace.toString().trim().split('\n').forEach(print);
        print(horizontalSeparator);
      }
    }
  });
}
