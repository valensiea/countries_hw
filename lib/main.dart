import 'dart:convert';
import 'package:countries_hw/countries.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Country>? _countries;

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  void _getCountries() async {
    try {
      var dio = Dio(BaseOptions(responseType: ResponseType.plain));
      var response =
          await dio.get('https://api.sampleapis.com/countries/countries');
      List<dynamic> list = jsonDecode(response.data);
      setState(() {
        _countries = list.map((country) => Country.fromJson(country)).toList();
        _countries!.sort((a, b) => a.name!.compareTo(b.name!));
      });
    } catch (e) {
      print('Error fetching countries: $e');
      // Handle the error gracefully, e.g., show a message to the user
      setState(() {
        _countries = []; // Clear the countries list or set it to null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries of the World"),
      ),
      body: _buildCountryList(),
    );
  }

  Widget _buildCountryList() {
    if (_countries == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (_countries!.isEmpty) {
      return const Center(child: Text('No countries found'));
    } else {
      return ListView.builder(
        itemCount: _countries!.length,
        itemBuilder: (context, index) {
          var country = _countries![index];

          return ListTile(
            title: Text(country.name ?? ''),
            subtitle: Text(country.capital ?? ''),
            trailing: country.flag == null
                ? null
                : Image.network(
                    country.flag!,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red);
                    },
                  ),
          );
        },
      );
    }
  }
}
