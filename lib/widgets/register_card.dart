import 'dart:io';

import '../my_packages/my_packages.dart';
import 'package:image_picker/image_picker.dart';

import '../providers/auth_provider.dart';

import '../models/person/person.dart';
import '../models/error_handler.dart';
import '../widgets/auth_button.dart';

import '../screens/screens.dart';

import '../constants_and_methods.dart';

class RegisterCard extends StatefulWidget {
  const RegisterCard({Key? key}) : super(key: key);

  @override
  _RegisterCardState createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNoController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  File? file;
  bool _isLoading = false;

  String _password = '';
  Person person = Person.user(
    phoneNo: '',
    email: '',
    name: '',
    groups: [],
    imageUrl: '',
    createdAt: DateTime.now(),
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneNoController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final _pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (_pickedFile == null) return;
    setState(() => file = File(_pickedFile.path));
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (file == null) {
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please upload your photo',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.red,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: kDefaultBorderRadius,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 20.0,
          ),
          margin: const EdgeInsets.only(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.white,
        ),
      );
      return;
    }

    _formKey.currentState!.save();
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);
    try {
      await Provider.of<MyAuthProvider>(context, listen: false).register(
        email: person.email,
        password: _password,
        person: person,
        file: file,
      );
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
      _phoneNoController.clear();
      _confirmPasswordController.clear();
      file = null;
      setState(() => _isLoading = false);
      await Future.delayed(const Duration(milliseconds: 600));
      showAlertBox(
        dialogType: AlertType.success,
        title: 'Success',
        context: context,
        body: 'Registration successful',
      );
    } on FirebaseException catch (e) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = false);
      final statusCode = AuthExceptionHandler.getExceptionStatus(e);

      showAlertBox(
        context: context,
        dialogType: AlertType.none,
        title: 'Error',
        body: AuthExceptionHandler.generateExceptionMessage(statusCode),
      );
    } catch (e) {
      FocusScope.of(context).unfocus();
      setState(() => _isLoading = false);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getAuthContainerWidth(context),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextFormField(
                  controller: _nameController,
                  style: kAuthInputTextStyle,
                  decoration: InputDecoration(
                    hintText: 'Your name',
                    hintStyle: kAuthInputHintStyle,
                    errorStyle: kAuthErrorStyle,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      FontAwesomeIcons.user,
                      color: kTextColorWithOpacity,
                      size: 20.0,
                    ),
                    contentPadding: kAuthInputPadding,
                    border: OutlineInputBorder(
                      borderRadius: kDefaultBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    person = Person.user(
                      name: value,
                      email: person.email,
                      imageUrl: person.imageUrl,
                      phoneNo: person.phoneNo,
                      groups: [],
                    );
                  }),
              kSpaceBox,
              TextFormField(
                  controller: _emailController,
                  style: kAuthInputTextStyle,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email address',
                    hintStyle: kAuthInputHintStyle,
                    errorStyle: kAuthErrorStyle,
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      color: kTextColorWithOpacity,
                      size: 20.0,
                    ),
                    contentPadding: kAuthInputPadding,
                    border: OutlineInputBorder(
                      borderRadius: kDefaultBorderRadius,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide an email address';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    person = Person.user(
                      name: person.name,
                      email: value,
                      imageUrl: person.imageUrl,
                      phoneNo: person.phoneNo,
                      groups: [],
                    );
                  }),
              kSpaceBox,
              TextFormField(
                controller: _phoneNoController,
                style: kAuthInputTextStyle,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Phone no',
                  hintStyle: kAuthInputHintStyle,
                  errorStyle: kAuthErrorStyle,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.phone_outlined,
                    size: 22.0,
                    color: kTextColorWithOpacity,
                  ),
                  contentPadding: kAuthInputPadding,
                  border: OutlineInputBorder(
                    borderRadius: kDefaultBorderRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your phone no.';
                  }
                  if (value.length < 10) {
                    return 'Invalid phone no';
                  }
                  return null;
                },
                onSaved: (value) {
                  person = Person.user(
                    name: person.name,
                    email: person.email,
                    imageUrl: person.imageUrl,
                    phoneNo: value,
                    groups: [],
                  );
                },
              ),
              kSpaceBox,
              TextFormField(
                controller: _passwordController,
                style: kAuthInputTextStyle,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: kAuthInputHintStyle,
                  errorStyle: kAuthErrorStyle,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    size: 22.0,
                    color: kTextColorWithOpacity,
                  ),
                  contentPadding: kAuthInputPadding,
                  border: OutlineInputBorder(
                    borderRadius: kDefaultBorderRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter your password';
                  }
                  if (value.length < 8) {
                    return 'Password must be up to 8 characters or more';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              kSpaceBox,
              TextFormField(
                controller: _confirmPasswordController,
                style: kAuthInputTextStyle,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Confirm password',
                  hintStyle: kAuthInputHintStyle,
                  errorStyle: kAuthErrorStyle,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    size: 22.0,
                    color: kTextColorWithOpacity,
                  ),
                  contentPadding: kAuthInputPadding,
                  border: OutlineInputBorder(
                    borderRadius: kDefaultBorderRadius,
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm password';
                  }
                  if (value != _passwordController.text) {
                    return 'Password does not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 6.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 120,
                    width: 120,
                    clipBehavior: Clip.antiAlias,
                    padding: file != null
                        ? const EdgeInsets.all(0)
                        : const EdgeInsets.symmetric(horizontal: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: kDefaultBorderRadius,
                    ),
                    child: file != null
                        ? Image.file(file!, fit: BoxFit.cover)
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.photo_camera_outlined,
                                color: kTextColorWithOpacity,
                                size: 24.0,
                              ),
                              Text(
                                'preview photo',
                                style: TextStyle(
                                  color: kTextColorWithOpacity,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                  ),
                  TextButton(
                    child: Text(
                      'Upload Photo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: _pickImage,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0x93000000),
                      shadowColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              AuthButton(
                isLoading: _isLoading,
                btnText: 'SUBMIT',
                onTap: _submit,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  TextButton(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ResetPasswordScreen.routeName,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
