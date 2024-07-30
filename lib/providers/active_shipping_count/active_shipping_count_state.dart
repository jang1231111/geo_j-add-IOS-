class ActiveShippingCountState {
  final int activeShippingCount;

  ActiveShippingCountState({required this.activeShippingCount});

  factory ActiveShippingCountState.intial() {
    return ActiveShippingCountState(activeShippingCount: 0);
  }

  @override
  String toString() =>
      'ActiveShippingCountState(activeShippingCount: $activeShippingCount)';

  ActiveShippingCountState copyWith({
    int? activeShippingCount,
  }) {
    return ActiveShippingCountState(
      activeShippingCount: activeShippingCount ?? this.activeShippingCount,
    );
  }
}
