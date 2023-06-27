import 'package:flutter_test/flutter_test.dart';

import 'package:encointer_wallet/page-encointer/new_bazaar/logic/businesses_store.dart';
import 'package:encointer_wallet/page-encointer/new_bazaar/widgets/dropdown_widget.dart';
import 'package:encointer_wallet/utils/fetch_status.dart';

void main() {
  late BusinessesStore businessesStore;

  setUp(() => businessesStore = BusinessesStore());

  group('BusinessesStore Test', () {
    test('`getBusinesses()` should update fetchStatus to success and populate businesses list', () async {
      expect(businessesStore.fetchStatus, FetchStatus.loading);
      expect(businessesStore.businesses, isNull);

      await businessesStore.getBusinesses();

      expect(businessesStore.fetchStatus, FetchStatus.success);
      expect(businessesStore.businesses, isNotNull);
      expect(businessesStore.businesses!.length, greaterThan(0));
    });

    test('`getBusinesses()` should filter businesses by category', () async {
      await businessesStore.getBusinesses(category: Category.artAndMusic);

      expect(businessesStore.businesses, isNotNull);
      expect(businessesStore.businesses!.every((business) => business.category == Category.artAndMusic), isTrue);
    });
  });
}