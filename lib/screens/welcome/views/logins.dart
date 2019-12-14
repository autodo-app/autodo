import 'package:autodo/blocs/barrel.dart';
import 'package:autodo/widgets/legal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:autodo/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

class SignInScreen extends StatefulWidget {
  @override
  SignInScreenState createState() => SignInScreenState();
}

enum FormMode { LOGIN, SIGNUP }

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordResetKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String _email;
  String _password;
  String _errorMessage;
  String _sendError;

  bool _isLoading;

  FocusNode _emailNode, _passwordNode;
  TextEditingController _emailController;

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget _waitForEmailVerification(user) => AlertDialog(
        title: Text('Verify Email',
            style: Theme.of(context).primaryTextTheme.title),
        content: Text(
            'An email has been sent to you with a link to verify your account.\n\nYou must verify your email to use auToDo.',
            style: Theme.of(context).primaryTextTheme.body1),
        actions: [
          FutureBuilder(
              future: Auth().waitForVerification(user),
              builder: (context, snap) {
                if (!snap.hasData) return Container();
                return FlatButton(
                  child: Text('Next'),
                  onPressed: () =>
                      Navigator.popAndPushNamed(context, '/newuser'),
                );
              })
        ],
      );

  Future<void> _signUp() async {
    if (kReleaseMode) {
      var user = await Auth().signUpWithVerification(_email, _password);
      if (user != null) {
        showDialog(
            context: context,
            builder: (context) => _waitForEmailVerification(user),
            barrierDismissible: false);
      }
      setState(() {
        _isLoading = false;
      });
    } else {
      // don't want to deal with using real emails and verifying them in
      // debug
      await initNewUser(_email, _password);
    }
  }

  void _signUpErrorHandling(PlatformException e) {
    var errorString = "Error communicating to the auToDo servers.";
    if (e.code == "ERROR_WEAK_PASSWORD") {
      errorString = "Your password must be longer than 6 characters.";
    } else if (e.code == "ERROR_INVALID_EMAIL") {
      errorString = "The email address you entered is invalid.";
    } else if (e.code == "ERROR_EMAIL_ALREADY_IN_USE") {
      errorString = "The email address you entered is already in use.";
    } else if (e.code == "ERROR_WRONG_PASSWORD") {
      errorString = "Incorrect password, please try again.";
    }
    print(e);
    setState(() {
      _isLoading = false;
      _errorMessage = errorString;
    });
  }

  void _submit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (!_validateAndSave()) {
      setState(() => _isLoading = false);
      return;
    }

    try {
      if (widget.formMode == FormMode.SIGNUP) {
        await _signUp();
      } else {
        await initExistingUser(_email, _password);
      }
      setState(() => _isLoading = false);
      if (widget.formMode == FormMode.SIGNUP)
        Navigator.popAndPushNamed(context, '/newuser');
      else
        Navigator.pushNamed(context, '/load');
    } on PlatformException catch (e) {
      _signUpErrorHandling(e);
    }
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    PrivacyPolicy.init(context);
    _emailNode = FocusNode()..requestFocus();
    _passwordNode = FocusNode();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: scaffoldBackgroundGradient(),
      child: Scaffold(
        key: _scaffoldKey,
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

  TextStyle linkStyle() {
    return TextStyle(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.solid,
        fontSize: 13.0,
        fontWeight: FontWeight.w300);
  }

  TextStyle finePrint() {
    return TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300);
  }

  bool _error() {
    return _errorMessage.length > 0 && _errorMessage != null;
  }

  Widget _legal() {
    if (_error()) return Container();
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
        child: Center(
            child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(children: [
            TextSpan(
              text: 'By signing up, you agree to the ',
              style: finePrint(),
            ),
            TextSpan(
              text: 'terms and conditions',
              style: linkStyle(),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            TextSpan(
              text: ' and ',
              style: finePrint(),
            ),
            TextSpan(
              text: 'privacy policy',
              style: linkStyle(),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showDialog<Widget>(
                      context: context,
                      builder: (ctx) => PrivacyPolicy.dialog(ctx));
                },
            ),
            TextSpan(
              text: ' of the auToDo app.',
              style: finePrint(),
            ),
          ]),
        )));
  }

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
            _legal(),
            _showErrorMessage(),
            _showPrimaryButton(),
            _showSecondaryButtons(),
          ],
        ),
      ),
    );
  }

  Widget _showErrorMessage() {
    if (!_error()) return Container();
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Center(
        child: Text(
          _errorMessage,
          style: TextStyle(
              fontSize: 13.0,
              color: Colors.red,
              height: 1.0,
              fontWeight: FontWeight.w300),
        ),
      ),
    );
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
      controller: _emailController,
      maxLines: 1,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofocus: true,
      focusNode: _emailNode,
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
      onFieldSubmitted: (_) {
        _emailNode.unfocus();
        _passwordNode.requestFocus();
      },
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
        focusNode: _passwordNode,
        textInputAction: TextInputAction.done,
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

  Widget _showSecondaryButtons() => Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: widget.formMode == FormMode.LOGIN
                  ? Text('Create an account', style: linkStyle())
                  : Text('Have an account? Sign in', style: linkStyle()),
              onPressed: () {
                widget.formMode == FormMode.LOGIN
                    ? setState(() => widget.formMode = FormMode.SIGNUP)
                    : setState(() => widget.formMode = FormMode.LOGIN);
              },
            ),
            (widget.formMode == FormMode.LOGIN)
                ? _passwordReset()
                : Container(),
          ],
        ),
      );

  Widget _showPrimaryButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 0.0),
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

  _sendButton() => FlatButton(
      child: Text(
        'SEND',
        style: Theme.of(context).primaryTextTheme.button,
      ),
      onPressed: () async {
        showDialog(
          context: context,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );
        if (_passwordResetKey.currentState.validate())
          _passwordResetKey.currentState.save();
        try {
          await Auth().sendPasswordReset(_email);
        } catch (e) {
          if (e.code == 'ERROR_INVALID_EMAIL')
            _sendError = "Invalid email address format";
          else if (e.code == 'ERROR_USER_NOT_FOUND')
            _sendError = "Could not find an account for this email address";
        }
        if (_sendError == null) {
          _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text('Password Reset email has been sent.')));
          Navigator.pop(context); // progress bar
          Navigator.pop(context); // dialog
        }
      });

  _passwordResetDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text('Send Password Reset',
                style: Theme.of(context).primaryTextTheme.title),
            content: Form(
              key: _passwordResetKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // roll own email box
                  TextFormField(
                    initialValue: _emailController.text,
                    maxLines: 1,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
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
                  ),
                  (_sendError != null) ? Text(_sendError) : Container(),
                ],
              ),
            ),
            actions: [
              FlatButton(
                  child: Text('BACK',
                      style: Theme.of(context).primaryTextTheme.button),
                  onPressed: () => Navigator.pop(context)),
              _sendButton()
            ]),
      );

  _passwordReset() => FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Text(
        'Forgot your password?',
        style: linkStyle(),
      ),
      onPressed: () => _passwordResetDialog());
}
