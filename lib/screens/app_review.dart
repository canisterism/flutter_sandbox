import 'package:app_review/app_review.dart';
import 'package:flutter/material.dart';

class AppReviewScreen extends StatefulWidget {
  const AppReviewScreen({Key key}) : super(key: key);
  static String routeName = '/home';

  @override
  _AppReviewScreenState createState() => _AppReviewScreenState();
}

class _AppReviewScreenState extends State<AppReviewScreen> {
  @override
  initState() {
    super.initState();
    AppReview.getAppID.then((onValue) {
      setState(() {
        appID = onValue;
      });
      print("App ID" + appID);
    });
  }

  String appID = "";
  String output = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('App Review'),
        ),
        body: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              SizedBox.fromSize(size: Size(0, 40.0)),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('App ID'),
                subtitle: Text(appID),
                onTap: () {
                  AppReview.getAppID.then((onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              ListTile(
                leading: const Icon(
                  Icons.shop,
                ),
                title: const Text('View Store Page'),
                onTap: () {
                  AppReview.storeListing.then((onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              ListTile(
                leading: const Icon(
                  Icons.star,
                ),
                title: const Text('Request Review'),
                onTap: () {
                  AppReview.requestReview.then((onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              ListTile(
                leading: const Icon(
                  Icons.note_add,
                ),
                title: const Text('Write a  Review'),
                onTap: () {
                  AppReview.writeReview.then((onValue) {
                    setState(() {
                      output = onValue;
                    });
                    print(onValue);
                  });
                },
              ),
              const Divider(height: 20.0),
              ListTile(
                title: Text(output),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
