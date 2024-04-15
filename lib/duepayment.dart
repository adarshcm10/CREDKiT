import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:credkit/Home.dart';
import 'package:credkit/addRequest.dart';
import 'package:credkit/profile.dart';
import 'package:credkit/requests.dart';
import 'package:credkit/transitions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class DuePage extends StatefulWidget {
  const DuePage({super.key});

  @override
  State<DuePage> createState() => _DuePageState();
}

class _DuePageState extends State<DuePage> {
  final String email = FirebaseAuth.instance.currentUser!.email.toString();

  Future<void> sendNotification(String serverKey, List<String> deviceTokens,
      String title, String body) async {
    const postUrl = 'https://fcm.googleapis.com/fcm/send';

    final data = {
      "registration_ids": deviceTokens,
      "notification": {"body": body, "title": title}
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=$serverKey'
    };

    var response = await http.post(Uri.parse(postUrl),
        body: json.encode(data), headers: headers);

    if (response.statusCode == 200) {
      const SnackBar(
        content: AlertDialog(
          title: Text("Notification send"),
          backgroundColor: Color(0xffE31E26),
        ),
      );
    }
  }

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
        leading: Builder(
          builder: (context) => Padding(
            padding: const EdgeInsets.only(left: 30),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Image.asset(
                'assets/menubar.png',
                height: 25,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ),
      ),
      drawer: Drawer(
          child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //container of background color 0D1D2E
          Container(
            color: const Color(0xff0D1D2E),
            height: 200,
            child: Center(child: Image.asset('assets/logo-small.png')),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(
                left: //40% of drawer width
                    0.15 * MediaQuery.of(context).size.width),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    //pop drawer
                    Navigator.pop(context);
                    //navigate to home.dart
                    Navigator.pushReplacement(
                        context, FadeRoute(page: const HomePage()));
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.home,
                        color: Color(0xff0D1D2E),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Home',
                          style: TextStyle(
                            color: Color(0xff0D1D2E),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                GestureDetector(
                  onTap: () {
                    //pop drawer
                    Navigator.pop(context);
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Color(0xffFF6D00),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Pay Due',
                          style: TextStyle(
                            color: Color(0xffFF6D00),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                //gesture detector for profile
                GestureDetector(
                  onTap: () {
                    //pop drawer
                    Navigator.pop(context);
                    FirebaseFirestore.instance
                        .collection('requests')
                        .doc(email)
                        .get()
                        .then((doc) {
                      if (doc.exists) {
                        Navigator.push(
                            context, FadeRoute(page: const MyRequests()));
                      } else {
                        //navigfate to add request page
                        Navigator.push(
                            context, FadeRoute(page: const AddRequest()));
                      }
                    });
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.message,
                        color: Color(0xff0D1D2E),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'My Requests',
                          style: TextStyle(
                            color: Color(0xff0D1D2E),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    //pop drawer
                    Navigator.pop(context);
                    //navigate to profile.dart
                    Navigator.push(
                        context, FadeRoute(page: const ProfilePage()));
                  },
                  child: const Row(
                    children: [
                      Icon(
                        Icons.person,
                        color: Color(0xff0D1D2E),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          'Profile',
                          style: TextStyle(
                            color: Color(0xff0D1D2E),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //add logout button at bottom
          const Spacer(),
          GestureDetector(
            onTap: () {
              //signout user
              FirebaseAuth.instance.signOut();
            },
            child: Container(
              color: const Color(0xffFF6D00),
              height: 50,
              child: const Center(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Container(
                  width: double.infinity,
                  //height: 131,
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(width: 2, color: Color(0xFFFFDABF)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Upcoming',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w300,
                          height: 0.09,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //display 'due' from collection userdata , document email
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userdata')
                            .doc(email)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              Text(
                                NumberFormat.currency(
                                  locale: 'en_IN',
                                  symbol: '₹',
                                  decimalDigits: 2,
                                ).format(double.parse(
                                    snapshot.data!['due'].toString())),
                                style: const TextStyle(
                                  color: const Color(0xFFFF6900),
                                  fontSize: 40,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              //if there is field 'duedate', display it as dd-mm-yyyy format else 'no dues left'
                              snapshot.data!['due'] != 0
                                  ? Text(
                                      'on ${DateFormat('dd-MM-yyyy').format(snapshot.data!['duedate'].toDate())}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    )
                                  : const Text(
                                      'No dues left',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      //gesture detector for pay due if due is not 0
                      StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('userdata')
                            .doc(email)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            );
                          }

                          return snapshot.data!['due'] != 0
                              ? GestureDetector(
                                  onTap: () {
                                    //pop
                                    Navigator.of(context).pop();
                                    //show snackabr for payment success
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Center(
                                          child: Text('Payment Successful'),
                                        ),
                                        backgroundColor: Color(0xFFFF6900),
                                      ),
                                    );
                                    //get duedate from firebase and add 28 days to duedate and add to firebase
                                    DateTime duedate =
                                        snapshot.data!['duedate'].toDate();
                                    duedate =
                                        duedate.add(const Duration(days: 28));
                                    FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(email)
                                        .get()
                                        .then((doc) {
                                      var endDate = doc.data()!['end'].toDate();
                                      if (!duedate.isAfter(endDate)) {
                                        FirebaseFirestore.instance
                                            .collection('userdata')
                                            .doc(email)
                                            .update({'duedate': duedate});
                                        //update duedate in doc with value in lender field of doc email
                                        FirebaseFirestore.instance
                                            .collection('userdata')
                                            .doc(email)
                                            .get()
                                            .then((DocumentSnapshot
                                                documentSnapshot) {
                                          String lender =
                                              documentSnapshot['lender'];
                                          FirebaseFirestore.instance
                                              .collection('userdata')
                                              .doc(lender)
                                              .update({'duedate': duedate});
                                        });
                                      } else {
                                        //delete duedate
                                        //set due to 0
                                        FirebaseFirestore.instance
                                            .collection('userdata')
                                            .doc(email)
                                            .update({
                                          'due': 0,
                                          'duedate': FieldValue.delete()
                                        });
                                        //set due to 0 in doc with value in lender field of doc email
                                        FirebaseFirestore.instance
                                            .collection('userdata')
                                            .doc(email)
                                            .get()
                                            .then((DocumentSnapshot
                                                documentSnapshot) {
                                          String lender =
                                              documentSnapshot['lender'];
                                          FirebaseFirestore.instance
                                              .collection('userdata')
                                              .doc(lender)
                                              .update({
                                            'due': 0,
                                            'duedate': FieldValue.delete()
                                          });
                                        });
                                      }
                                    });

                                    //get device token from collection userdata doc email
                                    FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(email)
                                        .get()
                                        .then((DocumentSnapshot
                                            documentSnapshot) {
                                      String did = documentSnapshot['token2'];
                                      //send notification to device token
                                      sendNotification(
                                        'AAAAWQ5e930:APA91bETjSgvHLzc-uP45fFIgN-0f7KuDnTW9ckft98Zgq5HVk3AKOUHtbIeCnmwWlxTrTULuJHIKWdEwvn4-YKYyCWLe0r1XiOD82JswnhwrfiIaCdUTSA22d1KVf6guAZblLQhhfG5',
                                        [did],
                                        'New Payment Received',
                                        //due amount
                                        '₹${snapshot.data!['due']}',
                                      );
                                    });
                                    //add due amount and todays date as timestamp to subcollection history in firebase
                                    FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(email)
                                        .collection('history')
                                        .add({
                                      'amount': snapshot.data!['due'],
                                      'date': Timestamp.now()
                                    });
                                    //add due amount and todays date as timestamp to subcollection history of collection userdata and doc name as in lender field of doc email
                                    FirebaseFirestore.instance
                                        .collection('userdata')
                                        .doc(email)
                                        .get()
                                        .then((DocumentSnapshot
                                            documentSnapshot) {
                                      String lender =
                                          documentSnapshot['lender'];
                                      FirebaseFirestore.instance
                                          .collection('userdata')
                                          .doc(lender)
                                          .collection('history')
                                          .add({
                                        'amount': snapshot.data!['due'],
                                        'date': Timestamp.now()
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    child: Container(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: ShapeDecoration(
                                        shape: RoundedRectangleBorder(
                                          side: const BorderSide(
                                              width: 2,
                                              color: Color(0xFFFFDABF)),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          'Pay Due',
                                          style: TextStyle(
                                            color: Color(0xFFFF6900),
                                            fontSize: 16,
                                            fontFamily: 'Gotham',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(
                                  height: 0,
                                );
                        },
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )),

            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30),
              child: Row(
                children: [
                  Text('Recent Payments',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      )),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //display amount and date from collection userdata , document email and subcollection history
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('userdata')
                  .doc(email)
                  .collection('history')
                  .orderBy('date', descending: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Text(
                      'Loading...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }

                return snapshot.data!.docs.isNotEmpty
                    ? Column(
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 30, right: 30, bottom: 10),
                            child: Container(
                              width: double.infinity,
                              height: 70,
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      width: 2, color: Color(0xFFFFDABF)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                        locale: 'en_IN',
                                        symbol: '₹',
                                        decimalDigits: 2,
                                      ).format(double.parse(
                                          data['amount'].toString())),
                                      style: const TextStyle(
                                        color: Color(0xFFFF6900),
                                        fontSize: 16,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      DateFormat('dd-MM-yyyy')
                                          .format(data['date'].toDate()),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: 'Gotham',
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  width: 2, color: Color(0xFFFFDABF)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Center(
                            child: Text('No recent transaction',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontFamily: 'Gotham',
                                  fontWeight: FontWeight.w300,
                                )),
                          ),
                        ),
                      );
              },
            )
            //
          ],
        ),
      ),
    );
  }
}
