import 'package:flutter/material.dart';
import 'package:flutter_study_project/wechat_sound/wechat_record_sound_view.dart';

class WechatSoundPage extends StatelessWidget {
  const WechatSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemBuilder: (context, index) {
                  return Container(
                    child: Text("123=> $index"),
                  );
                },
                itemCount: 2,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.grey.withAlpha(20),
              height: 60,
              child: const WechatRecordSoundView(),
            )
          ],
        ),
      ),
    );
  }
}
