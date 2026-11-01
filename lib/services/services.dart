import '../data/mock_catalog.dart';
import '../data/models.dart';

/// Core + external facades (mock implementations — no vendor SDKs).
class AuthService {
  bool _signedIn = false;
  bool get isSignedIn => _signedIn;
  Future<void> signInDemo() async => _signedIn = true;
  Future<void> signOut() async => _signedIn = false;
}

class GuestProfileService {
  GuestProfile get profile => MockCatalog.guest;
  void updateDisplayName(String name) => MockCatalog.guest.displayName = name;
}

class AnalyticsService {
  void track(String event, [Map<String, Object?>? props]) {
    // no-op facade (Adobe/AEP-shaped role)
  }
}

class ExperiencePlatform {
  Reservation get activeReservation => MockCatalog.reservation;
}

class WearableBle {
  bool get isConnected => false;
  Future<void> pairDemo() async {}
}

class PaymentsService {
  List<FolioCharge> get charges => MockCatalog.folio;
  double get balance =>
      MockCatalog.folio.fold<double>(0, (sum, c) => sum + c.amount);
  Future<bool> makePayment(double amount) async => true;
}

class HybridWebBridge {
  Future<void> openFlow(String id) async {
    // UI hosts styled hybrid screens; bridge is a seam for later WebViews.
  }
}

class PushMessagingFacade {
  int get unreadApprox => MockCatalog.inbox.length;
}

class ChatFacade {
  List<ChatThread> get threads => MockCatalog.chats;
}

class SupportFacade {
  String get hoursLabel => 'Guest Services · Deck 3 · 24h';
}

class PrivacyConsentFacade {
  bool analyticsAllowed = true;
}

class HarborlineServices {
  HarborlineServices()
      : auth = AuthService(),
        profile = GuestProfileService(),
        analytics = AnalyticsService(),
        experience = ExperiencePlatform(),
        wearable = WearableBle(),
        payments = PaymentsService(),
        hybrid = HybridWebBridge(),
        push = PushMessagingFacade(),
        chat = ChatFacade(),
        support = SupportFacade(),
        privacy = PrivacyConsentFacade();

  final AuthService auth;
  final GuestProfileService profile;
  final AnalyticsService analytics;
  final ExperiencePlatform experience;
  final WearableBle wearable;
  final PaymentsService payments;
  final HybridWebBridge hybrid;
  final PushMessagingFacade push;
  final ChatFacade chat;
  final SupportFacade support;
  final PrivacyConsentFacade privacy;
}
