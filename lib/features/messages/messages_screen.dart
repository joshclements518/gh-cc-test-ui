import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Eyebrow('Inbox'),
                SizedBox(height: 6),
                DisplayTitle('Notifications'),
                SizedBox(height: 4),
                Text('Ship notices, dining, and folio alerts.', style: TextStyle(color: HlTokens.inkSoft)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...MockCatalog.inbox.map((i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HlCard(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(backgroundColor: HlTokens.foam, child: Text(i.kind[0], style: const TextStyle(color: HlTokens.sea, fontWeight: FontWeight.w800))),
                    title: Text(i.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    subtitle: Text('${i.body}\n${i.whenLabel} · ${i.kind}'),
                    isThreeLine: true,
                  ),
                ),
              )),
          const SectionLabel('Onboard chat (mock)'),
          ...MockCatalog.chats.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text(c.preview),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatThreadScreen(threadId: c.id))),
                ),
              )),
          const SectionLabel('Contacts'),
          ...MockCatalog.contacts.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
                  title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${c.relation} · ${c.stateroom}'),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => ContactDetailScreen(contactId: c.id))),
                ),
              )),
        ],
      ),
    );
  }
}

class ChatThreadScreen extends StatelessWidget {
  const ChatThreadScreen({super.key, required this.threadId});
  final String threadId;
  @override
  Widget build(BuildContext context) {
    final t = MockCatalog.chats.firstWhere((e) => e.id == threadId);
    return Scaffold(
      appBar: AppBar(title: Text(t.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SoftChip('Demo chat · provider-shaped facade'),
          const SizedBox(height: 12),
          ...t.messages.map((m) => Align(
                alignment: m.fromMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  constraints: const BoxConstraints(maxWidth: 280),
                  decoration: BoxDecoration(
                    color: m.fromMe ? HlTokens.sea : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: m.fromMe ? null : Border.all(color: HlTokens.line),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(m.text, style: TextStyle(color: m.fromMe ? Colors.white : HlTokens.ink)),
                      const SizedBox(height: 4),
                      Text(m.when, style: TextStyle(color: m.fromMe ? Colors.white70 : HlTokens.inkSoft, fontSize: 11)),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

class ContactDetailScreen extends StatelessWidget {
  const ContactDetailScreen({super.key, required this.contactId});
  final String contactId;
  @override
  Widget build(BuildContext context) {
    final c = MockCatalog.contacts.firstWhere((e) => e.id == contactId);
    return Scaffold(
      appBar: AppBar(title: Text(c.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: HlCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DisplayTitle(c.name),
              const SizedBox(height: 8),
              Text(c.relation, style: const TextStyle(color: HlTokens.inkSoft)),
              Text('Stateroom / location: ${c.stateroom}'),
            ],
          ),
        ),
      ),
    );
  }
}
