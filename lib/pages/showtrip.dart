import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/response/TripsGetResponse.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:flutter_application_1/pages/profile.dart';
import 'package:flutter_application_1/pages/trip.dart';
import 'package:http/http.dart' as http;

class Showtrip extends StatefulWidget {
  int idx = 0;
  Showtrip({super.key,required this.idx});

  @override
  State<Showtrip> createState() => _ShowtripState();
}

class _ShowtripState extends State<Showtrip> {
  String url = "";
  List<TripsGetResponse> trips = [];
  //late คือการกำหนดให้ว่าตอนนี้ยังไม่มีค่าแต่จะมีค่าแน่นอน
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
    // Configuration.getConfig().then(
    //   (value) {
    //     url = value['apiEndpoint'];
    //     log(url);
    //   },
    // ).catchError(
    //   (error) {
    //     log(error);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if(value == "profile"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if(value == "logout"){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              "ปลายทาง",
              style: TextStyle(fontSize: 18),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () {
                      ShowAllTrips(null);
                    },
                    child: const Text(
                      "ทั้งหมด",
                      style: TextStyle(fontSize: 18),
                    )),
                const SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () {
                      ShowAllTrips("เอเชีย");
                    },
                    child:
                        const Text("เอเชีย", style: TextStyle(fontSize: 18))),
                const SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () {
                      ShowAllTrips("ยุโรป");
                    },
                    child: const Text("ยุโรป", style: TextStyle(fontSize: 18))),
                const SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () {
                      ShowAllTrips("เอเชียตะวันออกเฉียงใต้");
                    },
                    child:
                        const Text("อาเซียน", style: TextStyle(fontSize: 18))),
                        const SizedBox(
                  width: 8,
                ),
                FilledButton(
                    onPressed: () {
                      ShowAllTrips("ประเทศไทย");
                    },
                    child: const Text("ประเทศไทย", style: TextStyle(fontSize: 18))),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      children: trips
                          .map(
                            (trip) => Card(
                              color: Colors.amber,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      trip.name,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                              child: SizedBox(
                                            width: 200,
                                            child: Image.network(
                                              trip.coverimage,
                                              width: 200),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("ประเทศ${trip.country}"),
                                                Text(
                                                    "ระยะเวลา ${trip.duration}วัน"),
                                                Text("ราคา ${trip.price}"),
                                                FilledButton(
                                                    onPressed: () => goToTripPage(trip.idx),
                                                    child: const Text(
                                                        "รายละเอียดเพิ่มเติม"))
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      // children: [
                      //   const SizedBox(height: 10,),
                      //   Card(
                      //     child: Padding(
                      //       padding: const EdgeInsets.symmetric(
                      //           horizontal: 25, vertical: 15),
                      //       child: Column(
                      //         crossAxisAlignment: CrossAxisAlignment.start,
                      //         children: [
                      //           const Text(
                      //             "อันซีน สวิตเซอร์แลนด์",
                      //             style: TextStyle(
                      //                 fontSize: 22, fontWeight: FontWeight.bold),
                      //           ),
                      //           const SizedBox(
                      //             height: 10,
                      //           ),
                      //           SingleChildScrollView(
                      //             scrollDirection: Axis.horizontal,
                      //             child: Row(
                      //               children: [
                      //                 GestureDetector(
                      //                     child: Image.asset(
                      //                   'assets/images/switch.jpg',
                      //                   width: 200,
                      //                 )),
                      //                 Padding(
                      //                   padding: const EdgeInsets.symmetric(
                      //                       horizontal: 10),
                      //                   child: Column(
                      //                     crossAxisAlignment:
                      //                         CrossAxisAlignment.start,
                      //                     children: [
                      //                       const Text("ประเทศสวิตเซอร์แลนด์"),
                      //                       const Text("ระยะเวลา 10 วัน"),
                      //                       const Text("ราคา 195000"),
                      //                       FilledButton(
                      //                           onPressed: () => (),
                      //                           child: const Text("รายละเอียดเพิ่มเติม"))
                      //                     ],
                      //                   ),
                      //                 )
                      //               ],
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //   )
                      // ],
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  //fuction for load data from api
  Future<void> loadDataAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    //get api
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    //call api /trips
    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripsGetResponseFromJson(data.body);
  }

  //zone can be null
  void ShowAllTrips(String? zone) async {
    try {
      var value = await http.get(Uri.parse('$url/trips'));
      trips = tripsGetResponseFromJson(value.body);
      List<TripsGetResponse> filterredTrips = [];
      if (zone != null) {
        for (var trip in trips) {
        if(trip.destinationZone == zone){
            filterredTrips.add(trip);
          }
        }
      } else {
        filterredTrips = tripsGetResponseFromJson(value.body);
      }
      trips = filterredTrips;
      setState(() {
        log(trips.length.toString());
      });
    } catch (eee) {
      log(eee.toString());
    }
  }
  
  goToTripPage(int idx) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => TripPage(idx: idx),));
  }
}
