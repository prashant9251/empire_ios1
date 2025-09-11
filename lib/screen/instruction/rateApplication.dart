import 'package:flutter/material.dart';
import 'package:launch_app_store/launch_app_store.dart';

import '../../main.dart';

class RatingApplication extends StatefulWidget {
  const RatingApplication({Key? key}) : super(key: key);

  @override
  State<RatingApplication> createState() => _RatingApplicationState();
}

class _RatingApplicationState extends State<RatingApplication> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => rateApplication(),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
              child: Text(
            "${firebSoftwraesInfo["ratingMsg"]}",
            style: TextStyle(color: Colors.blue),
          )),
          Image.asset(
            "assets/img/rating.png",
            width: 20,
          )
        ],
      ),
    );
  }

  rateApplication() async {
    await LaunchReview.launch(androidAppId: "$androidId", iOSAppId: "$IosId");
  }
}
