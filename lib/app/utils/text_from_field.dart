String? validateMobileNumber(String? mobileNumber) {
  final RegExp regex = RegExp(r'^01\d{9}$');
  if (mobileNumber != null && mobileNumber.isEmpty) {
    return 'Mobile number is required';
  } else if (!regex.hasMatch(mobileNumber!)) {
    return 'Enter a valid 11 digit number';
  }
  return null;
}
