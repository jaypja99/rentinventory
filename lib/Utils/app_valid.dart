import 'common_utils.dart';

String? validateEmail(String? value) {
  if (value!.trim().isEmpty) {
    return string("label_email_validation");
  }
  if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.+-]+\.[a-zA-Z]+").hasMatch(value)) {
    return "Email is invalid";
  }
  return null;
}

String? validateMobile(String? value) {
  if (value!.trim().isEmpty) {
    return "Mobile Number is required.";
  }
  if (value.trim().length!=10) {
    return "Mobile Number is invalid.";
  }
  return null;
}

String? validateNameTitle(String? value) {
  if (value=="Title") {
    return "Title is required.";
  }
  return null;
}

String? validateOTP(String? value) {
  if (value!.trim().isEmpty) {
    return "OTP is required.";
  }
  return null;
}
String? validateCustomerName(String? value) {
  if (value!.trim().isEmpty) {
    return "Customer Name is required.";
  }
  return null;
}

String? validateCustomerAddress(String? value) {
  if (value!.trim().isEmpty) {
    return "Address is required.";
  }
  return null;
}

String? validateState(String? value) {
  if (value!.trim().isEmpty) {
    return "State is required.";
  }
  return null;
}

String? validateCity(String? value) {
  if (value!.trim().isEmpty) {
    return "City is required.";
  }
  return null;
}

String? validateArea(String? value) {
  if (value!.trim().isEmpty) {
    return "Area is required.";
  }
  return null;
}

String? validateDealer(String? value){
  if(value!.trim().isEmpty){
    return "Please Select purchase from !";
  }
  return null;
}

String? validateCategory(String? value){
  if(value!.trim().isEmpty || value == "Select"){
    return "Please Select Product Category !";
  }
  return null;
}

String? validateSubCategory(String? value){
  if(value!.trim().isEmpty|| value == "Select"){
    return "Please Select Product Sub Category !";
  }
  return null;
}
String? validateServiceCallType(String? value){
  if(value!.trim().isEmpty || value == "Select"){
    return "Please Select Service Call Type !";
  }
  return null;
}

String? validateNOC(String? value) {
  if (value!.trim().isEmpty || value == "Select") {
    return "Please Select Nature of Complaint !";
  }
  return null;
}

String? validFeedBackComment(String? value) {
  if (value!.trim().length > 50 && value.trim().length > 0) {
    return "Maximum length for remarks is up-to 50 characters only !";
  }
  return null;
}

String? validPurchaseDate(String? value) {
  if (value!.trim().isEmpty) {
    return "Please Select Purchase Date";
  }
  return null;
}


String? validIndoorNumber(String? value) {
  if (value!.trim().isEmpty) {
    return "Please Enter Indoor Serial Number";
  }
  return null;
}


String? validOutdoorNumber(String? value) {
  if (value!.trim().isEmpty) {
    return "Please Enter Outdoor Serial Number";
  }
  return null;
}