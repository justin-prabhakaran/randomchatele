import 'package:randomchatele/usecases.dart';
import 'package:randomchatele/utils.dart';
import 'package:televerse/televerse.dart';

void main() {
  ChatID myID;

  bot.command("start", (ctx) {
    ctx.reply("/connectme");
  });

  bot.command("connectme", (ctx) {
    ///users.add(ChatID(DateTime.now().millisecondsSinceEpoch));
    myID = ChatID(ctx.chat.id);
    if (!users.contains(myID)) {
      users.addLast(myID);
    }
    print(users);

    makeConnection(myID);
  });

  bot.command("help", (ctx) {
    ctx.api.sendMessage(ctx.id, """/connectme for new Connection
/bye for terminating connection
Enjoy with Strangers !""");
  });
  bot.start();
}
