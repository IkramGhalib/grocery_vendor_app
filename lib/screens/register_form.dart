import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _cpasswordTextController = TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  TextEditingController _nameTextController = TextEditingController();
  String email;
  String password;
  String mobile;
  String shopName;
  bool _isLoading = false;

  // file upload code
  Future<String> uploadFile(filePath) async {
    File file = File(filePath);
    firebase_storage.FirebaseStorage _storage =
        firebase_storage.FirebaseStorage.instance;

    try {
      await _storage
          .ref('uploads/shopProfilePic/${_nameTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }
    // now after upload file need file url path to save in database
    String downloadURL = await _storage
        .ref('uploads/shopProfilePic/${_nameTextController.text}')
        .getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    scafflodMessage(message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return _isLoading ?CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    ):Form(
      key: _formkey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Shop Name';
                }
                setState(() {
                  _nameTextController.text = value;
                });
                setState(() {
                  shopName = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.add_business),
                  labelText: 'Business Name',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Email Textfield
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              controller: _emailTextController,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Email Address';
                }
                setState(() {
                  email = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: 'Email Address',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Mobile Number Textfield
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLength: 10,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Mobile Number';
                }
                setState(() {
                  mobile = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.phone_android),
                  labelText: 'Mobile Number',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Password Textfield
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Password';
                }
                if (value.length <= 6) {
                  return 'Minimum 6 character';
                }
                setState(() {
                  password = value;
                });
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: 'Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Confirm Password Textfield
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              obscureText: true,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Confirm Number';
                }
                if (value.length <= 6) {
                  return 'Minimum 6 character';
                }
                if (_passwordTextController.text !=
                    _cpasswordTextController.text) {
                  return 'Password doesn\'t match';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key_outlined),
                  labelText: 'Confirm Password',
                  contentPadding: EdgeInsets.zero,
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          // Password Textfield
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: TextFormField(
              maxLines: 6,
              controller: _addressTextController,
              validator: (value) {
                if (value.isEmpty) {
                  return 'Enter Navigate Your Shop';
                }
                if (_authData.shopLatitude == null) {
                  return 'Please Navigate Shop';
                }
                return null;
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.contact_mail_outlined),
                  labelText: 'Shop Location',
                  // contentPadding: EdgeInsets.zero,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.location_searching),
                    onPressed: () {
                      _addressTextController.text =
                          'Locating...\n Please wait...';
                      _authData.getCurrentAddress().then((address) {
                        if (address != null) {
                          setState(() {
                            _addressTextController.text =
                                '${_authData.placeName}\n${_authData.shopAddress}';
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Couldnot find location...')));
                        }
                      });
                    },
                  ),
                  enabledBorder: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2),
                  ),
                  focusColor: Colors.blue),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  child: FlatButton(
                color: Colors.green,
                onPressed: () {
                  if (_authData.isPicAvail == true) {
                    if (_formkey.currentState.validate()) {
                      setState(() {
                        _isLoading = true;
                      });
                      _authData
                          .registerVendor(email, password)
                          .then((credential) {
                        if (credential.user.uid != null) {
                          uploadFile(_authData.image.path).then((url) {
                            if (url!=null) {
                              _authData
                                  .saveVendorDataDB(
                                      url: url,
                                      mobile: mobile,
                                      shopName: shopName)
                                  .then((value) {
                                _isLoading = false;
                                Navigator.pushNamed(context, HomeScreen.id);
                              });
                              
                            } else {
                              scafflodMessage('Failed to upload profile');
                            }
                          });
                        } else {
                          // register failed
                          scafflodMessage(_authData.error);
                        }
                      });

                      // ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Processing Data...')));
                    }
                  } else {
                    scafflodMessage('Shop profile picture to be added...');
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //     content: Text('Shop profile picture to be added...')));
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(color: Colors.white),
                ),
              ))
            ],
          )
        ],
      ),
    );
  }
}
