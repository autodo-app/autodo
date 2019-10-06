final RegExp lowerToUpper = RegExp('([a-z])([A-Z])');

String titleCase(String input) {
  if (input == '' || input == null) return input;
  input = input[0].toUpperCase() + input.substring(1); // capitalize first letter
  return input.replaceAllMapped(lowerToUpper, (m) => "${m[1]} ${m[2]}"); // space between words
}