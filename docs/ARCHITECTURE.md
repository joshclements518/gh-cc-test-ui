# Harborline Navigator — Architecture

Fictional cruise companion demo for AI control-plane Flutter stories.

## Layers (mapped from control-plane `docs/examples/*-navigator-architecture.png`)

| Reference layer | Baseline module |
| --- | --- |
| Users (iOS / Android) | Flutter project under `app/` (iOS 16+ / modern Android via Flutter defaults) |
| Presentation | `lib/features/*`, `lib/ui/widgets`, `lib/theme` |
| Core frameworks | `lib/services/services.dart` — Auth, GuestProfile, Analytics (no-op), ExperiencePlatform, WearableBle (no-op), Payments, HybridWebBridge |
| Hybrid web | `lib/features/hybrid` + `HybridWebBridge` seam |
| External facades | PushMessaging, Chat, Support, PrivacyConsent (named facades; no vendor SDKs) |

## Data flow

```
UI (features) → AppState → HarborlineServices → MockCatalog
```

Widgets read through services/state; sample content lives in `lib/data/mock_catalog.dart`.

## Layout

```
lib/
  main.dart / app.dart
  theme/          # tokens + ThemeData
  data/           # models + mock catalog
  services/       # mock core + external facades
  state/          # AppState + AppScope
  ui/widgets/     # shared chrome
  features/       # auth, shell, home, plans, explore, messages, account, hybrid
```

## Out of scope

Real client/vendor cruise APIs, Unity AR, real BLE, real payments, vendor SDKs (analytics/messaging/etc.).
