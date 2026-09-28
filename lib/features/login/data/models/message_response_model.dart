class MessageResponseModel {
  const MessageResponseModel({this.message, this.code});

  final String? message;
  final String? code;

  static MessageResponseModel fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> nested =
        json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : const <String, dynamic>{};

    const List<String> messageKeys = <String>['message', 'detail', 'error'];
    const List<String> codeKeys = <String>['code'];

    return MessageResponseModel(
      message: _stringOf(json, messageKeys) ?? _stringOf(nested, messageKeys),
      code: _stringOf(json, codeKeys) ?? _stringOf(nested, codeKeys),
    );
  }

  static String? _stringOf(Map<String, dynamic> json, List<String> keys) {
    for (final String key in keys) {
      final Object? value = json[key];
      if (value is String && value.isNotEmpty) return value;
    }
    return null;
  }
}
