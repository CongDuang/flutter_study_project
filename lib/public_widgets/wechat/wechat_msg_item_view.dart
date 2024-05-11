import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_study_project/pages/wechat_sound/wechat_sound_msg_view.dart';
import 'package:flutter_study_project/public_widgets/wechat/models/msg.dart';
import 'package:flutter_study_project/public_widgets/wechat/wechat_msg_item_container.dart';
import 'package:rxdart/rxdart.dart';

double imageMaxWidth = 120;
double maxWidth = 247;
double locationWidth = 220;

class WechatMsgItemView extends StatefulWidget {
  const WechatMsgItemView({
    super.key,
    this.itemViewBuilder,
    this.customTypeBuilder,
    this.notificationTypeBuilder,
    this.voicePlayStatusSub,
    required this.msg,
    this.textScaleFactor = 1.0,
    this.onClickItemView,
  });

  final ItemViewBuilder? itemViewBuilder;
  final CustomTypeBuilder? customTypeBuilder;
  final NotificationTypeBuilder? notificationTypeBuilder;

  final Subject<MsgInfoStreamEv<bool>>? voicePlayStatusSub;
  final Msg msg;

  final double textScaleFactor;
  final Function()? onClickItemView;

  @override
  State<WechatMsgItemView> createState() => _WechatMsgItemViewState();
}

class _WechatMsgItemViewState extends State<WechatMsgItemView> {
  Msg get _msg => widget.msg;

  bool get _isISend => true;

  late StreamSubscription<bool> _keyboardSubs;

  @override
  void initState() {
    final keyboardVisibilityCtrl = KeyboardVisibilityController();
    _keyboardSubs = keyboardVisibilityCtrl.onChange.listen((bool visible) {});
    super.initState();
  }

  @override
  void dispose() {
    _keyboardSubs.cancel();
    super.dispose();
  }

  Widget get _child => widget.itemViewBuilder?.call(context, _msg) ?? _buildChildView();

  Widget _buildChildView() {
    Widget? child;
    final itemView = buildMsgInfoItemView(
      msg: _msg,
      textScaleFactor: widget.textScaleFactor,
      isISend: _isISend,
      voicePlayStatusSub: widget.voicePlayStatusSub,
    );
    child = itemView.child;
    return child = WechatMsgItemContainer(
      key: ValueKey(_msg.msgId),
      msgId: _msg.msgId ?? "",
      isISend: _isISend,
      isShowSending: itemView.isShowSending,
      isBubbleBg: child == null ? true : itemView.isBubbleBg,
      bubbleColor: itemView.bubbleColor,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: widget.onClickItemView,
        child: child ?? const Text("暂不支持该类型"),
      ),
    );
  }

  static MsgItemView buildMsgInfoItemView({
    required Msg msg,
    required double textScaleFactor,
    required bool isISend,
    Subject<MsgInfoStreamEv<bool>>? voicePlayStatusSub,
  }) {
    Widget? child;
    bool isBubbleBg = false;
    Color? bubbleColor;
    bool isShowSending = false;
    bool isUseContainer = true;

    isBubbleBg = true;
    isShowSending = true;
    child = WechatSoundMsgView(
      msg: msg,
      isISend: isISend,
      voicePlayStatusSub: voicePlayStatusSub,
    );

    return MsgItemView(
      child: child,
      isBubbleBg: isBubbleBg,
      bubbleColor: bubbleColor,
      isUseContainer: isUseContainer,
      isShowSending: isShowSending,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: _child,
      ),
    );
  }
}

typedef ItemViewBuilder = Widget? Function(
  BuildContext context,
  Msg msg,
);

typedef NotificationTypeBuilder = Widget? Function(
  BuildContext context,
  Msg msg,
);

typedef ItemVisibilityChange = void Function(
  Msg msg,
  bool visible,
);

class CustomTypeInfo {
  final Widget customView;
  final bool needBubbleBackground;
  final bool needChatItemContainer;

  CustomTypeInfo(
    this.customView, [
    this.needBubbleBackground = true,
    this.needChatItemContainer = true,
  ]);
}

typedef CustomTypeBuilder = CustomTypeInfo? Function(
  BuildContext context,
  Msg msg,
);

class MsgInfoStreamEv<T> {
  final String msgId;
  final T value;

  MsgInfoStreamEv({required this.msgId, required this.value});

  @override
  String toString() {
    return 'MsgInfoStreamEv{id: $msgId, value: $value}';
  }
}

class MsgItemView {
  final Widget? child;
  final bool isBubbleBg;
  final Color? bubbleColor;
  final bool isUseContainer;
  final bool isShowSending;

  MsgItemView({
    required this.child,
    required this.isBubbleBg,
    this.bubbleColor,
    this.isUseContainer = true,
    this.isShowSending = true,
  });
}
