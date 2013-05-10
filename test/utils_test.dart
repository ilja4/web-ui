// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/** Tests for some of the utility helper functions used by the compiler. */
library utils_test;

import 'package:unittest/compact_vm_config.dart';
import 'package:unittest/unittest.dart';
import 'package:web_ui/src/utils.dart';

main() {
  useCompactVMConfiguration();

  for (bool startUppercase in [false, true]) {
    Matcher caseEquals(String str) {
      if (startUppercase) str = str[0].toUpperCase()+ str.substring(1);
      return equals(str);
    }

    camelCase(str) => toCamelCase(str, startUppercase: startUppercase);

    group('toCamelCase startUppercase=$startUppercase', () {
      test('empty', () {
        expect(camelCase(''), equals(''));
      });

      test('single token', () {
        expect(camelCase('a'), caseEquals('a'));
        expect(camelCase('ab'), caseEquals('ab'));
        expect(camelCase('Ab'), caseEquals('Ab'));
        expect(camelCase('AB'), caseEquals('AB'));
        expect(camelCase('long_word'), caseEquals('long_word'));
      });

      test('dashes in the middle', () {
        expect(camelCase('a-b'), caseEquals('aB'));
        expect(camelCase('a-B'), caseEquals('aB'));
        expect(camelCase('A-b'), caseEquals('AB'));
        expect(camelCase('long-word'), caseEquals('longWord'));
      });

      test('leading/trailing dashes', () {
        expect(camelCase('-hi'), caseEquals('Hi'));
        expect(camelCase('hi-'), caseEquals('hi'));
        expect(camelCase('hi-friend-'), caseEquals('hiFriend'));
      });

      test('consecutive dashes', () {
        expect(camelCase('--hi-friend'), caseEquals('HiFriend'));
        expect(camelCase('hi--friend'), caseEquals('hiFriend'));
        expect(camelCase('hi-friend--'), caseEquals('hiFriend'));
      });
    });
  }

  test('trimOrCompact', () {
    expect(trimOrCompact('[ b ]'), '[ b ]');
    expect(trimOrCompact('    [ x ]'), ' [ x ]');
    expect(trimOrCompact(' \n [ x ]'), '[ x ]');
    expect(trimOrCompact(' \n [ x ] '), '[ x ] ');
    expect(trimOrCompact(' \n [ x ]    '), '[ x ] ');
    expect(trimOrCompact(' \n [ x ]  \t  '), '[ x ] ');
    expect(trimOrCompact(' \n [ x ]  \r  '), '[ x ] ');
    expect(trimOrCompact(' \n [ x ]  \n  '), '[ x ]');
    expect(trimOrCompact('  [ x ] \n '), ' [ x ]');
    expect(trimOrCompact('  [ x ]  '), ' [ x ] ');
    expect(trimOrCompact(' [ x ] '), ' [ x ] ');
    expect(trimOrCompact('  \t\t   [ x ] \t\t   '), ' [ x ] ');
    expect(trimOrCompact('  \t\t \n  [ x ] \n \t\t   '), '[ x ]');
    expect(trimOrCompact('     '), ' ');
    expect(trimOrCompact('   \t  '), ' ');
    expect(trimOrCompact('   \n  '), '');
    expect(trimOrCompact('   \r  '), ' '); // \r is ignored
    expect(trimOrCompact(''), '');
  });
}
