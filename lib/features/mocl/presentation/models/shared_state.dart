class SharedState<T> {
  final T? object;

  SharedState({required this.object});

  SharedState.initial() : object = null;

  SharedState copyWith({T? newObject}) {
    return SharedState(
      object: newObject ?? this.object,
    );
  }
}
