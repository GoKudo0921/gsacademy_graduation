import 'package:SmartWedding/account_page/screen.dart';
import 'package:SmartWedding/utils/authentication.dart';
import 'package:flutter/material.dart';

import 'create_account_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('ログイン'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'メールアドレス'),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      obscureText: true,
                      controller: passController,
                      decoration: const InputDecoration(hintText: 'パスワード'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('アカウント作成は'),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccountPage()));
                          },
                          child: const Text('こちら',
                              style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              var result = await Authentication.emailSignIn(
                                  email: emailController.text,
                                  pass: passController.text);
                              if (result == true) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Screen()));
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                // ログインエラーのハンドリング
                                // エラーメッセージの表示など
                              }
                            },
                      child: const Text('emailでログイン',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
