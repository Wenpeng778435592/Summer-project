
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:my_diet_diary/DatabaseHelpers/OpenFoodFactsHelper.dart';

class BarcodeScanPage extends StatefulWidget {
  @override
  _BarcodeScanPageState createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends State<BarcodeScanPage> {
  var openfoodsHelper = new OpenFoodFactsHelper();
  String food = 'Unknown';

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Scan Result',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '$food',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 72),
          RaisedButton(
            color: Colors.amber,
            child: Text('Start Barcode Scan', style: TextStyle(fontSize: 20)),
            onPressed: scanBarcode,
            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30)),
          ),

        ],
      ),
    ),
  );

  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      var foodName = await openfoodsHelper.getFoodFromBarcode(barcode);

      setState(() {
        this.food = foodName;
      });
    } on PlatformException {
      food = 'Failed to get platform version.';
    }
  }
}