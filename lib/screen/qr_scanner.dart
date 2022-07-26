// ignore_for_file: prefer_const_constructors, unused_local_variable, unnecessary_this, import_of_legacy_library_into_null_safe, avoid_print, must_be_immutable, prefer_typing_uninitialized_variables, use_key_in_widget_constructors
import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/detail_tiket.dart';
import 'dart:ui' as ui;
import '../service/api_service.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class QR extends StatefulWidget {
  String type;
  final id;
  final check;
  final notCheck;
  QR({key, this.type, this.id, this.check, this.notCheck});

  @override
  State<QR> createState() => _QRState();
}

class _QRState extends State<QR> {
  final qrkey = GlobalKey(debugLabel: "QR");
  Barcode barcode;
  QRViewController controller;
  String hasil;
  Timer timer;
  final arguments = Get.arguments;
  bool isLoading = false;
  bool connected = true;

  void connection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('connected');
        if (mounted) {
          setState(() {
            connected = true;
          });
        }
      }
    } on SocketException catch (_) {
      // print('not connected');
      if (mounted) {
        setState(() {
          connected = false;
        });
      }
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    controller?.dispose();
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

  void codeScan() {
    setState(() {
      if (barcode == null) {
        hasil = "Scan A Code";
      } else {
        hasil = barcode?.code;
      }
    });
  }

  @override
  void initState() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => connection());
    codeScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..userInteractions = false
      ..dismissOnTap = false;
    controller?.resumeCamera();
    final width = MediaQuery.of(context).size.width;

    final height = Get.height;
    final themeData = Theme.of(context).brightness == ui.Brightness.dark
        ? "DarkTheme"
        : "LightTheme";

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Scan Ticket",
            style: TextStyle(
                color: (hasil == "Invalid Ticket" ||
                        hasil == "Not Ticket For This Event" ||
                        hasil == "No Connection")
                    ? Colors.red
                    : (hasil == "This Ticket Is Not Valid" ||
                            hasil == "Connected")
                        ? Color.fromARGB(255, 255, 193, 59)
                        : (hasil == "Success")
                            ? Color.fromARGB(120, 76, 175, 79)
                            : greenTheme,
                fontWeight: FontWeight.bold,
                fontSize: width / 20),
          ),
          backgroundColor: themeData == "DarkTheme" ? bgDark : Colors.white,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Iconsax.close_circle5,
              color: (hasil == "Invalid Ticket" ||
                      hasil == "Not Ticket For This Event" ||
                      hasil == "No Connection")
                  ? Colors.red
                  : (hasil == "This Ticket Is Not Valid" ||
                          hasil == "Connected")
                      ? Color.fromARGB(255, 255, 193, 59)
                      : (hasil == "Success")
                          ? Color.fromARGB(120, 76, 175, 79)
                          : greenTheme,
            ),
          ),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: [
            buildQrView(context),
            Positioned(
              bottom: 90,
              child: buildResult(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                buildControlButtons(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildResult() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: (hasil == "Invalid Ticket" ||
                hasil == "Not Ticket For This Event" ||
                hasil == "No Connection")
            ? Colors.red
            : (hasil == "This Ticket Is Not Valid" || hasil == "Connected")
                ? Color.fromARGB(255, 255, 193, 59)
                : (hasil == "Success")
                    ? Color.fromARGB(120, 76, 175, 79)
                    : greenTheme,
      ),
      child: Text(
        hasil.toString(),
        style: TextStyle(color: Colors.white),
        maxLines: 3,
      ),
    );
  }

  Widget buildControlButtons() {
    final height = Get.height;
    return Container(
      height: height / 12.5,
      // padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(8),
        color: (hasil == "Invalid Ticket" ||
                hasil == "Not Ticket For This Event" ||
                hasil == "No Connection")
            ? Colors.red
            : (hasil == "This Ticket Is Not Valid" || hasil == "Connected")
                ? Color.fromARGB(255, 255, 193, 59)
                : (hasil == "Success")
                    ? Color.fromARGB(120, 76, 175, 79)
                    : greenTheme,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            icon: FutureBuilder(
              future: controller?.getFlashStatus(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return Icon(
                    snapshot.data ? Icons.flash_on : Icons.flash_off,
                    color: Colors.white,
                  );
                } else {
                  return IconButton(
                    icon: Icon(Icons.flash_off),
                    onPressed: () {
                      GetPlatform.isIOS
                          ? showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text("Fail"),
                                content: Text("You Don't Have Flashlight"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(color: greenTheme),
                                    ),
                                    onPressed: () => Get.back(),
                                  )
                                ],
                              ),
                            )
                          : Dialogs.materialDialog(
                              color: Get.isDarkMode ? bgDark : Colors.white,
                              context: context,
                              title: "Fail",
                              titleAlign: TextAlign.center,
                              titleStyle: TextStyle(
                                fontSize: Get.width / 20,
                                fontFamily: 'popinsemi',
                              ),
                              msg: "You Don't Have Flashlight",
                              msgStyle: TextStyle(color: grayText),
                              actions: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    "Ok",
                                    style: TextStyle(color: greenTheme),
                                  ),
                                ),
                              ],
                            );
                    },
                    color: Colors.white,
                  );
                }
              },
            ),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {});
            },
          )
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrkey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: (hasil == "Invalid Ticket" ||
                  hasil == "Not Ticket For This Event" ||
                  hasil == "No Connection")
              ? Colors.red
              : (hasil == "This Ticket Is Not Valid" || hasil == "Connected")
                  ? Color.fromARGB(255, 255, 193, 59)
                  : (hasil == "Success")
                      ? Color.fromARGB(120, 76, 175, 79)
                      : greenTheme,
          borderRadius: 11,
          borderWidth: 10,
          borderLength: 20,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((bar) {
      setState(() {
        this.barcode = bar;
        // print(bar);
        Timer(Duration(microseconds: 1), () {
          if (connected) {
            EasyLoading.show(
              status: 'loading...',
            );
            checkingCode(bar);
          } else {
            Timer.periodic(
                Duration(seconds: 20), (Timer t) => EasyLoading.dismiss());
            setState(() {
              hasil = "No Connection";
              if (connected) {
                hasil = "Connected";
              }
            });
            Timer(Duration(seconds: 5), () {
              if (mounted) {
                setState(() {
                  hasil = "Scan A Code";
                });
              }
            });
          }
          setState(() {
            isLoading = true;
          });
        });
      });
    });
  }

  void checkingCode(bar) {
    controller?.pauseCamera();
    List vip = [];
    Future ticket;
    ticket = ApiService().singleTicket(bar.code).then((value) {
      ApiService().vip().then((result) {
        if (value["status"] == "error") {
          EasyLoading.dismiss();

          if (mounted) {
            setState(() {
              hasil = "Invalid Ticket";
              isLoading = false;
            });
          }

          Timer(Duration(seconds: 5), () {
            if (mounted) {
              setState(() {
                hasil = "Scan A Code";
              });
            }
          });
        } else {
          EasyLoading.dismiss();
          result["acf"]["ticket_id_vip_list"].map(((e) => vip.add(e))).toList();
          var isVip = vip.where((element) => element["ticket_vip_id"] == bar.code).toList();
           if (isVip.isNotEmpty) {
              EasyLoading.dismiss();
              EasyLoading.dismiss();
                    if (mounted) {
                      setState(() {
                        hasil = "Success";
                        isLoading = true;
                      });
                    }
                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() {
                          hasil = "Scan A Code";
                        });
                      }
                    });
                    Timer(Duration(microseconds: 1), () {
                      Get.off(
                          DetailTiket(
                            id: bar.code,
                            type: "single",
                            idDetail: widget.id,
                            check: widget.check,
                            notCheck: widget.notCheck,
                          ),
                          transition: Transition.circularReveal,
                          arguments: arguments);
                    });
            } else {
              if (value["data"]["WooCommerceEventsBookingDate"] == null ||
                  value["data"]["WooCommerceEventsBookingDate"] == "") {
                if (widget.type != "single") {
                  EasyLoading.dismiss();
                  if (mounted) {
                    setState(() {
                      hasil = "This Ticket Is Not Valid";
                      isLoading = true;
                    });
                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() {
                          hasil = "Scan A Code";
                        });
                      }
                    });
                  }
                } else {
                  EasyLoading.dismiss();
                  if (value["data"]["WooCommerceEventsProductID"].toString() !=
                      widget.id.toString()) {
                    setState(() {
                      hasil = "Not Ticket For This Event";
                      isLoading = true;
                    });
                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() {
                          hasil = "Scan A Code";
                        });
                      }
                    });
                  } else {
                    EasyLoading.dismiss();
                    if (mounted) {
                      setState(() {
                        hasil = "Success";
                        isLoading = true;
                      });
                    }
                    Timer(Duration(seconds: 5), () {
                      if (mounted) {
                        setState(() {
                          hasil = "Scan A Code";
                        });
                      }
                    });
                    Timer(Duration(microseconds: 1), () {
                      // controller!.pauseCamera();
                      Get.off(
                          DetailTiket(
                            id: bar.code,
                            type: widget.type,
                            idDetail: widget.id,
                            check: widget.check,
                            notCheck: widget.notCheck,
                          ),
                          transition: Transition.circularReveal,
                          arguments: arguments);
                    });
                  }
                }
              } else {
                EasyLoading.dismiss();
                if (value["data"]["WooCommerceEventsProductID"].toString() !=
                    widget.id.toString()) {
                  setState(() {
                    hasil = "Not Ticket For This Event";
                    isLoading = true;
                  });
                  Timer(Duration(seconds: 5), () {
                    if (mounted) {
                      setState(() {
                        hasil = "Scan A Code";
                      });
                    }
                  });
                } else {
                  EasyLoading.dismiss();

                  if (mounted) {
                    setState(() {
                      hasil = "Success";
                      isLoading = true;
                    });
                  }
                  Timer(Duration(seconds: 5), () {
                    if (mounted) {
                      setState(() {
                        hasil = "Scan A Code";
                      });
                    }
                  });
                  Timer(Duration(microseconds: 1), () {
                    // controller!.pauseCamera();
                    Get.off(
                        DetailTiket(
                          id: bar.code,
                          type: widget.type,
                          idDetail: widget.id,
                          check: widget.check,
                          notCheck: widget.notCheck,
                        ),
                        transition: Transition.circularReveal,
                        arguments: arguments);
                  });
                }
              }
            }
        }
      });
    });
  }
}
