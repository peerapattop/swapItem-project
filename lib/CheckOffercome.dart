import 'package:async/async.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swapitem/ProfileScreen.dart';
import 'package:swapitem/widget/offer_imageshow.dart';
class CheckOffercome extends StatefulWidget {
  const CheckOffercome({super.key});

  @override
  State<CheckOffercome> createState() => _CheckOffercomeState();
}

class _CheckOffercomeState extends State<CheckOffercome> {
  late User _user;
  late DatabaseReference _postRef;
  late DatabaseReference _offerRef;
  bool havePost = true;
  bool haveoffer = true;
  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser!;
    _postRef = FirebaseDatabase.instance.reference().child('posts');
    _offerRef = FirebaseDatabase.instance.reference().child('offers');

    _fetchUserPosts();
  }

  Future<void> _fetchUserPosts() async {
    _postRef
        .orderByChild('uid') // สถานะโพสต์ 'status_post'
        .equalTo(_user.uid)
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var firstKey = data.keys.first;
        var firstPost = Map<dynamic, dynamic>.from(data[firstKey]);
      }
      else {
        havePost = false;
      }
    });

    _offerRef
        .orderByChild('uid')
        .equalTo(_user.uid) // สถานะยื่น 'status_offer'
        .limitToFirst(1)
        .onValue
        .listen((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> data =
        Map<dynamic, dynamic>.from(event.snapshot.value as Map);
        var firstKey = data.keys.first;
        var firstPost = Map<dynamic, dynamic>.from(data[firstKey]);
      }
      else {
        haveoffer = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

