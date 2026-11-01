import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../data/models.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});
  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String query = '';
  String? category;

  List<Venue> get filtered {
    return MockCatalog.venues.where((v) {
      final q = query.trim().toLowerCase();
      final matchesQ = q.isEmpty || v.name.toLowerCase().contains(q) || v.tags.any((t) => t.contains(q));
      final matchesC = category == null || v.category == category;
      return matchesQ && matchesC;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cats = MockCatalog.venues.map((v) => v.category).toSet().toList()..sort();
    return Scaffold(
      appBar: AppBar(title: const Text('Explore')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: 'Find venues, decks, experiences',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: HlTokens.line)),
            ),
            onChanged: (v) => setState(() => query = v),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: const Text('All'),
                    selected: category == null,
                    onSelected: (_) => setState(() => category = null),
                  ),
                ),
                ...cats.map((c) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(c),
                        selected: category == c,
                        onSelected: (_) => setState(() => category = c),
                      ),
                    )),
              ],
            ),
          ),
          const SectionLabel('Spotlight'),
          SizedBox(
            height: 132,
            child: PageView(
              children: MockCatalog.spotlights.map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(colors: [HlTokens.sea, HlTokens.seaDeep]),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(s.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16)),
                          const SizedBox(height: 6),
                          Text(s.subtitle, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withOpacity(0.9))),
                        ],
                      ),
                    ),
                  )).toList(),
            ),
          ),
          const SectionLabel('Venues'),
          ...filtered.map((v) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HlCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${v.deck} · ${v.category}\n${v.blurb}'),
                    isThreeLine: true,
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => VenueDetailScreen(venueId: v.id))),
                  ),
                ),
              )),
          const SectionLabel('Ship tools'),
          _Tool('Deck plans', Icons.map_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DeckPlansScreen()))),
          _Tool('Map & directions', Icons.directions, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapDirectionsScreen()))),
          _Tool('Articles', Icons.menu_book_outlined, () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ArticlesScreen()))),
        ],
      ),
    );
  }
}

class _Tool extends StatelessWidget {
  const _Tool(this.label, this.icon, this.onTap);
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
        leading: Icon(icon, color: HlTokens.sea),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class VenueDetailScreen extends StatelessWidget {
  const VenueDetailScreen({super.key, required this.venueId});
  final String venueId;
  @override
  Widget build(BuildContext context) {
    final v = MockCatalog.venues.firstWhere((e) => e.id == venueId);
    return Scaffold(
      appBar: AppBar(title: Text(v.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftChip(v.category),
                const SizedBox(height: 10),
                DisplayTitle(v.name),
                Text('${v.deck} · ${v.hours}', style: const TextStyle(color: HlTokens.inkSoft)),
                const SizedBox(height: 12),
                Text(v.blurb, style: const TextStyle(height: 1.45, fontSize: 15)),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: v.tags.map(SoftChip.new).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DeckPlansScreen extends StatelessWidget {
  const DeckPlansScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deck plans')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DisplayTitle('MV Aether Dawn'),
                const SizedBox(height: 8),
                const Text('Schematic deck map (demo). Stateroom view highlights midship Deck 9.', style: TextStyle(color: HlTokens.inkSoft)),
                const SizedBox(height: 16),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(colors: [HlTokens.foam, Colors.white, HlTokens.foam.withOpacity(0.5)]),
                    border: Border.all(color: HlTokens.line),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Deck 9 · Stateroom 9241 highlighted', style: TextStyle(fontWeight: FontWeight.w700, color: HlTokens.seaDeep)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MapDirectionsScreen extends StatelessWidget {
  const MapDirectionsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map & directions')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HlCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              DisplayTitle('To Aurora Theater'),
              SizedBox(height: 8),
              Text('From stateroom 9241 · ~6 minutes', style: TextStyle(color: HlTokens.inkSoft)),
              SizedBox(height: 12),
              Text('1. Exit aft elevator bank\n2. Descend to Deck 4\n3. Follow theater promenade signs', style: TextStyle(height: 1.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Articles')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: MockCatalog.articles.map((a) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: HlCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(a.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(a.summary),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ArticleDetailScreen(articleId: a.id))),
                ),
              ),
            )).toList(),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.articleId});
  final String articleId;
  @override
  Widget build(BuildContext context) {
    final a = MockCatalog.articles.firstWhere((e) => e.id == articleId);
    return Scaffold(
      appBar: AppBar(title: const Text('Article')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HlCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DisplayTitle(a.title),
              const SizedBox(height: 12),
              Text(a.body, style: const TextStyle(height: 1.5, fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
