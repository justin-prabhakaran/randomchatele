import 'dart:async';

import 'package:randomchatele/utils.dart';
import 'package:televerse/telegram.dart';

import 'package:televerse/televerse.dart';

void makeConnection(ChatID myID) async {
  try {
    StreamController<Message?> myController = StreamController<Message?>();
    StreamController<Message?> endUserController = StreamController<Message?>();
    ChatID endUserID = users.first;

    print("End : ${endUserID.id}");
    print("my : ${myID.id}");

    if (endUserID != myID) {
      await bot.api.sendMessage(myID, "Connected ${endUserID.id}");
      await bot.api.sendMessage(endUserID, "Connected ${myID.id}");

      users.remove(myID);
      users.remove(endUserID);
      print(users);

      fetchFromMyID(myController, myID, endUserController);
      fetchFromEndUserID(endUserController, endUserID, myController);

      myController.stream.listen((data) async {
        try {
          if (data?.audio != null) {
            await bot.api.sendAudio(
                endUserID, InputFile.fromFileId(data?.audio?.fileId ?? ""));
          } else if (data?.photo != null) {
            await bot.api.sendPhoto(endUserID,
                InputFile.fromFileId(data?.photo?.first.fileId ?? ""));
          } else if (data?.text != null) {
            await bot.api.sendMessage(endUserID, data?.text ?? "Error");
          } else if (data == null) {
            await bot.api.sendMessage(endUserID, "Bot : Connection Terminated");
          }
        } catch (e) {
          print("Error in myController stream: $e");
        }
      });

      endUserController.stream.listen((data) async {
        try {
          if (data?.audio?.fileId != null) {
            await bot.api.sendAudio(
                myID, InputFile.fromFileId(data?.audio?.fileId ?? ""));
          } else if (data?.photo?.first != null) {
            await bot.api.sendPhoto(
                myID, InputFile.fromFileId(data?.photo?.first.fileId ?? ""));
          } else if (data?.text != null) {
            await bot.api.sendMessage(myID, data!.text!);
          } else if (data == null) {
            await bot.api.sendMessage(myID, "Bot : Connection Terminated");
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
      if (s?.text?.toLowerCase() == "/exit") {
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
      if (s?.text?.toLowerCase() == "/exit") {
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
                  up.message?.text != null;
            })
        .then((value) => value.update.message);
  } catch (e) {
    print("Error in fetchMessages: $e");
    return null;
  }
}
