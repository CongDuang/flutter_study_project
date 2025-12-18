class Msg {
  Msg({
    String? msgId,
    MsgType? msgType,
    bool? isISend,
    DateTime? createTime,
    MediaInfo? mediaInfo,
  }) {
    _msgId = msgId;
    _msgType = msgType;
    _isISend = isISend;
    _createTime = createTime;
    _mediaInfo = mediaInfo;
  }

  Msg.fromJson(dynamic json) {
    _msgId = json['msgId'];
    _msgType = json['msgType'];
    _isISend = json['isISend'];
    _createTime = json['createTime'];
    _mediaInfo = json['mediaInfo'] != null
        ? MediaInfo.fromJson(json['mediaInfo'])
        : null;
  }

  String? _msgId;
  MsgType? _msgType;
  bool? _isISend;
  DateTime? _createTime;
  MediaInfo? _mediaInfo;

  Msg copyWith({
    String? msgId,
    MsgType? msgType,
    bool? isISend,
    DateTime? createTime,
    MediaInfo? mediaInfo,
  }) => Msg(
    msgId: msgId ?? _msgId,
    msgType: msgType ?? _msgType,
    isISend: isISend ?? _isISend,
    createTime: createTime ?? _createTime,
    mediaInfo: mediaInfo ?? _mediaInfo,
  );

  String? get msgId => _msgId;

  MsgType? get msgType => _msgType;

  bool? get isISend => _isISend;

  DateTime? get createTime => _createTime;

  MediaInfo? get mediaInfo => _mediaInfo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msgId'] = _msgId;
    map['msgType'] = _msgType;
    map['isISend'] = _isISend;
    map['createTime'] = _createTime;
    if (_mediaInfo != null) {
      map['mediaInfo'] = _mediaInfo?.toJson();
    }
    return map;
  }
}

class MediaInfo {
  MediaInfo({int? duration, String? sourceUrl, String? url}) {
    _duration = duration;
    _sourceUrl = sourceUrl;
    _url = url;
  }

  MediaInfo.fromJson(dynamic json) {
    _duration = json['duration'];
    _sourceUrl = json['sourceUrl'];
    _url = json['url'];
  }

  int? _duration;
  String? _sourceUrl;
  String? _url;

  MediaInfo copyWith({int? duration, String? sourceUrl, String? url}) =>
      MediaInfo(
        duration: duration ?? _duration,
        sourceUrl: sourceUrl ?? _sourceUrl,
        url: url ?? _url,
      );

  int? get duration => _duration;

  String? get sourceUrl => _sourceUrl;

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['duration'] = _duration;
    map['sourceUrl'] = _sourceUrl;
    map['url'] = _url;
    return map;
  }
}

enum MsgType { sound }
