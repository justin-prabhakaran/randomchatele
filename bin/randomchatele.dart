import 'package:randomchatele/usecases.dart';
import 'package:randomchatele/utils.dart';
import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

void main() {
  try {
    ChatID myID;

    bot.command("start", (ctx) {
      ctx.reply("""/connectme => new Connection
/bye => terminating connection

Enjoy with Strangers !""");
    });

    bot.command("connectme", (ctx) async {
      ///users.add(ChatID(DateTime.now().millisecondsSinceEpoch));
      myID = ChatID(ctx.chat.id);
      if (!users.contains(myID)) {
        users.addLast(myID);
      }
      print(users);
      Message m = await ctx.reply("@Bot : Connecting.......");
      makeConnection(myID, m);
    });

    bot.start();
  } catch (e) {
    print(e);
  }
}
