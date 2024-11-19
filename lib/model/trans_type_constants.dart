class TransTypeConstants {
  final int id;
  final String description;

  const TransTypeConstants({
    required this.id,
    required this.description,
  });
  @override
  String toString() {
    return description;
  }
}
