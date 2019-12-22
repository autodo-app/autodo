import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:autodo/blocs/blocs.dart';
import 'package:autodo/theme.dart';
import 'package:autodo/localization.dart';
import 'package:autodo/widgets/widgets.dart';

class _ErrorMessage extends StatelessWidget {
  final String msg;

  _ErrorMessage(this.msg);

  @override 
  build(context) => Padding(
    padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
    child: Center(
      child: Text(
        msg,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      ),
    ),
  );
}

class _Legal extends StatelessWidget {
  @override 
  build(context) => Container(
    padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
            text: AutodoLocalizations.legal1 + ' ',
            style: finePrint(),
          ),
          TextSpan(
            text: AutodoLocalizations.legal2,
            style: linkStyle(),
            recognizer: TapGestureRecognizer()..onTap = () {},
          ),
          TextSpan(
            text: ' ' + AutodoLocalizations.legal3 + ' ',
            style: finePrint(),
          ),
          TextSpan(
            text: AutodoLocalizations.legal4,
            style: linkStyle(),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                BlocProvider.of<LegalBloc>(context).add(LoadLegal());
                showDialog<Widget>(
                    context: context,
                    builder: (ctx) => BlocBuilder<LegalBloc, LegalState>(
                      builder: (context, state) {
                        if (state is LegalLoading) {
                          return LoadingIndicator();
                        } else if (state is LegalLoaded) {
                          return PrivacyPolicy(state.text);
                        } else {
                          Navigator.pop(context);
                          return Container();
                        }
                      }
                    )
                );
              },
          ),
          TextSpan(
            text: ' ' + AutodoLocalizations.legal5,
            style: finePrint(),
          ),
        ]),
      )
    )
  );
}

class _EmailForm extends StatelessWidget {
  final Function onSaved;
  final FocusNode node, nextNode;

  _EmailForm({this.onSaved, this.node, this.nextNode});

  @override 
  build(context) => TextFormField(
    keyboardType: TextInputType.emailAddress,
    textInputAction: TextInputAction.next,
    autofocus: true,
    focusNode: node,
    decoration: InputDecoration(
      hintText: AutodoLocalizations.email,
      hintStyle: TextStyle(
        color: Colors.grey[400],
      ),
      icon: Icon(
        Icons.mail,
        color: Colors.grey[300],
      )
    ),
    onSaved: (value) => onSaved(value.trim()),
    onChanged: (val) => BlocProvider.of<LoginBloc>(context).add(
      LoginEmailChanged(email: val)
    ),
    onFieldSubmitted: (_) {
      node.unfocus();
      nextNode.requestFocus();
    },
  );
}

class _PasswordForm extends StatelessWidget {
  final Function onSaved;
  final FocusNode node;

  _PasswordForm({this.onSaved, this.node});

  @override 
  build(context) => Container(
    padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
    child: TextFormField(
      obscureText: true,
      focusNode: node,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        hintText: AutodoLocalizations.password,
        hintStyle: TextStyle(
          color: Colors.grey[400],
        ),
        icon: Icon(
          Icons.lock,
          color: Colors.grey[300],
        )
      ),
      onChanged: (val) => BlocProvider.of<LoginBloc>(context).add(
        LoginPasswordChanged(password: val)
      ),
      onSaved: (value) => onSaved(value.trim()),
    ),
  );
}

class _SignupButton extends StatelessWidget {
  @override 
  build(context) => Container(
    padding: EdgeInsets.only(top: 10.0),
    child: FlatButton(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: Text(
        AutodoLocalizations.createAnAccount, 
        style: linkStyle()
      ),
      onPressed: () => Navigator.of(context).pushNamed('/signup'),
    ),
  );
}

class _LoginButton extends StatelessWidget {
  final Function onPressed;

  _LoginButton({this.onPressed});

  @override 
  build(context) => Container(
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
        child: Text(
          AutodoLocalizations.login,
          style: Theme.of(context).accentTextTheme.button,
        ),
        onPressed: () => onPressed(),
      ),
    ),
  );
}

class _PasswordResetDialog extends StatefulWidget {
  @override 
  _PasswordResetDialogState createState() => _PasswordResetDialogState();
}

class _PasswordResetDialogState extends State<_PasswordResetDialog> {
  final _passwordResetKey = GlobalKey<FormState>();
  String _email;

  @override 
  build(context) => AlertDialog(
    title: Text(
      AutodoLocalizations.sendPasswordReset,
      style: Theme.of(context).primaryTextTheme.title
    ),
    content: Form(
      key: _passwordResetKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // roll own email box
          TextFormField(
            // initialValue: _emailController.text,
            maxLines: 1,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            autofocus: true,
            decoration: InputDecoration(
              hintText: AutodoLocalizations.email,
              hintStyle: TextStyle(
                color: Colors.grey[400],
              ),
              icon: Icon(
                Icons.mail,
                color: Colors.grey[300],
              )
            ),
            onChanged: (val) => BlocProvider.of<LoginBloc>(context).add(
              LoginEmailChanged(email: val)
            ),
            onSaved: (value) => _email = value.trim(),
          ),
        ],
      ),
    ),
    actions: [
      FlatButton(
        child: Text(
          AutodoLocalizations.back.toUpperCase(),
          style: Theme.of(context).primaryTextTheme.button
        ),
        onPressed: () => Navigator.pop(context)
      ),
      FlatButton(
        child: Text(
          AutodoLocalizations.send.toUpperCase(),
          style: Theme.of(context).primaryTextTheme.button,
        ),
        onPressed: () {
          BlocProvider.of<LoginBloc>(context).add(
            SendPasswordResetPressed(email: _email)
          );
          Navigator.pop(context); // dialog
        }
      )
    ]
  );
}

class _PasswordResetButton extends StatelessWidget {
  build(context) => FlatButton(
    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    child: Text(
      AutodoLocalizations.forgotYourPassword,
      style: linkStyle(),
    ),
    onPressed: () => showDialog(
      context: context,
      builder: (context) => _PasswordResetDialog(),
    ),
  );
}

class LoginScreen extends StatefulWidget {
  @override 
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;
  FocusNode _emailNode, _passwordNode;

  @override 
  void initState() {
    _emailNode = FocusNode()..requestFocus();
    _passwordNode = FocusNode();
    super.initState();
  }

  @override 
  void dispose() {
    _emailNode.dispose();
    _passwordNode.dispose();
    super.dispose();
  }

  @override 
  build(context) => BlocBuilder<LoginBloc, LoginState>(  
    builder: (context, state) => Scaffold(  
      appBar: AppBar(  
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[300]),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(  
          AutodoLocalizations.login,
          style: Theme.of(context).primaryTextTheme.subtitle
        ),
      ),
      // Add a stack somewhere in here to display the loading process indicator
      body: Form(  
        key: _formKey,
        child: Container(  
          padding: EdgeInsets.all(15),
          child: ListView(  
            children: <Widget>[
              _EmailForm( 
                onSaved: (val) => _email = val,
                node: _emailNode,
                nextNode: _passwordNode
              ),
              _PasswordForm(
                onSaved: (val) => _password = val,
                node: _passwordNode
              ),
              (state is LoginError) ? _ErrorMessage(state.errorMsg) : Container(),
              _Legal(),
              _LoginButton( 
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    BlocProvider.of<LoginBloc>(context).add(
                      LoginWithCredentialsPressed(
                        email: _email,
                        password: _password
                      )
                    );
                    Navigator.pop(context);
                  }
                } 
              ),
              _PasswordResetButton(),
              _SignupButton(),
            ],
          )
        )
      )
    ),
  );
}