import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class HybridFlowScreen extends StatefulWidget {
  const HybridFlowScreen({super.key, required this.flowId, required this.title});
  final String flowId;
  final String title;
  @override
  State<HybridFlowScreen> createState() => _HybridFlowScreenState();
}

class _HybridFlowScreenState extends State<HybridFlowScreen> {
  final field = TextEditingController();
  bool done = false;

  String get helper {
    switch (widget.flowId) {
      case 'gratuities':
        return 'Prepay crew gratuities for your stateroom (demo form).';
      case 'insurance':
        return 'Add trip protection details (demo — no purchase).';
      case 'ground':
        return 'Airport transfer preferences for embarkation day.';
      case 'air':
        return 'Airline and arrival time for meet-and-greet planning.';
      case 'band':
        return 'Design your HarborBand+ colorway (hybrid-styled demo).';
      default:
        return 'Demo hybrid flow.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          HlCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SoftChip('Hybrid web-shaped · offline demo'),
                const SizedBox(height: 10),
                DisplayTitle(widget.title),
                const SizedBox(height: 8),
                Text(helper, style: const TextStyle(color: HlTokens.inkSoft, height: 1.4)),
                const SizedBox(height: 16),
                if (!done) ...[
                  TextField(
                    controller: field,
                    decoration: InputDecoration(
                      labelText: widget.flowId == 'band' ? 'Band colorway' : 'Details',
                      hintText: widget.flowId == 'band' ? 'Sea glass / midnight' : 'Sample input',
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        await state.completeHybrid(widget.title);
                        setState(() => done = true);
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ] else ...[
                  const SoftChip('Success'),
                  const SizedBox(height: 8),
                  Text(state.lastHybridResult ?? 'Submitted', style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text('No network call was made — this is a styled hybrid placeholder for demos.', style: TextStyle(color: HlTokens.inkSoft)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
