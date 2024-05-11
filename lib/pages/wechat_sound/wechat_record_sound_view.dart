import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_study_project/pages/wechat_sound/wechat_sound_bubble_view.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class WechatRecordSoundView extends StatefulWidget {
  const WechatRecordSoundView({super.key, this.onRecordedCallback, this.conversationId});

  final Function(String soundFilePath)? onRecordedCallback;
  final String? conversationId;

  @override
  State<WechatRecordSoundView> createState() => _WechatRecordSoundViewState();
}

class _WechatRecordSoundViewState extends State<WechatRecordSoundView> {
  late OverlayEntry overlayEntry;

  final double bezierBoxHeight = 150;

  final GlobalKey _cancelBtnKey = GlobalKey();

  ValueNotifier<bool> canCancelNotifier = ValueNotifier(false);
  String soundFilePath = "";

  Offset? cancelPosition;
  Size? cancelSize;
  late FlutterSoundRecorder recorder;

  @override
  void initState() {
    super.initState();
  }

  createOverlay() {
    overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return ValueListenableBuilder<bool>(
          valueListenable: canCancelNotifier,
          builder: (_, canCancel, child) {
            return Positioned(
              child: Scaffold(
                backgroundColor: Colors.white.withOpacity(0.2),
                body: Column(
                  verticalDirection: VerticalDirection.up,
                  children: [
                    ClipPath(
                      clipper: TopClipper(),
                      child: Container(
                        color: const Color(0xFFE1E1E1),
                        height: bezierBoxHeight,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(canCancel ? "松开 取消" : "松开 发送"),
                    const SizedBox(height: 20),
                    Container(
                      key: _cancelBtnKey,
                      height: 60,
                      width: 60,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFE1E1E1),
                      ),
                      child: const Icon(Icons.close),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const WechatSoundBubbleView()
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 32),
        child: const Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("按住说话"),
          ],
        ),
      ),
      onLongPressDown: (LongPressDownDetails details) {
        debugPrint("long press down");
        createOverlay();
        initRecorder();
      },
      onLongPressUp: () {
        cancelPosition = null;
        cancelSize = null;
      },
      onLongPressStart: (LongPressStartDetails details) async {
        showFloatingButtonOverlay(context);
        await startRecorder();
      },
      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
        final globalPosition = details.globalPosition;
        getCancelBtnInfo();
        if (cancelSize != null && cancelPosition != null && cancelSize != Size.zero && cancelPosition != Offset.zero) {
          if (globalPosition.dx >= cancelPosition!.dx &&
              globalPosition.dx <= cancelPosition!.dx + cancelSize!.width &&
              globalPosition.dy >= cancelPosition!.dy &&
              globalPosition.dy <= cancelPosition!.dy + cancelSize!.height) {
            canCancelNotifier.value = true;
          } else {
            canCancelNotifier.value = false;
          }
        }
      },
      onLongPressEnd: (LongPressEndDetails details) {
        overlayEntry.remove();
        // 停止录音
        stopRecording();
        // disposeRecorder();
      },
    );
  }

  showFloatingButtonOverlay(BuildContext context) {
    OverlayState overlayState = Overlay.of(context);
    overlayState.insert(overlayEntry);
  }

  getCancelBtnInfo() {
    final RenderBox? renderBox = _cancelBtnKey.currentContext?.findRenderObject() as RenderBox?;
    if (cancelPosition == null || cancelPosition == Offset.zero) {
      final position = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
      cancelPosition = position;
    }
    if (cancelSize == null || cancelSize == Size.zero) {
      cancelSize = renderBox?.size;
    }
  }

  initRecorder() {
    recorder = FlutterSoundRecorder(logLevel: Level.error);
  }

  disposeRecorder() {
    // recorder.closeRecorder();
  }

  Future<void> startRecorder() async {
    try {
      final status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        print('microphone not has Permission ');
        return;
      }
      await recorder.openRecorder();
      soundFilePath =
          "${(await getTemporaryDirectory()).path}/wechat_sound/sound_${DateTime.now().millisecondsSinceEpoch}${ext[Codec.pcm16WAV.index]}";
      final file = File(soundFilePath);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      await recorder.openRecorder();
      print('Recording started at path $soundFilePath');
      await recorder.startRecorder(
        toFile: soundFilePath,
        codec: Codec.pcm16WAV,
        numChannels: 1,
        bitRate: 8000,
      );
    } catch (err) {
      print(err);
    }
  }

  Future<void> stopRecording() async {
    try {
      await recorder.stopRecorder();
      widget.onRecordedCallback?.call(soundFilePath);
      print('Recording stopped');
    } catch (error) {
      print('error stoped recording $error');
    }
  }

  @override
  void dispose() {
    canCancelNotifier.dispose();
    super.dispose();
  }
}

class TopClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    const bezierHeight = 40.0;
    path.lineTo(0, bezierHeight); //第一个点
    path.lineTo(0, size.height); //第二个点
    path.lineTo(size.width, size.height); // 第三个点
    path.lineTo(size.width, bezierHeight); //第四个点
    var firstControlPoint = Offset(size.width / 2, -bezierHeight); //曲线开始点
    var firstEndPoint = const Offset(0, bezierHeight); // 曲线结束点
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
