import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rbac/screens/company_page.dart';
import 'package:rbac/screens/pbe.dart';
import 'package:http/http.dart' as http;

import '../models/company.dart';

class my_pages extends StatefulWidget {
  const my_pages({super.key});

  @override
  State<my_pages> createState() => _my_pagesState();
}

class _my_pagesState extends State<my_pages> {
  int usid = 102;

  Company? company;

  List<Company> companies = [];

  Future<List<Company>> fetchCompanies() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8080/users/$usid/companies'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body.toString());

      for (Map i in data) {
        Company com = Company(
          id: i['id'],
          name: i['name'],
        );
        companies.add(com);
      }

      return companies;
    } else {
      return companies;
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text('My Pages'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(0.2),
        child: Column(
          children: [
            SizedBox(height: 100),
            Text(
              'My Pages',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder<List<Company>>(
                //if number of itmes is zero , make a screen that says Oops no companies yet
                future: fetchCompanies(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Company>> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 300,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                              title: Text(snapshot.data![index].name!),
                              onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => company_page(
                                        comid: snapshot.data![index].id!,
                                      ),
                                    ),
                                  ));
                        },
                      ),
                    );
                    //if number of itmes is zero , make a screen that says Oops no companies yet
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => pbe()));
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text('Add new page',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0),
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
