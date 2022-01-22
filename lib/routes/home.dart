// ignore_for_file: prefer_const_constructors, prefer_typing_uninitialized_variables, avoid_print
import 'dart:convert';
import 'package:covid_stats/models/global.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeRoute extends StatefulWidget {
  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  var newConfirmed;
  var totalConfirmed;
  var newDeaths;
  var totalDeaths;
  var newRecovered;
  var totalRecovered;

  String message = '';

  bool isLoading = false;
  var dataDecoded;
  void getData() async {
    var response =
        await http.get(Uri.parse("https://api.covid19api.com/summary"));
    print(response.body);
    setState(() {
      dataDecoded = jsonDecode(response.body);
    });
    print('data after decode $dataDecoded');
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        newConfirmed = dataDecoded['Global']['NewConfirmed'];
        totalConfirmed = dataDecoded['Global']['TotalConfirmed'];
        newDeaths = dataDecoded['Global']['NewDeaths'];
        totalDeaths = dataDecoded['Global']['TotalDeaths'];
        newRecovered = dataDecoded['Global']['NewRecovered'];
        totalRecovered = dataDecoded['Global']['TotalRecovered'];
      });

      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
        message = 'data not found';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  'Covid-19 Live Stats',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      getData();
                    },
                    child: Text('Get Data')),
                Container(
                    child: isLoading
                        ? CircularProgressIndicator()
                        : Text(
                            message,
                            style: TextStyle(color: Colors.red, fontSize: 50),
                          )),
                Text(
                  "New Confirmed = $newConfirmed",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "Total Confirmed = $totalConfirmed",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.blue,
                  ),
                ),
                Text(
                  "New Deaths = $newDeaths",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "Total Deaths = $totalDeaths",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.red,
                  ),
                ),
                Text(
                  "New Recovered = $newRecovered",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.green,
                  ),
                ),
                Text("Total Recovered = $totalRecovered",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: Colors.green,
                    )),
              ],
            ),
          ),
        ));
  }
}
