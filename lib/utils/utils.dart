import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static Widget placeholder(double height, double space, {double? width}) {
    return Column(
      children: [
        Container(
          height: height,
          width: width ?? double.infinity,
          color: Colors.black.withOpacity(0.2),
        ),
        SizedBox(height: space),
      ],
    );
  }

  static showToast(
    String message,
    Color bgColor,
    Color textColor, {
    int? duration,
  }) {
    // remove any already displayed toasts
    Fluttertoast.cancel();

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: duration ?? 1,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  static requestTimeout() {
    log("EXCEPTION: ", error: "Request timeout");

    Utils.showToast(
        "Maybe you ran out of internet :/. Go get some more and try again.",
        Colors.red,
        Colors.white);
  }

  static catchError(e) {
    log("EXCEPTION: ", error: e.toString());

    Utils.showToast(
      "Oops. Details are hiding and they don't want to come out. Please try again.",
      Colors.red,
      Colors.white,
    );
  }
}

/// CLASS USED TO REMOVE THE SCROLL GLOW FROM LISTS
class NoMoreGlow extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
