class Reservation {
  const Reservation({
    required this.id,
    required this.title,
    required this.shipName,
    required this.datesLabel,
    required this.guestsLabel,
    required this.stateroom,
    required this.deck,
    required this.diningTime,
    required this.folioTotal,
  });
  final String id;
  final String title;
  final String shipName;
  final String datesLabel;
  final String guestsLabel;
  final String stateroom;
  final String deck;
  final String diningTime;
  final double folioTotal;
}

class ItineraryDay {
  const ItineraryDay({
    required this.dayNumber,
    required this.dateLabel,
    required this.portLabel,
    required this.events,
  });
  final int dayNumber;
  final String dateLabel;
  final String portLabel;
  final List<PlanEvent> events;
}

class PlanEvent {
  const PlanEvent({
    required this.id,
    required this.title,
    required this.timeLabel,
    required this.location,
    required this.category,
    required this.description,
    this.reserved = false,
  });
  final String id;
  final String title;
  final String timeLabel;
  final String location;
  final String category;
  final String description;
  final bool reserved;
}

class Venue {
  const Venue({
    required this.id,
    required this.name,
    required this.deck,
    required this.category,
    required this.blurb,
    required this.hours,
    required this.tags,
  });
  final String id;
  final String name;
  final String deck;
  final String category;
  final String blurb;
  final String hours;
  final List<String> tags;
}

class InboxItem {
  const InboxItem({
    required this.id,
    required this.title,
    required this.body,
    required this.whenLabel,
    required this.kind,
  });
  final String id;
  final String title;
  final String body;
  final String whenLabel;
  final String kind;
}

class ChatThread {
  const ChatThread({
    required this.id,
    required this.name,
    required this.preview,
    required this.messages,
  });
  final String id;
  final String name;
  final String preview;
  final List<ChatMessage> messages;
}

class ChatMessage {
  const ChatMessage({required this.fromMe, required this.text, required this.when});
  final bool fromMe;
  final String text;
  final String when;
}

class Contact {
  const Contact({required this.id, required this.name, required this.relation, required this.stateroom});
  final String id;
  final String name;
  final String relation;
  final String stateroom;
}

class FolioCharge {
  const FolioCharge({required this.label, required this.amount, required this.when});
  final String label;
  final double amount;
  final String when;
}

class Article {
  const Article({required this.id, required this.title, required this.summary, required this.body});
  final String id;
  final String title;
  final String summary;
  final String body;
}

class SpotlightItem {
  const SpotlightItem({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}

class GuestProfile {
  GuestProfile({
    required this.displayName,
    required this.email,
    this.childWifiAllowed = true,
    this.childChatAllowed = false,
    this.childPurchasesAllowed = false,
    this.promoEmail = true,
    this.promoPush = false,
  });
  String displayName;
  String email;
  bool childWifiAllowed;
  bool childChatAllowed;
  bool childPurchasesAllowed;
  bool promoEmail;
  bool promoPush;
}
