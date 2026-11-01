# Harborline Navigator — UI

## Brand

**Harborline** / ship **Aether of the Seas** — fictional cruise line for control-plane demos.

## Palette (`lib/theme/tokens.dart`)

- Sea deep / sea — primary navigation + accents
- Foam / mist — backgrounds
- Ink / ink soft — typography
- Coral — CTAs and highlights
- Line — borders

## Typography

System typography with strong weight/letter-spacing hierarchy — see `lib/theme/app_theme.dart` (no runtime font fetch).

## Components

- `HlCard`, `SectionLabel`, `Eyebrow`, `DisplayTitle`, `SoftChip`
- Bottom `NavigationBar` with Home · Plans · Explore · Messages · Account
- Hybrid flow screens styled as offline web-shaped forms

## Fidelity bar

Primary tabs and required child routes show rich sample data (itinerary, venues, inbox, folio). No blank “Coming soon” shells on required surfaces.
