class DeviceSearchState {
  final String searchTerm;

  DeviceSearchState({required this.searchTerm});

  factory DeviceSearchState.initial() {
    return DeviceSearchState(searchTerm: '');
  }

  @override
  String toString() => 'DeviceSearchState(searchTerm: $searchTerm)';

  DeviceSearchState copyWith({
    String? searchTerm,
  }) {
    return DeviceSearchState(
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
