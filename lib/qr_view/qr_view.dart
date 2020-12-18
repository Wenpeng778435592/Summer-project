import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_qr_reader/flutter_qr_reader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui';
import 'dart:io' show Platform;
// import 'package:flutter_screenutil/screenutil.dart';
import 'dart:math';
// import 'package:mido/common/sound/playBtnSound.dart';
import 'dart:io';

/// to use the permissions that already get
/// Relevant privileges must be obtained before use
class QrcodeReaderView extends StatefulWidget {
  final Widget headerWidget;
  final Future Function(String) onScan;
  final double scanBoxRatio;
  final Color boxLineColor;
  final Widget helpWidget;
  QrcodeReaderView({
    Key key,
    @required this.onScan,
    this.headerWidget,
    this.boxLineColor = Colors.cyanAccent,
    this.helpWidget,
    this.scanBoxRatio = 0.85,
  }) : super(key: key);

  @override
  QrcodeReaderViewState createState() => new QrcodeReaderViewState();
}

/// operations after scanning the bar code
/// ```dart
/// GlobalKey<QrcodeReaderViewState> qrViewKey = GlobalKey();
/// qrViewKey.currentState.startScan();
/// ```
class QrcodeReaderViewState extends State<QrcodeReaderView>
        with TickerProviderStateMixin,WidgetsBindingObserver {
  QrReaderViewController _controller;
  AnimationController _animationController;
  ScannerController _scannerController;
  ///
  /// the state of camera apply
  bool _permissionStatusCamera = false;

  bool openFlashlight;
  Timer _timer;
  @override
  void initState() {
    super.initState();
    openFlashlight = false;
        _initAnimation();

    WidgetsBinding.instance.addObserver(this);

  }

  void _setupScannerController() async {
    _scannerController = ScannerController(
      scannerResult: (String result) {
        setState(
              () {
            /*
            to solve the result of scanning bar code
             */
                _onQrBack(result);
          },
        );
      },
      /*
      to solve after the widgets are created
       */
      scannerViewCreated: () {
       /*
        begin to scan
         */
        _startCameraWithPreviewWithCheckPermission();

      },
    );
  }

  bool _cameraGranted() {
    print("_permissionStatusCamera:$_permissionStatusCamera");
    return  _permissionStatusCamera;
  }

  ///
  /// this function can only show when the page first time pop up and can be recalled when the screen is light on/off
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState:${state}");
    /*
    lifecycle
     */
    if (state == AppLifecycleState.resumed) {
      /*
      when the screen is light off, this function can be recalled, when the page is first time created, it can not be recalled.
       */
      _startCameraPreviewWithPermissionCheck();
    } else if (state == AppLifecycleState.paused) {
      /*
      when the screen is light off, it can be recalled, and when the page is destroyed, it can not be recalled.
       */
      _stopCameraPreviewWithPermissionCheck();
    } else {
      /*
      Do nothing！
       */
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    super.deactivate();
    /*
    recalled when jump to next A page
    recalled when return from last A page
     */
    print("deactivate");
    /*
    switch：Camera open state, camera preview state
     */
    _toggleCameraPreviewWithCheckPermission();
  }

  @override
  void dispose() {
    /*
    Release.
     */
    print("dispose");
    _clearAnimation();
    _stopCameraPreviewWithPermissionCheck();
    _stopCameraWithPermissionCheck();
    _scannerController = null;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  _toggleCameraPreviewWithCheckPermission() {
    if (_cameraGranted()) {
      if (_scannerController.isStartCameraPreview) {
        _scannerController.stopCameraPreview();
      } else {
        _scannerController.startCameraPreview();
      }
    }
  }

  _startCameraWithPreviewWithCheckPermission() {
    /*
    Open the camera and preview
    */
//    if (_cameraGranted()) {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        //if is run on ios device, should have a delay to open the camera
        Future.delayed(Duration(milliseconds: 100), () {
          print("Open the camera");
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
//    }
  }

  _startCameraPreviewWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.startCameraPreview();
    }
  }

  _stopCameraPreviewWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.stopCameraPreview();
    }
  }

  _stopCameraWithPermissionCheck() {
    if (_cameraGranted()) {
      _scannerController.stopCamera();
    }
  }


  // bool _isOpenFlashWithCheckPermission() {
  //   if (_cameraGranted()) {
  //     return _scannerController.isOpenFlash;
  //   } else {
  //     return false;
  //   }
  // }


  void _initAnimation() {
    setState(() {
      _animationController = AnimationController(
              vsync: this, duration: Duration(milliseconds: 1000));
    });
    _animationController
      ..addListener(_upState)
      ..addStatusListener((state) {
        if (state == AnimationStatus.completed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.reverse(from: 1.0);
          });
        } else if (state == AnimationStatus.dismissed) {
          _timer = Timer(Duration(seconds: 1), () {
            _animationController?.forward(from: 0.0);
          });
        }
      });
    _animationController.forward(from: 0.0);
  }

  void _clearAnimation() {
    _timer?.cancel();
    if (_animationController != null) {
      _animationController?.dispose();
      _animationController = null;
    }
  }

  void _upState() {
    setState(() {});
  }


  bool isScan = false;
  Future _onQrBack(data, [_]) async {
    if (isScan == true) return;
    isScan = true;
    // stopScan();
    await widget.onScan(data);
  }

//  void startScan() {
//    isScan = false;
//    _controller.startCamera(_onQrBack);
//    _initAnimation();
//  }
//
//  void stopScan() {
//    _clearAnimation();
//    _controller.stopCamera();
//  }

  void _onCreateController(QrReaderViewController controller) async {
    _controller = controller;
    _controller.startCamera(_onQrBack);
  }

  Future<bool> setFlashlight() async {
    openFlashlight = await _controller.setFlashlight();
    setState(() {});
    return openFlashlight;
  }

  Future _scanImage() async {
//    stopScan();
    print("Open the photos");
    var pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    File image = File(pickedFile.path);
    final res = await FlutterQrReader.imgScan(image);
    await widget.onScan(res);
  }

  @override
  Widget build(BuildContext context) {

    _setupScannerController();
    return Material(
      color: Colors.black54,
      child: LayoutBuilder(builder: (context, constraints) {
        final qrScanSize = constraints.maxWidth * widget.scanBoxRatio;
        final mediaQuery = MediaQuery.of(context);
        if (constraints.maxHeight < qrScanSize * 1.5) {
          // print("Suggest the ratio of height and scan area height is more than 1.5");
        }

        Size size = window.physicalSize;
        double screenWidth = size.width / window.devicePixelRatio;
        double screenHeight = size.height / window.devicePixelRatio;

        return Stack(
          children: <Widget>[
            if (Platform.isIOS) (
              Container(
                alignment: Alignment.center,
                child: Container(
                  color: Colors.black54,
                  width: screenHeight,
                  height: screenWidth,
                  
                  child: PlatformAiBarcodeScannerWidget(
                    platformScannerController: _scannerController,
                    unsupportedDescription:
                    "Hello this is your custom text about unsupported platform tip",
                  ),
                )  
              )
            ) else (
              Transform.rotate(
                angle: - math.pi / 2,
                // child: SizedBox(
                //   width: screenWidth,
                //   height: screenHeight,
                  child: QrReaderView(
                    width: screenWidth,
                    height: screenHeight,
                    callback: _onCreateController,
                  ),
                // ),
              )
            ),
           if (widget.headerWidget != null) widget.headerWidget,
        //      if(Platform.isIOS)(
             Positioned(
               left: (constraints.maxWidth - qrScanSize) / 2,
               top: (constraints.maxHeight - qrScanSize) * 0.333333,
               child: CustomPaint(
                 painter: QrScanBoxPainter(
                   boxLineColor: widget.boxLineColor,
                   animationValue: _animationController?.value ?? 0,
                   isForward:
                   _animationController?.status == AnimationStatus.forward,
                 ),
                 child: SizedBox(
                   width: qrScanSize,
                   height: qrScanSize,
                 ),
               ),
             ),
        // ),
        //     if(Platform.isIOS)(
             Positioned(
               top: (constraints.maxHeight - qrScanSize) * 0.333333 +
                       qrScanSize +
                       24,
               width: constraints.maxWidth,
               child: Align(
                 alignment: Alignment.center,
                 child: DefaultTextStyle(
                   style: TextStyle(color: Colors.white),
                   child: widget.helpWidget ?? Text("Please put the bar code on the scan area"),
                 ),
               ),
             ),
        // ),

            Positioned(
              width: constraints.maxWidth,
              bottom: constraints.maxHeight == mediaQuery.size.height
                      ? 12 + mediaQuery.padding.top
                      : 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: _scanImage,
                    child: Container(
                      width: 45,
                      height: 45,
                      alignment: Alignment.center,
                      child: Image.asset(
                        "assets/tool_img.png",
                        package: "flutter_qr_reader",
                        width: 25,
                        height: 25,
                        color: Colors.white54,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      border: Border.all(color: Colors.white30, width: 12),
                    ),
                    alignment: Alignment.center,
                    child: Image.asset(
                      "assets/tool_qrcode.png",
                      package: "flutter_qr_reader",
                      width: 35,
                      height: 35,
                      color: Colors.white54,
                    ),
                  ),
                  SizedBox(width: 45, height: 45),
                ],
              ),
            )
          ],
        );
      }),
    );
  }

}

class QrScanBoxPainter extends CustomPainter {
  final double animationValue;
  final bool isForward;
  final Color boxLineColor;

  QrScanBoxPainter(
          {@required this.animationValue,
            @required this.isForward,
            this.boxLineColor})
          : assert(animationValue != null),
            assert(isForward != null);

  @override
  void paint(Canvas canvas, Size size) {
    final borderRadius = BorderRadius.all(Radius.circular(12)).toRRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
    );
    canvas.drawRRect(
      borderRadius,
      Paint()
        ..color = Colors.white54
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    final path = new Path();
    // leftTop
    path.moveTo(0, 50);
    path.lineTo(0, 12);
    path.quadraticBezierTo(0, 0, 12, 0);
    path.lineTo(50, 0);
    // rightTop
    path.moveTo(size.width - 50, 0);
    path.lineTo(size.width - 12, 0);
    path.quadraticBezierTo(size.width, 0, size.width, 12);
    path.lineTo(size.width, 50);
    // rightBottom
    path.moveTo(size.width, size.height - 50);
    path.lineTo(size.width, size.height - 12);
    path.quadraticBezierTo(
            size.width, size.height, size.width - 12, size.height);
    path.lineTo(size.width - 50, size.height);
    // leftBottom
    path.moveTo(50, size.height);
    path.lineTo(12, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - 12);
    path.lineTo(0, size.height - 50);

    canvas.drawPath(path, borderPaint);

    canvas.clipRRect(
            BorderRadius.all(Radius.circular(12)).toRRect(Offset.zero & size));

    // draw horizontal grid
    final linePaint = Paint();
    final lineSize = size.height * 0.45;
    final leftPress = (size.height + lineSize) * animationValue - lineSize;
    linePaint.style = PaintingStyle.stroke;
    linePaint.shader = LinearGradient(
      colors: [Colors.transparent, boxLineColor],
      begin: isForward ? Alignment.topCenter : Alignment(0.0, 2.0),
      end: isForward ? Alignment(0.0, 0.5) : Alignment.topCenter,
    ).createShader(Rect.fromLTWH(0, leftPress, size.width, lineSize));
    for (int i = 0; i < size.height / 5; i++) {
      canvas.drawLine(
        Offset(
          i * 5.0,
          leftPress,
        ),
        Offset(i * 5.0, leftPress + lineSize),
        linePaint,
      );
    }
    for (int i = 0; i < lineSize / 5; i++) {
      canvas.drawLine(
        Offset(0, leftPress + i * 5.0),
        Offset(
          size.width,
          leftPress + i * 5.0,
        ),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(QrScanBoxPainter oldDelegate) =>
          animationValue != oldDelegate.animationValue;

  @override
  bool shouldRebuildSemantics(QrScanBoxPainter oldDelegate) =>
          animationValue != oldDelegate.animationValue;
}
