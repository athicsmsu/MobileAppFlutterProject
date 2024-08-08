import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/config/config.dart';
import 'package:flutter_application_1/models/request/CustomersRegisterPostRequest.dart';
import 'package:flutter_application_1/models/response/CustomersRegisterPostRes.dart';
import 'package:flutter_application_1/pages/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController ConfirmPasswordCtl = TextEditingController();
  String url = "";
  
  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then((value) {
      url = value['apiEndpoint'];
      log(url);
    },).catchError((error) {
      log(error);
    },);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ลงทะเบียนสมาชิกใหม่"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ชื่อ-นามสกุล",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "หมายเลขโทรศัพท์",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: phoneCtl,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "อีเมล",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: emailCtl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "รหัสผ่าน",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "ยืนยันรหัสผ่าน",
                    style: TextStyle(fontSize: 16),
                  ),
                  TextField(
                    controller: ConfirmPasswordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 1)),
                    ),
                  )
                ],
              ),
            ),
            FilledButton(
                onPressed: () {
                  Register();
                },
                child: const Text(
                  "สมัครสมาชิก",
                  style: TextStyle(fontSize: 20),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {},
                    child: const Text(
                      "หากมีบัญชีอยู่แล้ว?",
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    )),
                TextButton(
                    onPressed: () {
                      GoLogin();
                    },
                    child: const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 20),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  void GoLogin() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ));
  }

  void Register() async {
    var name = nameCtl.text;
    var phone = phoneCtl.text;
    var email = emailCtl.text;
    var password = passwordCtl.text;
    var ConfirmPassword = ConfirmPasswordCtl.text;

    if (name.isNotEmpty &&
        phone.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        ConfirmPassword.isNotEmpty) {
      if (password == ConfirmPassword) {
        var data = CustomersRegisterPostRequest(
            fullname: name,
            phone: phone,
            email: email,
            image:
                "http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png",
            password: password);
        try {
          var value = await http.post(
              Uri.parse('$url/customers'),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: jsonEncode(data));
          var customer = customersRegisterPostResFromJson(value.body);
          log(customer.message);
          log(customer.id.toString());
        } catch (eee) {
          log("Insert Error " + eee.toString());
        }
      } else {
        log("password not match");
      }
    } else {
      log("Fields MUST NOT be empty!!!");
    }
  }
}
