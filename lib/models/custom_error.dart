class CustomError {
  final String errMsg;

  CustomError({this.errMsg = ''});

  @override
  String toString() => 'CustomError\n($errMsg)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomError && other.errMsg == errMsg;
  }

  @override
  int get hashCode => errMsg.hashCode;
}
