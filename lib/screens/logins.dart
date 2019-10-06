import 'package:flutter/material.dart';
import 'package:autodo/blocs/userauth.dart';
import 'package:autodo/theme.dart';

class SignInScreen extends StatefulWidget {
  final Auth userAuth = Auth();
  FormMode formMode;
  SignInScreen({@required this.formMode});

  @override
  SignInScreenState createState() => SignInScreenState();
}

enum FormMode { LOGIN, SIGNUP }

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _submit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (widget.formMode == FormMode.SIGNUP)
          userId = await widget.userAuth.signUp(_email, _password);
        else
          userId = await widget.userAuth.signIn(_email, _password);
        // widget.userAuth.sendEmailVerification();
        setState(() {
          _isLoading = false;
        });
        if (userId.length > 0 && userId != null) {
          Navigator.pushNamed(context, '/');
        }
      } catch (e) {
        print("error: $e");
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
            onPressed: () => Navigator.pop(context),
          ),
          title: Hero(
            tag: "SignupButton",
            transitionOnUserGestures: true,
            child: Text(
              widget.formMode == FormMode.LOGIN ? 'LOG IN' : 'SIGN UP',
              style: TextStyle(color: Colors.grey[300]),
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            _showBody(),
            _showCircularProgress(),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container();
  }

  // void _showVerifyEmailSentDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       // return object of type Dialog
  //       return AlertDialog(
  //         title: Text("Verify your account"),
  //         content: Text("Link to verify account has been sent to your email"),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text("Dismiss"),
  //             onPressed: () {
  //               // _changeFormToLogin();
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Widget _showBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _showEmailInput(),
            _showPasswordInput(),
            _showPrimaryButton(),
            _showSecondaryButton(),
            _showErrorMessage(),
          ],
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return Container(
        height: 0.0,
      );
    }
  }

  String _emailValidator(value) {
    if (value.isEmpty)
      return 'Email can\'t be empty';
    else if (!value.contains('@') || !value.contains('.'))
      return 'Invalid email address';
    return null;
  }

  Widget _showEmailInput() {
    return TextFormField(
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      autofocus: true,
      decoration: InputDecoration(
          hintText: 'Email',
          hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
          icon: Icon(
            Icons.mail,
            color: Colors.grey[300],
          )),
      validator: (value) => _emailValidator(value),
      onSaved: (value) => _email = value.trim(),
    );
  }

  String _passwordValidator(value) {
    if (value.isEmpty)
      return 'Password can\'t be empty';
    else if (value.length < 6)
      return 'Password must be longer than 6 characters';
    return null;
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(
              color: Colors.grey[400],
            ),
            icon: Icon(
              Icons.lock,
              color: Colors.grey[300],
            )),
        validator: (value) => _passwordValidator(value),
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showSecondaryButton() {
    return FlatButton(
      child: widget.formMode == FormMode.LOGIN
          ? Text('Create an account',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300))
          : Text('Have an account? Sign in',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300)),
      onPressed: () {
        widget.formMode == FormMode.LOGIN
            ? setState(() => widget.formMode = FormMode.SIGNUP)
            : setState(() => widget.formMode = FormMode.LOGIN);
      },
    );
  }

  Widget _showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
      child: SizedBox(
        height: 40.0,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          color: Theme.of(context).primaryColor,
          child: widget.formMode == FormMode.LOGIN
              ? Text(
                'Login',
                style: Theme.of(context).accentTextTheme.button,
              )
              : Text( 
                'Create account',
                style: Theme.of(context).accentTextTheme.button,
          ),
          onPressed: () => _submit(),
        ),
      ),
    );
  }
}
