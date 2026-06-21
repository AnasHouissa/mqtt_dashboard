import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/services/tn_phone.dart';

void main() {
  group('TnPhone.normalize — canonicalises user input to +216XXXXXXXX', () {
    test('already canonical', () {
      expect(TnPhone.normalize('+21655101214'), '+21655101214');
    });
    test('with spaces', () {
      expect(TnPhone.normalize('+216 55 101 214'), '+21655101214');
      expect(TnPhone.normalize('  55 101 214 '), '+21655101214');
    });
    test('with dashes', () {
      expect(TnPhone.normalize('+216-55-101-214'), '+21655101214');
    });
    test('00216 international prefix', () {
      expect(TnPhone.normalize('0021655101214'), '+21655101214');
    });
    test('bare 8-digit local number gets +216 prepended', () {
      expect(TnPhone.normalize('55101214'), '+21655101214');
    });
    test('rejects wrong length / junk', () {
      expect(TnPhone.normalize(''), isNull);
      expect(TnPhone.normalize('5510121'), isNull); // 7 digits
      expect(TnPhone.normalize('551012145'), isNull); // 9 digits
      expect(TnPhone.normalize('+33123456789'), isNull); // not Tunisian
      expect(TnPhone.normalize('TEKKIM'), isNull); // alphanumeric
    });
  });

  group('TnPhone.matchKey — tolerant sender matching', () {
    // Every representation of the same subscriber number yields the same key.
    final equivalents = [
      '+21655101214',
      '00216 55 101 214',
      '21655101214',
      '55101214',
      '+216-55-101-214',
    ];

    test('all formats of one number share a key', () {
      final keys = equivalents.map(TnPhone.matchKey).toSet();
      expect(keys, hasLength(1));
      expect(keys.single, '55101214');
    });

    test('a stored +216 number matches a bare-local sender', () {
      final stored = TnPhone.normalize('+21655101214')!; // canonical storage
      expect(TnPhone.matchKey('55101214'), TnPhone.matchKey(stored));
    });

    test('different numbers do not collide', () {
      expect(TnPhone.matchKey('+21655101214'),
          isNot(TnPhone.matchKey('+21655101215')));
    });

    test('alphanumeric / too-short senders never match', () {
      expect(TnPhone.matchKey('TEKKIM'), isNull);
      expect(TnPhone.matchKey('1234'), isNull);
    });
  });
}
