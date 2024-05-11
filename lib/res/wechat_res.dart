import 'dart:ui';

class WechatColors {
  WechatColors._();

  static const Color primaryValue = Color(0xFF2EB812);

  /// bubble
  static const Color rightBubbleColor = Color(0xFF95EC69);
  static const Color leftBubbleColor = Color(0xFFFFFFFF);
}

const _dir = "assets/images";
const iconAssets = '$_dir/icon';

class WechatImages {
  WechatImages._();

  static const icLeftBubbleArrow = "$iconAssets/ic_left_bubble_arrow.webp";
  static const icRightBubbleArrow = "$iconAssets/ic_right_bubble_arrow.webp";
}
