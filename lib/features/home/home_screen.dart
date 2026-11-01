import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';
import '../../ui/widgets/release_tips_banner.dart';
import '../plans/plans_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final onBoard = state.mode == VoyageMode.onBoard;
    final res = MockCatalog.reservation;
    final name = state.services.profile.profile.displayName.split(' ').first;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _Hero(onBoard: onBoard, name: name, res: res, state: state)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 28),
          sliver: SliverList.list(children: [
            Transform.translate(
              offset: const Offset(0, -28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HlCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Eyebrow('Your voyage'),
                        const SizedBox(height: 6),
                        DisplayTitle(res.title),
                        const SizedBox(height: 4),
                        Text('${res.datesLabel} · Guests: ${res.guestsLabel}',
                            style: const TextStyle(color: HlTokens.inkSoft, fontSize: 13)),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            SoftChip('Dining ${res.diningTime}'),
                            SoftChip(onBoard ? 'Mustering done' : 'Check-in opens soon'),
                            SoftChip('Folio \$${res.folioTotal.toStringAsFixed(0)}'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const ReleaseTipsBanner(),
                      ],
                    ),
                  ),
                  const SectionLabel('Quick actions'),
                  Row(
                    children: [
                      Expanded(child: _ActionTile(icon: Icons.check_circle_outline, label: 'Check-In', onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MyReservationsScreen()));
                      })),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionTile(icon: Icons.restaurant_outlined, label: 'Dining', onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DiningRotationScreen()));
                      })),
                      const SizedBox(width: 10),
                      Expanded(child: _ActionTile(icon: Icons.star_outline, label: 'Activities', onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ActivityDetailScreen(eventId: 'e5')));
                      })),
                    ],
                  ),
                  const SectionLabel('Up next'),
                  _NextCard(
                    time: '7:30\nPM',
                    title: 'Aurora Theater — First Light',
                    subtitle: 'Deck 4 · Reserved · Arrive 15 min early',
                    color: HlTokens.sea,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ActivityDetailScreen(eventId: 'e5')),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _NextCard(
                    time: '8:45\nPM',
                    title: 'Dinner · Rotational dining',
                    subtitle: 'Coral Room · Table 42 · Anytime seating open',
                    color: HlTokens.coral,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const DiningRotationScreen()),
                    ),
                  ),
                  if (!onBoard) ...[
                    const SectionLabel('Before you sail'),
                    HlCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DisplayTitle('Pre-cruise checklist'),
                          const SizedBox(height: 8),
                          const Text('· Complete online check-in\n· Add travel companions\n· Review dining & shows\n· Download deck plans for offline use',
                              style: TextStyle(height: 1.5, color: HlTokens.inkSoft)),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ]),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.onBoard, required this.name, required this.res, required this.state});
  final bool onBoard;
  final String name;
  final dynamic res;
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(22, MediaQuery.paddingOf(context).top + 18, 22, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: onBoard
              ? const [Color(0xFF1A8A8E), HlTokens.sea, Color(0xFF163A4A)]
              : const [Color(0xFF3D7A8C), Color(0xFF2F5F70), HlTokens.ink],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 7, height: 7,
                        decoration: BoxDecoration(
                          color: onBoard ? const Color(0xFF7DFFA8) : HlTokens.gold,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          onBoard ? 'On board · Ship Wi‑Fi' : 'At home · Pre-cruise',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => state.setMode(onBoard ? VoyageMode.atHome : VoyageMode.onBoard),
                child: Text(onBoard ? 'At-home' : 'On-board',
                    style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            onBoard ? 'Good evening, $name' : 'Your voyage awaits, $name',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600, height: 1.15),
          ),
          const SizedBox(height: 6),
          Text(
            onBoard
                ? '${res.shipName} · ${res.deck} · Stateroom ${res.stateroom}'
                : '${res.shipName} · Departs ${res.datesLabel.split("–").first.trim()}',
            style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _CountCell(onBoard ? '3' : '9', onBoard ? 'Day' : 'Days')),
              const SizedBox(width: 10),
              Expanded(child: _CountCell(onBoard ? '2' : '—', onBoard ? 'Left' : 'Nights')),
              const SizedBox(width: 10),
              Expanded(child: _CountCell(onBoard ? '18h' : 'Oct', onBoard ? 'To port' : '12')),
            ],
          ),
        ],
      ),
    );
  }
}

class _CountCell extends StatelessWidget {
  const _CountCell(this.n, this.l);
  final String n;
  final String l;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        children: [
          Text(n, style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
          Text(l.toUpperCase(), style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 10, letterSpacing: 0.6)),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.icon, required this.label, required this.onTap});
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: HlTokens.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: HlTokens.line),
        ),
        child: Column(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: HlTokens.foam, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: HlTokens.sea, size: 20),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _NextCard extends StatelessWidget {
  const _NextCard({required this.time, required this.title, required this.subtitle, required this.color, required this.onTap});
  final String time;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(HlTokens.radiusCard),
      child: HlCard(
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(14)),
              child: Text(time, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11, height: 1.15)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(color: HlTokens.inkSoft, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
