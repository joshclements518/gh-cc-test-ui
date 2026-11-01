import 'package:flutter/material.dart';
import '../../services/release_info.dart';

/// Shows live UI tip (local `/healthz`) and API tip (remote API `/healthz`).
class ReleaseTipsBanner extends StatefulWidget {
  const ReleaseTipsBanner({super.key, this.light = false});

  /// When true, use light text (login gradient). Otherwise ink-on-card.
  final bool light;

  @override
  State<ReleaseTipsBanner> createState() => _ReleaseTipsBannerState();
}

class _ReleaseTipsBannerState extends State<ReleaseTipsBanner> {
  late Future<ReleaseTips> _future;

  @override
  void initState() {
    super.initState();
    _future = ReleaseInfo.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final fg = widget.light ? Colors.white : const Color(0xFF1A2B34);
    final muted = widget.light ? Colors.white70 : const Color(0xFF5A6B74);
    final bg = widget.light ? Colors.black.withOpacity(0.22) : const Color(0xFFF0F4F5);
    final border = widget.light ? Colors.white24 : const Color(0xFFD0D8DC);

    return FutureBuilder<ReleaseTips>(
      future: _future,
      builder: (context, snap) {
        final loading = snap.connectionState != ConnectionState.done;
        final tips = snap.data;
        final ui = tips?.uiShort ?? '…';
        final api = tips?.apiShort ?? '…';

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'RELEASE TIPS',
                    style: TextStyle(
                      color: muted,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  if (loading)
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(strokeWidth: 2, color: muted),
                    )
                  else
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.refresh, size: 16, color: muted),
                      onPressed: () => setState(() => _future = ReleaseInfo.fetch()),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'UI  $ui',
                style: TextStyle(
                  color: fg,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'API $api',
                style: TextStyle(
                  color: fg,
                  fontFamily: 'monospace',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (tips?.error != null) ...[
                const SizedBox(height: 6),
                Text(
                  tips!.error!,
                  style: TextStyle(color: muted, fontSize: 10),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
