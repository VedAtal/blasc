import 'package:blasc/desktop_layouts/desktop_admin_status.dart';
import 'package:blasc/desktop_layouts/desktop_dashboard.dart';
import 'package:blasc/desktop_layouts/desktop_examples.dart';
import 'package:blasc/desktop_layouts/desktop_status.dart';
import 'package:blasc/desktop_layouts/desktop_submission.dart';
import 'package:blasc/global_vars/mobile_message.dart';
import 'package:blasc/responsive/responsive_layout.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class Constants {
  // firebase vars
  static final firestore = FirebaseFirestore.instance;
  static final firebaseStorage = FirebaseStorage.instance;
  static User? user = FirebaseAuth.instance.currentUser;
  static final CollectionReference allSubmissions =
      firestore.collection('submissions');

  // vars
  static var pages = [
    'Home',
    'Examples',
    'Submission',
    'Status',
  ];

  static var pageRoutes = {
    'Home': const ResponsiveLayout(DesktopDashboard(), MobileMessage()),
    'Examples': const ResponsiveLayout(DesktopExamples(), MobileMessage()),
    'Submission': const ResponsiveLayout(DesktopSubmission(), MobileMessage()),
    'Status': user!.uid == 'cKV7qf9OZGhuMSQGGGXXQQezPoC2'
        ? const AdminStatus()
        : const ResponsiveLayout(DesktopStatus(), MobileMessage()),
  };

  static var homeIntro = [
    'Welcome to ',
    'BeSomeone Learning Adventure Submissions Curation (BLASC), ',
    'where YOU can submit a new learning adventure to be discovered by '
        'classrooms all over the world in a few simple steps:',
    '1. Make sure your learning adventure has a website with all the '
        'details needed for a classroom to run the adventure. It can be as '
        'simple as a public Google Doc, PDF, or Google Site to as complex as a '
        'full website. You\'ll need the link URL to submit a learning adventure '
        'to BeSomeone.',
    '2. Fill out the Submission form, including one or more '
        'good representative pictures.',
    '3. Our curators will review (and potentially '
        'edit) your submission, and then either accept it (it\'s now in the app!) '
        'or decline it with notes. You\'ll receive an email when the status changes. '
        'If you\'re declined, feel free to review the notes, make changes, and '
        're-submit!',
    'That\'s it! It\'s just that simple, and then your learning adventure '
        'can be impacting students everywhere. Thank you for taking the time to make a difference!'
  ];

  static var subjects = [
    'English',
    'Social Studies',
    'Math',
    'Science',
    'Technology',
    'Foreign Language',
    'Arts',
    'Sports',
    'Career',
  ];

  static var subjectSelected = {
    'English': false,
    'Social Studies': false,
    'Math': false,
    'Science': false,
    'Technology': false,
    'Foreign Language': false,
    'Arts': false,
    'Sports': false,
    'Career': false,
  };

  static var linkCounter = 1;
  static var linkCount = [
    'Link 1',
  ];

  static var skillTopics = [
    'Mindful Self',
    'Servant Leader',
    'Compelling Communicator',
    'Critical Thinker and Problem Solver',
    'Creative Maker',
  ];

  static var skillTopicSelected = {
    'Mindful Self': false,
    'Servant Leader': false,
    'Compelling Communicator': false,
    'Critical Thinker and Problem Solver': false,
    'Creative Maker': false,
  };

  static var skills = {
    'Mindful Self': [
      'Healthy Habits',
      'Growth Mindset',
      'Self-Direction',
      'Self-Reflection/Journaling',
      'Emotional Self-Regulation',
      'Good Judgement',
      'Confidence+Courage',
      'Curiosity+Imagination',
      'Wayfinding',
      'Individual Sport',
    ],
    'Servant Leader': [
      'Warm-Hearted',
      'Tough-Minded',
      'Peer Support',
      'Conflict Resolution and Negotiation',
      'Team Sport',
      'Collaborative Teamwork',
      'Community Volunteering',
      'Enterprising Entrepreneurship',
      'Zest+Humor',
      'Event Organizer or Volunteer',
    ],
    'Compelling Communicator': [
      'Reading',
      'Spelling',
      'Grammar',
      'Vocabulary Expansion',
      'Keyboard/Typing',
      'Nonfiction Writing',
      'Fiction Writing',
      'Writing Feedback',
      'Multimedia',
      'Presenting',
      'Active Listening',
      'Foreign Language',
      'Adventure Promoter',
    ],
    'Critical Thinker and Problem Solver': [
      'Math Problem Solving',
      'Socratic Dialogue/Debate',
      'Evidence Evaluation',
      'Textual Analysis',
      'Inquiry-Based Investigation',
      'Financial Literacy',
      'Coding+Algorithim Structuring',
      'Modeling+Simulations',
      'Decision Analysis',
      'Creative Problem-Solving Approaches',
    ],
    'Creative Maker': [
      'Innovative Design Thinking',
      'Art',
      'Cooking',
      'Music',
      'Theater',
      'Video Creation',
      'Making',
      'Graphic Design+Animation',
      'Digital Design+Fabrication',
      'Engineering+Robotics',
      'Adventure Creator',
    ],
  };

  static var skillSelected = {
    'Healthy Habits': false,
    'Growth Mindset': false,
    'Self-Direction': false,
    'Self-Reflection/Journaling': false,
    'Emotional Self-Regulation': false,
    'Good Judgement': false,
    'Confidence+Courage': false,
    'Curiosity+Imagination': false,
    'Wayfinding': false,
    'Individual Sport': false,
    'Warm-Hearted': false,
    'Tough-Minded': false,
    'Peer Support': false,
    'Conflict Resolution and Negotiation': false,
    'Citizenship': false,
    'Team Sport': false,
    'Collaborative Teamwork': false,
    'Community Volunteering': false,
    'Enterprising Entrepreneurship': false,
    'Zest+Humor': false,
    'Event Organizer or Volunteer': false,
    'Reading': false,
    'Spelling': false,
    'Grammar': false,
    'Vocabulary Expansion': false,
    'Keyboard/Typing': false,
    'Nonfiction Writing': false,
    'Fiction Writing': false,
    'Writing Feedback': false,
    'Multimedia': false,
    'Presenting': false,
    'Active Listening': false,
    'Foreign Language': false,
    'Adventure Promoter': false,
    'Math Problem Solving': false,
    'Socratic Dialogue/Debate': false,
    'Evidence Evaluation': false,
    'Textual Analysis': false,
    'Inquiry-Based Investigation': false,
    'Financial Literacy': false,
    'Coding+Algorithim Structuring': false,
    'Modeling+Simulations': false,
    'Decision Analysis': false,
    'Creative Problem-Solving Approaches': false,
    'Innovative Design Thinking': false,
    'Art': false,
    'Cooking': false,
    'Music': false,
    'Theater': false,
    'Video Creation': false,
    'Making': false,
    'Graphic Design+Animation': false,
    'Digital Design+Fabrication': false,
    'Engineering+Robotics': false,
    'Adventure Creator': false,
  };

  static var imageNameList = [];

  static var imageList = [];

  static var imageUUID = [];

  static var status = {
    'Pending': false,
    'Approved': false,
    'Rejected': false,
  };

  // colors
  static const Color teal1 = Color.fromRGBO(26, 166, 159, 100);
  static const Color teal2 = Color.fromARGB(156, 4, 136, 129);
  static const Color gold = Color.fromARGB(255, 238, 176, 5);
  static const Color backgroundTeal = Color.fromARGB(156, 214, 243, 243);
  // static const Color backgroundTeal = Color.fromARGB(156, 190, 214, 213);

  // methods
  static void BSredirect() async {
    var url = 'https://besomeone.app/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }

  static void URLredirect(String URL) async {
    var url = URL;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "Could not launch $url";
    }
  }
}
