import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_study_project/pages/wechat_sound/wechat_record_sound_view.dart';
import 'package:flutter_study_project/public_widgets/wechat/models/msg.dart';
import 'package:flutter_study_project/public_widgets/wechat/wechat_msg_item_view.dart';
import 'package:flutter_study_project/utils/common_utils.dart';
import 'package:logger/logger.dart' as logger;
import 'package:rxdart/rxdart.dart';

class WechatSoundPage extends StatefulWidget {
  const WechatSoundPage({super.key});

  @override
  State<WechatSoundPage> createState() => _WechatSoundPageState();
}

class _WechatSoundPageState extends State<WechatSoundPage> {
  final voicePlayStatusSub = PublishSubject<MsgInfoStreamEv<bool>>();
  final FlutterSoundPlayer soundPlayer = FlutterSoundPlayer(logLevel: logger.Level.error);
  final msgList = <Msg>[];

  @override
  void initState() {
    soundPlayer.openPlayer();
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
  }

  @override
  void dispose() {
    voicePlayStatusSub.close();
    soundPlayer.closePlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemBuilder: (context, index) {
                final msg = msgList[index];
                return WechatMsgItemView(
                  msg: msg,
                  voicePlayStatusSub: voicePlayStatusSub,
                );
              },
              itemCount: msgList.length,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            color: Colors.grey.withAlpha(20),
            height: 60,
            child: WechatRecordSoundView(
              onRecordedCallback: (path) async {
                final duration = await CommonUtils.getAudioDuration(File(path));
                setState(() {
                  msgList.add(
                    Msg(
                      msgId: DateTime.now().millisecondsSinceEpoch.toString(),
                      msgType: MsgType.MSG_TYPE_SOUND,
                      isISend: true,
                      createTime: DateTime.now(),
                      mediaInfo: MediaInfo(
                        duration: duration.inSeconds,
                        sourceUrl: path,
                        url: "",
                      ),
                    ),
                  );
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
