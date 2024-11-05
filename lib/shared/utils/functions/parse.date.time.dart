class FnDateTime {
// Método para deserializar la fecha en formato .NET
  static DateTime fromDotNetDate(String dotNetDate) {
    final milliseconds = int.parse(dotNetDate.replaceAll(RegExp(r'[^\d]'), ''));
    return DateTime.fromMillisecondsSinceEpoch(milliseconds);
  }

  // Método para serializar la fecha de vuelta al formato .NET
  static String toDotNetDate(DateTime date) {
    return '/Date(${date.millisecondsSinceEpoch})/';
  }
}
