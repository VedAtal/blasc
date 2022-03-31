import 'package:blasc/desktop_layouts/desktop_adventure_page.dart';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/header_builder.dart';
import 'package:blasc/global_vars/image_generator.dart';
import 'package:blasc/global_vars/mobile_message.dart';
import 'package:blasc/responsive/responsive_layout.dart';
import 'package:blasc/routes/popUpRoute.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DesktopExamples extends StatefulWidget {
  const DesktopExamples({Key? key}) : super(key: key);

  @override
  _ExamplesState createState() => _ExamplesState();
}

class _ExamplesState extends State<DesktopExamples> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Constants.backgroundTeal,
      appBar: Header(
        currentHeight,
        currentWidth,
        'Examples',
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // title, headers, and examples
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.15,
                    currentHeight * 0.03,
                    currentWidth * 0.15,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      // title
                      Container(
                        margin: EdgeInsets.only(bottom: currentHeight * 0.03),
                        child: Text(
                          'Examples',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: currentWidth * 0.03,
                          ),
                        ),
                      ),
                      // headers
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
                                'Description',
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
                                'Skills',
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
                                'Image',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: currentWidth * 0.015),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // examples
                      const ExamplesList(),
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

class ExamplesList extends StatefulWidget {
  const ExamplesList({Key? key}) : super(key: key);

  @override
  _ExamplesListState createState() => _ExamplesListState();
}

class _ExamplesListState extends State<ExamplesList> {
  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    // examples stream from firebase
    final Stream<QuerySnapshot> _examplesStream =
        Constants.firestore.collection('examples').snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: _examplesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            child: Align(
              child: CircularProgressIndicator(),
              alignment: Alignment.topCenter,
            ),
          );
        }

        return Column(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PopUpRoute(
                    builder: (context) => ResponsiveLayout(
                      DesktopAdventurePage(document),
                      const MobileMessage(),
                    ),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.only(bottom: currentHeight * 0.01),
                height: currentHeight * 0.2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: currentWidth * 0.002,
                    ),
                  ],
                ),
                // example title, description, skills, and image
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // title
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
                    // description
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        currentWidth * 0.01,
                        0,
                        currentWidth * 0.01,
                        0,
                      ),
                      width: (currentWidth * 0.7) * 0.35,
                      child: Text(
                        data['Description'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: currentWidth * 0.008,
                        ),
                      ),
                    ),
                    // skills
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        currentWidth * 0.01,
                        0,
                        currentWidth * 0.01,
                        0,
                      ),
                      width: (currentWidth * 0.7) * 0.16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ...(data['Skills']).map((skill) {
                            return Text(
                              skill,
                              style: TextStyle(
                                fontSize: currentWidth * 0.008,
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                    // image
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        currentWidth * 0.01,
                        0,
                        currentWidth * 0.01,
                        0,
                      ),
                      width: (currentWidth * 0.7) * 0.15,
                      child: ImageGenerator(
                        data['Image'],
                        null,
                        currentWidth * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
