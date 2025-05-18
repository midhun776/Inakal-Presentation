import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inakal/features/auth/controller/auth_controller.dart';
import 'package:inakal/features/auth/registration/screens/registration_description.dart';
import 'package:inakal/features/auth/registration/widgets/country_state_city.dart';
import 'package:inakal/features/auth/registration/widgets/dropdown_feild.dart';
import 'package:inakal/features/auth/registration/widgets/registration_loader.dart';
import 'package:inakal/common/widgets/custom_button.dart';
import 'package:inakal/features/auth/registration/widgets/gender_selection.dart';
import 'package:inakal/constants/app_constants.dart';
import 'package:intl/intl.dart';
import '../widgets/text_field_widget.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _maritalStatusController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? selectedGender;

  @override
  void dispose() {
    _firstNameController.dispose();
    _secondNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _dobController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // String? _validatePassword(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'Password is required';
  //   } else if (value.length < 8) {
  //     return 'Password must be at least 8 characters';
  //   } else if (!RegExp(r"[A-Z]").hasMatch(value)) {
  //     return 'Password must contain at least one uppercase letter';
  //   } else if (!RegExp(r"[a-z]").hasMatch(value)) {
  //     return 'Password must contain at least one lowercase letter';
  //   } else if (!RegExp(r"[0-9]").hasMatch(value)) {
  //     return 'Password must contain at least one digit';
  //   }
  //   return null;
  // }

  var isChecked = false;

  final AuthController regController = Get.find();
  void _storeData() {
    regController.setBasicDetails(
        firstName: _firstNameController.text,
        lastName: _secondNameController.text,
        email: _emailController.text,
        address: _addressController.text,
        country: _countryController.text,
        state: _stateController.text,
        district: _cityController.text,
        pincode: _pincodeController.text,
        dob: _dobController.text,
        maritalStatus: _maritalStatusController.text,
        gender: selectedGender!);
  }

  String getHeadingText(String profileFor) {
    switch (profileFor) {
      case "Myself":
        return "Let’s Get to Know You Better!";
      case "Son":
        return "Let’s Get to Know Your Son Better!";
      case "Daughter":
        return "Let’s Get to Know Your Daughter Better!";
      case "Friend":
        return "Let’s Get to Know Your Friend Better!";
      case "Cousin":
        return "Let’s Get to Know Your Cousin Better!";
      case "Brother":
        return "Let’s Get to Know Your Brother Better!";
      case "Sister":
        return "Let’s Get to Know Your Sister Better!";
      default:
        return "Let’s Get to Know You Better!";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 30.0, right: 30.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const RegistrationLoader(progress: 2),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  getHeadingText(regController.user.value
                      .userProfileCreatedFor!), // Replace with the actual profile created for value
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryRed,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16.0),
              TextFieldWidget(
                controller: _firstNameController,
                hintText: 'First Name',
                validator: (value) =>
                    value!.isEmpty ? 'First Name is required' : null,
              ),
              TextFieldWidget(
                controller: _secondNameController,
                hintText: 'Second Name',
                validator: (value) =>
                    value!.isEmpty ? 'Second Name is required' : null,
              ),
              TextFieldWidget(
                controller: _emailController,
                hintText: 'Email ID',
                validator: _validateEmail,
              ),
              TextFieldWidget(
                controller: _addressController,
                hintText: 'Address',
                validator: (value) =>
                    value!.isEmpty ? 'Address is required' : null,
              ),
              CountryStateCityWidget(
                  countryController: _countryController,
                  stateController: _stateController,
                  cityController: _cityController,
                  isChecked: isChecked),
              const SizedBox(height: 10),
              TextFieldWidget(
                controller: _pincodeController,
                hintText: 'Pincode',
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value!.isEmpty ? 'Pincode is required' : null,
              ),
              const SizedBox(height: 10),
              Center(child: Text("Gender")),
              GenderSelectionWidget(
                selectedGender: selectedGender,
                onGenderSelected: (gender) {
                  setState(() {
                    // If gender is changed after selecting DOB, clear the DOB field
                    if (selectedGender != null &&
                        selectedGender != gender &&
                        _dobController.text.isNotEmpty) {
                      _dobController.clear();
                    }
                    selectedGender = gender;
                  });
                },
              ),
              selectedGender == "error"
                  ? const Column(
                      children: [
                        SizedBox(height: 10),
                        Text(
                          "Select a gender",
                          style: TextStyle(
                              color: AppColors.errorRed, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const SizedBox(height: 10),
              const SizedBox(height: 10),
              TextFieldWidget(
                readOnly: true,
                controller: _dobController,
                hintText: 'Date of Birth',
                validator: (value) =>
                    value!.isEmpty ? 'Date of birth is required' : null,
                suffixIcon: const Icon(Icons.calendar_month),
                // readOnly: true,
                onTap: () async {
                  // Check if gender is selected
                  if (selectedGender != "Male" && selectedGender != "Female") {
                    setState(() {
                      selectedGender = "error"; // trigger the gender error
                    });
                    return;
                  }

                  FocusScope.of(context).unfocus();

                  // Calculate last valid date as per age rule
                  DateTime today = DateTime.now();
                  DateTime maxSelectableDate = selectedGender == "Male"
                      ? DateTime(today.year - 21, today.month, today.day)
                      : DateTime(today.year - 18, today.month, today.day);

                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: maxSelectableDate,
                    firstDate: DateTime(1900),
                    lastDate: maxSelectableDate,
                  );

                  if (pickedDate != null) {
                    String formattedDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    _dobController.text = formattedDate;
                  }
                },
              ),
              DropdownWidget(
                controller: _maritalStatusController,
                label: "Marital Status",
                items: const [
                  "Single",
                  "Married",
                  "Divorced",
                  "Widowed",
                  "Separated",
                  "Complicated"
                ],
              ),
              const SizedBox(height: 17.0),
              CustomButton(
                text: "Continue",
                onPressed: () {
                  isChecked = true;
                  if (_formKey.currentState!.validate() &&
                      selectedGender != null &&
                      selectedGender != "error") {
                    _storeData();
                    Get.to(
                      const RegistrationDescription(),
                      transition: Transition.rightToLeftWithFade,
                      duration: const Duration(milliseconds: 800),
                    );
                  } else {
                    setState(() {
                      selectedGender ??= "error";
                    });
                  }
                },
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
