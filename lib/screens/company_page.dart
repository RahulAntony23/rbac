// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rbac/screens/update_company.dart';

class company_page extends StatefulWidget {
  int? comid;
  company_page({this.comid});

  @override
  State<company_page> createState() => _company_pageState();
}

class _company_pageState extends State<company_page> {
  String companyname = '';
  String location = '';
  String FoE = '';
  String path = '';
  int isVerfied = 0;
  String description = '';

  void fetchCompany() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8080/getCompany?id=${widget.comid}'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['name']);
      setState(() {
        companyname = data['name'];
        path = data['dppath'];
        location = data['location'];
        FoE = data['foE'];
        isVerfied = data['isVerified'];
        description = data['description'];
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCompany();
  }

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    int id = widget.comid!;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(width: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.file(
                        File(path),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 40),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            companyname,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          // make this text appear Unverified if isVerified is 0 , if it is 1 then make it Verified. while unverfied color of text should be red and while verfied it should be black
                          Text(
                            isVerfied == 0 ? 'Unverified' : 'Verified',
                            style: TextStyle(
                              fontSize: 15,
                              color: isVerfied == 0 ? Colors.red : Colors.black,
                            ),
                          ),
                          Text(
                            location,
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            FoE,
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 100),
                  ],
                ),
                SizedBox(height: 20),
              ],
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              controller.nextPage(
                  duration: Duration(milliseconds: 300), curve: Curves.easeIn);
            },
          ),
        ],
      ),
      body: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),

                // put text like ABout and blah blah blah
                Text(
                  'About',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 30),

                // make this text and add a text view below it
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(height: 30),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Edit Page',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => update_company(comid: id)));
                    },
                    child: Text(
                      'Page Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Verify Page',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
