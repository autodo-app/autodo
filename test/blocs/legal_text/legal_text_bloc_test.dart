import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:autodo/blocs/blocs.dart';

class MockAssetBundle extends Mock implements AssetBundle {}

final exampleMd = """
---
layout: page
title: Privacy Policy
permalink: /privacy-policy/
---

Your privacy is important to us and we are committed to protecting it.

This Privacy Policy describes how we collect, use, store, share and protect your information both on our digital platform and with our partners. This Privacy Policy applies when you install the application or access any of the platforms. This document is governed by the terms and conditions set forth in the [Terms of Service](www.autodo.app/terms-and-conditions/).

By creating an account or simply accessing the platform, you expressly agree to the collection, use, disclosure and retention of your information as described in this document. 

## Object

The following Privacy Policy is regarding the **auToDo** mobile and web applications and platforms. These applications and platforms will be henceforth referred to as the **AUTODO APP**.

The individual(s) creating and maintaining the **AUTODO APP** will be henceforth referred to the **DEVELOPERS**. At the time of writing, these individuals consist of:

- Jonathan Bayless
""";

final exampleOutput = RichText(
    text: TextSpan(
        text:
            "Your privacy is important to us and we are committed to protecting it.\n\nThis Privacy Policy describes how we collect, use, store, share and protect your information both on our digital platform and with our partners. This Privacy Policy applies when you install the application or access any of the platforms. This document is governed by the terms and conditions set forth in the Terms of Service.\n\nBy creating an account or simply accessing the platform, you expressly agree to the collection, use, disclosure and retention of your information as described in this document. \n\nObject\n\nThe following Privacy Policy is regarding the auToDo mobile and web applications and platforms. These applications and platforms will be henceforth referred to as the AUTODO APP.\n\nThe individual(s) creating and maintaining the AUTODO APP will be henceforth referred to the DEVELOPERS. At the time of writing, these individuals consist of:\n\n•   Jonathan Bayless\n\n"));

void main() {
  group('LegalBloc', () {
    test('Null Assertion', () {
      expect(() => LegalBloc(bundle: null), throwsAssertionError);
    });
    blocTest('LoadLegal',
        build: () {
          final assetBundle = MockAssetBundle();
          when(assetBundle.loadString('legal/privacy-policy.md'))
              .thenAnswer((_) async => exampleMd);
          return LegalBloc(bundle: assetBundle);
        },
        act: (bloc) async => bloc.add(LoadLegal()),
        expect: [
          LegalNotLoaded(),
          LegalLoading(),
          LegalLoaded(text: exampleOutput)
        ]);
  });
}
