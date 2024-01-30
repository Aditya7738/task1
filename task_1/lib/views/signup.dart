import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/helpers/validation_helper.dart';
import 'package:task_1/model/user_model.dart';
import 'package:task_1/views/login.dart';

class SignupPage extends StatefulWidget {
  SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNoController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _userNameController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  String phone = "";

  String email = "";

  String user_name = "";

  String name = "";

  String password = "";

  String address = "";

  List<String> options = ["+91", "+92"];

  String selectedOption = "+91";

  bool isObscured = true;

  bool isObscured2 = true;

  bool savingData = false;

  late DBHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Signup"),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                  child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/login.png",
                        width: 150.0,
                        height: 70.0,
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text("Register account",
                          style: TextStyle(fontSize: 20.0)),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormField(
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return ValidationHelper.nullOrEmptyString(value);
                        },
                        decoration: const InputDecoration(
                          // errorText: ,
                          labelText: "Enter your name*",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _phoneNoController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          return ValidationHelper.isPhoneNoValid(value);
                        },
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            labelText: "Mobile number*"),
                        maxLines: 1,
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _addressController,
                        minLines: 2,
                        maxLines: 3,
                        validator: (value) {
                          return ValidationHelper.isFullAddress(value);
                        },
                        keyboardType: TextInputType.streetAddress,
                        decoration: const InputDecoration(
                          labelText: "Address*",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          return ValidationHelper.isEmailValid(value);
                        },
                        decoration: const InputDecoration(
                          // errorText: ,
                          labelText: "Enter your email*",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _userNameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          return ValidationHelper.nullOrEmptyString(value);
                        },
                        decoration: const InputDecoration(
                          // errorText: ,
                          labelText: "Enter your username*",
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: isObscured,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          return ValidationHelper.isPasswordContain(value);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscured = !isObscured;
                              });
                            },
                            icon: Icon(isObscured
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          // errorText: ,
                          labelText: "Enter your password",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: isObscured2,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          return ValidationHelper.isPassAndConfirmPassSame(
                              _passwordController.text, value!);
                        },
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isObscured2 = !isObscured2;
                              });
                            },
                            icon: Icon(isObscured
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          // errorText: ,
                          labelText: "Confirm your password",
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      Center(
                          child: RichText(
                              text: TextSpan(
                                  text:
                                      '*By clicking on Save chage, you accept our ',
                                  style: const TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                            TextSpan(
                              text: 'T&C',
                              style: const TextStyle(
                                color: Color(0xffCC868A),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle the click event for the specific word.
                                  print('You clicked on T&C');
                                  // Add your custom action here.
                                },
                            ),
                            const TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(
                                color: Color(0xffCC868A),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  // Handle the click event for the specific word.
                                  print('You clicked on Privacy Policy');
                                  // Add your custom action here.
                                },
                            ),
                          ]))),
                      const SizedBox(
                        height: 30.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              phone = _phoneNoController.text;
                              email = _emailController.text;
                              user_name = _userNameController.text;
                              name = _nameController.text;
                              address = _addressController.text;

                              password = _passwordController.text;
                            });

                            Random random = new Random();
                            String randomNumber = random.nextInt(10).toString();

                            print("$phone $email $name $user_name $address");

                            UserModel userModel = UserModel(
                                userId: randomNumber,
                                name: name,
                                userName: user_name,
                                email: email,
                                phoneNo: phone,
                                password: password,
                                address: address);

                            setState(() {
                              savingData = true;
                            });

                            await dbHelper.insert(userModel);

                            setState(() {
                              savingData = false;
                            });

                            print("SAVED DATA $userModel");

                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ));
                          }
                        },
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: const Color(0xffCC868A),
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            child: Center(
                              child: savingData
                                  ? const SizedBox(
                                      width: 20.0,
                                      height: 20.0,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                        backgroundColor: Color(0xffCC868A),
                                      ),
                                    )
                                  : const Text(
                                      "Sign up",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                            )),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                          child: RichText(
                              text: TextSpan(
                                  text: 'Already have an account?',
                                  style: const TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                            TextSpan(
                              text: ' Login',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xffCC868A),
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginPage(),
                                  ));
                                },
                            ),
                          ]))),
                    ]),
              ))),
        ));
  }
}
