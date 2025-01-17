// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Project imports:
import '../User/Data/user_hive.dart';

class AccountInfo extends StatefulWidget {
  const AccountInfo({super.key});

  @override
  State<AccountInfo> createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {

  bool _isDataLoaded = false;
  bool _updateLoading = false;

  String name = '';
  String image = '';
  String? gender = '';
  String? division1 = '';
  String? division2 = '';
  String email = '';
  String phone = '';
  String address1 = '';

  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController address1Controller = TextEditingController();

  final CollectionReference _collectionReference =
  FirebaseFirestore.instance.collection('userData');

  @override
  void initState() {
    super.initState();
    _checkAndSaveUser();
  }

  _checkAndSaveUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;

    final userData = await FirebaseFirestore.instance.collection('userData').doc(uid).get();
    if (!userData.exists) {
      // Save user data if the user is new
      FirebaseFirestore.instance.collection('userData').doc(uid).set({
        'name' : FirebaseAuth.instance.currentUser?.displayName,
        'imageURL' : FirebaseAuth.instance.currentUser?.photoURL,
        'Email': FirebaseAuth.instance.currentUser?.email,
        'Phone Number': '',
        'Gender': 'not selected',
        'Address1': ['Address1 Not Found', 'not selected'],
        'coins': 20000,
        //'coupons': 0,
        'wishlist': FieldValue.arrayUnion([]),
      });

      setState(() {

      });
    }
    else{
      _readData();
    }
  }

  _readData() async{
    final String uid = UserHive().getUserUid();

    final DocumentReference documentReference =
    FirebaseFirestore.instance.collection('userData').doc(uid);

    await documentReference.get().then( (DocumentSnapshot snapshot) {
      if(snapshot.exists){
        name = snapshot['name'];
        image = snapshot['imageURL'];
        gender = snapshot['Gender'];
        email = snapshot['Email'];
        phone = snapshot['Phone Number'];

        address1 = snapshot['Address1'][0];
        division1 = snapshot['Address1'][1];

        nameController.text = name;
        imageController.text = image;
        genderController.text = gender!;
        emailController.text = email;
        phoneNumberController.text = phone;
        
        if(address1.contains('Address1 Not Found')){
          address1Controller.text = '';
        }else{
          address1Controller.text = address1;
        }

        setState(() {
          _isDataLoaded = true;
        });
      }
    });
  }

  Future<void> _updatePersonalDetails() async{
    setState(() {
      _updateLoading = true;
    });
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }
    final uid = user.uid;
    await _collectionReference.doc(uid).update({
      'name' : nameController.text,
      'Email' : emailController.text,
      'Gender' : gender,
      'Phone Number': phoneNumberController.text,
      'Address1': [address1Controller.text, division1],
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_isDataLoaded){
      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.030),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Blank Space
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.07,
                ),

                //"Account Details" Text
                Padding(
                  padding: const EdgeInsets.only(bottom: 4,left: 7),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          /*Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => BottomBar(),)
                          );*/
                          Navigator.of(context).pop();
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                        ),
                      ),
                      const Text(
                        "Account Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10,),

                //Details
                SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Name *"),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: nameController.text.isEmpty ? Colors.red.shade50 : Colors.transparent,
                              borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              controller: nameController,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "name . . . ",
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.abc),
                                //labelText: "Semester",
                              ),
                            ),
                          ),

                          const Text("Additional E-Mail"),
                          SizedBox(
                            height: 50,
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "example@mail.com",
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.abc),
                                //labelText: "Semester",
                              ),
                            ),
                          ),

                          const Text("Select Gender"),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton<String>(
                              value: gender ?? 'not selected',
                              icon: const Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              elevation: 16,
                              isExpanded: true,
                              autofocus: true,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                              underline: const SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  gender = newValue!;
                                });
                              },
                              items: <String>[
                                'Male',
                                'Female',
                                'others',
                                'not selected'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),

                          const Text("Phone Number *"),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: phoneNumberController.text.isEmpty ? Colors.red.shade50 : Colors.transparent,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child: TextField(
                              controller: phoneNumberController,
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "ex: +880... ",
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.onetwothree),
                                //labelText: "Semester",
                              ),
                            ),
                          ),

                          const Text("Delivery Location 1 *"),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: address1Controller.text.isEmpty ? Colors.red.shade50 : Colors.transparent,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: MediaQuery.of(context).size.width*0.7,
                            child: TextField(
                              controller: address1Controller,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: Colors.white,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide.none,
                                ),
                                hintText: "address1",
                                hintStyle: const TextStyle(
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(Icons.abc),
                                //labelText: "Semester",
                              ),
                            ),
                          ),
                          //Select Division1
                          const Padding(padding: EdgeInsets.only(left: 15),child: Text("Select Division *")),
                          Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: division1 == 'not selected' ? Colors.red.shade50 : Colors.white,
                                borderRadius: BorderRadius.circular(5)
                            ),
                            width: MediaQuery.of(context).size.width*0.7,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: DropdownButton<String>(
                                value: division1 ?? 'not selected',
                                icon: const Icon(Icons.arrow_drop_down),
                                iconSize: 25,
                                elevation: 16,
                                isExpanded: true,
                                autofocus: true,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                                underline: const SizedBox(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    division1 = newValue!;
                                  });
                                },
                                items: <String>[
                                  'Dhaka',
                                  'Mymensingh',
                                  'Chittagong',
                                  'Khulna',
                                  'Rajshahi',
                                  'Rangpur',
                                  'Sylhet',
                                  'Barisal',
                                  'not selected'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                //update Button
                SizedBox(
                  height: 33,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      if(
                          nameController.text == '' ||
                          phoneNumberController.text == '' ||
                          address1Controller.text == '' ||
                          division1 == '' || division1 == 'not selected'
                      ){
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Name, Phone Number & Delivery Location \ncan not be empty / not selected",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              duration: Duration(milliseconds: 3000),
                            ));
                      }else{
                        _updatePersonalDetails();
                        setState(() {
                          _updateLoading = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Information Update Successful"),
                              duration: Duration(milliseconds: 1500),
                            ));
                      }
                    }
                    ,
                    child: const Text("Update"),
                  ),
                ),
                _updateLoading == true ? const LinearProgressIndicator() : const SizedBox(),
              ],
            ),
          ),
        ),
      );
    }
    else{
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
