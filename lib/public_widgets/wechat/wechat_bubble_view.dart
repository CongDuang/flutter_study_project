import 'package:flutter/material.dart';
import 'package:flutter_study_project/pages/wechat_sound/wechat_sound_bubble_view.dart';
import 'package:flutter_study_project/res/wechat_res.dart';

enum BubbleType {
  send,
  receiver,
}

class WechatBubbleView extends StatelessWidget {
  const WechatBubbleView({
    super.key,
    this.margin,
    this.constraints,
    this.alignment = Alignment.center,
    this.backgroundColor,
    this.child,
    required this.bubbleType,
  });

  final EdgeInsetsGeometry? margin;
  final BoxConstraints? constraints;
  final AlignmentGeometry? alignment;
  final Color? backgroundColor;
  final Widget? child;
  final BubbleType bubbleType;

  bool get isISend => bubbleType == BubbleType.send;

  @override
  Widget build(BuildContext context) {
    Color bgColor = backgroundColor ?? (isISend ? WechatColors.rightBubbleColor : WechatColors.leftBubbleColor);
    return Container(
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isISend)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.asset(
                WechatImages.icLeftBubbleArrow,
                width: 5,
                color: bgColor,
              ),
            ),
          Container(
            constraints: constraints,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            alignment: alignment,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: borderRadius(isISend),
            ),
            child: child,
          ),
          if (isISend)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Image.asset(
                WechatImages.icRightBubbleArrow,
                width: 5,
                color: bgColor,
              ),
            ),
        ],
      ),
    );
  }
}
