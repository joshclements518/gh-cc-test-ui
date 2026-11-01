import 'models.dart';

/// Rich sample catalog for Harborline Navigator demos.
abstract final class MockCatalog {
  static final reservation = Reservation(
    id: 'res-eastern-isles',
    title: 'Eastern Isles · 7 nights',
    shipName: 'MV Aether Dawn',
    datesLabel: 'Oct 12–19',
    guestsLabel: 'Maya + Jordan',
    stateroom: '9241',
    deck: 'Deck 9',
    diningTime: '5:45p',
    folioTotal: 214.40,
  );

  static final guest = GuestProfile(
    displayName: 'Maya Chen',
    email: 'maya.chen@example.com',
  );

  static final itinerary = <ItineraryDay>[
    ItineraryDay(
      dayNumber: 1,
      dateLabel: 'Sun Oct 12',
      portLabel: 'Embark · Port Aurora',
      events: const [
        PlanEvent(
          id: 'e1',
          title: 'Muster drill',
          timeLabel: '4:00 PM',
          location: 'Assembly Station B',
          category: 'Safety',
          description: 'Required safety briefing for all guests. Bring your keycards.',
          reserved: true,
        ),
        PlanEvent(
          id: 'e2',
          title: 'Sail-away on Sky Deck',
          timeLabel: '5:30 PM',
          location: 'Deck 14 Aft',
          category: 'Activity',
          description: 'Live quartet and welcome sparkling cider as we leave Port Aurora.',
        ),
      ],
    ),
    ItineraryDay(
      dayNumber: 2,
      dateLabel: 'Mon Oct 13',
      portLabel: 'Sea day',
      events: const [
        PlanEvent(
          id: 'e3',
          title: 'Coral Room brunch',
          timeLabel: '10:30 AM',
          location: 'Coral Room · Deck 3',
          category: 'Dining',
          description: 'Rotational dining brunch with coastal pastries and fresh fruit.',
          reserved: true,
        ),
        PlanEvent(
          id: 'e4',
          title: 'Port adventure: Cliff gardens walk',
          timeLabel: '1:00 PM',
          location: 'Shore desk · Deck 1',
          category: 'Port',
          description: 'Guided walk through cliffside gardens. Moderate walking shoes recommended.',
        ),
      ],
    ),
    ItineraryDay(
      dayNumber: 3,
      dateLabel: 'Tue Oct 14',
      portLabel: 'Nassau Harbor (mock)',
      events: const [
        PlanEvent(
          id: 'e5',
          title: 'Aurora Theater — First Light',
          timeLabel: '7:30 PM',
          location: 'Deck 4',
          category: 'Entertainment',
          description: 'Reserved seats. Arrive 15 minutes early for the house overture.',
          reserved: true,
        ),
        PlanEvent(
          id: 'e6',
          title: 'Dinner · Rotational dining',
          timeLabel: '8:45 PM',
          location: 'Coral Room · Table 42',
          category: 'Dining',
          description: 'Anytime seating also available at Harbor Grill.',
          reserved: true,
        ),
      ],
    ),
    ItineraryDay(
      dayNumber: 4,
      dateLabel: 'Wed Oct 15',
      portLabel: 'Sea day',
      events: const [
        PlanEvent(
          id: 'e7',
          title: 'Virtual queue: Debarkation ticket',
          timeLabel: 'Open window',
          location: 'Guest services app',
          category: 'Queue',
          description: 'Sample queue ticket for express luggage day. Status: hold active.',
          reserved: true,
        ),
      ],
    ),
  ];

  static final venues = <Venue>[
    Venue(id: 'v1', name: 'Coral Room', deck: 'Deck 3', category: 'Dining', blurb: 'Rotational dining with ocean views and seasonal menus.', hours: '5:30p–9:30p', tags: ['dinner', 'reservation']),
    Venue(id: 'v2', name: 'Harbor Grill', deck: 'Deck 11', category: 'Dining', blurb: 'Casual grill and salads with anytime seating.', hours: '11:30a–10p', tags: ['casual', 'anytime']),
    Venue(id: 'v3', name: 'Aurora Theater', deck: 'Deck 4', category: 'Entertainment', blurb: 'Main stage productions and guest lectures.', hours: 'Show nights', tags: ['shows']),
    Venue(id: 'v4', name: 'Sky Deck Pool', deck: 'Deck 14', category: 'Recreation', blurb: 'Open-air pool, cabanas, and sail-away gatherings.', hours: '7a–10p', tags: ['pool', 'family']),
    Venue(id: 'v5', name: 'Chart Room Spa', deck: 'Deck 12', category: 'Spa', blurb: 'Thermal suite and treatment rooms overlooking the wake.', hours: '8a–8p', tags: ['spa']),
    Venue(id: 'v6', name: 'Kids Cove', deck: 'Deck 10', category: 'Youth', blurb: 'Supervised clubs by age group with evening hours.', hours: '9a–10p', tags: ['kids']),
    Venue(id: 'v7', name: 'Beacon Lounge', deck: 'Deck 8', category: 'Lounge', blurb: 'Quiet cocktails and acoustic sets after dinner.', hours: '5p–midnight', tags: ['nightlife']),
    Venue(id: 'v8', name: 'Fitness Studio', deck: 'Deck 14 Fwd', category: 'Fitness', blurb: 'Classes and open gym with sea views.', hours: '6a–9p', tags: ['fitness']),
    Venue(id: 'v9', name: 'Shore Excursions Desk', deck: 'Deck 1', category: 'Services', blurb: 'Port adventures booking and meet-up points.', hours: '9a–6p', tags: ['port']),
  ];

  static final inbox = <InboxItem>[
    InboxItem(id: 'i1', title: 'Muster complete', body: 'Thanks for completing your safety drill. You’re cleared for sail-away.', whenLabel: '2h ago', kind: 'Safety'),
    InboxItem(id: 'i2', title: 'Dining reminder', body: 'Coral Room seating at 5:45p tonight. Table 42.', whenLabel: '4h ago', kind: 'Dining'),
    InboxItem(id: 'i3', title: 'Port day tips', body: 'Tomorrow’s harbor arrival is at 8:00a. Tender tickets in My Plans.', whenLabel: 'Yesterday', kind: 'Port'),
    InboxItem(id: 'i4', title: 'Folio update', body: 'Spa credit posted. Current balance \$214.40.', whenLabel: 'Yesterday', kind: 'Folio'),
    InboxItem(id: 'i5', title: 'Show reservation', body: 'Aurora Theater — First Light is confirmed for 7:30p.', whenLabel: 'Mon', kind: 'Entertainment'),
  ];

  static final chats = <ChatThread>[
    ChatThread(
      id: 'c1',
      name: 'Jordan Chen',
      preview: 'Meet at Sky Deck before the show?',
      messages: const [
        ChatMessage(fromMe: false, text: 'Pool was perfect — heading back to 9241.', when: '3:02p'),
        ChatMessage(fromMe: true, text: 'Nice. Meet at Sky Deck before the show?', when: '3:05p'),
        ChatMessage(fromMe: false, text: 'Meet at Sky Deck before the show?', when: '3:06p'),
      ],
    ),
    ChatThread(
      id: 'c2',
      name: 'Guest Services',
      preview: 'Your debarkation window is held.',
      messages: const [
        ChatMessage(fromMe: true, text: 'Can you hold an express luggage window?', when: 'Mon'),
        ChatMessage(fromMe: false, text: 'Your debarkation window is held.', when: 'Mon'),
      ],
    ),
  ];

  static final contacts = <Contact>[
    Contact(id: 'k1', name: 'Jordan Chen', relation: 'Travel companion', stateroom: '9241'),
    Contact(id: 'k2', name: 'Avery Chen', relation: 'Child · Youth club', stateroom: '9241'),
    Contact(id: 'k3', name: 'Guest Services', relation: 'Ship services', stateroom: 'Deck 3'),
  ];

  static final folio = <FolioCharge>[
    FolioCharge(label: 'Specialty coffee · Harbor Grill', amount: 12.50, when: 'Today'),
    FolioCharge(label: 'Spa thermal suite', amount: 89.00, when: 'Yesterday'),
    FolioCharge(label: 'Shore excursion deposit', amount: 75.00, when: 'Sun'),
    FolioCharge(label: 'Wi‑Fi day pass ×2', amount: 37.90, when: 'Sun'),
  ];

  static final articles = <Article>[
    Article(
      id: 'a1',
      title: 'How rotational dining works',
      summary: 'Same table, new menu themes each night.',
      body: 'Harborline pairs you with a table team for the voyage. You can also use anytime venues on upper decks when you want flexibility.',
    ),
    Article(
      id: 'a2',
      title: 'Finding quiet corners on sea days',
      summary: 'Libraries, forward lounges, and early spa hours.',
      body: 'Try Beacon Lounge before 6p or the Chart Room reading nook for calmer spaces away from the pool deck.',
    ),
  ];

  static final spotlights = <SpotlightItem>[
    SpotlightItem(title: 'Tonight in Aurora Theater', subtitle: 'First Light · 7:30p · Deck 4'),
    SpotlightItem(title: 'Chef’s tasting at Coral Room', subtitle: 'Ask your server about the tasting flight'),
    SpotlightItem(title: 'Sunrise yoga', subtitle: 'Deck 14 Fwd · 6:45a · bring a layer'),
  ];

  static final diningRotation = <String>[
    'Night 1 — Coastal welcome',
    'Night 2 — Spice route',
    'Night 3 — Captain’s celebration',
    'Night 4 — Market grill',
  ];

  static final portAdventures = <PlanEvent>[
    PlanEvent(
      id: 'p1',
      title: 'Cliff gardens walk',
      timeLabel: '1:00 PM',
      location: 'Meet Deck 1',
      category: 'Port',
      description: 'Moderate walk with ocean overlooks. Includes guided commentary.',
    ),
    PlanEvent(
      id: 'p2',
      title: 'Harbor kayak intro',
      timeLabel: '9:30 AM',
      location: 'Tender pier',
      category: 'Port',
      description: 'Calm-water kayaking for beginners. Life vests provided.',
    ),
  ];
}
