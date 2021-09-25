class GeneralExeption extends Error {
  GeneralExeption({
    required this.title,
    required this.message,
  });
  final String title;
  final String message;
}
