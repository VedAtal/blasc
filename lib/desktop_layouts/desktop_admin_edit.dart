import 'dart:typed_data';
import 'package:blasc/global_vars/Constants.dart';
import 'package:blasc/global_vars/image_generator.dart';
import 'package:blasc/global_vars/image_retriever.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class DesktopEdit extends StatefulWidget {
  final DocumentSnapshot currentAdventure;
  final String docID;
  const DesktopEdit(this.currentAdventure, this.docID, {Key? key})
      : super(key: key);

  @override
  _EditState createState() => _EditState(currentAdventure, docID);
}

class _EditState extends State<DesktopEdit> {
  final DocumentSnapshot currentAdventure;
  final String docID;
  _EditState(this.currentAdventure, this.docID);

  final adventureTitleController = TextEditingController();
  final adventureDescriptionController = TextEditingController();
  final adventureLinkControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  int oldImageCount = 1;

  var deleteImageFiles = [];

  @override
  void dispose() {
    adventureDescriptionController.dispose();
    adventureTitleController.dispose();
    for (var linkController in adventureLinkControllers) {
      linkController.dispose();
    }
    super.dispose();
  }

  // prefill current advenutre information
  @override
  void initState() {
    Map<String, dynamic> data =
        currentAdventure.data()! as Map<String, dynamic>;

    adventureTitleController.text = data['Title'];

    adventureDescriptionController.text = data['Description'];

    for (String selectedSubject in data['Subjects']) {
      Constants.subjectSelected[selectedSubject] = true;
    }

    for (String selectedSkill in data['Skills']) {
      Constants.skillSelected[selectedSkill] = true;
    }

    Constants.linkCounter = data['Links'].length;

    if (Constants.linkCounter == 1) {
      Constants.linkCount = ['Link 1'];
    } else if (Constants.linkCounter == 2) {
      Constants.linkCount = ['Link 1', 'Link 2'];
    } else if (Constants.linkCounter == 3) {
      Constants.linkCount = ['Link 1', 'Link 2', 'Link 3'];
    } else {
      Constants.linkCount = ['Link 1', 'Link 2', 'Link 3', 'Link 4'];
    }

    for (String link in data['Links']) {
      adventureLinkControllers[data['Links'].indexOf(link)].text = link;
    }

    for (String image in data['Images']) {
      Constants.imageUUID.add(image.substring(18));
      Constants.imageNameList.add(image);
    }

    oldImageCount = data['Images'].length;

    Constants.status[data['Status']] = true;

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // delete button
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        currentWidth * 0.01,
                        currentHeight * 0.01,
                        currentWidth * 0.01,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          child: IconButton(
                            hoverColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            iconSize: currentWidth * 0.024,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    'Confirm Delete',
                                    style: TextStyle(
                                      fontSize: currentWidth * 0.012,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete this adventure?',
                                    style: TextStyle(
                                      fontSize: currentWidth * 0.01,
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: currentWidth * 0.01,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.white,
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Constants.allSubmissions
                                            .doc(docID)
                                            .delete();
                                        for (int deleteLoop = 0;
                                            deleteLoop < oldImageCount;
                                            deleteLoop++) {
                                          String? url = await ImageRetriever(
                                                  Constants.imageNameList[
                                                      deleteLoop])
                                              .getData();
                                          await FirebaseStorage.instance
                                              .refFromURL(url as String)
                                              .delete();
                                        }
                                        clearSubmission();
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: currentWidth * 0.01,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // exit button
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        currentWidth * 0.01,
                        currentHeight * 0.01,
                        currentWidth * 0.01,
                        0,
                      ),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  'Unsaved Changes',
                                  style: TextStyle(
                                    fontSize: currentWidth * 0.012,
                                  ),
                                ),
                                content: Text(
                                  'You have unsaved changes, are you sure you want to leave this page?',
                                  style: TextStyle(
                                    fontSize: currentWidth * 0.01,
                                  ),
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: currentWidth * 0.01,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      clearSubmission();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Leave',
                                      style: TextStyle(
                                        fontSize: currentWidth * 0.01,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      primary: Constants.teal1,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.close,
                          ),
                          iconSize: currentWidth * 0.025,
                          hoverColor: Colors.transparent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
                // title, description, subjects, links, skills, and images
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.25,
                    currentHeight * 0.05,
                    currentWidth * 0.25,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // page title
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Text(
                          'Edit Adventure',
                          style: TextStyle(
                            fontSize: currentWidth * 0.02,
                          ),
                        ),
                      ),
                      // adventure title
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        height: currentWidth * 0.04,
                        child: TextField(
                          controller: adventureTitleController,
                          textAlignVertical: TextAlignVertical.center,
                          style: TextStyle(
                            fontSize: currentWidth * 0.008,
                          ),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                              fontSize: currentWidth * 0.007,
                            ),
                            labelText: 'Adventure Title',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLength: 100,
                        ),
                      ),
                      // adventure description
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        height: currentWidth * 0.13,
                        child: TextField(
                          controller: adventureDescriptionController,
                          maxLines: (currentHeight * 0.01).round(),
                          style: TextStyle(
                            fontSize: currentWidth * 0.008,
                          ),
                          decoration: InputDecoration(
                            counterStyle: TextStyle(
                              fontSize: currentWidth * 0.007,
                            ),
                            labelText: 'Adventure Description',
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: const OutlineInputBorder(),
                            alignLabelWithHint: true,
                          ),
                          maxLength: 500,
                        ),
                      ),
                      // adventure subjects
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: currentHeight * 0.01,
                              ),
                              child: Text(
                                'Subjects',
                                style: TextStyle(
                                  fontSize: currentWidth * 0.012,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...(Constants.subjects).map((subject) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    Constants.subjectSelected[subject] =
                                        !Constants.subjectSelected[subject]!;
                                  });
                                },
                                child: Container(
                                  height: currentWidth * 0.02,
                                  margin: EdgeInsets.only(
                                    bottom: currentHeight * 0.009,
                                  ),
                                  child: Row(
                                    children: [
                                      Transform.scale(
                                        scale: currentWidth * 0.0006,
                                        child: Checkbox(
                                          value: Constants
                                              .subjectSelected[subject],
                                          hoverColor: Colors.transparent,
                                          onChanged: (checked) {
                                            setState(() {
                                              Constants.subjectSelected[
                                                  subject] = checked!;
                                            });
                                          },
                                          activeColor: Constants.teal1,
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: currentWidth * 0.007,
                                        ),
                                        child: Text(
                                          subject,
                                          style: TextStyle(
                                            fontSize: currentWidth * 0.01,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      // adventure links
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: currentHeight * 0.02,
                              ),
                              child: Text(
                                'Links',
                                style: TextStyle(
                                  fontSize: currentWidth * 0.012,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...(Constants.linkCount).map((link) {
                              return Container(
                                margin: EdgeInsets.only(
                                  bottom: currentHeight * 0.01,
                                ),
                                height: currentWidth * 0.04,
                                child: TextField(
                                  controller: adventureLinkControllers[
                                      Constants.linkCount.indexOf(link)],
                                  textAlignVertical: TextAlignVertical.center,
                                  style: TextStyle(
                                    fontSize: currentWidth * 0.008,
                                  ),
                                  decoration: InputDecoration(
                                    counterStyle: TextStyle(
                                      fontSize: currentWidth * 0.007,
                                    ),
                                    labelText: link,
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.auto,
                                    border: const OutlineInputBorder(),
                                    alignLabelWithHint: true,
                                  ),
                                ),
                              );
                            }).toList(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                    right: currentWidth * 0.01,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (Constants.linkCounter == 4) {
                                        return;
                                      }
                                      setState(() {
                                        Constants.linkCounter++;
                                        Constants.linkCount.add(
                                            'Link ${Constants.linkCounter}');
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    hoverColor: Colors.transparent,
                                    color: Constants.teal2,
                                    iconSize: currentWidth * 0.018,
                                    tooltip: 'Add another link',
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    left: currentWidth * 0.01,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (Constants.linkCounter == 1) {
                                        return;
                                      }
                                      setState(() {
                                        Constants.linkCount.remove(
                                            'Link ${Constants.linkCounter}');
                                        adventureLinkControllers[
                                                Constants.linkCounter - 1]
                                            .clear();
                                      });
                                      Constants.linkCounter--;
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                    hoverColor: Colors.transparent,
                                    color: Constants.teal2,
                                    iconSize: currentWidth * 0.018,
                                    tooltip: 'Remove previous link',
                                    padding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // adventure skills
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                bottom: currentHeight * 0.02,
                              ),
                              child: Text(
                                'Skills',
                                style: TextStyle(
                                  fontSize: currentWidth * 0.012,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...(Constants.skillTopics).map((topic) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        Constants.skillTopicSelected[topic] =
                                            !Constants
                                                .skillTopicSelected[topic]!;
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(
                                        bottom: currentHeight * 0.01,
                                      ),
                                      child: Row(
                                        children: [
                                          Transform.scale(
                                            scale: currentWidth * 0.0006,
                                            child: IconButton(
                                              icon: Constants
                                                          .skillTopicSelected[
                                                      topic]!
                                                  ? const Icon(Icons
                                                      .arrow_drop_down_sharp)
                                                  : const Icon(
                                                      Icons.arrow_right),
                                              onPressed: () {
                                                setState(() {
                                                  Constants.skillTopicSelected[
                                                      topic] = !Constants
                                                          .skillTopicSelected[
                                                      topic]!;
                                                });
                                              },
                                              hoverColor: Colors.transparent,
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                              left: currentWidth * 0.007,
                                            ),
                                            child: Text(
                                              topic,
                                              style: TextStyle(
                                                fontSize: currentWidth * 0.01,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  ...(Constants.skills[topic])!.map((skill) {
                                    if (Constants.skillTopicSelected[topic] ==
                                        false) {
                                      return const SizedBox.shrink();
                                    } else {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            Constants.skillSelected[skill] =
                                                !Constants
                                                    .skillSelected[skill]!;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.only(
                                            left: currentWidth * 0.01,
                                          ),
                                          height: currentWidth * 0.02,
                                          margin: EdgeInsets.only(
                                            bottom: currentHeight * 0.009,
                                          ),
                                          child: Row(
                                            children: [
                                              Transform.scale(
                                                scale: currentWidth * 0.0006,
                                                child: Checkbox(
                                                  hoverColor:
                                                      Colors.transparent,
                                                  value: Constants
                                                      .skillSelected[skill],
                                                  onChanged: (checked) {
                                                    setState(() {
                                                      Constants.skillSelected[
                                                          skill] = checked!;
                                                    });
                                                  },
                                                  activeColor: Constants.teal1,
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  left: currentWidth * 0.007,
                                                ),
                                                child: Text(
                                                  skill,
                                                  style: TextStyle(
                                                    fontSize:
                                                        currentWidth * 0.01,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      // adventure images
                      Align(
                        child: Container(
                          margin: EdgeInsets.only(
                            bottom: currentHeight * 0.02,
                          ),
                          child: Text(
                            'Images',
                            style: TextStyle(
                              fontSize: currentWidth * 0.012,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.02,
                        ),
                        height: currentHeight * 0.12,
                        width: double.maxFinite,
                        child: InkWell(
                          child: DottedBorder(
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    size: currentWidth * 0.018,
                                  ),
                                  Text(
                                    'Click to Upload',
                                    style: TextStyle(
                                      fontSize: currentWidth * 0.01,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            strokeWidth: 2,
                            color: Colors.grey,
                            dashPattern: const [4],
                          ),
                          hoverColor: Colors.transparent,
                          onTap: () async {
                            if (Constants.imageNameList.length == 5) {
                              return;
                            }
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['png', 'jpeg', 'jpg'],
                            );
                            if (result != null) {
                              Uint8List? file = result.files.first.bytes;
                              setState(() {
                                Constants.imageList.add(file);
                                String uuid = const Uuid().v4();
                                Constants.imageUUID.add(uuid);
                                Constants.imageNameList
                                    .add('submission_images/' + uuid);
                              });
                            }
                          },
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Wrap(
                          children: [
                            ...(Constants.imageNameList).map((imageName) {
                              return InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                          content: ImageGenerator(
                                        imageName,
                                        null,
                                        currentWidth * 0.08,
                                      ));
                                    },
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  margin: EdgeInsets.fromLTRB(
                                    0,
                                    0,
                                    currentWidth * 0.003,
                                    currentHeight * 0.005,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: imageName,
                                          style: TextStyle(
                                            fontSize: currentWidth * 0.01,
                                          ),
                                        ),
                                        WidgetSpan(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              left: currentWidth * 0.003,
                                            ),
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  if (Constants.imageNameList
                                                          .indexOf(imageName) <
                                                      oldImageCount) {
                                                    deleteImageFiles
                                                        .add(imageName);
                                                    Constants.imageNameList
                                                        .remove(imageName);
                                                    Constants.imageUUID.remove(
                                                        imageName
                                                            .toString()
                                                            .substring(18));
                                                    oldImageCount--;
                                                  } else {
                                                    Constants.imageNameList
                                                        .remove(imageName);
                                                    Constants.imageUUID.remove(
                                                        imageName
                                                            .toString()
                                                            .substring(18));
                                                    Constants.imageList.remove(
                                                        Constants.imageNameList
                                                                .indexOf(
                                                                    imageName) -
                                                            oldImageCount);
                                                  }
                                                });
                                              },
                                              child: Icon(
                                                Icons.close,
                                                size: currentWidth * 0.011,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      // adventure status
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              child: Text(
                                'Pending',
                                style: TextStyle(
                                  color: Constants.status['Pending']!
                                      ? Colors.white
                                      : Colors.orange,
                                  fontSize: currentWidth * 0.015,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Constants.status['Pending'] = true;
                                  Constants.status['Approved'] = false;
                                  Constants.status['Rejected'] = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Constants.status['Pending']!
                                    ? Colors.orange
                                    : Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              child: Text(
                                'Rejected',
                                style: TextStyle(
                                  color: Constants.status['Rejected']!
                                      ? Colors.white
                                      : Colors.red,
                                  fontSize: currentWidth * 0.015,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Constants.status['Pending'] = false;
                                  Constants.status['Approved'] = false;
                                  Constants.status['Rejected'] = true;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Constants.status['Rejected']!
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                            ElevatedButton(
                              child: Text(
                                'Approved',
                                style: TextStyle(
                                  color: Constants.status['Approved']!
                                      ? Colors.white
                                      : Colors.green,
                                  fontSize: currentWidth * 0.015,
                                ),
                              ),
                              onPressed: () {
                                setState(() {
                                  Constants.status['Pending'] = false;
                                  Constants.status['Approved'] = true;
                                  Constants.status['Rejected'] = false;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Constants.status['Approved']!
                                    ? Colors.green
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // update adventure
                      Container(
                        margin: EdgeInsets.only(
                          bottom: currentHeight * 0.04,
                        ),
                        width: double.maxFinite,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Constants.teal1,
                          ),
                          child: Text(
                            'Update Adventure',
                            style: TextStyle(
                              fontSize: currentWidth * 0.015,
                            ),
                          ),
                          onPressed: () {
                            updateAdventure();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // update adventure information in firebase
  Future<void> updateAdventure() async {
    var skills = [];
    var subjects = [];
    var links = [];
    var imagePaths = [];

    Constants.skillSelected.forEach((key, value) {
      if (value == true) {
        skills.add(key);
      }
    });

    Constants.subjectSelected.forEach((key, value) {
      if (value == true) {
        subjects.add(key);
      }
    });

    for (int linkLoop = 0; linkLoop < Constants.linkCounter; linkLoop++) {
      links.add(adventureLinkControllers[linkLoop].text.trim());
    }

    for (String imageID in Constants.imageNameList) {
      imagePaths.add(imageID);
    }

    for (int uploadLoop = 0;
        uploadLoop < Constants.imageList.length;
        uploadLoop++) {
      Constants.firebaseStorage
          .ref('submission_images')
          .child(Constants.imageUUID[oldImageCount])
          .putData(Constants.imageList[uploadLoop]);
      oldImageCount++;
    }

    for (int deleteLoop = 0;
        deleteLoop < deleteImageFiles.length;
        deleteLoop++) {
      String? url =
          await ImageRetriever(deleteImageFiles[deleteLoop]).getData();
      await FirebaseStorage.instance.refFromURL(url as String).delete();
    }

    Constants.allSubmissions.doc(docID).set(
      {
        'Title': adventureTitleController.text.trim(),
        'Description': adventureDescriptionController.text.trim(),
        'Skills': skills,
        'Subjects': subjects,
        'Images': imagePaths,
        'Links': links,
        'Status': Constants.status['Pending']!
            ? 'Pending'
            : Constants.status['Approved']!
                ? 'Approved'
                : 'Rejected',
      },
      SetOptions(merge: true),
    );

    clearSubmission();

    Navigator.pop(context);
  }

  // clear submission fields
  void clearSubmission() {
    Constants.skillSelected.forEach((key, value) {
      Constants.skillSelected[key] = false;
    });

    Constants.subjectSelected.forEach((key, value) {
      Constants.subjectSelected[key] = false;
    });

    Constants.skillTopicSelected.forEach((key, value) {
      Constants.skillTopicSelected[key] = false;
    });

    Constants.status.forEach((key, value) {
      Constants.status[key] = false;
    });

    Constants.linkCounter = 1;
    Constants.linkCount.length = 1;
    Constants.imageList.clear();
    Constants.imageNameList.clear();
    Constants.imageUUID.clear();
    deleteImageFiles.clear();

    dispose();
  }
}
