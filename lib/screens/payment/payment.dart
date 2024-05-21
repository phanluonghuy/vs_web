import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vs_web/screens/home/home_screen.dart';
import '../../models/UserDAO.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});
  static String routeName = "/payment";

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  UserDAO userDao = UserDAO();
  String _imagePath = '';
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _captchaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _login = false;
  double totalPrice = 0.0;

  Widget payment() {
    return Padding(
      padding: EdgeInsets.fromLTRB(33, 50, 33, 0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 22),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Available Balance',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    height: 1.2,
                    letterSpacing: 0.1,
                    color: Color(0xFF878787),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(4, 0, 4, 50),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '\$46099.20',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    height: 0.6,
                    letterSpacing: 0.1,
                    color: Color(0xFF5163BF),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(2, 0, 2, 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Please, upload your base image to pay $totalPrice for GTVShop',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w400,
                    fontSize: 15,
                    color: Color(0xFF878787),
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 17),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Upload Image',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color(0xFF5265BE),
                  ),
                ),
              ),
            ),
            Stack(
              children: [
                (_imagePath.isEmpty)
                    ? SizedBox()
                    : Image.file(
                        File(_imagePath),
                        fit: BoxFit.cover,
                        opacity: const AlwaysStoppedAnimation(0.7),
                      ),
                FutureBuilder(
                    future: userDao.getImage(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return snapshot.data ?? SizedBox();
                      }
                      return SizedBox();
                    }),
              ],
            ),
            SizedBox(height: 20),
            // (_imagepath.isEmpty) ? SizedBox() : Image.file(
            //   File(_imagepath),
            //   fit: BoxFit.cover,
            // ),
            (_imagePath.isEmpty)
                ? IconButton(
                    icon: Icon(Icons.upload),
                    iconSize: 30,
                    onPressed: () async {
                      final ImagePicker picker = ImagePicker();
                      final XFile? image =
                          await picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _imagePath = image.path;
                        });
                      }
                    },
                  )
                : Wrap(
                    children: [
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Enter captcha in screen',
                            style: GoogleFonts.getFont(
                              'Roboto Condensed',
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _captchaController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter captcha!";
                            }
                            if (value.toLowerCase() !=
                                userDao.captcha.toLowerCase()) {
                              return "Wrong captcha";
                            }
                          },
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: 'Captcha',
                              hintStyle: TextStyle(
                                  color: Colors.black26, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
            SizedBox(height: 50),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 153,
                height: 72,
                child: Container(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF5265BE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 153,
                          height: 59,
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () async {
                            if (_imagePath.isEmpty) {
                              EasyLoading.showError(
                                  "Please upload your base image");
                            }
                            if (_formKey.currentState!.validate()) {
                              // EasyLoading.showSuccess('Success!').whenComplete(() => Timer(Duration(seconds: 2), () {
                              //   context.read<CartBloc>().add(ClearCart());
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) => MyApp())
                              //   );
                              // }));
                              EasyLoading.showSuccess('Success!').whenComplete(
                                  () => Timer(Duration(seconds: 2), () {
                                        Navigator.pushNamed(
                                            context, HomeScreen.routeName);
                                      }));
                            }
                          },
                          child: SizedBox(
                            height: 26,
                            child: Text(
                              'PAY',
                              style: GoogleFonts.getFont(
                                'Roboto Condensed',
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget login() {
    return Container(
      padding: EdgeInsets.fromLTRB(33, 73, 33, 52),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'MEOW WALLET PAYMENT 🐱‍👓',
              style: GoogleFonts.getFont(
                'Roboto Condensed',
                fontWeight: FontWeight.w600,
                fontSize: 40,
                height: 1.3,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Email Address',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'example@mail.com',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 15)),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 18, 0, 0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Password',
                  style: GoogleFonts.getFont(
                    'Roboto Condensed',
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.black26, fontSize: 15),
                  suffixIcon: Icon(Icons.visibility_off)),
            ),
            SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: () async {
                  String _msg = await userDao.login(
                      _emailController.text, _passwordController.text);
                  print(_msg);
                  if (_msg == "Failed") {
                    const snackBar = SnackBar(
                      content: Text('Your username or password was wrong'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (_msg == "Account is lock") {
                    const snackBar = SnackBar(
                      content: Text('Your account was lock!'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    setState(() {
                      _login = true;
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    width: 201,
                    height: 59,
                    child: Center(
                      child: Text(
                        'Login',
                        style: GoogleFonts.getFont('Roboto Condensed',
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    totalPrice = 337.15;

    return Scaffold(
      backgroundColor: Colors.white,
      body: (_login) ? payment() : login(),
    );
  }
}
