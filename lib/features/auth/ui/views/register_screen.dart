import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/core/firebase_constants.dart';
import 'package:puzzle/core/models/user_model.dart';
import 'package:puzzle/features/auth/ui/views/login_screen.dart';
import 'package:puzzle/features/questions/models/questionnaire_answers_model.dart';
import 'package:puzzle/features/questions/ui/views/questionnaire_view.dart';
import 'package:puzzle/generated/assets.dart';

import '../../../../core/di/di.dart';
import '../../logic/auth_cubit.dart';
import '../../logic/auth_state.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //child
  File? image;
  TextEditingController childNameController = TextEditingController();
  TextEditingController childDateController = TextEditingController();
  TextEditingController childSSNController = TextEditingController();
  GenderType genderGroupValue = GenderType.male;

  //parent
  TextEditingController parentNameController = TextEditingController();
  TextEditingController parentSSNController = TextEditingController();
  TextEditingController parentRelationController = TextEditingController();
  TextEditingController parentGovernorateController = TextEditingController();
  bool hasClinicGroupValue = true;

  //clinic
  TextEditingController clinicNameController = TextEditingController();
  TextEditingController clinicAddressController = TextEditingController();
  TextEditingController clinicDoctorNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    childSSNController.addListener(() {
      final birthdate = extractBirthdate(childSSNController.text);
      if (birthdate != null) {
        childDateController.text = birthdate;
      } else {
        childDateController.text = '';
      }
    });
  }

  @override
  void dispose() {
    childNameController.dispose();
    childDateController.dispose();
    childSSNController.dispose();
    parentNameController.dispose();
    parentSSNController.dispose();
    parentRelationController.dispose();
    parentGovernorateController.dispose();
    clinicNameController.dispose();
    clinicAddressController.dispose();
    clinicDoctorNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void register({required BuildContext context}) async {
    final userModel = _buildUserModel();
    final validationMessage = _validateInputs(userModel);

    if (validationMessage != null) {
      showSnackBar(context: context, content: validationMessage);
      return;
    }

    BlocProvider.of<AuthCubit>(context).register(
      password: passwordController.text.trim(),
      imagePath: image!.path,
      userModel: userModel,
    );
  }

  UserModel _buildUserModel() {
    final childName = childNameController.text.trim();
    final childDate = childDateController.text.trim();
    final childSSN = childSSNController.text.trim();
    final parentName = parentNameController.text.trim();
    final parentSSN = parentSSNController.text.trim();
    final parentRelation = parentRelationController.text.trim();
    final parentGovernorate = parentGovernorateController.text.trim();
    final email = emailController.text.trim();
    final clinicName = clinicNameController.text.trim();
    final clinicAddress = clinicAddressController.text.trim();
    final clinicDoctorName = clinicDoctorNameController.text.trim();

    return UserModel(
      id: '',
      email: email,
      child: ChildModel(
        name: childName,
        profilePicture: '',
        dateOfBirth: childDate,
        ssn: childSSN,
        gender: genderGroupValue,
      ),
      parent: ParentModel(
        name: parentName,
        ssn: parentSSN,
        relation: parentRelation,
        governorate: parentGovernorate,
        hasClinic: hasClinicGroupValue,
        clinicName: hasClinicGroupValue ? clinicName : '',
        clinicAddress: hasClinicGroupValue ? clinicAddress : '',
        clinicDoctorName: hasClinicGroupValue ? clinicDoctorName : '',
      ),
      userPiece: 0,
      pieces: [],
      level: 0,
      selection: {
        "0": 0,
        "1": 0,
        "2": 0,
      },
      questionnaireAnswersModel: QuestionnaireAnswersModel(answers: {}),
      score:0,
    );
  }

  String? _validateInputs(UserModel userModel) {
    // Validate image
    if (image == null) return "برجاء اختيار الصورة الشخصية";

    // Validate child data
    if (userModel.child.name.isEmpty ||
        userModel.child.dateOfBirth.isEmpty ||
        userModel.child.ssn.isEmpty) {
      return "برجاء ملئ جميع الحقول";
    }

    if (!_isValidName(userModel.child.name)) {
      return "اسم الطفل يجب أن يكون ثلاثي";
    }

    if (!_isValidSSN(userModel.child.ssn)) {
      return "الرقم القومي للطفل يجب أن يكون 14 رقمًا";
    }

    // Validate parent data
    if (userModel.parent.name.isEmpty ||
        userModel.parent.ssn.isEmpty ||
        userModel.parent.relation.isEmpty ||
        userModel.parent.governorate.isEmpty ||
        userModel.email.isEmpty ||
        passwordController.text.trim().isEmpty) {
      return "برجاء ملئ جميع الحقول";
    }

    if (!_isValidName(userModel.parent.name)) {
      return "اسم ولي الأمر يجب أن يكون ثلاثي";
    }

    if (!_isValidSSN(userModel.parent.ssn)) {
      return "الرقم القومي لولي الأمر يجب أن يكون 14 رقمًا";
    }

    // Validate clinic data if applicable
    if (hasClinicGroupValue) {
      if ((userModel.parent.clinicName?.isEmpty ?? true) ||
          (userModel.parent.clinicAddress?.isEmpty ?? true) ||
          (userModel.parent.clinicDoctorName?.isEmpty ?? true)) {
        return "برجاء ملئ جميع الحقول";
      }
    }

    return null;
  }

  bool _isValidSSN(String id) {
    // Check length is exactly 14 digits
    if (id.length != 14 || !RegExp(r'^\d+$').hasMatch(id)) {
      return false;
    }

    // Extract components
    String century = id.substring(0, 1);
    String month = id.substring(3, 5);
    String day = id.substring(5, 7);
    String governorate = id.substring(7, 9);

    // Validate century (2 for 1900s, 3 for 2000s)
    if (!['2', '3'].contains(century)) {
      return false;
    }

    // Validate month (01-12)
    int monthNum = int.tryParse(month) ?? 0;
    if (monthNum < 1 || monthNum > 12) {
      return false;
    }

    // Validate day (01-31)
    int dayNum = int.tryParse(day) ?? 0;
    if (dayNum < 1 || dayNum > 31) {
      return false;
    }

    // Validate governorate code (01-27)
    int governorateNum = int.tryParse(governorate) ?? 0;
    if (governorateNum < 1 || governorateNum > 99) {
      return false;
    }

    return true;
  }

  bool _isValidName(String name) {
    // Check if name contains exactly three words
    final nameRegex = RegExp(
        r'^\s*([a-zA-Z\u0621-\u064A]+)\s+([a-zA-Z\u0621-\u064A]+)\s+([a-zA-Z\u0621-\u064A]+)\s*$');
    return nameRegex.hasMatch(name);
  }

  String? extractBirthdate(String ssn) {
    // First validate the ID format
    if (!_isValidSSN(ssn)) {
      return null;
    }

    try {
      // Extract date components
      String century = ssn.substring(0, 1);
      String year = ssn.substring(1, 3);
      String month = ssn.substring(3, 5);
      String day = ssn.substring(5, 7);

      // Convert century digit to full year prefix
      String fullYearPrefix = century == '2' ? '19' : '20';
      String fullYear = '$fullYearPrefix$year';

      // Create the formatted date string
      return '$day/$month/$fullYear';
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoadingState) {
          showLoadingDialog(context);
        } else if (state is AuthErrorState) {
          Navigator.of(context).pop();
          showSnackBar(context: context, content: state.message);
        } else if (state is AuthenticatedState) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const QuestionnaireView(),
            ),
          );
        }
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          body: Stack(
            children: [
              const CustomBackground(),
              Positioned(
                top: 250,
                left: 0,
                child: Image.asset(Assets.assetsStar, width: 70, height: 70),
              ),
              Positioned(
                top: 450,
                right: 0,
                child: Image.asset(Assets.assetsStar, width: 60, height: 60),
              ),
              CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 30),
                        Image.asset(Assets.assetsLogo, width: 100, height: 80),
                        const SizedBox(height: 10),
                        Text(
                          "معلومات الطفل",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 40,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          children: [
                            image == null
                                ? const CircleAvatar(
                                    backgroundImage:
                                        AssetImage(Assets.assetsProfile),
                                    radius: 50,
                                  )
                                : CircleAvatar(
                                    backgroundImage: FileImage(image!),
                                    radius: 50,
                                  ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  onPressed: selectImage,
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: childNameController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الاسم",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: childSSNController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الرقم القومي",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            enabled: false,
                            controller: childDateController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "تاريخ الميلاد",
                              hintText: "يتم استخراجه من الرقم القومي",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'النوع',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              RadioMenuButton<GenderType>(
                                value: GenderType.male,
                                groupValue: genderGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderGroupValue = value ?? GenderType.male;
                                  });
                                },
                                child: Text(
                                  'ذكر',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              RadioMenuButton<GenderType>(
                                value: GenderType.female,
                                groupValue: genderGroupValue,
                                onChanged: (value) {
                                  setState(() {
                                    genderGroupValue =
                                        value ?? GenderType.female;
                                  });
                                },
                                child: Text(
                                  'انثي',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "معلومات ولي الامر",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 40,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: parentNameController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الاسم",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: parentSSNController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "الرقم القومي",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: parentRelationController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "صلة القرابة",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: parentGovernorateController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "المحافظة",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: Column(
                            children: [
                              Text(
                                'هل يوجد مركز تخاطب أو عيادة يذهب إليها الطفل؟',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RadioMenuButton<bool>(
                                    value: true,
                                    groupValue: hasClinicGroupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        hasClinicGroupValue = value ?? true;
                                      });
                                    },
                                    child: Text(
                                      'نعم',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  RadioMenuButton<bool>(
                                    value: false,
                                    groupValue: hasClinicGroupValue,
                                    onChanged: (value) {
                                      setState(() {
                                        hasClinicGroupValue = value ?? false;
                                      });
                                    },
                                    child: Text(
                                      'لا',
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (hasClinicGroupValue)
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: TextFormField(
                                  controller: clinicNameController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: AppColors.white),
                                  decoration: const InputDecoration(
                                    labelText: "اسم المركز أو العيادة",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: TextFormField(
                                  controller: clinicAddressController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: AppColors.white),
                                  decoration: const InputDecoration(
                                    labelText: "عنوان المركز أو العيادة",
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60),
                                child: TextFormField(
                                  controller: clinicDoctorNameController,
                                  textInputAction: TextInputAction.next,
                                  style: TextStyle(color: AppColors.white),
                                  decoration: const InputDecoration(
                                    labelText: "اسم الطبيب المتخصص",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 10),
                        Text(
                          "بيانات الحساب",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 40,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: emailController,
                            textInputAction: TextInputAction.next,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "البريد الالكتروني",
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 60),
                          child: TextFormField(
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            style: TextStyle(color: AppColors.white),
                            decoration: const InputDecoration(
                              labelText: "كلمة السر",
                            ),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          margin: const EdgeInsets.only(top: 50),
                          height: 170,
                          child: Stack(
                            children: [
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  width: double.infinity,
                                  height: 145,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "تمتلك حساب؟",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 20,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "سجل دخول",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: InkWell(
                                  onTap: () => register(context: context),
                                  child: Container(
                                    height: 50,
                                    width: double.infinity,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 70),
                                    decoration: BoxDecoration(
                                      color: AppColors.buttonColor,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.fitHeight,
                                        child: Text(
                                          "انشاء",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
