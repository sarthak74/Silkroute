import 'package:url_launcher/url_launcher.dart';

class Helpers {
  launchURLBrowser(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<List<String>> getAgreements() {
    return [
      [
        "Mentioned stock must be available",
        "If stock decreases due to any external reason, immideately update it on app",
        "Do not enter false/ambiguous information of products",
        "85% Payment within 24 hrs, 15% Payment after 15 days (at the end of return policy)",
        "You have to keep your package ready within 2 hrs of getting order confirmation.",
        "There must not be anything else inside package, strict actions will be taken."
      ],
      [
        "If return request is made, we will notify you immideately & you can track the  package.",
        "You have to return the money within 7 days of return request.",
        "due to false information, you will pay logistic charges."
      ]
    ];
  }
}
