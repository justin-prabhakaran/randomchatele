import 'dart:collection';

import 'package:televerse/televerse.dart';

const String API_KEY = "6681746324:AAFzg454h41tQnmuinKrt5S4TcbjbxL0Cg0";
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
/connectmem  👉  New Connection 🫂🍻
/bye  👉  Terminating connection ❌❗

Embrace new connections and share the joy with friends 🙏""";
