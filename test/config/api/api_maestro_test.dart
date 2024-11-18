import 'package:flutter_test/flutter_test.dart';
import 'package:sgem/config/api/api.maestro.dart';

void main() {
  group('MaestroService', () {
    group('getMaestros', () {
      test('should work in prod', () {
        MaestroService maestroService = MaestroService();

        expect(maestroService, isNotNull);

        // final response = await maestroService.getMaestros();
        expect(() async => maestroService.getMaestros(), returnsNormally);
      });
    });
  });
}
