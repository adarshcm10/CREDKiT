// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
//import cloud_firestore
import 'package:cloud_firestore/cloud_firestore.dart';
//import firebase_auth
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class AcceptOffer extends StatefulWidget {
  String docid;
  AcceptOffer({super.key, required this.docid});

  @override
  State<AcceptOffer> createState() => _AcceptOfferState();
}

class _AcceptOfferState extends State<AcceptOffer> {
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
                                decimalDigits: 3,
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
                              //if value of due in collection userdata doc email is 0 update value of due in collection userdata doc email to amount
                              FirebaseFirestore.instance
                                  .collection('userdata')
                                  .doc(email)
                                  .update({
                                'due': due,
                                'duedate': duedate,
                                'end': enddate
                              });

                              //delete document from collection offers
                              FirebaseFirestore.instance
                                  .collection('offers')
                                  .doc(widget.docid)
                                  .delete();
                            }
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
