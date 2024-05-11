import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_study_project/public_widgets/wechat/wechat_bubble_view.dart';

class WechatMsgItemContainer extends StatefulWidget {
  const WechatMsgItemContainer({
    super.key,
    required this.msgId,
    required this.isBubbleBg,
    required this.isISend,
    required this.isShowSending,
    required this.child,
    this.bubbleColor,
  });

  final String msgId;
  final bool isBubbleBg;
  final bool isISend;
  final bool isShowSending;
  final Widget child;
  final Color? bubbleColor;

  @override
  State<WechatMsgItemContainer> createState() => _WechatMsgItemContainerState();
}

class _WechatMsgItemContainerState extends State<WechatMsgItemContainer> {
  Widget _buildChildView(BubbleType type) {
    if (widget.isBubbleBg) {
      return WechatBubbleView(
        bubbleType: type,
        backgroundColor: widget.bubbleColor,
        child: widget.child,
      );
    }
    return widget.child;
  }

  Widget _buildLeftView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildChildView(BubbleType.receiver),
              ],
            )
          ],
        )
      ],
    );
  }

  Widget _buildRightView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildChildView(BubbleType.send),
              ],
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: widget.isISend ? _buildRightView() : _buildLeftView()),
            ],
          )
        ],
      ),
    );
  }
}
