import * as React from 'react';
import { useState, useEffect } from 'react';
import { useSelector } from 'react-redux';
import Avatar from '@material-ui/core/Avatar';
import Button from '@material-ui/core/Button';
import Link from '@material-ui/core/Link';
import Grid from '@material-ui/core/Grid';
import LockOutlinedIcon from '@material-ui/icons/LockOutlined';
import Typography from '@material-ui/core/Typography';
import { makeStyles } from '@material-ui/core/styles';
import Container from '@material-ui/core/Container';

import { Formik, Form, Field, useFormikContext } from 'formik';
import { TextField, CheckboxWithLabel } from 'formik-material-ui';
import { LinearProgress, CssBaseline, Box } from '@material-ui/core';

import { RootState } from '../app/store';
import { AuthRequest } from '../app/_models';
import Copyright from '../copyright';

type FormState = 'login' | 'signup';

type LoginFormProps = {
  handle_login: (data: AuthRequest) => Promise<any>;
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

const ErrorCatcher = () => {
  const authStatus = useSelector((state: RootState) => state.auth.status);
  const authError = useSelector((state: RootState) => state.auth.error);
  const { setStatus } = useFormikContext();

  useEffect(() => {
    console.log(authStatus);
    console.log('t');
    if (authStatus === 'failed') {
      setStatus(authError);
    }
  }, [authStatus, authError, setStatus]);

  return null;
};

export const LoginForm: React.FC<LoginFormProps> = (props) => {
  const classes = useStyles();

  const { handle_login, initState } = props;
  const [state, setState] = useState<FormState>(initState);

  const switchState = () => setState(state === 'login' ? 'signup' : 'login');

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
            validate={(values) => {
              const errors: FormFields = {};

              if (!values.email) {
                errors.email = 'Required';
              } else if (
                !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i.test(values.email)
              ) {
                errors.email = 'Invalid email address';
              }

              if (!values.password) {
                errors.password = 'Required';
              } else if (values.password.length < 6) {
                errors.password = 'Password too short';
              }

              return errors;
            }}
            onSubmit={async (values, { setSubmitting }) => {
              await handle_login({
                username: values.email,
                password: values.password,
                rememberMe: values.rememberMe,
              });
              setSubmitting(false);
            }}
          >
            {({ submitForm, isSubmitting }) => (
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
                <ErrorCatcher />
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
