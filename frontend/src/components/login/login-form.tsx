import * as React from 'react';
import { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import Avatar from '@material-ui/core/Avatar';
import Button from '@material-ui/core/Button';
import Link from '@material-ui/core/Link';
import Grid from '@material-ui/core/Grid';
import LockOutlinedIcon from '@material-ui/icons/LockOutlined';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';

import { Formik, Form, Field } from 'formik';
import * as Yup from 'yup';
import { TextField, CheckboxWithLabel } from 'formik-material-ui';
import { LinearProgress, CssBaseline, Box } from '@material-ui/core';

import {
  logInAsync,
  loginBasic,
  signUpAsync,
  signupBasic,
} from '../app/_store';
import Copyright from '../copyright';

type FormState = 'login' | 'signup';

type LoginFormProps = {
  initState: FormState;
};

const useStyles = makeStyles((theme) => ({
  paper: {
    marginTop: theme.spacing(8),
    display: 'flex',
    flexDirection: 'column',
    alignItems: 'center',
  },
  avatar: {
    margin: theme.spacing(1),
    backgroundColor: theme.palette.primary.main,
  },
  form: {
    width: '100%', // Fix IE 11 issue.
    marginTop: theme.spacing(1),
  },
  submit: {
    margin: theme.spacing(3, 0, 2),
  },
}));

interface FormFields {
  email?: string;
  password?: string;
  rememberMe?: string | boolean;
}

export const LoginForm: React.FC<LoginFormProps> = (props) => {
  const classes = useStyles();
  const dispatch = useDispatch();

  const { initState } = props;
  const [state, setState] = useState<FormState>(initState);

  const switchState = () => setState(state === 'login' ? 'signup' : 'login');

  const schema = Yup.object().shape({
    email: Yup.string().email('Invalid email address').required('Required'),
    password: Yup.string().min(6, 'Password too short').required('Required'),
  });

  const _handleSubmit = async (values: any, actions: any) => {
    try {
      const request = {
        username: values.email,
        password: values.password,
        rememberMe: values.rememberMe,
      };
      // split the two actions up so that we can catch any errors on the first attempt.
      // this is a slow way to do it since we're repeating requests :/
      if (state === 'login') {
        await loginBasic(request);
        await dispatch(logInAsync(request));
      } else {
        await signupBasic(request);
        await dispatch(signUpAsync(request));
      }
    } catch (e) {
      if (e.username) {
        actions.setStatus(e.username);
        return;
      } else if (e.password) {
        actions.setStatus(e.password);
        return;
      }
      actions.setStatus(e);
    }
  };

  return (
    <Container component="main" maxWidth="xs">
      <CssBaseline />
      <div className={classes.paper}>
        <Avatar className={classes.avatar}>
          <LockOutlinedIcon />
        </Avatar>
        <Typography component="h1" variant="h5">
          {state === 'login' ? 'Sign in' : 'Sign up'}
        </Typography>
        <div className={classes.form}>
          <Formik
            initialValues={{
              email: '',
              password: '',
              rememberMe: false,
            }}
            validationSchema={schema}
            onSubmit={_handleSubmit}
          >
            {({ submitForm, isSubmitting, status }) => (
              <Form>
                <Field
                  component={TextField}
                  name="email"
                  type="email"
                  label="Email"
                  margin="normal"
                  variant="outlined"
                  required
                  fullWidth
                />
                <Field
                  component={TextField}
                  name="password"
                  type="password"
                  label="Password"
                  margin="normal"
                  variant="outlined"
                  required
                  fullWidth
                />
                <Field
                  component={CheckboxWithLabel}
                  type="checkbox"
                  name="rememberMe"
                  color="primary"
                  Label={{ label: 'Remember me' }}
                />
                {isSubmitting && <LinearProgress />}
                <Typography variant="body2" color="error">
                  {status ? JSON.stringify(status) : ''}
                </Typography>
                <Button
                  // type="submit"
                  variant="contained"
                  fullWidth
                  className={classes.submit}
                  color="primary"
                  disabled={isSubmitting}
                  onClick={submitForm}
                >
                  {state === 'login' ? 'Sign In' : 'Sign Up'}
                </Button>
              </Form>
            )}
          </Formik>
          <Grid justify="center" container>
            {state === 'login' ? (
              <Grid item xs>
                <Link href="#" variant="body2">
                  Forgot password?
                </Link>
              </Grid>
            ) : (
              <></>
            )}
            <Grid item>
              <Link href="#" onClick={switchState} variant="body2">
                {state === 'login'
                  ? "Don't have an account? Sign Up"
                  : 'Already have an account? Sign In'}
              </Link>
            </Grid>
          </Grid>
        </div>
      </div>
      <Box mt={8}>
        <Copyright />
      </Box>
    </Container>
  );
};

export default LoginForm;
