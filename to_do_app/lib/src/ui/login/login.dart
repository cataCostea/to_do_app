import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/login_provider.dart';
import '../../ui/dashboard/dashboard.dart';
import '../../utils/form_validations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<FormState> _loginForm = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  LoginProvider login;

  @override
  void didChangeDependencies() {
    login = Provider.of<LoginProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: GestureDetector(
        child: SafeArea(
          child: Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          child: Text("Hi, what's your name?"),
                        ),
                        buildForm(),
                        submitButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildForm() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Form(
        key: _loginForm,
        child: Container(
          child: TextFormField(
            controller: userNameController,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.sentences,
            scrollPadding: EdgeInsets.only(bottom: 100.0),
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderSide:
                    BorderSide(color: Theme.of(context).colorScheme.primary),
              ),
              hintStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
                fontSize: 20.0,
              ),
              hintText: "Your name",
            ),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
              fontSize: 20.0,
            ),
            validator: Validations().mandatoryAndLength,
          ),
        ),
      ),
    );
  }

  Widget submitButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 25.0),
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
        width: MediaQuery.of(context).size.width / 2,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Theme.of(context).colorScheme.primary.withOpacity(0.25),
        ),
        child: Text(
          "Submit",
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
      onTap: () {
        var isValid = _loginForm.currentState.validate();
        if (isValid) {
          login.setUserName(userNameController.text);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        }
      },
    );
  }
}
