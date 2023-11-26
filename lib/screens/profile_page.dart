// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rbac/screens/my_pages.dart';

class profile_page extends StatefulWidget {
  profile_page({super.key});

  @override
  State<profile_page> createState() => _profile_pageState();
}

class _profile_pageState extends State<profile_page> {
  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 100),
                    const SizedBox(width: 40),
                    Column(
                      children: [
                        Text(
                          'Profile Name',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
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
              child: const Column(
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
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget odio euismod, aliquam nisl vitae, aliquet nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. Donec euismod, nisl eget aliquam ultricies, nisl nisl aliquet nisl, vitae aliquet nisl nisl vitae nisl. ',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),

                  // put text like ABout and blah blah blah
                ],
              ),
            ),
            Container(
              child: Column(children: [
                SizedBox(height: 30),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Profile Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => my_pages()));
                    },
                    child: Text(
                      'My Pages',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Pro Membership',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Saved',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                SizedBox(height: 20),
                TextButton(
                    onPressed: () {},
                    child: Text(
                      'Analytics',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              ]),
            ),
          ]),
    );
  }
}
