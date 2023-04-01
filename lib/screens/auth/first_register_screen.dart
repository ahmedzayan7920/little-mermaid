import 'dart:io';

import 'package:flutter/material.dart';
import 'package:puzzle/background.dart';
import 'package:puzzle/core/app_colors.dart';
import 'package:puzzle/core/app_functions.dart';
import 'package:puzzle/generated/assets.dart';
import 'package:puzzle/screens/auth/login_screen.dart';
import 'package:puzzle/screens/auth/second_register_screen.dart';

class FirstRegisterScreen extends StatefulWidget {
  const FirstRegisterScreen({Key? key}) : super(key: key);

  @override
  State<FirstRegisterScreen> createState() => _FirstRegisterScreenState();
}

class _FirstRegisterScreenState extends State<FirstRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ssnController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  File? image;

  @override
  void dispose() {
    nameController.dispose();
    ssnController.dispose();
    birthDateController.dispose();
    cityController.dispose();
    super.dispose();
  }

  void selectImage() async {
    image = await pickImageFromGallery(context);
    setState(() {});
  }

  void goNext() {
    String name = nameController.text.trim();
    String ssn = ssnController.text.trim();
    String birtDate = birthDateController.text.trim();
    String city = cityController.text.trim();
    if (image != null) {
      if (name.isNotEmpty && ssn.isNotEmpty && birtDate.isNotEmpty && city.isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>  SecondRegisterScreen(
                image: image!,
                childName: name,
                childSsn: ssn,
                childBirthDate: birtDate,
                childCity: city,
                ),
          ),
        );
      } else {
        showSnackBar(context: context, content: "برجاء ملئ جميع الحقول");
      }
    } else {
      showSnackBar(context: context, content: "برجاء اختيار الصورة الشخصية");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(Assets.assetsStar, width: 50, height: 50),
                          const SizedBox(width: 30),
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
                          const Spacer(),
                        ],
                      ),
                      Stack(
                        children: [
                          image == null
                              ? const CircleAvatar(
                            backgroundImage: AssetImage(Assets.assetsProfile),
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            labelText: "الاسم الثلاثي",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          controller: ssnController,
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
                          controller: cityController,
                          style: TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            labelText: "المحافظة",
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 60),
                        child: TextFormField(
                          controller: birthDateController,
                          onTap: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1970),
                              lastDate: DateTime.now(),
                            );
                            if (newDate == null) return;
                            setState(() {
                              birthDateController.text =
                              "${newDate.year.toString()}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";
                            });
                          },
                          readOnly: true,
                          style: TextStyle(color: AppColors.white),
                          decoration: const InputDecoration(
                            labelText: "تاريخ الميلاد",
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              builder: (context) => const LoginScreen(),
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
                                onTap: goNext,
                                child: Container(
                                  height: 50,
                                  width: double.infinity,
                                  margin: const EdgeInsets.symmetric(horizontal: 70),
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonColor,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.fitHeight,
                                      child: Text(
                                        "التالي",
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
    );
  }
}
