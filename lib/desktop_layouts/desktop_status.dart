import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/header_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DesktopStatus extends StatefulWidget {
  const DesktopStatus({Key? key}) : super(key: key);

  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<DesktopStatus> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      appBar: Header(
        currentHeight,
        currentWidth,
        'Status',
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // header titles
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.15,
                    currentHeight * 0.03,
                    currentWidth * 0.15,
                    0,
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                        child: Text(
                          'Status',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentWidth * 0.03,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: currentHeight * 0.01),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            blurRadius: currentWidth * 0.002,
                          ),
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: (currentWidth * 0.7) * 0.15,
                              margin: EdgeInsets.fromLTRB(
                                currentWidth * 0.01,
                                0,
                                currentWidth * 0.01,
                                0,
                              ),
                              child: Text(
                                'Title',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: currentWidth * 0.015),
                              ),
                            ),
                            Container(
                              width: (currentWidth * 0.7) * 0.35,
                              margin: EdgeInsets.fromLTRB(
                                currentWidth * 0.01,
                                0,
                                currentWidth * 0.01,
                                0,
                              ),
                              child: Text(
                                'Date',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: currentWidth * 0.015),
                              ),
                            ),
                            Container(
                              width: (currentWidth * 0.7) * 0.15,
                              margin: EdgeInsets.fromLTRB(
                                currentWidth * 0.01,
                                0,
                                currentWidth * 0.01,
                                0,
                              ),
                              child: Text(
                                'Status',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: currentWidth * 0.015),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // adventures
                      StatusList('Pending'),
                      StatusList('Rejected'),
                      StatusList('Approved'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StatusList extends StatefulWidget {
  String statusType;
  StatusList(this.statusType, {Key? key}) : super(key: key);

  @override
  State<StatusList> createState() => _StatusListState(statusType);
}

class _StatusListState extends State<StatusList> {
  String statusType;
  _StatusListState(this.statusType);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    final Stream<QuerySnapshot> _statusStream = Constants.allSubmissions
        .where('UID', isEqualTo: Constants.user!.uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _statusStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          if (statusType == 'Pending') {
            return const SizedBox(
              child: Align(
                child: CircularProgressIndicator(),
                alignment: Alignment.topCenter,
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }

        // CHANGE CARD DISPLAY ON USER END
        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;

            if (data['Status'] != statusType) {
              return const SizedBox.shrink();
            } else {
              return InkWell(
                onTap: () {
                  // EXPAND USER DISPLAY FOR ADVENTURES
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: currentHeight * 0.01),
                  height: currentHeight * 0.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: currentWidth * 0.002,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // adventure title
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          currentWidth * 0.01,
                          0,
                          currentWidth * 0.01,
                          0,
                        ),
                        width: (currentWidth * 0.7) * 0.15,
                        child: Text(
                          data['Title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentHeight * 0.02,
                          ),
                        ),
                      ),
                      // date created
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          currentWidth * 0.01,
                          0,
                          currentWidth * 0.01,
                          0,
                        ),
                        width: (currentWidth * 0.7) * 0.15,
                        child: Text(
                          data['Created'].toDate().toString().substring(0, 10),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentHeight * 0.02,
                          ),
                        ),
                      ),
                      // current status
                      Container(
                        margin: EdgeInsets.fromLTRB(
                          currentWidth * 0.01,
                          0,
                          currentWidth * 0.01,
                          0,
                        ),
                        width: (currentWidth * 0.7) * 0.15,
                        child: Text(
                          data['Status'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentHeight * 0.02,
                            color: data['Status'] == 'Pending'
                                ? Colors.orange
                                : data['Status'] == 'Rejected'
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          }).toList(),
        );
      },
    );
  }
}
