class Either<L, R> {
  final L? _left;
  final R? _right;

  const Either._(this._left, this._right)
      : assert(_left != null || _right != null);

  /// Factory for Left
  static Either<L, R> left<L, R>(L value) => Either<L, R>._(value, null);

  /// Factory for Right
  static Either<L, R> right<L, R>(R value) => Either<L, R>._(null, value);

  /// Check if it's a Left
  bool get isLeft => _left != null;

  /// Check if it's a Right
  bool get isRight => _right != null;

  /// Fold function to handle both sides
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) {
    if (_left != null) {
      return onLeft(_left as L);
    } else if (_right != null) {
      return onRight(_right as R);
    }
    throw StateError('Either must contain a value on one side.');
  }
}

class Unit {
  const Unit();
}