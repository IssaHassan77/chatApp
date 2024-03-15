import 'dart:io';

import 'package:chat_app/widgets/picker/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, this.isLoading, {super.key});

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String username,
    File? image,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormeState();
}

class _AuthFormeState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';
  File? _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState?.validate();
    FocusScope.of(context).unfocus();
    if (_userImageFile == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please pick an image'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    if (isValid!) {
      _formKey.currentState?.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImageFile,
        _isLogin,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin) UserImagePicker(_pickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    onSaved: (value) {
                      _userEmail = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'please enter a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email Address',
                    ),
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      onSaved: (value) {
                        _userName = value!;
                      },
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (value) {
                        if (value!.isEmpty || value.length < 4) {
                          return 'Please enter at least 4 characters';
                        }
                        return null;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    onSaved: (value) {
                      _userPassword = value!;
                    },
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 7) {
                        return 'password must be at least 7 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: _trySubmit,
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                        style: TextStyle(
                          color: Theme.of(context).primaryIconTheme.color,
                        ),
                      ),
                    ),
                  if (!widget.isLoading)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isLogin = !_isLogin;
                        });
                      },
                      child: Text(_isLogin
                          ? 'create new account'
                          : 'I already have an account'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
