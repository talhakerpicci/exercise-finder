extension StringExtensions on String {
  String camelCaseToSnakeCase() {
    return replaceAllMapped(
      RegExp(r'(?<=[a-z])[A-Z]'),
      (Match match) => '_${match.group(0)!.toLowerCase()}',
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
