import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

class HlCard extends StatelessWidget {
  const HlCard({super.key, required this.child, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: HlTokens.card,
        borderRadius: BorderRadius.circular(HlTokens.radiusCard),
        border: Border.all(color: HlTokens.line),
        boxShadow: [
          BoxShadow(
            color: HlTokens.ink.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
    );
  }
}

class Eyebrow extends StatelessWidget {
  const Eyebrow(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.08 * 16,
        color: HlTokens.sea,
      ),
    );
  }
}

class DisplayTitle extends StatelessWidget {
  const DisplayTitle(this.text, {super.key, this.color});
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: color ?? HlTokens.ink,
        height: 1.2,
        letterSpacing: -0.3,
      ),
    );
  }
}

class SoftChip extends StatelessWidget {
  const SoftChip(this.label, {super.key});
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: HlTokens.foam,
        borderRadius: BorderRadius.circular(HlTokens.radiusChip),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: HlTokens.seaDeep,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
