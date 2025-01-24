class ConnectingState {
  final bool isConnecting;

  ConnectingState({required this.isConnecting});

  factory ConnectingState.initial() {
    return ConnectingState(isConnecting: false);
  }

  @override
  String toString() => 'ConnectionState(isConnecting: $isConnecting)';

  ConnectingState copyWith({
    bool? isConnecting,
  }) {
    return ConnectingState(
      isConnecting: isConnecting ?? this.isConnecting,
    );
  }
}
