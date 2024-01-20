import 'dart:async';

import 'package:randomchatele/utils.dart';
import 'package:televerse/telegram.dart';

import 'package:televerse/televerse.dart';

Future<void> makeConnection(ChatID myID, Message m) async {
  try {
    users.map((e) {
      print("User :${e.id}");
    });

    StreamController<Message?> myController = StreamController<Message?>();
    StreamController<Message?> endUserController = StreamController<Message?>();

    ChatID endUserID = users.first;

    print("user A : ${endUserID.id}");
    print("User B : ${myID.id}");

    if (endUserID != myID) {
      users.remove(myID);
      users.remove(endUserID);

      users.map((e) {
        print("User :${e.id}");
      });

      await bot.api.editMessageText(
          myID, m.messageId, "@Bot : Connected with ${endUserID.id}");
      await bot.api.sendMessage(endUserID, "@Bot : Connected with ${myID.id}");

      fetchFromMyID(myController, myID, endUserController);
      fetchFromEndUserID(endUserController, endUserID, myController);

      myController.stream.listen((data) async {
        try {
          if (data != null) {
            bot.api.copyMessage(endUserID, myID, data.messageId);
            print("[${myID.id} - ${endUserID.id}] : ${data.text!}"); //print
          } else {
            bot.api.sendMessage(endUserID, "@Bot : Connection terminated");
          }
        } catch (e) {
          print("Error in myController stream: $e");
        }
      });

      endUserController.stream.listen((data) async {
        try {
          if (data != null) {
            bot.api.copyMessage(myID, endUserID, data.messageId);
            print("[${endUserID.id} - ${myID.id}] : ${data.text!}"); //print
          } else {
            bot.api.sendMessage(myID, "@Bot : Connection terminated");
          }
        } catch (e) {
          print("Error in endUserController stream: $e");
        }
      });
    }
  } catch (e) {
    print("Error in makeConnection: $e");
  }
}

Future<void> fetchFromMyID(StreamController<Message?> myController, ChatID myID,
    StreamController<Message?> endUserController) async {
  try {
    while (!myController.isClosed) {
      Message? s = await fetchMessages(myID);
      if (s?.text?.toLowerCase() == "/bye") {
        myController.add(null);
        myController.close();
        endUserController.add(null);
        endUserController.close();
        break;
      }
      myController.add(s);
    }
  } catch (e) {
    print("Error in fetchFromMyID: $e");
  }
}

Future<void> fetchFromEndUserID(StreamController<Message?> endUserController,
    ChatID endUserID, StreamController<Message?> myController) async {
  try {
    while (!endUserController.isClosed) {
      Message? s = await fetchMessages(endUserID);
      if (s?.text?.toLowerCase() == "/bye") {
        endUserController.add(null);
        endUserController.close();
        myController.add(null);
        myController.close();
        break;
      }
      endUserController.add(s);
    }
  } catch (e) {
    print("Error in fetchFromEndUserID: $e");
  }
}

Future<Message?> fetchMessages(ChatID id) async {
  try {
    return await conv
        .waitFor(
            chatId: id,
            filter: (up) {
              return up.message?.audio != null ||
                  up.message?.photo != null ||
                  up.message?.text != null ||
                  up.message?.animation != null ||
                  up.message?.contact != null ||
                  up.message?.document != null ||
                  up.message?.sticker != null;
            })
        .then((value) => value.update.message);
  } catch (e) {
    print("Error in fetchMessages: $e");
    return null;
  }
}
