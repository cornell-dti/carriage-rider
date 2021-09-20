import 'package:carriage_rider/utils/Ordinal.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Ordinal function returns correct strings', () {
    // tests from 1 to 31 because we use ordinal for days in dates
    List<String> ordinals = [
      '1st',
      '2nd',
      '3rd',
      '4th',
      '5th',
      '6th',
      '7th',
      '8th',
      '9th',
      '10th',
      '11th',
      '12th',
      '13th',
      '14th',
      '15th',
      '16th',
      '17th',
      '18th',
      '19th',
      '20th',
      '21st',
      '22nd',
      '23rd',
      '24th',
      '25th',
      '26th',
      '27th',
      '28th',
      '29th',
      '30th',
      '31st'
    ];

    for (int i = 1; i <= 31; i++) {
      expect(ordinal(i), ordinals[i - 1]);
    }
  });
}
