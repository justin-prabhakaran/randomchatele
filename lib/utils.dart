import 'dart:collection';

import 'package:televerse/televerse.dart';

const String API_KEY = "6681746324:AAEiS-wmBo9x4bp1uZsLPQctWwsaw5xg7yY";
Bot bot = Bot(API_KEY);
final Queue<ChatID> users = Queue<ChatID>();

Conversation conv = Conversation(bot);
