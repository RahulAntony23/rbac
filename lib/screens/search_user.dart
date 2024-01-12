import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchUser extends StatefulWidget {
  int comid;

  SearchUser({required this.comid});

  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
 TextEditingController _controller = TextEditingController();
  List<dynamic> _users = [];

  Future<void> _search(String name) async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8080/userByName?name=$name'));
    if (response.statusCode == 200) {
      var users = jsonDecode(response.body);
      setState(() {
        //take only the name of the users and id of
        _users = users.map((user) => {'username': user['name'], 'id': user['id']}).toList();
      });
    } else {
      print('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  onPressed: () => _search(_controller.text),
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_users[index]['username']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddUserPage(
                          username: _users[index]['username'],
                          userID: _users[index]['id'],
                          comid: widget.comid,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}





class AddUserPage extends StatefulWidget {
  final String username;
  final int comid;
  final int userID;

  AddUserPage({required this.username , required this.comid , required this.userID});
  

  @override
  _AddUserPageState createState() => _AddUserPageState();
}



class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  int h = 0;
  final List<String> roles = ['Content personnel', 'Admin','Super Admin'];
  String? _currentRole;
  TextEditingController _roleController = TextEditingController();

  void addRole (int comid, int userID, String role , int hierarchy) async {
    var reqBody = ({
      'role': role,
      'hierarchy': hierarchy,
    });
   
   
    var response = await http.post(
        Uri.parse('http://10.0.2.2:8080/companies/$comid/addEmployee/$userID'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));
    
    if (response.statusCode == 200) {
      print('Role added');
       
    } else {
      print(response.statusCode);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text('Adding : ${widget.username}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            SizedBox(height: 20),
            
            TextFormField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Set Role'),
            ),

            SizedBox(height: 20),

             DropdownButton<String>(
        value: roles[h],
        onChanged: (String? newValue) {
          setState(() {
            h = roles.indexOf(newValue!);
          });
        },
        items: roles.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
             ),


            SizedBox(height: 30),

            GestureDetector(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  addRole(widget.comid, widget.userID, _roleController.text, h);
                  Navigator.pop(context);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
