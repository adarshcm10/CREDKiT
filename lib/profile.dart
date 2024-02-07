import 'package:credkit/getstarted.dart';
import 'package:credkit/transitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//firestore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String email = FirebaseAuth.instance.currentUser!.email.toString();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/logo-small.png',
          height: 25,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        //menubar.png for opening drawer. add things to make it work on scaffold
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset(
                'assets/menubar.png',
                height: 25,
              ),
              // replace 'assets/menubar.png' with your image path
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
        //at right side add notification icon
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: Image.asset(
                'assets/home.png',
                height: 25,
              ),
              onPressed: () {
                //pop screen
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: Text('My Profile',
                  style: TextStyle(
                    fontSize: 21,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            //get name from collection 'userdata' and document with email
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userdata')
                  .doc(email)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Name:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              snapshot.data!['name'],
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Email:',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w200,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              email,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w300,
                    ),
                  );
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 2, color: Color(0xFFFFDABF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child:
                      //get due data from collection 'userdata' and document with email
                      StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('userdata')
                        .doc(email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'Upcoming',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'en_IN',
                                symbol: '₹',
                                decimalDigits: 0,
                              ).format(int.parse(snapshot.data!['due'])),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF6900),
                                fontSize: 33,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '${DateTime.parse(snapshot.data!['duedate'].toDate().toString()).day}/${DateTime.parse(snapshot.data!['duedate'].toDate().toString()).month}/${DateTime.parse(snapshot.data!['duedate'].toDate().toString()).year}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const Text(
                              'View >>',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFFF6900),
                                fontSize: 16,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w300,
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w300,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 60),
              child: GestureDetector(
                onTap: () async {
                  //sign out
                  try {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(
                        context, SlideRightRoute(page: const GetStarted()));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error signing out: $e')),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFFF6D00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Sign Out',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Gotham Black',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
