import 'dart:typed_data';
import 'package:blasc/global_vars/Constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:uuid/uuid.dart';

class DesktopSubmit extends StatefulWidget {
  const DesktopSubmit({Key? key}) : super(key: key);

  @override
  _SubmitState createState() => _SubmitState();
}

class _SubmitState extends State<DesktopSubmit> {
  final ScrollController _scroller = ScrollController();

  final adventureTitleController = TextEditingController();
  final adventureDescriptionController = TextEditingController();
  final adventureLinkControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String? _titleError;
  String? _descriptionError;
  final List<String?> _linkErrors = [
    null,
    null,
    null,
    null,
  ];
  bool _subjectError = false;
  bool _skillError = false;
  bool _imageError = false;

  @override
  void dispose() {
    adventureDescriptionController.dispose();
    adventureTitleController.dispose();
    for (var linkController in adventureLinkControllers) {
      linkController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: CustomScrollView(
        controller: _scroller,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // exit button
                Container(
                  margin: EdgeInsets.fromLTRB(
                    currentWidth * 0.01,
                    currentHeight * 0.01,
                    currentWidth * 0.01,
                    currentHeight * 0.01,
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
                    ),
                  ),
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
                          'Create Adventure',
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
                            errorText: _titleError,
                          ),
                          maxLength: 100,
                          onChanged: (text) {
                            if (text.trim() != '') {
                              setState(() {
                                _titleError = null;
                              });
                            }
                          },
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
                            errorText: _descriptionError,
                          ),
                          maxLength: 500,
                          onChanged: (text) {
                            if (text.trim() != '') {
                              setState(() {
                                _descriptionError = null;
                              });
                            }
                          },
                        ),
                      ),
                      // adventure subjects
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color:
                                _subjectError ? Colors.red : Colors.transparent,
                            width: 1,
                          ),
                        ),
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
                                    _subjectError = false;
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
                                              _subjectError = false;
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
                        padding: const EdgeInsets.all(5),
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
                                    errorText: _linkErrors[
                                        Constants.linkCount.indexOf(link)],
                                  ),
                                  onChanged: (text) {
                                    if (text.trim() != '') {
                                      setState(() {
                                        _linkErrors[Constants.linkCount
                                            .indexOf(link)] = null;
                                      });
                                    }
                                  },
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
                                        _linkErrors[Constants.linkCounter - 1] =
                                            null;
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
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color:
                                _skillError ? Colors.red : Colors.transparent,
                            width: 1,
                          ),
                        ),
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
                                            _skillError = false;
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
                                                      _skillError = false;
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
                      Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Align(
                              child: Container(
                                padding: const EdgeInsets.all(5),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                  color: _imageError ? Colors.red : Colors.grey,
                                  dashPattern: const [4],
                                ),
                                hoverColor: Colors.transparent,
                                onTap: () async {
                                  setState(() {
                                    _imageError = false;
                                  });
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
                                    String fileName = result.files.first.name;
                                    setState(() {
                                      Constants.imageNameList.add(fileName);
                                      Constants.imageList.add(file);
                                      Constants.imageUUID
                                          .add(const Uuid().v4());
                                    });
                                  }
                                },
                              ),
                            ),
                          ],
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
                              return Container(
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
                                                int index = Constants
                                                    .imageNameList
                                                    .indexOf(imageName);
                                                Constants.imageNameList
                                                    .remove(imageName);
                                                Constants.imageList
                                                    .removeAt(index);
                                                Constants.imageUUID
                                                    .removeAt(index);
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
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                      // submit adventure
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
                            'Submit Adventure',
                            style: TextStyle(
                              fontSize: currentWidth * 0.015,
                            ),
                          ),
                          onPressed: () {
                            submitAdventure();
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

  // upload adventure information to firebase
  Future<void> submitAdventure() async {
    bool anyEmptyFields = false;

    if (adventureTitleController.text.isEmpty) {
      _titleError = 'Can\'t be empty';
      anyEmptyFields = true;
    }

    if (adventureDescriptionController.text.isEmpty) {
      _descriptionError = 'Can\'t be empty';
      anyEmptyFields = true;
    }

    for (int linkLoop = 0; linkLoop < Constants.linkCounter; linkLoop++) {
      if (adventureLinkControllers[linkLoop].text.isEmpty) {
        _linkErrors[linkLoop] = 'Can\'t be empty';
        anyEmptyFields = true;
      }
    }

    if (!Constants.subjectSelected.containsValue(true)) {
      _subjectError = true;
      anyEmptyFields = true;
    }

    if (!Constants.skillSelected.containsValue(true)) {
      _skillError = true;
      anyEmptyFields = true;
    }

    if (Constants.imageList.isEmpty) {
      _imageError = true;
      anyEmptyFields = true;
    }

    if (anyEmptyFields) {
      setState(() {
        _scroller.jumpTo(_scroller.position.minScrollExtent);
      });
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text(
              'Some fields are empty.',
              textAlign: TextAlign.center,
            ),
          );
        },
      );
      return;
    }

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

    for (String imageID in Constants.imageUUID) {
      imagePaths.add('submission_images/' + imageID);
    }

    for (int uploadLoop = 0;
        uploadLoop < Constants.imageNameList.length;
        uploadLoop++) {
      Constants.firebaseStorage
          .ref('submission_images')
          .child(Constants.imageUUID[uploadLoop])
          .putData(Constants.imageList[uploadLoop]);
    }

    Constants.allSubmissions.add({
      'Title': adventureTitleController.text.trim(),
      'Description': adventureDescriptionController.text.trim(),
      'Skills': skills,
      'Subjects': subjects,
      'Images': imagePaths,
      'Links': links,
      'Status': 'Pending',
      'User': Constants.user!.email,
      'UID': Constants.user!.uid,
      'Created': FieldValue.serverTimestamp(),
    });

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

    dispose();
  }
}
