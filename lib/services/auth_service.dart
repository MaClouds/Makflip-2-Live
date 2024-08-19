import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:markflip/models/user_models.dart';
import 'package:markflip/provider/user_provider.dart';
import 'package:markflip/utilities/global_variable.dart';
import 'package:markflip/views/screens/auth/signIn_screen.dart';
import 'package:markflip/views/screens/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/error_handler/error_handling.dart';

class AuthService {
  Future<void> createUser({
    required  context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      UserModel user = UserModel(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/signup'),
        body: user.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Account has been created for you');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> loginUser({
    required  context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString(
            'x-auth-token',
            jsonDecode(response.body)['token'],
          );
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);

          print('User data set in provider: ${response.body}');

          if (Provider.of<UserProvider>(context, listen: false)
              .user
              .token
              .isNotEmpty) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          }
        },
      );

      print('Login response token: ${jsonDecode(response.body)['token']}');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getUserData( context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token == null) {
        preferences.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
        print('Fetched user data set in provider: ${userRes.body}');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOut( context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token != null) {
        http.Response response = await http.post(
          Uri.parse('$uri/api/signout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        if (response.statusCode == 200) {
          await preferences.remove('x-auth-token');
          Provider.of<UserProvider>(context, listen: false).clearUser();
          showSnackBar(context, 'Signed out successfully');
        } else {
          showSnackBar(context, 'Failed to sign out: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error signing out: $e');
      showSnackBar(context, 'Error signing out: $e');
    }
  }

  Future<void> createSeller({
    required  context,
    required String email,
    required String name,
    required String password,
  }) async {
    try {
      UserModel seller = UserModel(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: 'seller',
        token: '',
      );
      http.Response response = await http.post(
        Uri.parse('$uri/api/seller/signup'),
        body: seller.toJson(),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Seller account has been created');
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInPage()),
            (route) => false,
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> loginSeller({
    required  context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse("$uri/api/seller/signin"),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          "Content-Type": 'application/json; charset=UTF-8'
        },
      );

      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          await preferences.setString(
            'x-auth-token',
            jsonDecode(response.body)['token'],
          );
          Provider.of<UserProvider>(context, listen: false)
              .setUser(response.body);

          print('Seller data set in provider: ${response.body}');

          if (Provider.of<UserProvider>(context, listen: false)
              .user
              .token
              .isNotEmpty) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
              (route) => false,
            );
          }
        },
      );

      print('Login response token: ${jsonDecode(response.body)['token']}');
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> getSellerData( context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token == null) {
        preferences.setString('x-auth-token', '');
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/api/seller/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response sellerRes = await http.get(
          Uri.parse('$uri/api/seller/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(sellerRes.body);
        print('Fetched seller data set in provider: ${sellerRes.body}');
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<void> signOutSeller( context) async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? token = preferences.getString('x-auth-token');

      if (token != null) {
        http.Response response = await http.post(
          Uri.parse('$uri/api/seller/signout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        if (response.statusCode == 200) {
          await preferences.remove('x-auth-token');
          Provider.of<UserProvider>(context, listen: false).clearUser();
          showSnackBar(context, 'Seller signed out successfully');
        } else {
          showSnackBar(context, 'Failed to sign out: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error signing out: $e');
      showSnackBar(context, 'Error signing out: $e');
    }
  }
}
