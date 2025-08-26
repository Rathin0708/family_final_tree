import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  test('get_it package is accessible', () {
    final getIt = GetIt.instance;
    expect(getIt, isNotNull);
  });
}
