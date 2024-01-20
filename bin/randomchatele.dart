import 'dart:async';

import 'package:randomchatele/usecases.dart';
import 'package:randomchatele/utils.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

void main() {
  print("Started");
  try {
    ChatID myID;

    bot.command("connectme", (ctx) async {
      ///users.add(ChatID(DateTime.now().millisecondsSinceEpoch));
      myID = ChatID(ctx.chat.id);

      if (!users.contains(myID)) {
        users.addLast(myID);
      }

      users.map((e) {
        print("User :${e.id}");
      });

      Message m = await ctx.reply("@Bot : Connecting.......");
      await makeConnection(myID, m);
    });

    bot.start(handle);
  } catch (e) {
    print(e);
  }
  // print("Ended");
}

FutureOr<void> handle(MessageContext ctx) async {
  
  print("User : ${ctx.from?.firstName} is online");
  await ctx.reply(startstr);
}
