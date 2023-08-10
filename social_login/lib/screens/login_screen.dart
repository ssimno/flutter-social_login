import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a new provider
    GithubAuthProvider githubProvider = GithubAuthProvider();

    return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: FutureBuilder(
              future: FirebaseAuth.instance.authStateChanges().first,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // 로그인 상태 확인 완료 (User가 null이 아니면 로그인된 것)
                if (snapshot.hasData && snapshot.data != null) {
                  return const HomeScreen(); // 홈 화면으로 이동
                } else {
                  return Container(
                    color: const Color.fromARGB(31, 176, 176, 176)
                        .withOpacity(0.1),
                    padding: const EdgeInsets.only(
                      top: 160,
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  30,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(2, 2),
                                  color: Colors.black38,
                                  blurRadius: 4,
                                )
                              ]),
                          child: const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        InkWell(
                          onTap: () {
                            signInWithGoogle().then((value) {
                              setState(() {});
                            });
                          },
                          child: Image.asset(
                            "assets/images/btn_login_google.png",
                            width: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            signInWithFacebook().then((value) {
                              setState(() {});
                            });
                          },
                          child: Image.asset(
                            "assets/images/btn_login_facebook.png",
                            width: 200,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            signInWithGitHub().then((value) {
                              setState(() {});
                            });
                          },
                          child: Image.asset(
                            "assets/images/btn_login_github.png",
                            width: 200,
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
