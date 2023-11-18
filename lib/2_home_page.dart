import '16_Payment.dart';
import '3_build_post.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key});

  @override
  _HomePageState createState() => _HomePageState();
}

//gg
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.notification_important,
              color: Colors.white,
            ),
            onPressed: () {
              // do something
            },
          )
        ],
        toolbarHeight: 40,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/image 40.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profile(context),
            Padding(
              padding: EdgeInsets.only(top: 6.0),
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(12.0), // ปรับค่าตามความต้องการ
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => (NewPost()),
                    ));
                  },
                  child: Text('สร้างโพสต์'),
                ),
              ),
            ),
            Container(
              height: 600,
              width: double.infinity,
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.all(20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[100],
                    child: const Text("He'd have you all unravel at the"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[200],
                    child: const Text('Heed not the rabble'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[300],
                    child: const Text('Sound of screams but the'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[400],
                    child: const Text('Who scream'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[500],
                    child: const Text('Revolution is coming...'),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.teal[600],
                    child: const Text('Revolution, they...'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Widget gh(BuildContext context) => Column(
      children: [
        profile(context),
        Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Column(
                children: [
                  Text('สร้างโพสต์เพื่อแลกของ'),
                ],
              ),
            ),
          ),
        ),
      ],
    );

Widget gide() => Expanded(
      child: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[100],
            child: const Text("He'd have you all unravel at the"),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[200],
            child: const Text('Heed not the rabble'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[300],
            child: const Text('Sound of screams but the'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[400],
            child: const Text('Who scream'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[500],
            child: const Text('Revolution is coming...'),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.teal[600],
            child: const Text('Revolution, they...'),
          ),
        ],
      ),
    );
Widget profile(BuildContext context) => Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0), // ปรับค่าตามความต้องการ
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('โควตาการแลก 5/5 เดือน'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0), // ปรับค่าตามความต้องการ
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text('โควตาการแลก 5/5 เดือน'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 6.0),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12.0), // ปรับค่าตามความต้องการ
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => (Payment()),
                          ));
                        },
                        child: Text('เติม VIP'),
                      ),
                    ),
                  ),
                ],
              )),
              Padding(
                padding: const EdgeInsets.only(right: 25, top: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/images/profileprame.png'),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Pramepree')
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
