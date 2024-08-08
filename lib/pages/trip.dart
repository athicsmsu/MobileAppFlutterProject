import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/response/TripGetByIDResponse.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});
  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = "";
  late TripGetByIdResponse trip;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายละเอียดทริป"),
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      style: const TextStyle(
                          fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Text(trip.country,style: const TextStyle(fontSize: 18)),
                    ),
                    Image.network(trip.coverimage),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ราคา ${trip.price} บาท',
                              style: const TextStyle(fontSize: 18)),
                          Text('โซน${trip.destinationZone}',
                              style: const TextStyle(fontSize: 18))
                        ],
                      ),
                    ),
                    Text(
                      trip.detail,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: FilledButton(
                            onPressed: () {},
                            child: const Text(
                              'จองเลย!!',
                              style: TextStyle(fontSize: 18),
                            )),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> loadDataAsync() async {
    await Future.delayed(const Duration(seconds: 2));
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];
    //call api /trips
    var data = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    trip = tripGetByIdResponseFromJson(data.body);
  }
}
