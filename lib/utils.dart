import 'dart:collection';

import 'package:televerse/televerse.dart';

const String API_KEY = "";
Bot bot = Bot(API_KEY);
final Queue<ChatID> users = Queue<ChatID>();
Conversation conv = Conversation(bot);
