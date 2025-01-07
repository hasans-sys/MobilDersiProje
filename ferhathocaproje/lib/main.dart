import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_page.dart'; // EventPage'i import ettik

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Giriş ve Kayıt Ekranı',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.deepPurpleAccent,
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
        textTheme: TextTheme(
          titleLarge: TextStyle(color: Colors.deepPurple[800], fontWeight: FontWeight.bold),
          bodyLarge: TextStyle(color: Colors.deepPurple[700]),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> signInWithGoogle() async {
      try {
        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: '866468639430-vgvdcktc5t9gotu9ddrvfst8v6q7r61e.apps.googleusercontent.com',
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        await _auth.signInWithCredential(credential);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const EventPage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Google ile giriş hatası: ${e.toString()}')),
        );
      }
    }

    void signIn() async {
      final String email = emailController.text;
      final String password = passwordController.text;
      if (email.isNotEmpty && password.isNotEmpty) {
        try {
          await _auth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EventPage()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${e.toString()}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
        );
      }
    }

    void resetPassword() async {
      if (emailController.text.isNotEmpty) {
        try {
          await _auth.sendPasswordResetEmail(email: emailController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Şifre sıfırlama e-postası gönderildi!')),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${e.toString()}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen e-posta adresinizi girin.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Giriş Yap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: signIn,
              child: const Text('Giriş Yap'),
            ),
           ElevatedButton(
              onPressed: signInWithGoogle,
              style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orangeAccent, 
               ),
            child: const Text('Google ile Giriş Yap'),
            ),

            TextButton(
              onPressed: resetPassword,
              child: const Text('Şifremi Unuttum'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void register() async {
      final String email = emailController.text;
      final String password = passwordController.text;
      if (email.isNotEmpty && password.isNotEmpty) {
        try {
          UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          await _firestore.collection('kullanicilar').doc(userCredential.user?.uid).set({
            'email': email,
          });
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Kayıt başarılı!')));
          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Hata: ${e.toString()}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lütfen tüm alanları doldurun.')),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'E-posta'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('Kayıt Ol'),
            ),
          ],
        ),
      ),
    );
  }
}
