import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/request/customer_login_post_req.dart';
import 'package:flutter_application_1/models/response/CustomersLoginPostRes.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int num = 0;
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  String url = "";

  //initState คือ function ที่ทำงานตอนเปิดหน้าแต่ทำหลัง construce
  //จะทำงานแค่ครั้งเดียว มันจะไม่ทำงานเมื่อเราเรียก setState และมันไม่สามารถทำงานเป็น async function ได้
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        url = value['apiEndpoint'];
        log(url);
      },
    ).catchError(
      (error) {
        log(error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                  onDoubleTap: () {
                    log('double Tap');
                  },
                  child: Image.asset('assets/images/logo.png')),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'หมายเลขโทรศัพท์',
                        style: TextStyle(fontSize: 24),
                      ),
                      TextField(
                        controller: phoneCtl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1))),
                      ),
                    ],
                  )),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'รหัสผ่าน',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextField(
                      controller: passwordCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        onPressed: () {
                          register();
                        },
                        child: const Text('ลงทะเบียนใหม่',
                            style: TextStyle(fontSize: 24))),
                    FilledButton(
                        onPressed: () => login(),
                        child: const Text('เข้าสู่ระบบ',
                            style: TextStyle(fontSize: 24)))
                  ],
                ),
              ),
              Text(text,
                  style: const TextStyle(fontSize: 24, color: Colors.red))
            ],
          ),
        ));
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }

  void login() async {
    // log(phoneCtl.text);
    // log(passwordCtl.text);
    // if (phoneCtl.text == "0812345678" && passwordCtl.text == "1234") {
    //   setState(() {
    //     text = '';
    //   });
    //   Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const Showtrip(),
    //       ));
    // } else {
    //   setState(() {
    //     text = 'Password Incorrect!';
    //   });
    // }

    var phone = phoneCtl.text;
    var password = passwordCtl.text;
    var data = CustomersLoginPostRequest(phone: phone, password: password);

    // http
    //     .post(Uri.parse('http://10.34.40.251:3000/customers/login'),
    //         headers: {"Content-Type": "application/json; charset=utf-8"},
    //         body: jsonEncode(data))
    //     .then(
    //   (value) {
    //     // log(value.body);
    //     var customer = customersLoginPostResponseFromJson(value.body);
    //     log(customer.customer.email);
    //     // var jsonRes = jsonDecode(value.body);
    //     // log(jsonRes["customer"]["email"]);
    //     setState(() {
    //       text = '';
    //     });
    //     Navigator.push(
    //         context,
    //         MaterialPageRoute(
    //           builder: (context) => const Showtrip(),
    //         ));
    //   },
    // ).catchError(
    //   (error) {
    //     log(error.toString());
    //     setState(() {
    //       text = 'Phone No or Password Incorrect!';
    //     });
    //   },
    // );

    try {
      var value = await http.post(
          Uri.parse('$url/customers/login'),
          headers: {"Content-Type": "application/json; charset=utf-8"},
          body: jsonEncode(data));
      var customer = customersLoginPostResponseFromJson(value.body);
      setState(() {
        text = '';
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Showtrip(idx: customer.customer.idx),
          ));
    } catch (eee) {
      log(eee.toString());
      setState(() {
        text = 'Phone No or Password Incorrect!';
      });
    }
  }
}
