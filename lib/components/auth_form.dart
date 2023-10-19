import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../services/auth_service.dart';

class AuthForm extends StatefulWidget {
  final String authType;
  const AuthForm({
    super.key,
    required this.authType,
  });


  @override
  State<StatefulWidget> createState() {
    return _AuthFormState();
  }
}

class RegisterAuthForm extends AuthForm{
  const RegisterAuthForm({super.key, super.authType = "register"});
}
class LoginAuthForm extends AuthForm{
  const LoginAuthForm({super.key, super.authType = "login"});
}

class _AuthFormState extends State<AuthForm>{
  late String formMessage = "";
  final AuthService authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final emailFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  bool emailRegExp(String userInput) => RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$').hasMatch(userInput);


  Future<Response> submitForm() async{
    Map<String, dynamic> formData = {'email': emailFieldController.text, 'password': passwordFieldController.text};
    late Response response;
    if(widget.authType == 'register'){
      response = await authService.registerUser(formData);
    }else if(widget.authType == 'login'){
      response = await authService.login(formData);
    }
    return response;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.6;
    return  ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 200, maxWidth: width),
      child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(hintText: "Email"),
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.isEmpty) {
                                  return 'L\'email doit être remplit';
                                }else if(!emailRegExp(inputValue)){
                                  return 'L\'adresse email n\'est pas valide';
                                }else{
                                  return null;
                                }
                              },
                              controller: emailFieldController,
                            ),
                            const Spacer(),
                            TextFormField(
                              obscureText: true,
                              enableSuggestions: false,
                              autocorrect: false,
                              decoration: const InputDecoration(hintText: 'Mot de passe'),
                              validator: (inputValue) {
                                if (inputValue == null || inputValue.length < 3) {
                                  return 'Le mot de passe doit faire au moins 3 caractères';
                                }
                                else{
                                  return null;
                                }
                              },
                              controller: passwordFieldController,
                            ),
                            const Spacer(),
                            ElevatedButton(
                                onPressed: () async {
                                  if(_formKey.currentState!.validate()){
                                    bool validatedResponse = false;
                                    Response response = await submitForm();
                                    String resultMessage;
                                    if(widget.authType == 'register'){
                                      resultMessage = response.statusCode == 201 ? "Registered successfully" : response.statusCode == 409 ? "Email already chosen" : "Register Failed";

                                      validatedResponse = response.statusCode == 200 ? true : false;
                                    }else if(widget.authType == 'login'){
                                      resultMessage = response.statusCode == 200 ? "Logged in successfully" : response.statusCode == 401 ? "Email or password are incorrect" : "Login Failed";
                                      validatedResponse = response.statusCode == 200 ? true : false;
                                    }else{
                                      resultMessage = "";
                                    }
                                    setState(() {
                                      formMessage = resultMessage;

                                      if(validatedResponse){
                                        Future.delayed(
                                            const Duration(seconds: 1),
                                                () => Navigator.of(context, rootNavigator: true).pushNamed('/')
                                        );
                                      }
                                    });
                                  }
                                },
                                child: const Text("Envoyer"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(formMessage)
                              ],
                            )
                          ]
                      ),
                    )
                ),
            ],
      ),
    );
  }
}

