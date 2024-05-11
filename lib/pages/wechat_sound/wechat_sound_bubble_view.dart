import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class WechatSoundBubbleView extends StatelessWidget {
  const WechatSoundBubbleView({
    super.key,
  });

  List<Widget> indicators() {
    final result = <Widget>[];
    for (int i = 0; i <= 3; i++) {
      result.add(const LoadingIndicator(
        indicatorType: Indicator.lineScalePulseOut,
        colors: [Colors.black],
        strokeWidth: 4.0,
        pathBackgroundColor: Colors.black45,
      ));
      result.add(const SizedBox(
        width: 2,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: borderRadius(false),
          ),
          child: SizedBox(
            height: 15,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...indicators(),
                ],
              ),
            ),
          ),
        ),
        Container(
          width: 15,
        )
      ],
    );
  }
}

BorderRadius borderRadius(bool isISend) => BorderRadius.only(
      topLeft: Radius.circular(isISend ? 6 : 6),
      topRight: Radius.circular(isISend ? 6 : 6),
      bottomLeft: const Radius.circular(6),
      bottomRight: const Radius.circular(6),
    );
