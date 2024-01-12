import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:rbac/screens/search_user.dart';


class roles extends StatefulWidget {
  int? comid;
  roles({this.comid});

  @override
  _rolesState createState() => _rolesState();
}

class _rolesState extends State<roles> {
 String _owner = '';
  List<dynamic> _contentCreators = [];
  List<dynamic> _admins = [];
  List<dynamic> _superAdmins = [];

  Future<void> _fetchEmployees(int companyId) async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8080/companies/$companyId/employees'));
    if (response.statusCode == 200) {
      var employees = jsonDecode(response.body);
      setState(() {
        _owner = employees[0]['company']['owner']['name'];
        _contentCreators = employees.where((employee) => employee['hierarchy'] == 0).map((employee) => employee['user']['name'] + ' - ' + employee['role']).toList();
        _admins = employees.where((employee) => employee['hierarchy'] == 1).map((employee) => employee['user']['name'] + ' - ' + employee['role']).toList();
        _superAdmins = employees.where((employee) => employee['hierarchy'] == 2).map((employee) => employee['user']['name'] + ' - ' + employee['role']).toList();
      });
    } else {
      print('Failed to load employees');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchEmployees(widget.comid!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employees'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchUser(comid: widget.comid!)),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Text('Page Creator: ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
                  
                  Text(_owner,
                  style: TextStyle(
                    fontSize: 20,
                    
                  )),
            ],
          ),

          SizedBox(height: 10),

          
           Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text('Super Admins',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _superAdmins.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${_superAdmins[index]}'),
                        );
                      },
                    ),
                  ),
                  
              ],
            ),
          ),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text('Admins',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _admins.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${_admins[index]}'),
                        );
                      },
                    ),
                  ),
                  
              ],
            ),
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: [
                Text('Content Creators',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _contentCreators.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${_contentCreators[index]}'),
                        );
                      },
                    ),
                  ),
                  
              ],
            ),
          ),
        ],
      ),
    );
  }
}