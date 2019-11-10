final RegExp lowerToUpper = RegExp('([a-z])([A-Z])');

String titleCase(String input) {
  if (input == '' || input == null) return input;
  input = input[0].toUpperCase() + input.substring(1); // capitalize first letter
  return input.replaceAllMapped(lowerToUpper, (m) => "${m[1]} ${m[2]}"); // space between words
}

String requiredValidator(String val) => (val == null || val == "") ? "This field is required." : null; 

String doubleValidator(String val) {
  if (val == null || val == "")
    return "This field is required.";
  try {
    int.parse(val);
  } catch (e) {
    return "Car Mileage must be an integer.";
  }
  return null;
}

String intValidator(String val) {
  if (val == null || val == "")
    return "This field is required.";
  try {
    int.parse(val);
  } catch (e) {
    return "Car Mileage must be an integer.";
  }
  return null;
}