
/// Capitalize first letter
String capitalizeFirstLetter(String s) =>
    (s?.isNotEmpty ?? false) ? '${s[0].toUpperCase()}${s.substring(1)}' : s;

