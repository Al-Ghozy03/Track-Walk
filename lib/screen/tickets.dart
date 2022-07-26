// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_unnecessary_containers, non_constant_identifier_names, unused_local_variable, curly_braces_in_flow_control_structures, must_be_immutable, deprecated_member_use, avoid_print, unnecessary_new, unred_type_equality_checks, use_key_in_widget_constructors

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:track_walk_admin/colors.dart';
import 'package:track_walk_admin/screen/detail_tiket.dart';
import 'package:track_walk_admin/screen/qr_scanner.dart';
import '../service/api_service.dart';
import '../widget/check_icons.dart';
import '../widget/custom_shimmer.dart';

class Ticket extends StatefulWidget {
  String type;
  String id;
  String img;
  Ticket({key, this.id, this.img, this.type});

  @override
  State<Ticket> createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  int activeIndexFilter = 0;
  int activeIndexSort = 0;
  Future ticket;
  Future detail;
  String keyword = "";
  final arguments = Get.arguments;
  List data = [];
  List dataDetail = [];
  int checkedIn = 0;
  int notCheckedIn = 0;

  void dialogDetails() {
    widget.type != "single"
        ? showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Get.isDarkMode ? bgDark : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(MediaQuery.of(context).size.width / 20),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width / 20))),
            context: context,
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width / 15),
                  child: FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Text("loading");
                      if (snapshot.hasError) return Text("error");
                      if (snapshot.hasData) {
                        List data = snapshot.data
                            .where((e) =>
                                e["WooCommerceEventsProductID"] == widget.id)
                            .toList();
                        return Column(
                          children: data.asMap().entries.map((e) {
                            List value =
                                e.value["WooCommerceEventsBookingOptions"][
                                    e.value["WooCommerceEventsBookingOptionIDs"]
                                        [0]]["add_date_ids"];
                            var time =
                                e.value["WooCommerceEventsBookingOptions"][
                                    e.value["WooCommerceEventsBookingOptionIDs"]
                                        [0]]["add_date"];

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Details",
                                      style: TextStyle(
                                          fontSize: width / 15,
                                          fontFamily: "popinsemi"),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        icon: Icon(Iconsax.close_circle))
                                  ],
                                ),
                                SizedBox(height: width / 40),
                                Text(arguments[0]),
                                SizedBox(height: width / 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Location",
                                      style: TextStyle(color: grayText),
                                    ),
                                    SizedBox(width: width / 15),
                                    Flexible(
                                        child: Text(e.value[
                                            "WooCommerceEventsLocation"])),
                                  ],
                                ),
                                SizedBox(height: width / 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Time Zone",
                                      style: TextStyle(color: grayText),
                                    ),
                                    SizedBox(width: width / 25),
                                    Flexible(
                                        child: Text(e.value[
                                            "WooCommerceEventsTimeZone"])),
                                  ],
                                ),
                                SizedBox(height: width / 20),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Slots",
                                      style: TextStyle(color: grayText),
                                    ),
                                    SizedBox(width: width / 7),
                                    Flexible(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.value["WooCommerceEventsBookingOptions"][e
                                                          .value[
                                                      "WooCommerceEventsBookingOptionIDs"]
                                                  [0]]["label"]
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: "popinsemi"),
                                        ),
                                        Column(
                                          children:
                                              value.asMap().entries.map((j) {
                                            return Row(
                                              children: [
                                                Text(
                                                  time[j.value.toString()]
                                                      ["date"],
                                                  style: TextStyle(
                                                      color: grayText),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                      left: width / 40),
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: width / 50,
                                                      vertical: width / 100),
                                                  decoration: BoxDecoration(
                                                      color: greenTheme,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              width)),
                                                  child: Text(
                                                    "10/10",
                                                    style: TextStyle(
                                                        fontSize: width / 50,
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            );
                                          }).toList(),
                                        )
                                      ],
                                    )),
                                  ],
                                ),
                              ],
                            );
                          }).toList(),
                        );
                      }
                      return Text("kosong");
                    },
                    future: detail,
                  ),
                ),
              );
            },
          )
        : showModalBottomSheet(
            isScrollControlled: true,
            backgroundColor: Get.isDarkMode ? bgDark : Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft:
                        Radius.circular(MediaQuery.of(context).size.width / 20),
                    topRight: Radius.circular(
                        MediaQuery.of(context).size.width / 20))),
            context: context,
            builder: (context) {
              final width = MediaQuery.of(context).size.width;
              final height = MediaQuery.of(context).size.height;
              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(width / 15),
                  child: FutureBuilder(
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return Text("loading");
                      if (snapshot.hasError) return Text("error");
                      if (snapshot.hasData) {
                        List data = snapshot.data
                            .where((e) =>
                                e["WooCommerceEventsProductID"] == widget.id)
                            .toList();
                        print(data[0]);
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Details",
                                  style: TextStyle(
                                      fontSize: width / 15,
                                      fontFamily: "popinsemi"),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: Icon(Iconsax.close_circle))
                              ],
                            ),
                            SizedBox(height: width / 40),
                            Text(
                              arguments[0],
                              style: TextStyle(
                                  fontSize: width / 22,
                                  fontFamily: "popinsemi"),
                            ),
                            SizedBox(height: width / 20),
                            Container(
                              // height: 5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CheckIcon(
                                        width: width,
                                        color: Colors.green,
                                        jumlah: checkedIn,
                                        title: "Checked In",
                                      ),
                                      SizedBox(
                                        height: width / 30,
                                      ),
                                      CheckIcon(
                                        width: width,
                                        color: Colors.grey,
                                        jumlah: notCheckedIn,
                                        title: "Not Checked In",
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: width / 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "When",
                                  style: TextStyle(color: grayText),
                                ),
                                SizedBox(width: width / 5.5),
                                Flexible(
                                    child:
                                        Text(data[0]["WooCommerceEventsDate"])),
                              ],
                            ),
                            SizedBox(height: width / 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time",
                                  style: TextStyle(color: grayText),
                                ),
                                SizedBox(width: width / 5),
                                Flexible(
                                    child: Text(
                                        "${data[0]["WooCommerceEventsHour"]}:${data[0]["WooCommerceEventsMinutes"]} - ${data[0]["WooCommerceEventsHourEnd"]}:${data[0]["WooCommerceEventsMinutesEnd"]}")),
                              ],
                            ),
                            SizedBox(height: width / 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Where",
                                  style: TextStyle(color: grayText),
                                ),
                                SizedBox(width: width / 6),
                                Flexible(
                                    child: Text(
                                        data[0]["WooCommerceEventsLocation"])),
                              ],
                            ),
                            SizedBox(height: width / 20),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Time Zone",
                                  style: TextStyle(color: grayText),
                                ),
                                SizedBox(width: width / 10),
                                Flexible(
                                    child: Text(
                                        data[0]["WooCommerceEventsTimeZone"])),
                              ],
                            ),
                            SizedBox(height: width / 20),
                          ],
                        );
                      }
                      return Text("kosong");
                    },
                    future: detail,
                  ),
                ),
              );
            });
  }

  void modalFilter() {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Get.isDarkMode ? bgDark : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(MediaQuery.of(context).size.width / 20),
              topRight:
                  Radius.circular(MediaQuery.of(context).size.width / 20))),
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(width / 15),
            child: StatefulBuilder(
              builder: (context, StateSetter stateSetter) {
                List filter = [
                  "All Tickets",
                  "One-day Tickets",
                  "Bookable Tickets"
                ];
                List sort = [
                  "Ticket Name : A-Z",
                  "Ticket Name : Z-A",
                ];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Filter",
                        style: TextStyle(
                            fontSize: width / 15, fontFamily: "popinsemi")),
                    SizedBox(height: width / 20),
                    Wrap(
                      children: filter
                          .asMap()
                          .entries
                          .map((data) => Container(
                              margin: EdgeInsets.only(right: width / 40),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          activeIndexFilter == data.key
                                              ? blueThemeOpacity
                                              : null,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                                  activeIndexFilter == data.key
                                                      ? greenTheme
                                                      : grayText),
                                          borderRadius:
                                              BorderRadius.circular(width))),
                                  onPressed: () {
                                    stateSetter(() {
                                      activeIndexFilter = data.key;
                                    });
                                    setState(() {});
                                  },
                                  child: Text(
                                    data.value,
                                    style: TextStyle(
                                        color: activeIndexFilter == data.key
                                            ? greenTheme
                                            : grayText,
                                        fontSize: width / 25,
                                        fontFamily:
                                            activeIndexFilter == data.key
                                                ? "popinsemi"
                                                : "popin"),
                                  ))))
                          .toList(),
                    ),
                    SizedBox(height: width / 20),
                    Text("Sort",
                        style: TextStyle(
                            fontSize: width / 15, fontFamily: "popinsemi")),
                    SizedBox(height: width / 20),
                    Wrap(
                      children: sort
                          .asMap()
                          .entries
                          .map((value) => Container(
                              margin: EdgeInsets.only(right: width / 40),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                      elevation: 0,
                                      backgroundColor:
                                          activeIndexSort == value.key
                                              ? blueThemeOpacity
                                              : null,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(
                                              color:
                                                  activeIndexSort == value.key
                                                      ? greenTheme
                                                      : grayText),
                                          borderRadius:
                                              BorderRadius.circular(width))),
                                  onPressed: () {
                                    stateSetter(() {
                                      activeIndexSort = value.key;
                                    });
                                    setState(() {
                                      if (activeIndexSort == 0) {
                                        data.sort(
                                          (a, b) => a["customerFirstName"]
                                              .toString()
                                              .toLowerCase()
                                              .compareTo(b["customerFirstName"]
                                                  .toString()
                                                  .toLowerCase()),
                                        );
                                      } else {
                                        data.sort(
                                          (a, b) => b["customerFirstName"]
                                              .toString()
                                              .toLowerCase()
                                              .compareTo(a["customerFirstName"]
                                                  .toString()
                                                  .toLowerCase()),
                                        );
                                      }
                                    });
                                  },
                                  child: Text(
                                    value.value,
                                    style: TextStyle(
                                        color: activeIndexSort == value.key
                                            ? greenTheme
                                            : grayText,
                                        fontSize: width / 25,
                                        fontFamily: activeIndexSort == value.key
                                            ? "popinsemi"
                                            : "popin"),
                                  ))))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void navigateToDetail(List values, int i) {
    Get.to(
            () => DetailTiket(
                  id: values[i]["WooCommerceEventsTicketID"],
                  type: widget.type,
                  idDetail: widget.id,
                  check: checkedIn,
                  notCheck: notCheckedIn,
                ),
            transition: Transition.rightToLeft,
            arguments: arguments)
        ?.then((value) {
      ticket = ApiService().ticket(widget.id);
      ticket.then((value) {
        setState(() {
          data = value;
          var filter = arguments[1].runtimeType != DateTime
              ? data.where((element) {
                  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element[
                              "WooCommerceEventsBookingDateTimestamp"]) *
                          1000);
                  return DateFormat.yMEd().format(timestamp) ==
                          DateFormat.yMEd().format(DateTime.now()) &&
                      (element["WooCommerceEventsAttendeeName"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()) ||
                          element["customerFirstName"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()) ||
                          element["customerFirstName"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()));
                }).toList()
              : data.where((element) {
                  DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
                      int.parse(element[
                              "WooCommerceEventsBookingDateTimestamp"]) *
                          1000);
                  return DateFormat.yMEd().format(timestamp) ==
                          DateFormat.yMEd().format(arguments[1]) &&
                      (element["WooCommerceEventsAttendeeName"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()) ||
                          element["customerFirstName"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()) ||
                          element["WooCommerceEventsTicketID"]
                              .toLowerCase()
                              .toString()
                              .contains(keyword.toLowerCase()));
                }).toList();
        });
      });
    });
  }

  void refresh() {
    setState(() {
      ticket = ApiService().ticket(widget.id);
      ticket.then((value) {
        data = value;
      });
    });
  }

  @override
  void initState() {
    ticket = ApiService().ticket(widget.id);
    detail = ApiService().event();
    ticket.then((value) {
      setState(() {
        data = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var filter = widget.type == "single"
        ? data.where((element) {
            DateTime bookingDate = DateTime.fromMillisecondsSinceEpoch(
                int.parse(element["WooCommerceEventsBookingDateTimestamp"]) *
                    1000);
            return (element["customerFirstName"]
                        .toString()
                        .toLowerCase()
                        .contains(keyword.toLowerCase()) ||
                    element["WooCommerceEventsAttendeeName"]
                        .toString()
                        .toLowerCase()
                        .contains(keyword.toLowerCase())) &&
                (bookingDate.day == DateTime.now().day &&
                    bookingDate.month == DateTime.now().month &&
                    bookingDate.year == DateTime.now().year);
          }).toList()
        : data.where((element) {
            DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(
                int.parse(element["WooCommerceEventsBookingDateTimestamp"]) *
                    1000);
            return DateFormat.yMEd().format(timestamp) ==
                    DateFormat.yMEd().format(arguments[1]) &&
                element["WooCommerceEventsBookingDate"] != "" &&
                (element["WooCommerceEventsAttendeeName"]
                        .toLowerCase()
                        .toString()
                        .contains(keyword.toLowerCase()) ||
                    element["customerFirstName"]
                        .toLowerCase()
                        .toString()
                        .contains(keyword.toLowerCase()) ||
                    element["WooCommerceEventsTicketID"]
                        .toLowerCase()
                        .toString()
                        .contains(keyword.toLowerCase()));
          }).toList();
    final width = Get.width;
    final height = Get.height;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(width / 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(GetPlatform.isIOS
                          ? Icons.arrow_back_ios_rounded
                          : Iconsax.arrow_left)),
                  SizedBox(height: width / 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width / 4,
                        height: width / 4,
                        decoration: BoxDecoration(
                          color: grayText,
                          borderRadius: BorderRadius.circular(width / 30),
                          image: DecorationImage(
                            image: NetworkImage(widget.img),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: width / 20,
                      ),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              arguments[0],
                              style: TextStyle(
                                  fontSize: width / 18,
                                  fontFamily: "popinsemi"),
                            ),
                            Text(
                              widget.type == "single"
                                  ? "${DateFormat.d().format(DateTime.now())} ${DateFormat.MMMM().format(DateTime.now())} ${DateFormat.y().format(DateTime.now())}"
                                  : "${DateFormat.d().format(arguments[1])} ${DateFormat.MMMM().format(arguments[1])} ${DateFormat.y().format(arguments[1])}",
                              style: TextStyle(
                                  fontSize: width / 27, color: grayText),
                            ),
                            InkWell(
                              onTap: () {
                                dialogDetails();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Expand Details",
                                    style: TextStyle(fontSize: width / 27),
                                  ),
                                  Icon(Iconsax.arrow_down_1, size: width / 22)
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width / 20),
                  _searchBar(width, height),
                  SizedBox(height: width / 15),
                  FutureBuilder(
                    future: ticket,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState != ConnectionState.done)
                        return _loadingState(width, height);
                      if (snapshot.hasError)
                        return Column(
                          children: [
                            LottieBuilder.asset(
                                "assets/json/94992-error-404.json"),
                            Text(
                              "Ooops, something went wrong",
                              style: TextStyle(
                                  fontFamily: "popinsemi",
                                  fontSize: width / 17),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "Please check your internet connection",
                              style: TextStyle(color: grayText),
                            )
                          ],
                        );
                      if (snapshot.hasData) {
                        List checked = snapshot.data
                            .where((e) =>
                                e["WooCommerceEventsStatus"] == "Checked In")
                            .toList();
                        List notChecked = snapshot.data
                            .where((e) =>
                                e["WooCommerceEventsStatus"] ==
                                "Not Checked In")
                            .toList();
                        checkedIn = checked.length;
                        notCheckedIn = notChecked.length;
                        return _listBuilder(width, height, filter);
                      } else {
                        return Text("kosong");
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
      bottomNavigationBar: Container(
        height: height / 12.5,
        width: width,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary: greenTheme,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
            onPressed: () {
              Get.to(
                  () => QR(
                        type: widget.type,
                        id: widget.id,
                        check: checkedIn,
                        notCheck: notCheckedIn,
                      ),
                  transition: Transition.circularReveal,
                  arguments: arguments);
            },
            child: Icon(Icons.qr_code_scanner, size: width / 10)),
      ),
    );
  }

  Widget _loadingState(width, height) {
    return Container(
      height: height * 0.75,
      child: ListView.separated(
          itemBuilder: (_, i) {
            return Row(
              children: [
                CustomShimmer(
                    width: width / 10, height: width / 10, radius: width / 10),
                SizedBox(width: width / 30),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomShimmer(
                        height: width / 30, width: width * 0.65, radius: width),
                    SizedBox(height: width / 55),
                    CustomShimmer(
                        height: width / 30, width: width * 0.45, radius: width),
                  ],
                )
              ],
            );
          },
          separatorBuilder: (_, i) =>
              SizedBox(height: width / 15, child: Divider(thickness: 0.8)),
          itemCount: 10),
    );
  }

  Widget _listBuilder(height, width, List values) {
    if (values.isEmpty)
      return Column(
        children: [
          LottieBuilder.asset("assets/json/67375-no-data.json"),
          Container(
            width: width / 3,
            child: AutoSizeText(
              "Ooops, No Ticket In This Date",
              style: TextStyle(fontFamily: "popinsemi"),
              presetFontSizes: [20, 15],
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    if (GetPlatform.isIOS)
      return CupertinoScrollbar(
        child: Container(
          height: height,
          child: CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async => refresh(),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate((_, i) {
                return InkWell(
                  onTap: () => navigateToDetail(values, i),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: width / 45),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Row(
                          children: [
                            Icon(
                              Icons.circle,
                              size: width / 20,
                              color: values[i]["WooCommerceEventsStatus"]
                                          .toLowerCase() !=
                                      "checked in"
                                  ? Colors.grey
                                  : Colors.green,
                            ),
                            SizedBox(width: width / 30),
                            Flexible(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  values[i]["customerFirstName"] == ""
                                      ? values[i]["WooCommerceEventsTicketID"]
                                      : values[i]["customerFirstName"],
                                  style: TextStyle(
                                      fontSize: width / 45,
                                      fontFamily: "popinsemi"),
                                ),
                                Text(
                                  values[i]["WooCommerceEventsStatus"],
                                  style: TextStyle(fontSize: width / 55),
                                )
                              ],
                            ))
                          ],
                        )),
                        Icon(Iconsax.arrow_right_3,
                            size: width / 40, color: grayText)
                      ],
                    ),
                  ),
                );
              }, childCount: values.length))
            ],
          ),
        ),
      );
    return Container(
      height: height,
      child: RefreshIndicator(
        onRefresh: () async => refresh(),
        child: ListView.separated(
            itemBuilder: (_, i) {
              return InkWell(
                onTap: () => navigateToDetail(values, i),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: width / 45),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: width / 20,
                            color: values[i]["WooCommerceEventsStatus"]
                                        .toLowerCase() !=
                                    "checked in"
                                ? Colors.grey
                                : Colors.green,
                          ),
                          SizedBox(width: width / 30),
                          Flexible(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                values[i]["customerFirstName"] == ""
                                    ? values[i]["WooCommerceEventsTicketID"]
                                    : values[i]["customerFirstName"],
                                style: TextStyle(
                                    fontSize: width / 45,
                                    fontFamily: "popinsemi"),
                              ),
                              Text(
                                values[i]["WooCommerceEventsStatus"],
                                style: TextStyle(fontSize: width / 55),
                              )
                            ],
                          ))
                        ],
                      )),
                      Icon(Iconsax.arrow_right_3,
                          size: width / 40, color: grayText)
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, i) => Divider(
                  thickness: 0.8,
                ),
            itemCount: values.length),
      ),
    );
  }

  Widget _searchBar(width, height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: width * 0.75,
          child: GetPlatform.isIOS
              ? CupertinoSearchTextField(
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                  style: TextStyle(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  padding: EdgeInsets.symmetric(vertical: width / 30),
                )
              : TextField(
                  onChanged: (value) {
                    setState(() {
                      keyword = value;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      prefixIcon:
                          Icon(Iconsax.search_normal_1, color: grayText),
                      hintText: "Search",
                      filled: storage.read("isDark"),
                      fillColor: inputDark,
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width / 40),
                          borderSide: storage.read("isDark")
                              ? BorderSide.none
                              : BorderSide(color: grayText)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(width / 40),
                          borderSide: storage.read("isDark")
                              ? BorderSide.none
                              : BorderSide(color: grayText))),
                ),
        ),
        InkWell(
          onTap: () {
            modalFilter();
          },
          child: Container(
            padding: EdgeInsets.all(width / 35),
            decoration: BoxDecoration(
                color: greenTheme,
                borderRadius: BorderRadius.circular(width / 40)),
            child: Icon(Iconsax.setting_4, color: Colors.white),
          ),
        )
      ],
    );
  }
}
