import 'dart:io';

import 'package:flutter/material.dart';
import 'package:keysight_pma/const/appcolors.dart';
import 'package:keysight_pma/const/appfonts.dart';
import 'package:keysight_pma/const/constants.dart';
import 'package:keysight_pma/const/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../cache/appcache.dart';

class DigitalQualityRmaQrCodeScanScreen extends StatefulWidget {
  DigitalQualityRmaQrCodeScanScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DigitalQualityRmaQrCodeScanScreen();
  }
}

class _DigitalQualityRmaQrCodeScanScreen
    extends State<DigitalQualityRmaQrCodeScanScreen> {
  late Barcode result;
  late QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isCameraPause = false;
  bool? isDarkTheme = AppCache.sortFilterCacheDTO!.currentTheme;

  @override
  void initState() {
    super.initState();
    Utils.setFirebaseAnalyticsCurrentScreen(
        Constants.ANALYTICS_DQM_RMA_QRCODE_SCANNER_SCREEN);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            centerTitle: true,
            automaticallyImplyLeading: false,
            backgroundColor: isDarkTheme!
                ? AppColors.serverAppBar()
                : AppColorsLightMode.serverAppBar(),
            title: Text(
              Utils.getTranslated(
                  context, 'dqm_rma_qrcode_scanner_appbar_title')!,
              style: AppFonts.robotoRegular(
                20,
                color: isDarkTheme!
                    ? AppColors.appGrey()
                    : AppColorsLightMode.appGrey(),
                decoration: TextDecoration.none,
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset(isDarkTheme!
                    ? Constants.ASSET_IMAGES + 'close_bttn.png'
                    : Constants.ASSET_IMAGES_LIGHT + 'close_icon.png'),
              ),
            ],
          ),
          body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: _buildQrView(context),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Widget _buildQrView(BuildContext ctx) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 200.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: (ctrl) => _onQRViewCreated(context, ctrl),
      overlay: QrScannerOverlayShape(
          borderColor: AppColors.appGreyDE(),
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null &&
          scanData.code!.length > 0 &&
          !this.isCameraPause) {
        setState(() {
          this.isCameraPause = true;
          Navigator.pop(context, scanData.code);
        });
        controller.pauseCamera();
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    Utils.printInfo('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('The user did not allow camera access')),
      );
    }
  }
}
