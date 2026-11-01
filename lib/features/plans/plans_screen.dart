import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class PlansScreen extends StatelessWidget {
  const PlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Plans')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Itinerary'),
                const SizedBox(height: 6),
                const DisplayTitle('Day by day'),
                const SizedBox(height: 8),
                Text('Tap any day for activities, dining, and port notes.',
                    style: TextStyle(color: HlTokens.inkSoft, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...MockCatalog.itinerary.map((day) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HlCard(
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => DayDetailScreen(dayNumber: day.dayNumber)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: HlTokens.foam, borderRadius: BorderRadius.circular(14)),
                          child: Text('${day.dayNumber}', style: const TextStyle(fontWeight: FontWeight.w800, color: HlTokens.sea, fontSize: 18)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(day.dateLabel, style: const TextStyle(fontWeight: FontWeight.w700)),
                              Text(day.portLabel, style: const TextStyle(color: HlTokens.inkSoft, fontSize: 13)),
                              Text('${day.events.length} plans', style: const TextStyle(color: HlTokens.sea, fontSize: 12, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: HlTokens.inkSoft),
                      ],
                    ),
                  ),
                ),
              )),
          const SectionLabel('More'),
          _LinkTile('Dining rotation', Icons.restaurant, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiningRotationScreen()));
          }),
          _LinkTile('Port adventures', Icons.sailing_outlined, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PortAdventuresScreen()));
          }),
          _LinkTile('Virtual queue / debarkation', Icons.confirmation_number_outlined, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const VirtualQueueScreen()));
          }),
          _LinkTile('My reservations', Icons.bookmark_border, () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyReservationsScreen()));
          }),
        ],
      ),
    );
  }
}

class _LinkTile extends StatelessWidget {
  const _LinkTile(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
        tileColor: Colors.white,
        leading: Icon(icon, color: HlTokens.sea),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class DayDetailScreen extends StatelessWidget {
  const DayDetailScreen({super.key, required this.dayNumber});
  final int dayNumber;
  @override
  Widget build(BuildContext context) {
    final day = MockCatalog.itinerary.firstWhere((d) => d.dayNumber == dayNumber);
    return Scaffold(
      appBar: AppBar(title: Text('Day ${day.dayNumber}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DisplayTitle(day.dateLabel),
          Text(day.portLabel, style: const TextStyle(color: HlTokens.inkSoft)),
          const SizedBox(height: 16),
          ...day.events.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: HlCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${e.timeLabel} · ${e.location}\n${e.category}${e.reserved ? " · Reserved" : ""}'),
                    isThreeLine: true,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => ActivityDetailScreen(eventId: e.id)),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({super.key, required this.eventId});
  final String eventId;
  @override
  Widget build(BuildContext context) {
    final event = MockCatalog.itinerary.expand((d) => d.events).followedBy(MockCatalog.portAdventures).firstWhere((e) => e.id == eventId);
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftChip(event.category),
                const SizedBox(height: 10),
                DisplayTitle(event.title),
                const SizedBox(height: 8),
                Text('${event.timeLabel} · ${event.location}', style: const TextStyle(color: HlTokens.inkSoft)),
                const SizedBox(height: 14),
                Text(event.description, style: const TextStyle(height: 1.45, fontSize: 15)),
                if (event.reserved) ...[
                  const SizedBox(height: 14),
                  SoftChip('Reserved'),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiningRotationScreen extends StatelessWidget {
  const DiningRotationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dining rotation')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const HlCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Eyebrow('Coral Room'),
            SizedBox(height: 6),
            DisplayTitle('Your table team'),
            SizedBox(height: 8),
            Text('Table 42 · Traditional seating 5:45p. Learn more about themes below.', style: TextStyle(color: HlTokens.inkSoft, height: 1.4)),
          ])),
          const SectionLabel('Nightly themes'),
          ...MockCatalog.diningRotation.map((n) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
                  title: Text(n, style: const TextStyle(fontWeight: FontWeight.w600)),
                  trailing: TextButton(onPressed: () {}, child: const Text('Learn more')),
                ),
              )),
        ],
      ),
    );
  }
}

class PortAdventuresScreen extends StatelessWidget {
  const PortAdventuresScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Port adventures')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: MockCatalog.portAdventures.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HlCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(e.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${e.timeLabel} · ${e.description}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ActivityDetailScreen(eventId: e.id))),
                ),
              ),
            )).toList(),
      ),
    );
  }
}

class VirtualQueueScreen extends StatelessWidget {
  const VirtualQueueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual queue')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HlCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Eyebrow('Debarkation ticket'),
              const SizedBox(height: 8),
              const DisplayTitle('Express luggage window'),
              const SizedBox(height: 8),
              const Text('Status: hold active · Sample ticket for demo voyages.', style: TextStyle(color: HlTokens.inkSoft, height: 1.4)),
              const SizedBox(height: 16),
              SoftChip('Queue position · demo'),
              const SizedBox(height: 16),
              FilledButton(onPressed: () {}, child: const Text('View ticket details')),
            ],
          ),
        ),
      ),
    );
  }
}

class MyReservationsScreen extends StatefulWidget {
  const MyReservationsScreen({super.key});
  @override
  State<MyReservationsScreen> createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  final controller = TextEditingController();
  String? linked;
  @override
  Widget build(BuildContext context) {
    final res = MockCatalog.reservation;
    return Scaffold(
      appBar: AppBar(title: const Text('My reservations')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayTitle(res.title),
                Text('${res.shipName} · ${res.datesLabel}', style: const TextStyle(color: HlTokens.inkSoft)),
                if (linked != null) ...[
                  const SizedBox(height: 8),
                  SoftChip('Linked $linked'),
                ],
              ],
            ),
          ),
          const SectionLabel('Add / link reservation'),
          HlCard(
            child: Column(
              children: [
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    labelText: 'Confirmation code',
                    hintText: 'e.g. HL-48291',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => setState(() => linked = controller.text.isEmpty ? 'HL-48291' : controller.text),
                    child: const Text('Link reservation'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
