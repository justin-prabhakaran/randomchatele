import 'dart:async';

import 'package:randomchatele/utils.dart';
import 'package:televerse/telegram.dart';

import 'package:televerse/televerse.dart';

void makeConnection(ChatID myID) async {
  try {
    StreamController<Message> myController = StreamController<Message>();
    StreamController<Message> endUserController = StreamController<Message>();
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
        if (data.audio != null) {
          await bot.api
              .sendAudio(endUserID, InputFile.fromFileId(data.audio!.fileId));
        } else if (data.photo != null) {
          await bot.api.sendPhoto(
              endUserID, InputFile.fromFileId(data.photo!.first.fileId));
          print(data.photo!.first.fileId);
        } else {
          await bot.api.sendMessage(endUserID, data.text!);
        }
      });

      endUserController.stream.listen((data) async {
        if (data.audio != null) {
          await bot.api
              .sendAudio(myID, InputFile.fromFileId(data.audio!.fileId));
        } else if (data.photo != null) {
          await bot.api
              .sendPhoto(myID, InputFile.fromFileId(data.photo!.first.fileId));
        } else {
          await bot.api.sendMessage(myID, data.text!);
        }
      });

      fetchFromMyID(myController, myID, endUserController);
      fetchFromEndUserID(endUserController, endUserID, myController);
    }
  } catch (e) {
    print(e);
  }
}

Future<void> fetchFromMyID(StreamController<Message> myController, ChatID myID,
    StreamController<Message> endUserController) async {
  while (!myController.isClosed) {
    try {
      Message s = await fetchMessages(myID);
      if (s.text!.toLowerCase() == "/exit") {
        myController.add(Message.fromJson({
          "message_id": DateTime.now().millisecondsSinceEpoch,
          "date": "Bot : Connection Terminated",
          "sender_chat": myID.id
        }));
        myController.close();
        endUserController.add(Message.fromJson({
          "message_id": DateTime.now().millisecondsSinceEpoch,
          "date": "Bot : Connection Terminated",
          "sender_chat": myID.id
        }));
        endUserController.close();
        break;
      }
      myController.add(s);
    } catch (e) {
      print(e);
    }
  }
}

Future<void> fetchFromEndUserID(StreamController<Message> endUserController,
    ChatID endUserID, StreamController<Message> myController) async {
  while (!endUserController.isClosed) {
    try {
      Message s = await fetchMessages(endUserID);
      if (s == "/exit") {
        endUserController.add(Message.fromJson({
          "message_id": DateTime.now().millisecondsSinceEpoch,
          "date": "Bot : Connection Terminated",
          "sender_chat": endUserID.id
        }));
        endUserController.close();
        myController.add(Message.fromJson({
          "message_id": DateTime.now().millisecondsSinceEpoch,
          "date": "Bot : Connection Terminated",
          "sender_chat": endUserID.id
        }));
        myController.close();
        break;
      }
      endUserController.add(s);
    } catch (e) {
      print(e);
    }
  }
}

Future<Message> fetchMessages(ChatID endUserID) async {
  return await conv
      .waitFor(
          chatId: endUserID,
          filter: (up) {
            return up.message!.audio != null ||
                up.message!.photo != null ||
                up.message!.text != null;
          })
      .then((value) => value.update.message!);
}
