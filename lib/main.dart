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
  List<Country>? _filteredCountries;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCountries();
  }

  void _getCountries() async {
    // try {
    //   var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    //   var response =
    //       await dio.get('https://api.sampleapis.com/countries/countries');
    //   List<dynamic> list = jsonDecode(response.data);
    //   setState(() {
    //     _countries = list.map((country) => Country.fromJson(country)).toList();
    //     _countries!.sort((a, b) => a.name!.compareTo(b.name!));
    //   });
    // } catch (e) {
    //   print('Error fetching countries: $e');
    //   // Handle the error gracefully, e.g., show a message to the user
    //   setState(() {
    //     _countries = []; // Clear the countries list or set it to null
    //   });
    // }
    var dio = Dio(BaseOptions(responseType: ResponseType.plain));
    var response =
        await dio.get('https://api.sampleapis.com/countries/countries');

    List list = jsonDecode(response.data);

    setState(() {
      _countries = list.map((country) => Country.fromJson(country)).toList();
      _filteredCountries = _countries;
      _countries!.sort((a, b) => a.name!.compareTo(b.name!));
    });
  }

  void _filterCountries(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredCountries = _countries;
      });
    } else {
      setState(() {
        _filteredCountries = _countries!
            .where((country) =>
                country.name!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Countries of the World"),
      ),
      // body: _buildCountryList(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                suffixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredCountries == null
                ? SizedBox.shrink()
                : ListView.builder(
                    itemCount: _filteredCountries!.length,
                    itemBuilder: (context, index) {
                      var country = _filteredCountries![index];
                      return ListTile(
                        title: Text(country.name ?? ''),
                        subtitle: Text(country.abbreviation ?? ''),
                        trailing: country.flag!.isNotEmpty
                            ? Image.network(
                                country.flag!,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error);
                                },
                              )
                            : const SizedBox(
                                width: 50,
                                height: 50,
                              ),
                        onTap: () {
                          _showCountryDetails(
                              country.capital as String,
                              country.population as int,
                              country.currency as String,
                              country.phone as String,
                              country.flag as String,
                              country.emblem as String);
                        },
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  // Widget _buildCountryList() {
  //   if (_countries == null) {
  //     return const Center(child: CircularProgressIndicator());
  //   } else if (_countries!.isEmpty) {
  //     return const Center(child: Text('No countries found'));
  //   } else {
  //     return ListView.builder(
  //       itemCount: _countries!.length,
  //       itemBuilder: (context, index) {
  //         var country = _countries![index];

  //         return ListTile(
  //           title: Text(country.name ?? ''),
  //           subtitle: Text(country.abbreviation ?? ''),
  //           trailing: country.flag == null
  //               ? null
  //               : Image.network(
  //                   country.flag!,
  //                   errorBuilder: (context, error, stackTrace) {
  //                     return const Icon(Icons.error, color: Colors.red);
  //                   },
  //                 ),
  //         );
  //       },
  //     );
  //   }
  // }

  Future<void> _showCountryDetails(String capital, int population,
      String currency, String phone, String flag, String emblem) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Country Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Capital: $capital'),
                Text('Population: $population'),
                Text('Currency: $currency'),
                Text('Phone: $phone'),
                flag.isEmpty
                    ? Image.network(
                        flag,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Image not available');
                        },
                      )
                    : const Text('No image available'),
                emblem.isEmpty
                    ? Image.network(
                        emblem,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Image not available');
                        },
                      )
                    : const Text('No image available'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('CLOSE'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
