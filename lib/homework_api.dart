import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hw1/model/api.dart';
import 'package:http/http.dart' as http;

class MyHomeWork extends StatefulWidget {
  const MyHomeWork({super.key});

  @override
  State<MyHomeWork> createState() => _MyHomeWorkState();
}

class _MyHomeWorkState extends State<MyHomeWork> {
  API? apiData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(
          'https://api.waqi.info/feed/bangkok/?token=e79ab0c7c28505b479c46d385ef0e4969ca00ad4&t',
        ),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        API api = API.fromJson(data);
        setState(() {
          apiData = api;
          isLoading = false;
        });
      } else {
        print('failed to fetch data');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  String getAirQualityDescription(int aqi) {
    if (aqi <= 50) {
      return 'Good';
    } else if (aqi <= 100) {
      return 'Moderate';
    } else if (aqi <= 150) {
      return 'Unhealthy for Sensitive Groups';
    } else if (aqi <= 200) {
      return 'Unhealthy';
    } else if (aqi <= 300) {
      return 'Very Unhealthy';
    } else {
      return 'Hazardous';
    }
  }

  Color getAqiBGColor(int aqi) {
    if (aqi <= 50) {
      return Colors.green;
    } else if (aqi <= 100) {
      return Colors.yellow;
    } else if (aqi <= 150) {
      return Colors.orange;
    } else if (aqi <= 200) {
      return Colors.red;
    } else if (aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.pink;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Air Quality Index (AQI)',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      '${apiData?.city ?? 'Loading...'}',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                width: 200,
                height: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Colors.deepPurple[400],
                  color: apiData?.aqi != null
                      ? getAqiBGColor(apiData!.aqi!)
                      : Colors.deepPurple[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        '${apiData?.aqi ?? 'Loading...'}',
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      '${apiData != null && apiData!.aqi != null ? getAirQualityDescription(apiData!.aqi!) : 'Loading...'}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        // color: Colors.white,
                        color: apiData?.aqi != null
                            ? getAqiBGColor(apiData!.aqi!)
                            : Colors.white,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Temperature: ${apiData?.temp ?? 'Loading...'} °C',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  fetchData();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.refresh,
                      size: 20,
                      color: Colors.deepPurple[600],
                    ),
                    SizedBox(width: 10),
                    Text('Refresh', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
