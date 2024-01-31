import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class CheckOffercome extends StatefulWidget {
  const CheckOffercome({Key? key}) : super(key: key);

  @override
  State<CheckOffercome> createState() => _CheckOffercomeState();
}

class _CheckOffercomeState extends State<CheckOffercome> {
  late User _user;
  late DatabaseReference _postRef;
  late DatabaseReference _offerRef;
  List<Map<dynamic, dynamic>> postsList = [];
  List<Map<dynamic, dynamic>> offersList = [];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.reference().child('posts');
    _offerRef = FirebaseDatabase.instance.reference().child('offers');

    _fetchUserPosts();
  }

  Future<void> _fetchUserPosts() async {
    // Fetch posts data
    _postRef
        .orderByChild('uidUserpost')
        .equalTo(_user.uid)
        .onValue
        .listen((event) {
      print("Posts data event: $event");
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          // Set all posts data to postsList
          postsList = List<Map<dynamic, dynamic>>.from(data.values);
        });
      }
    });

    // Fetch offers data
    _offerRef
        .orderByChild('uidUserpost')
        .equalTo(_user.uid)
        .onValue
        .listen((event) {
      print("Offers data event: $event");
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);

        setState(() {
          // Set all offers data to offersList
          offersList = List<Map<dynamic, dynamic>>.from(data.values);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Offercome'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display posts data
            Text('Posts Data: ${mapListToString(postsList)}'),

            // Display offers data
            Text('Offers Data: ${mapListToString(offersList)}'),
          ],
        ),
      ),
    );
  }

  // Function to convert List<Map> to String
  String mapListToString(List<Map<dynamic, dynamic>> dataList) {
    StringBuffer result = StringBuffer();
    for (var data in dataList) {
      result.write(mapToString(data) + '\n');
    }
    return result.toString();
  }

  // Function to convert Map to String
  String mapToString(Map<dynamic, dynamic> data) {
    StringBuffer result = StringBuffer();
    data.forEach((key, value) {
      result.write('$key: $value, ');
    });
    return result.toString();
  }
}
