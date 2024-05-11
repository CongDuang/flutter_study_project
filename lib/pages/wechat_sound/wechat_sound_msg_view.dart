import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_study_project/public_widgets/wechat/models/msg.dart';
import 'package:flutter_study_project/public_widgets/wechat/wechat_msg_item_view.dart';
import 'package:lottie/lottie.dart';

class WechatSoundMsgView extends StatefulWidget {
  const WechatSoundMsgView({
    super.key,
    required this.msg,
    required this.isISend,
    this.voicePlayStatusSub,
  });

  final Msg msg;
  final bool isISend;
  final Stream<MsgInfoStreamEv<bool>>? voicePlayStatusSub;

  @override
  State<WechatSoundMsgView> createState() => _WechatSoundMsgViewState();
}

class _WechatSoundMsgViewState extends State<WechatSoundMsgView> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool isPlayingAnim = false;
  StreamSubscription? _playStatusSubs;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      value: 1,
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _playStatusSubs = widget.voicePlayStatusSub?.listen((event) {
      if (!mounted) return;
      if (widget.msg.msgId == event.msgId && event.value) {
        // 播放动画
        setState(() {
          _ctrl.repeat();
          _timer = Timer(Duration(seconds: widget.msg.mediaInfo?.duration ?? 1), () {
            _ctrl.stop();
            _timer?.cancel();
            _ctrl.value = 1;
          });
        });
        // 播放声音
      } else {
        // 停止播放动画
        if (_ctrl.isAnimating) {
          _ctrl.stop();
          _ctrl.value = 1;
        }
      }
    });
    _ctrl.addListener(() {
      setState(() {
        isPlayingAnim = _ctrl.isAnimating;
      });
    });
  }

  @override
  void dispose() {
    _playStatusSubs?.cancel();
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: widget.isISend ? TextDirection.ltr : TextDirection.rtl,
      children: [
        Text("${(widget.msg.mediaInfo?.duration ?? 0).toString()}''"),
        const SizedBox(height: 4),
        RotationTransition(
          turns: AlwaysStoppedAnimation(widget.isISend ? 180 / 360 : 0),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(Colors.black, BlendMode.srcIn),
            child: Lottie.asset(
              "assets/anim/voice_blue.json",
              controller: _ctrl,
              height: 18,
              width: 18,
              repeat: false,
              backgroundLoading: true,
            ),
          ),
        ),
      ],
    );
  }
}
