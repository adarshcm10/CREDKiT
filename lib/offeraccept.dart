// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
//import cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';
//import firebase_auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AcceptOffer extends StatefulWidget {
  String docid;
  AcceptOffer({super.key, required this.docid});

  @override
  State<AcceptOffer> createState() => _AcceptOfferState();
}

class _AcceptOfferState extends State<AcceptOffer> {
  final String email = FirebaseAuth.instance.currentUser!.email.toString();

  //function returns a string which is 32 characters long and contains numbers, alphabets and start with 0x
  String randomString() {
    const chars = '0123456789abcdef';
    final random = Random.secure();
    final result =
        List.generate(30, (index) => chars[random.nextInt(chars.length)])
            .join();
    return '0x$result';
  }

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
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'Offer details',
                  style: TextStyle(
                    color: Color(0xFFFF6900),
                    fontSize: 21,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //get amount, duartion and pa values from collection ofeers and document
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('offers')
                    .doc(widget.docid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong");
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
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

                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        //height: 131,
                        decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 2, color: Color(0xFFFFDABF)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              NumberFormat.currency(
                                locale: 'en_IN',
                                symbol: '₹',
                                decimalDigits: 0,
                              ).format(double.parse(
                                  snapshot.data!['amount'].toString())),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFFF6900),
                                fontSize: 26,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'For ${snapshot.data!['duration'].toString()} months duration',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              'With interest rate ${snapshot.data!['pa'].toString()}% pa.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gotham',
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          //if value of due in collection userdata doc email is not 0 display alert dialog cant accept offer
                          FirebaseFirestore.instance
                              .collection('userdata')
                              .doc(email)
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot['due'] != 0) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Cannot accept offer'),
                                    content: const Text(
                                        'You have an outstanding due. Please clear it before accepting a new offer.'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              double interest = snapshot.data!['amount'] *
                                  (snapshot.data!['pa'] / 100);
                              double monthly =
                                  (interest / 12) * snapshot.data!['duration'];
                              double total = snapshot.data!['amount'] + monthly;
                              double due = total / snapshot.data!['duration'];
                              //convert due into integer of 2 decimal places
                              due = double.parse(due.toStringAsFixed(2));
                              int days = snapshot.data!['duration'] * 28;
                              DateTime duedate =
                                  DateTime.now().add(const Duration(days: 28));
                              DateTime enddate =
                                  DateTime.now().add(Duration(days: days));
                              //pop
                              Navigator.pop(context);

                              String txid = randomString();

                              //save amount, email and datetime.now to collection blockchain as new doc
                              FirebaseFirestore.instance
                                  .collection('blockchain')
                                  .add({
                                'amount': snapshot.data!['amount'],
                                'email': email,
                                'date': DateTime.now(),
                                'tx': txid,
                              });

                              //update due, duedate and enddate in collection userdata doc email
                              FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(email)
                                  .update({
                                'due': due,
                                'duedate': duedate,
                                'end': enddate,
                                'lender': widget.docid,
                              });

                              //get device token from collection userdata doc email
                              FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(widget.docid)
                                  .get()
                                  .then((DocumentSnapshot documentSnapshot) {
                                String did = documentSnapshot['token'];
                                //send notification to device token
                                sendNotification(
                                  'AAAAWQ5e930:APA91bETjSgvHLzc-uP45fFIgN-0f7KuDnTW9ckft98Zgq5HVk3AKOUHtbIeCnmwWlxTrTULuJHIKWdEwvn4-YKYyCWLe0r1XiOD82JswnhwrfiIaCdUTSA22d1KVf6guAZblLQhhfG5',
                                  [did],
                                  'Offer accepted',
                                  'Your offer has been accepted',
                                );

                                //save token to collection userdata and doc email as token2
                                FirebaseFirestore.instance
                                    .collection('userdata')
                                    .doc(email)
                                    .update({
                                  'token2': did,
                                });
                              });

                              //save due and duedate to collection userdata and doc widget.docid
                              FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(widget.docid)
                                  .update({
                                'due': due,
                                'duedate': duedate,
                                'end': enddate,
                              });

                              //delete document from collection offers
                              FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(widget.docid)
                                  .delete();
                            }
                            //snackbar to show offer accepted
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Offer accepted'),
                              ),
                            );
                          });
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
                              'Accept Offer',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontFamily: 'Gotham Black',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
