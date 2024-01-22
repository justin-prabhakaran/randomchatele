import 'dart:async';

import 'package:randomchatele/usecases.dart';
import 'package:randomchatele/utils.dart';
import 'package:televerse/televerse.dart';

void main() {
  bot.onError((err) {
    print(err.error.toString());
  });

  print("Started");
  try {
    ChatID myID;

    bot.command("connectme", (ctx) async {
      myID = ChatID(ctx.chat.id);

      if (!users.contains(myID)) {
        users.addLast(myID);
      }

      users.map((e) {
        print("User :${e.id}");
      });

      await makeConnection(myID);
    });

    bot.start(handle);
  } on TelegramException catch (e) {
    print(e);
  } on TeleverseException catch (e) {
    print(e);
  } catch (e) {
    print(e);
  }
  // print("Ended");
}

FutureOr<void> handle(MessageContext ctx) async {
  print("User : ${ctx.from?.firstName} is online");
  await ctx.reply(startstr);
}
