import 'dart:async';

import 'package:televerse/telegram.dart';
import 'package:televerse/televerse.dart';

import 'utils.dart';

Future<void> makeConnection(ChatID myID) async {
  try {
    users.map((e) {
      print("User :${e.id}");
    });

    await bot.api.sendMessage(myID, "@Bot : Connecting...");
    // await bot.api.sendMessage(endUserID, "@Bot : Connected with ${myID.id}");

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

      await bot.api.sendMessage(myID, "@Bot : Connected with ${endUserID.id}");
      await bot.api.sendMessage(endUserID, "@Bot : Connected with ${myID.id}");

      fetchFromMyID(myController, myID, endUserController);
      fetchFromEndUserID(endUserController, endUserID, myController);

      myController.stream.listen((data) async {
        try {
          if (data != null) {
            await bot.api.copyMessage(endUserID, myID, data.messageId);
            print(
                "[${myID.id} - ${endUserID.id}] : ${data.text ?? "<Other Media>"}"); //print
          } else {
            await bot.api
                .sendMessage(endUserID, "@Bot : Connection terminated");
          }
        } catch (e) {
          print("Error in myController stream: $e");
        }
      });

      endUserController.stream.listen((data) async {
        try {
          if (data != null) {
            await bot.api.copyMessage(myID, endUserID, data.messageId);
            print(
                "[${endUserID.id} - ${myID.id}] : ${data.text ?? "<Other Media>"}"); //print
          } else {
            await bot.api.sendMessage(myID, "@Bot : Connection terminated");
          }
        } catch (e) {
          print("Error in endUserController stream: $e");
        }
      });
    }
  } on TelegramException catch (e) {
    print("Error in makeConnection: $e");
  } on TeleverseException catch (e) {
    print("Error in makeConnection: $e");
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
  } on TelegramException catch (e) {
    print("Error in fetchFromMyID: $e");
  } on TeleverseException catch (e) {
    print("Error in fetchFromMyID: $e");
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
  } on TelegramException catch (e) {
    print("Error in fetchFromEndUserID: $e");
  } on TeleverseException catch (e) {
    print("Error in fetchFromEndUserID: $e");
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
  } on TelegramException catch (e) {
    print("Error in fetchMessages: $e");
  } on TeleverseException catch (e) {
    print("Error in fetchMessages: $e");
  } catch (e) {
    print("Error in fetchMessages: $e");
  }
  return null;
}
