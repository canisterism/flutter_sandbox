import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateMyAppScreen extends StatefulWidget {
  const RateMyAppScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => RateMyAppScreenState();
}

class RateMyAppScreenState extends State<RateMyAppScreen> {
  WidgetBuilder builder = initialWidgetBuilder;

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Rate my app !'),
          ),
          body: RateMyAppBuilder(
            builder: builder,
            onInitialized: (context, rateMyApp) {
              setState(() =>
                  builder = (context) => ContentWidget(rateMyApp: rateMyApp));
              rateMyApp.conditions.forEach((condition) {
                if (condition is DebuggableCondition) {
                  print(condition
                      .valuesAsString); // We iterate through our list of conditions and we print all debuggable ones.
                }
              });

              print('Are all conditions met ? ' +
                  (rateMyApp.shouldOpenDialog ? 'Yes' : 'No'));

              if (rateMyApp.shouldOpenDialog) {
                rateMyApp.showRateDialog(context);
              }
            },
          ),
        ),
      );

  static Widget initialWidgetBuilder(BuildContext context) =>
      const Center(child: CircularProgressIndicator());
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({@required this.rateMyApp, Key key}) : super(key: key);
  final RateMyApp rateMyApp;

  @override
  State<StatefulWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  RateMyApp arbitraryRateMyAppController = RateMyApp(
      appStoreIdentifier: 'YOUR APP ID', googlePlayIdentifier: 'YOUR APP ID');
  List<DebuggableCondition> debuggableConditions = [];

  /// Whether the dialog should be opened.
  bool shouldOpenDialog = false;

  void openStarRateDialog() async {
    arbitraryRateMyAppController.init().then((value) =>
        arbitraryRateMyAppController.showStarRateDialog(context,
            title: 'Rate this app', // The dialog title.
            message:
                'You like this app ? Then take a little bit of your time to leave a rating :', // The dialog message.
            // contentBuilder: (context, defaultContent) => content, // This one allows you to change the default dialog content.
            actionsBuilder: (context, stars) {
              // Triggered when the user updates the star rating.
              return [
                // Return a list of actions (that will be shown at the bottom of the dialog).
                FlatButton(
                  child: Text('OK'),
                  onPressed: () async {
                    print('Thanks for the ' +
                        (stars == null ? '0' : stars.round().toString()) +
                        ' star(s) !');
                    // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                    // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                    await arbitraryRateMyAppController
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  },
                ),
              ];
            },
            ignoreIOS:
                false, // Set to false if you want to show the native Apple app rating dialog on iOS.
            dialogStyle: DialogStyle(
              // Custom dialog styles.
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20),
            ),
            starRatingOptions:
                StarRatingOptions(), // Custom star bar rating options.
            onDismissed: () => arbitraryRateMyAppController
                .callEvent(RateMyAppEventType.laterButtonPressed)));
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (DebuggableCondition condition in debuggableConditions) //
              textCenter(condition.valuesAsString),
            textCenter(
                'Are conditions met ? ' + (shouldOpenDialog ? 'Yes' : 'No')),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: RaisedButton(
                child: const Text('Launch "Rate my app" dialog'),
                onPressed: () async {
                  await widget.rateMyApp.showRateDialog(
                      context); // We launch the default Rate my app dialog.
                  refresh();
                },
              ),
            ),
            RaisedButton(
              child: const Text('Launch "Rate my app" star dialog'),
              onPressed: () async {
                await widget.rateMyApp.showStarRateDialog(context,
                    actionsBuilder: (_, stars) => starRateDialogActionsBuilder(
                        context,
                        stars)); // We launch the Rate my app dialog with stars.
                refresh();
              },
            ),
            RaisedButton(
              child: const Text('Reset'),
              onPressed: () async {
                await widget.rateMyApp
                    .reset(); // We reset all Rate my app conditions values.
                refresh();
              },
            ),
            RaisedButton(
              child: const Text('Rate an Arbitrary App with stars'),
              onPressed: () {
                openStarRateDialog();
                refresh();
              },
            ),
          ],
        ),
      );

  /// Returns a centered text.
  Text textCenter(String content) => Text(
        content,
        textAlign: TextAlign.center,
      );

  /// Allows to refresh the widget state.
  void refresh() {
    setState(() {
      debuggableConditions =
          widget.rateMyApp.conditions.whereType<DebuggableCondition>().toList();
      shouldOpenDialog = widget.rateMyApp.shouldOpenDialog;
    });
  }

  List<Widget> starRateDialogActionsBuilder(
      BuildContext context, double stars) {
    final Widget cancelButton = RateMyAppNoButton(
      // We create a custom "Cancel" button using the RateMyAppNoButton class.
      widget.rateMyApp,
      text: MaterialLocalizations.of(context).cancelButtonLabel.toUpperCase(),
      callback: refresh,
    );
    if (stars == null || stars == 0) {
      // If there is no rating (or a 0 star rating), we only have to return our cancel button.
      return [cancelButton];
    }

    // Otherwise we can do some little more things...
    String message = 'You put ' + stars.round().toString() + ' star(s). ';
    Color color;
    switch (stars.round()) {
      case 1:
        message += 'Did this app hurt you physically ?';
        color = Colors.red;
        break;
      case 2:
        message += 'That\'s not really cool man.';
        color = Colors.orange;
        break;
      case 3:
        message += 'Well, it\'s average.';
        color = Colors.yellow;
        break;
      case 4:
        message += 'This is cool, like this app.';
        color = Colors.lime;
        break;
      case 5:
        message += 'Great ! <3';
        color = Colors.green;
        break;
    }

    return [
      FlatButton(
        child:
            Text(MaterialLocalizations.of(context).okButtonLabel.toUpperCase()),
        onPressed: () async {
          print(message);
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: color,
            ),
          );

          // This allow to mimic a click on the default "Rate" button and thus update the conditions based on it ("Do not open again" condition for example) :
          await widget.rateMyApp
              .callEvent(RateMyAppEventType.rateButtonPressed);
          Navigator.pop<RateMyAppDialogButton>(
              context, RateMyAppDialogButton.rate);
          refresh();
        },
      ),
      cancelButton,
    ];
  }
}
