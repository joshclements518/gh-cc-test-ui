import 'package:flutter/material.dart';
import '../../data/mock_catalog.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';
import '../hybrid/hybrid_flows.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final p = state.services.profile.profile;
    final balance = state.services.payments.balance;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Eyebrow('Profile'),
                const SizedBox(height: 6),
                DisplayTitle(p.displayName),
                Text(p.email, style: const TextStyle(color: HlTokens.inkSoft)),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final controller = TextEditingController(text: p.displayName);
                    final next = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Edit name'),
                        content: TextField(controller: controller, decoration: const InputDecoration(labelText: 'Display name')),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                          FilledButton(onPressed: () => Navigator.pop(ctx, controller.text.trim()), child: const Text('Save')),
                        ],
                      ),
                    );
                    if (next != null && next.isNotEmpty) state.updateDisplayName(next);
                  },
                  child: const Text('Edit name'),
                ),
              ],
            ),
          ),
          const SectionLabel('Child permissions'),
          HlCard(
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Ship Wi‑Fi'),
                  value: p.childWifiAllowed,
                  onChanged: state.setChildWifi,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Onboard chat'),
                  value: p.childChatAllowed,
                  onChanged: state.setChildChat,
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Purchases'),
                  value: p.childPurchasesAllowed,
                  onChanged: state.setChildPurchases,
                ),
              ],
            ),
          ),
          const SectionLabel('Wearable'),
          ListTile(
            tileColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
            title: const Text('HarborBand+'),
            subtitle: const Text('Build a band · hybrid demo flow'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HybridFlowScreen(flowId: 'band', title: 'Build a HarborBand+'))),
          ),
          const SectionLabel('Folio'),
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DisplayTitle('\$${balance.toStringAsFixed(2)}'),
                const Text('Current onboard balance', style: TextStyle(color: HlTokens.inkSoft)),
                const SizedBox(height: 12),
                ...MockCatalog.folio.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(child: Text('${c.label}\n${c.when}', style: const TextStyle(height: 1.3))),
                          Text('\$${c.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        ],
                      ),
                    )),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () async {
                    final ok = await state.services.payments.makePayment(balance);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(ok ? 'Payment submitted (demo success)' : 'Payment failed')),
                    );
                  },
                  child: const Text('Make payment'),
                ),
              ],
            ),
          ),
          const SectionLabel('Ship Wi‑Fi'),
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                DisplayTitle('Connect at Sea'),
                SizedBox(height: 8),
                Text('Voyage pass active for 2 devices · streaming add-on available.', style: TextStyle(color: HlTokens.inkSoft)),
                SizedBox(height: 10),
                SoftChip('Day pass · demo'),
              ],
            ),
          ),
          const SectionLabel('Travel services'),
          _Nav('Gratuities', () => _openHybrid(context, 'gratuities', 'Gratuities')),
          _Nav('Insurance', () => _openHybrid(context, 'insurance', 'Travel insurance')),
          _Nav('Ground transport', () => _openHybrid(context, 'ground', 'Ground transport')),
          _Nav('Air details', () => _openHybrid(context, 'air', 'Air details')),
          const SectionLabel('Preferences'),
          HlCard(
            child: Column(
              children: [
                SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Email offers'), value: p.promoEmail, onChanged: state.setPromoEmail),
                SwitchListTile(contentPadding: EdgeInsets.zero, title: const Text('Push offers'), value: p.promoPush, onChanged: state.setPromoPush),
              ],
            ),
          ),
          const SectionLabel('About'),
          const HlCard(
            child: Text('Harborline Navigator 1.0.0\nDemo baseline for AI control-plane Flutter stories.\nIA inspired by docs/examples sitemap/architecture (structure only).'),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => state.signOut(),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  void _openHybrid(BuildContext context, String id, String title) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => HybridFlowScreen(flowId: id, title: title)));
  }
}

class _Nav extends StatelessWidget {
  const _Nav(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: HlTokens.line)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
