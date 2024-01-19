import 'dart:async';

import 'package:randomchatele/utils.dart';

import 'package:televerse/televerse.dart';

void makeConnection(ChatID myID) async {
  try {
    StreamController<String> myController = StreamController<String>();
    StreamController<String> endUserController = StreamController<String>();
    ChatID endUserID = users.first;

    print("End : ${endUserID.id}");
    print("my : ${myID.id}");

    if (endUserID != myID) {
      await bot.api.sendMessage(myID, "Connected ${endUserID.id}");
      await bot.api.sendMessage(endUserID, "Connected ${myID.id}");

      users.remove(myID);
      users.remove(endUserID);
      print(users);

      myController.stream.listen((data) async {
        await bot.api.sendMessage(endUserID, data);
      });

      endUserController.stream.listen((data) async {
        await bot.api.sendMessage(myID, data);
      });
      fetchFromMyID(myController, myID, endUserController);
      fetchFromEndUserID(endUserController, endUserID, myController);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> fetchFromMyID(StreamController<String> myController, ChatID myID,
    StreamController<String> endUserController) async {
  while (!myController.isClosed) {
    try {
      String s = await fetchMessages(myID);
      if (s == "/exit") {
        myController.add("Bot : Connection Terminated");
        myController.close();
        endUserController.add("Bot : Connection Terminated");
        endUserController.close();
        break;
      }
      myController.add(s);
    } catch (e) {
      print(e);
    }
  }
}

Future<void> fetchFromEndUserID(StreamController<String> endUserController,
    ChatID endUserID, StreamController<String> myController) async {
  while (!endUserController.isClosed) {
    try {
      String s = await fetchMessages(endUserID);
      if (s == "/exit") {
        endUserController.add("Bot : Connection Terminated");
        endUserController.close();
        myController.add("Bot : Connection Terminated");
        myController.close();
        break;
      }
      endUserController.add(s);
    } catch (e) {
      print(e);
    }
  }
}

Future<String> fetchMessages(ChatID endUserID) async {
  return await conv
      .waitForTextMessage(chatId: endUserID)
      .then((value) => value.message.text!);
}
