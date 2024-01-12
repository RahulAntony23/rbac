// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:rbac/screens/company_page.dart';
import 'package:http/http.dart' as http;

class verification extends StatefulWidget {
  String? path;
  late int comid;
  verification({required this.comid, this.path});

  @override
  State<verification> createState() => _verificationState();
}

class _verificationState extends State<verification> {
  String companyname = '';
  String location = '';
  String FoE = '';
  

  void fetchCompany() async {
    var response = await http.get(
      Uri.parse('http://10.0.2.2:8080/getCompany?comid=${widget.comid}'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print(data['name']);
      setState(() {
        companyname = data['name'];
        location = data['location'];
        FoE = data['expertise'];
      });
    } else {
      print(response.statusCode);
    }
  }

  void verify() async {
    var response = await http.put(
      Uri.parse('http://10.0.2.2:8080/company/${widget.comid}/verifyCompany'),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      print('Company Verified');
      
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

  String? IPC;
  String? PAN;
  String? GST;

  void uploadIPC() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      setState(() {
        IPC = file.name;
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8080/upload'));

      // Add company name and id to the request
      request.fields['companyName'] = companyname;
      request.fields['companyId'] = widget.comid.toString();

      request.files.add(http.MultipartFile(
          'pdf',
          File(file.path!).readAsBytes().asStream(),
          File(file.path!).lengthSync(),
          filename: file.name));

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  void uploadPAN() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      setState(() {
        PAN = file.name;
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8080/upload'));

      // Add company name and id to the request
      request.fields['companyName'] = companyname;
      request.fields['companyId'] = widget.comid.toString();

      request.files.add(http.MultipartFile(
          'pdf',
          File(file.path!).readAsBytes().asStream(),
          File(file.path!).lengthSync(),
          filename: file.name));

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  void uploadGST() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print(file.name);
      setState(() {
        GST = file.name;
      });

      var request = http.MultipartRequest(
          'POST', Uri.parse('http://10.0.2.2:8080/upload'));

      // Add company name and id to the request
      request.fields['companyName'] = companyname;
      request.fields['companyId'] = widget.comid.toString();

      request.files.add(http.MultipartFile(
          'pdf',
          File(file.path!).readAsBytes().asStream(),
          File(file.path!).lengthSync(),
          filename: file.name));

      var response = await request.send();

      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? path = widget.path;
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
                        File(path!),
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
                          // make the text not exceed the screen width
                          Text(
                            companyname,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          // if 
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
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(height: 20),
              Text(
                'Company Legal Name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      // add some border decoration
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Text(
                'Compaany Incorporation Certificate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: uploadIPC, child: Text('Upload File')),
              Text(IPC ?? 'No file selected'),
              SizedBox(height: 60),
              Text(
                'Company PAN Card',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: uploadPAN, child: Text('Upload File')),
              Text(PAN ?? 'No file selected'),
              SizedBox(height: 60),
              Text(
                'Company GST Certificate',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              TextButton(onPressed: uploadGST, child: Text('Upload File')),
              Text(GST ?? 'No file selected'),
              SizedBox(height: 60),
              FloatingActionButton(onPressed: () {
                Icon(Icons.arrow_forward, size: 50, color: Colors.black);
                controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              }),
              SizedBox(height: 60),
            ]),
          ),
          SingleChildScrollView(
            child: Column(children: [
              Padding(padding: EdgeInsets.all(20)),
              SizedBox(height: 20),
              Text(
                'Work Email Address',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      // add some border decoration
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              Text(
                'Work Phone Number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      // add some border decoration
                      border: UnderlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {
                        verify(),
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    company_page(comid: widget.comid)))
                      },
                  child: Text('Verify')),
            ]),
          ),
        ],
      ),
    );
  }
}
