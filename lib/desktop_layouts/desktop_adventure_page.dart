import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/image_generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DesktopAdventurePage extends StatelessWidget {
  final DocumentSnapshot document;
  const DesktopAdventurePage(this.document, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Constants.teal1,
            blurRadius: 25,
          ),
        ],
        border: Border.all(
          color: Colors.black,
          width: currentWidth * 0.002,
        ),
      ),
      margin: EdgeInsets.fromLTRB(
        currentWidth * 0.17,
        currentHeight * 0.09,
        currentWidth * 0.17,
        currentHeight * 0.09,
      ),
      child: Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // title
            Container(
              margin: EdgeInsets.fromLTRB(
                currentWidth * 0.025,
                currentHeight * 0.01,
                currentWidth * 0.025,
                currentHeight * 0.01,
              ),
              child: Text(
                data['Title'],
                style: TextStyle(
                  fontSize: currentWidth * 0.03,
                ),
              ),
            ),
            // description and image
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // description
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.025,
                    currentHeight * 0.03,
                    currentWidth * 0.02,
                    currentHeight * 0.03,
                  ),
                  width: currentWidth * 0.4,
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          'Description',
                          style: TextStyle(
                            fontSize: currentWidth * 0.015,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Text(
                        data['Description'],
                        style: TextStyle(
                          fontSize: currentWidth * 0.015,
                        ),
                      ),
                    ],
                  ),
                ),
                // image
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.02,
                    currentHeight * 0.04,
                    currentWidth * 0.025,
                    currentHeight * 0.03,
                  ),
                  child: ImageGenerator(
                    data['Image'],
                    null,
                    currentWidth * 0.16,
                  ),
                )
              ],
            ),
            // skills, subjects, and links
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // skills
                Flexible(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      currentWidth * 0.025,
                      currentHeight * 0.03,
                      currentWidth * 0.02,
                      currentHeight * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          child: Text(
                            'Skills',
                            style: TextStyle(
                              fontSize: currentWidth * 0.015,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                        ),
                        ...(data['Skills']).map((skill) {
                          return Text(
                            skill,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: currentWidth * 0.015,
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                // subjects and links
                Flexible(
                  flex: 6,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      currentWidth * 0.02,
                      currentHeight * 0.03,
                      currentWidth * 0.025,
                      currentHeight * 0.03,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // subjects
                        Container(
                          margin: EdgeInsets.fromLTRB(
                            0,
                            0,
                            currentWidth * 0.025,
                            currentHeight * 0.04,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Subjects',
                                style: TextStyle(
                                  fontSize: currentWidth * 0.015,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              Wrap(
                                children: [
                                  ...(data['Subjects']).map((skill) {
                                    return Text(
                                      skill + ', ',
                                      style: TextStyle(
                                        fontSize: currentWidth * 0.015,
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // links
                        Text(
                          'Links',
                          style: TextStyle(
                            fontSize: currentWidth * 0.015,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        ...(data['Links']).map((skill) {
                          return InkWell(
                            onTap: () {
                              Constants.URLredirect(skill);
                            },
                            child: Text(
                              skill,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                fontSize: currentWidth * 0.015,
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
