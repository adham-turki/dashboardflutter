class FormatException {
  final String message;

  FormatException(this.message);

  @override
  String toString() {
    return 'CustomException: $message ';
  }
}
