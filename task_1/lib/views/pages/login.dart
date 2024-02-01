import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_1/api/api_service.dart';
import 'package:task_1/helpers/db_helper.dart';
import 'package:task_1/helpers/validation_helper.dart';
import 'package:task_1/providers/wishlist_provider.dart';
import 'package:task_1/views/pages/catalog_page.dart';
import 'package:task_1/views/pages/signup.dart';
import 'package:provider/provider.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool isObscured = true;

  bool isObscured2 = true;

  bool isLoading = false;
  String username = "";
  String password = "";

  bool isLoginUnSuccessful = false;

  bool navigationLoading = false;

  late DBHelper dbHelper;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    
    final wishListProvider = Provider.of<WishlistProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Login"),
        ),
        body: navigationLoading
            ? const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.black,
                  color: Colors.white,
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(children: [
                        Image.asset(
                          "assets/images/login.png",
                          width: 150.0,
                          height: 70.0,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text("Welcome!",
                            style: TextStyle(fontSize: 20.0)),
                        const SizedBox(
                          height: 20.0,
                        ),
                        isLoginUnSuccessful
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 25.0),
                                //width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: const Color.fromARGB(
                                        255, 253, 233, 231),
                                    border: Border.all(
                                        color: Colors.red,
                                        style: BorderStyle.solid)),
                                child: const Text(
                                  "Email / password is wrong. Try again..",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 17.0),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextFormField(
                          controller: _usernameController,
                          keyboardType: TextInputType.emailAddress,
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
                            labelText: "Enter your password",
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              final username = _usernameController.text;
                              final password = _passwordController.text;

                              print("$username $password");

                              setState(() {
                                isLoading = true;
                              });

                              final result =
                                  await dbHelper.checkLogin(username, password);

                                   print("getAllUsers ${await dbHelper.getAllUsers()}");

                              setState(() {
                                isLoading = false;
                              });

                              if (result != null) {
                                setState(() {
                                  isLoginUnSuccessful = false;
                                });

                                wishListProvider.setuserId(result.userId);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CatalogPage(
                                        userModel: result,
                                      ),
                                    ));
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //     SnackBar(
                                //         padding: EdgeInsets.all(15.0),
                                //         backgroundColor: Colors.red,
                                //         content: Text(
                                //             "Username or password is wrong")));

                                setState(() {
                                  isLoginUnSuccessful = true;
                                });
                              }
                            }
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color(0xffCC868A),
                                  borderRadius: BorderRadius.circular(15.0)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 20.0),
                              child: Center(
                                child: isLoading
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
                                        "LOGIN",
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
                                    text: "Don't have account?",
                                    style: const TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                              TextSpan(
                                text: '  Create Account',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xffCC868A),
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) => SignupPage(),
                                    ));
                                  },
                              ),
                            ]))),
                      ]),
                    )),
              ));
  }
}
