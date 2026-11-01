import 'package:flutter_test/flutter_test.dart';
import 'package:harborline_navigator/data/mock_catalog.dart';

void main() {
  test('F1 sample data minimums', () {
    expect(MockCatalog.reservation.id.isNotEmpty, isTrue);
    expect(MockCatalog.itinerary.length, greaterThanOrEqualTo(3));
    expect(MockCatalog.venues.length, greaterThanOrEqualTo(8));
    expect(MockCatalog.inbox.length, greaterThanOrEqualTo(5));
    expect(MockCatalog.chats.length, greaterThanOrEqualTo(2));
    expect(MockCatalog.folio.length, greaterThanOrEqualTo(3));
    expect(MockCatalog.guest.displayName.isNotEmpty, isTrue);
  });
}
