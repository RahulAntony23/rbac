// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:rbac/screens/company_page.dart';
import 'package:rbac/screens/verification.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';
import 'package:http/http.dart' as http;

import '../helper/photopicker.dart';

class pbe extends StatefulWidget {
  const pbe({super.key});

  @override
  State<pbe> createState() => _pbeState();
}

class _pbeState extends State<pbe> {
  String? path;

  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();

  TextEditingController _searchController = TextEditingController();

  List<String> _allTags = [
    'AWS',
    'BIT',
    'Java Stack',
    'Web Development',
    'Elderberry',
    'Marketing',
    'Stock Market',
  ];
  List<String> _filteredItems = [];
  List<String> _selectedItems = [];

  late int comid;

  int usid = 102;

  @override
void postCompanyData(String name, List<String> tags, String description,
    String dppath, String address, String expertise) async {
  var reqBody = {
    "usid": usid,
    'name': name,
    'tags': tags,
    'description': description,
    'dppath': dppath,
    'location': address,
    'expertise': expertise,
  };

  var response = await http.post(
      Uri.parse('http://10.0.2.2:8080/users/$usid/companies'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody));
  print(jsonEncode(reqBody));

  if (response.statusCode == 200) {
    // returns id from from respose data
    var data = jsonDecode(response.body);
    comid = data['id'];
    print(data['id']);
  } else {
    print('Error saving company data');
  }
}

  @override
  void photopicker(BuildContext context) async {
    final pickedfile = await pickImage();
    if (pickedfile == null) return;
    final path = pickedfile.path;
    final croppedfile = await cropImage(path);
    if (croppedfile == null) return;

    setState(() {
      this.path = croppedfile.path;
    });
  }
  String location = '';
    String foe = '';

  final PageController controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final path = this.path;
    
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              if (controller.page == 0) {
                Navigator.pop(context);
              } else {
                controller.previousPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }
            },
          ),
        ),
        body: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            //first page
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 150),
                Text(
                  'Name of Page',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 90),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  child: Center(
                    child: TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        // add some border decoration
                        border: UnderlineInputBorder(),
                        hintText: 'What should we call this page?',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                FloatingActionButton(onPressed: () {
                  Icon(Icons.arrow_forward, size: 50, color: Colors.black);
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }),
              ]),
            ),

            //second page
            Container(
                child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(height: 60),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tags about the Company',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(height: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        if (value.isEmpty) {
                          _filteredItems = [];
                        } else {
                          _filteredItems = _allTags
                              .where((item) => item
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        }
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Search",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            String newItem = _searchController.text;
                            if (!_selectedItems.contains(newItem)) {
                              _selectedItems.add(newItem);
                            }
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      ),
                    ),
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: _selectedItems
                      .map((item) => Chip(
                            label: Text(item),
                            onDeleted: () {
                              setState(() {
                                _selectedItems.remove(item);
                              });
                            },
                          ))
                      .toList(),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount:
                        _filteredItems.length > 5 ? 5 : _filteredItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredItems[index]),
                        onTap: () {
                          setState(() {
                            _selectedItems.add(_filteredItems[index]);
                            _filteredItems = [];
                          });
                        },
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MediaQuery.of(context).viewInsets.bottom == 0.0
                      ? FloatingActionButton(
                          onPressed: () {
                            Icon(Icons.arrow_forward,
                                size: 50, color: Colors.black);
                            controller.nextPage(
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeIn);
                          },
                        )
                      : Container(), // Render an empty container when keyboard is open
                ),
                SizedBox(height: 50),
              ],
            )),

            //third page
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 150),
                Text(
                  'Page Description',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 90),
                //make a big text box
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: TextField(
                      controller: _description,
                      decoration: InputDecoration(
                        // add some border decoration
                        border: OutlineInputBorder(),

                        hintText: 'Tell us about your page',
                      ),
                      maxLines: 10,
                    ),
                  ),
                ),
                SizedBox(height: 50),

                FloatingActionButton(onPressed: () {
                  Icon(Icons.arrow_forward_sharp,
                      size: 10, color: const Color.fromARGB(255, 0, 0, 0));
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }),

                SizedBox(height: 50),
              ]),
            ),

            //fourth page
            //upload picture for company
            Container(
              padding: EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 80),
                Text(
                  'Upload a picture for your page',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                if (path != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(1000),
                    child: Image.file(
                      File(path),
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () => photopicker(context),
                    child: Text('Upload Image')),
                SizedBox(height: 50),
                FloatingActionButton(onPressed: () {
                  Icon(Icons.arrow_forward, size: 50, color: Colors.black);
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }),
              ]),
            ),

            //fifth page
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                SizedBox(height: 150),
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 50),
                SearchLocation(
                  apiKey: 'AIzaSyBdF7plpp1ydr9s-cP4iFXAne2uZqB6XPw',
                  onSelected: (Place place) {
                    location = place.description;
                    print(place.description);
                  },
                ),
                SizedBox(height: 100),
                FloatingActionButton(onPressed: () {
                  Icon(Icons.arrow_forward, size: 50, color: Colors.black);
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }),
              ]),
            ),

            //sixth page
            SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(children: [
                SizedBox(height: 120),
                Text(
                  'Field of Expertise',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 90),
                DropdownSearch<String>(
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                    showSelectedItems: true,
                  ),
                  items: [
                    "Aerospace",
                    "Agricultural",
                    "Automotive",
                    "Basic metal",
                    "Chemical",
                    "Computer",
                    "Construction",
                    "Creative",
                    "Cultural",
                    "Defense",
                    "Education",
                    "Electric power",
                    "Electronics",
                    "Energy",
                    "Engineering",
                    "Entertainment",
                    "Farming",
                    "Fashion",
                    "Film",
                    "Financial services",
                    "Fishing",
                    "Food",
                    "Forestry",
                    "Gambling",
                    "Gas",
                    "Green",
                    "Health services",
                    "Hospitality",
                    "Hotels",
                    "Industrial robot",
                    "Information",
                    "Information technology",
                    "Infrastructure",
                    "Insurance",
                    "Leisure",
                    "Low technology",
                    "Manufacturing",
                    "Meat",
                    "Media",
                    "Merchandising",
                    "Mining",
                    "Music",
                    "News media",
                    "Oil and gas",
                    "Pharmaceutical",
                    "Professional",
                    "Publishing",
                    "Pulp and paper",
                    "Railway",
                    "Real estate",
                    "Retail",
                    "Scientific",
                    "Services",
                    "Sex",
                    "Software",
                    "Space",
                    "Sport",
                    "Steel",
                    "Technology",
                    "Telecommunications",
                    "Textile",
                    "Tobacco",
                    "Transport",
                    "Utility",
                    "Video game",
                    "Water",
                    "Wholesale",
                    "Wood"
                  ],
                  dropdownDecoratorProps: DropDownDecoratorProps(
                    dropdownSearchDecoration: InputDecoration(
                      labelText: "Tell us what you do best",
                      hintText: "Select a field of expertise",
                    ),
                  ),
                  onChanged: (String? value) {
                    foe = value!;
                  },
                ),
                SizedBox(height: 100),
                FloatingActionButton(onPressed: () {
                  postCompanyData(_name.text, _selectedItems, _description.text,
                      path!, location, foe);
                  Icon(Icons.arrow_forward, size: 50, color: Colors.black);
                  controller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeIn);
                }),
              ]),
            ),

            //seventh page
            SingleChildScrollView(
              child: Column(children: [
                SizedBox(height: 200),
                Text(
                  'Page Created!',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 90),
                Text(
                  'Your page has been created! You can now add members to your page.',
                  style: TextStyle(
                    fontSize: 10,
                  ),
                ),
                SizedBox(height: 100),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      verification(path: path, comid: comid)))
                        },
                    child: Text('Verify Now')),
                ElevatedButton(
                    onPressed: () => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      company_page(comid: comid)))
                        },
                    child: Text('Do it later')),
              ]),
            ),
          ],
        ));
  }
}
