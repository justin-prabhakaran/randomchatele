import 'dart:collection';

import 'package:televerse/televerse.dart';

// ignore: constant_identifier_names
const String API_KEY = "6681746324:AAFin6L448mnyYWxDAgnB8YEfhFf0iEN2fw";
Bot bot = Bot(API_KEY,
    fetcher: LongPolling(),
    loggerOptions: LoggerOptions(
      requestHeader: false,
      responseHeader: false,
      logPrint: (object) {
        print(object);
      },
    ));
final Queue<ChatID> users = Queue<ChatID>();

Conversation conv = Conversation(bot);
String startstr = """
/connectme  👉  New Connection 🫂🍻
/bye  👉  Terminating connection ❌❗

Embrace new connections and share the joy with friends 🙏""";

