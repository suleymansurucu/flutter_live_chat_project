import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_projects/common_widget/widget_response_for_platform.dart';

class AlertDialogResponseForPlatform extends WidgetResponseForPlatform {
  final String baslik;
  final String icerik;
  final String anaButonYazisi;
  final String iptalButonYazisi;

  AlertDialogResponseForPlatform(
      {required this.baslik,
        required this.icerik,
        required this.anaButonYazisi,
        required this.iptalButonYazisi});

  Future<bool?> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context, builder: (context) => this)
        : await showDialog<bool>(
        context: context,
        builder: (context) => this,
        barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final tumButonlar = <Widget>[];

    if (Platform.isIOS) {
      if (iptalButonYazisi != null) {
        tumButonlar.add(
          CupertinoDialogAction(
            child: Text(iptalButonYazisi),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      tumButonlar.add(
        CupertinoDialogAction(
          child: Text(anaButonYazisi),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (iptalButonYazisi != null) {
        tumButonlar.add(
          ElevatedButton(
            child: Text(iptalButonYazisi),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      tumButonlar.add(
        ElevatedButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return tumButonlar;
  }
}