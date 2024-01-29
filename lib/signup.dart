import 'package:credkit/signin.dart';
import 'package:credkit/transitions.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _passwordVisible2 = false;
  var icon = Icons.visibility_off;
  var icon2 = Icons.visibility_off;
  void passwordVisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
      if (_passwordVisible) {
        icon = Icons.visibility;
      } else {
        icon = Icons.visibility_off;
      }
    });
  }

  void passwordVisibility2() {
    setState(() {
      _passwordVisible2 = !_passwordVisible2;
      if (_passwordVisible2) {
        icon2 = Icons.visibility;
      } else {
        icon2 = Icons.visibility_off;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                Image.asset(
                  'assets/logo-small.png',
                  height: 25,
                ),
                const SizedBox(
                  height: 30,
                ),
                Image.asset('assets/signup-img.png'),
                const SizedBox(
                  height: 30,
                ),
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Create your ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w700,
                          height: 0.05,
                        ),
                      ),
                      TextSpan(
                        text: 'account',
                        style: TextStyle(
                          color: Color(0xFFFF6D00),
                          fontSize: 23,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 10, right: 10, left: 10, top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      cursorColor: const Color.fromARGB(133, 255, 255, 255),
                      controller: fullNameController,
                      decoration: InputDecoration(
                        hintText: 'Full Name',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(129, 255, 255, 255),
                          fontSize: 16,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w300,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(170, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(206, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                //textfield with eye icon to show/hide password
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      cursorColor: const Color.fromARGB(133, 255, 255, 255),
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 20),
                        hintStyle: const TextStyle(
                          color: Color.fromARGB(129, 255, 255, 255),
                          fontSize: 16,
                          fontFamily: 'Gotham',
                          fontWeight: FontWeight.w300,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Color.fromARGB(170, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            width: 2,
                            color: Color.fromARGB(206, 255, 255, 255),
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      cursorColor: const Color.fromARGB(133, 255, 255, 255),
                      controller: passwordController,
                      obscureText: _passwordVisible,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(129, 255, 255, 255),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(170, 255, 255, 255),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(206, 255, 255, 255),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              passwordVisibility();
                            },
                            child: Icon(icon,
                                color:
                                    const Color.fromARGB(144, 250, 250, 250)),
                          )),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 10, left: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: TextField(
                      cursorColor: const Color.fromARGB(133, 255, 255, 255),
                      controller: confirmPasswordController,
                      obscureText: _passwordVisible2,
                      decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          hintStyle: const TextStyle(
                            color: Color.fromARGB(129, 255, 255, 255),
                            fontSize: 16,
                            fontFamily: 'Gotham',
                            fontWeight: FontWeight.w300,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color.fromARGB(170, 255, 255, 255),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color.fromARGB(206, 255, 255, 255),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              passwordVisibility2();
                            },
                            child: Icon(icon2,
                                color:
                                    const Color.fromARGB(144, 250, 250, 250)),
                          )),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Gotham',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 30, left: 30),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      decoration: ShapeDecoration(
                        color: const Color(0xFFFF6D00),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Gotham Black',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Already have an account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Gotham',
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, SlideRightRoute(page: const SignIn()));
                  },
                  child: const Text(
                    'Sign in here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationColor: Color(0xFFFF6D00),
                      decorationThickness: 5,
                      color: Color(0xFFFF6D00),
                      fontSize: 18,
                      fontFamily: 'Gotham',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
