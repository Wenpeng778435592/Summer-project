import 'dart:convert';
import 'package:flutter/services.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'qr_view.dart';


class ScanView extends StatefulWidget {
  ScanView({
    Key key,
    this.callback
  }) : super(key: key);
  final callback;
  @override
  _ScanViewState createState() => new _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  GlobalKey<QrcodeReaderViewState> qrViewKey = GlobalKey();

  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black,
      body: QrcodeReaderView(
        key: qrViewKey,
        onScan: onScan,
        scanBoxRatio: 0.3,
        headerWidget: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: Colors.white)
        ),
      ),
    );
  }

  Future onScan(String data) async {
    print("onScan: ${data}");
    if (data != null && data != "") {
      Navigator.pop(context, data);
    } else {
//      qrViewKey.currentState.startScan();
    }
  }

}