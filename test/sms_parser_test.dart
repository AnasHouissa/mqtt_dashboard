import 'package:flutter_test/flutter_test.dart';
import 'package:mqtt_dash/data/db/database.dart' show SmsValueMode;
import 'package:mqtt_dash/services/sms_parser.dart';

/// Build a body the way it arrives over SMS: NAME on the first line, the
/// content on the next.
String msg(String name, String content) => '$name\n$content';

void main() {
  group('SmsParser.parse — structure', () {
    test('extracts name, topic and raw value (input list)', () {
      final r = SmsParser.parse(msg('Salle_Serveur_2e_ETG', 'WATER ALERT [IN3, IN4]'));
      expect(r.name, 'Salle_Serveur_2e_ETG');
      expect(r.lines, hasLength(1));
      expect(r.lines.single.topic, 'WATER ALERT');
      expect(r.lines.single.rawValue, 'IN3, IN4');
      expect(r.lines.single.min, isNull);
      expect(r.lines.single.max, isNull);
    });

    test('error-code value', () {
      final r = SmsParser.parse(msg('Data_Center_1_K2', 'SENSOR ALERT [Err 111]'));
      expect(r.lines.single.topic, 'SENSOR ALERT');
      expect(r.lines.single.rawValue, 'Err 111');
    });

    test('OK / cleared value', () {
      final r = SmsParser.parse(msg('Salle_Serveur_2e_ETG', 'DOOR ALERT [OK]'));
      expect(r.lines.single.topic, 'DOOR ALERT');
      expect(r.lines.single.rawValue, 'OK');
    });

    test('inline Min - Max prefix (positive bounds)', () {
      final r = SmsParser.parse(
          msg('Data_Center_1_K2', 'Min 23.10 - Max 26.60 TEMP ALERT [21.62]'));
      final line = r.lines.single;
      expect(line.topic, 'TEMP ALERT');
      expect(line.rawValue, '21.62');
      expect(line.min, 23.10);
      expect(line.max, 26.60);
    });

    test('inline Min | Max prefix (negative bounds, integer)', () {
      final r = SmsParser.parse(
          msg('Frigo_NEG_Lab_1', 'Min -1 | Max -15 TEMP ALERT [28.62]'));
      final line = r.lines.single;
      expect(line.topic, 'TEMP ALERT');
      expect(line.rawValue, '28.62');
      expect(line.min, -1);
      expect(line.max, -15);
    });

    test('inline Min | Max prefix (negative bounds, decimal)', () {
      final r = SmsParser.parse(
          msg('Frigo_NEG_Lab_1', 'Min -1.0 | Max -15.0 TEMP ALERT [28.62]'));
      expect(r.lines.single.min, -1.0);
      expect(r.lines.single.max, -15.0);
    });

    test('range on its own line still binds to the following topic line', () {
      final r = SmsParser.parse(
          'Data_Center_1_K2\nMin 23.10 - Max 26.60\nTEMP ALERT [21.62]');
      final line = r.lines.single;
      expect(line.topic, 'TEMP ALERT');
      expect(line.min, 23.10);
      expect(line.max, 26.60);
    });

    test('multiple topic lines under one name', () {
      final r = SmsParser.parse(
          'Salle_Serveur_2e_ETG\nWATER ALERT [IN3, IN4]\nDOOR ALERT [OK]');
      expect(r.lines, hasLength(2));
      expect(r.lines[0].topic, 'WATER ALERT');
      expect(r.lines[1].topic, 'DOOR ALERT');
      // A range must not leak from one topic line to the next.
      expect(r.lines[1].min, isNull);
    });

    test('empty / malformed body', () {
      expect(SmsParser.parse('').isEmpty, isTrue);
      expect(SmsParser.parse('JustAName').isEmpty, isTrue);
    });
  });

  group('SmsParser.toValue', () {
    test('number mode parses the bracket number', () {
      expect(SmsParser.toValue('21.62', SmsValueMode.number), 21.62);
      expect(SmsParser.toValue('28.62', SmsValueMode.number), 28.62);
      expect(SmsParser.toValue('Err 111', SmsValueMode.number), 111);
    });

    test('activeCount counts active inputs, OK -> 0', () {
      expect(SmsParser.toValue('IN1, IN2, IN4', SmsValueMode.activeCount), 3);
      expect(SmsParser.toValue('IN2', SmsValueMode.activeCount), 1);
      expect(SmsParser.toValue('IN1, IN2, IN3, IN4', SmsValueMode.activeCount), 4);
      expect(SmsParser.toValue('OK', SmsValueMode.activeCount), 0);
    });

    test('presence is 1 unless cleared', () {
      expect(SmsParser.toValue('IN1', SmsValueMode.presence), 1);
      expect(SmsParser.toValue('Err 111', SmsValueMode.presence), 1);
      expect(SmsParser.toValue('OK', SmsValueMode.presence), 0);
    });
  });

  group('SmsParser.detectMode', () {
    test('numbers -> number', () {
      expect(SmsParser.detectMode('21.62'), SmsValueMode.number);
      expect(SmsParser.detectMode('-15.0'), SmsValueMode.number);
    });
    test('input lists and OK -> activeCount', () {
      expect(SmsParser.detectMode('IN1, IN2, IN4'), SmsValueMode.activeCount);
      expect(SmsParser.detectMode('IN2'), SmsValueMode.activeCount);
      expect(SmsParser.detectMode('OK'), SmsValueMode.activeCount);
    });
    test('error code -> number', () {
      expect(SmsParser.detectMode('Err 111'), SmsValueMode.number);
    });
  });

  group('SmsParser.activeInputs', () {
    test('extracts input indices from a list', () {
      expect(SmsParser.activeInputs('IN1, IN2, IN4'), {1, 2, 4});
      expect(SmsParser.activeInputs('IN12'), {12});
    });
    test('is case-insensitive and tolerant of spacing', () {
      expect(SmsParser.activeInputs(' in3 ,IN4'), {3, 4});
    });
    test('cleared / non-input values yield an empty set', () {
      expect(SmsParser.activeInputs('OK'), isEmpty);
      expect(SmsParser.activeInputs(''), isEmpty);
      expect(SmsParser.activeInputs('Err 111'), isEmpty);
    });
  });

  group('end-to-end over all real example messages', () {
    // (name, content, expected topic, expected numeric value under the value
    // mode auto-detected from the raw bracket value).
    final cases = <List<Object>>[
      ['Salle_Serveur_2e_ETG', 'WATER ALERT [IN3, IN4]', 'WATER ALERT', 2.0],
      ['Data_Center_1_K2', 'WATER ALERT [IN1, IN2, IN4]', 'WATER ALERT', 3.0],
      ['Data_Center_1_K2', 'SENSOR ALERT [Err 111]', 'SENSOR ALERT', 111.0],
      ['Data_Center_1_K2', 'Min 23.10 - Max 26.60 TEMP ALERT [21.62]', 'TEMP ALERT', 21.62],
      ['Data_Center_1_M2', 'Min 23.10 - Max 26.60 TEMP ALERT [31.62]', 'TEMP ALERT', 31.62],
      ['Data_Center_3_Meg', 'Min 23.10 - Max 26.60 TEMP ALERT [11.62]', 'TEMP ALERT', 11.62],
      ['Salle_Serveur_1er_ETG', 'Min 23.10 - Max 26.60 TEMP ALERT [28.62]', 'TEMP ALERT', 28.62],
      ['Salle_Serveur_1er_ETG', 'WATER ALERT [IN2]', 'WATER ALERT', 1.0],
      ['Salle_Serveur_2e_ETG', 'DOOR ALERT [IN3, IN4]', 'DOOR ALERT', 2.0],
      ['Salle_Serveur_2e_ETG', 'DOOR ALERT [IN1, IN2, IN3, IN4]', 'DOOR ALERT', 4.0],
      ['Frigo_NEG_Lab_1', 'DOOR ALERT [IN1]', 'DOOR ALERT', 1.0],
      ['Frigo_NEG_Lab_1', 'Min -1 | Max -15 TEMP ALERT [28.62]', 'TEMP ALERT', 28.62],
      ['Frigo_NEG_Lab_1', 'Min -1.0 | Max -15.0 TEMP ALERT [28.62]', 'TEMP ALERT', 28.62],
      ['Frigo_POS_Lab_2', 'WATER ALERT [IN1]', 'WATER ALERT', 1.0],
      ['Frigo_POS_Lab_2', 'WATER ALERT [OK]', 'WATER ALERT', 0.0],
      ['Salle_Serveur_2e_ETG', 'DOOR ALERT [OK]', 'DOOR ALERT', 0.0],
    ];

    for (final c in cases) {
      final name = c[0] as String;
      final content = c[1] as String;
      final expectedTopic = c[2] as String;
      final expectedValue = c[3] as double;
      test('$name | $content', () {
        final r = SmsParser.parse(msg(name, content));
        expect(r.name, name);
        final line = r.lines.single;
        expect(line.topic, expectedTopic);
        final mode = SmsParser.detectMode(line.rawValue);
        expect(SmsParser.toValue(line.rawValue, mode), closeTo(expectedValue, 1e-9));
      });
    }
  });
}
