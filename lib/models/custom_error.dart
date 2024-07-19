class CustomError {
  final String code;
  final String message;
  final String plugin;

  CustomError({
    this.code = '',
    this.message = '',
    this.plugin = '',
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomError &&
        other.code == code &&
        other.message == message &&
        other.plugin == plugin;
  }

  @override
  int get hashCode => code.hashCode ^ message.hashCode ^ plugin.hashCode;

  @override
  String toString() =>
      'CustomError(code: $code, message: $message, plugin: $plugin)';
}
