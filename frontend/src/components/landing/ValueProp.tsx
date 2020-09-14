import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';

import Button from './Button';
// @ts-ignore
import Header from '../../assets/header-image.png';
// @ts-ignore
import MainPhoto from '../../assets/undraw/undraw_task_list_6x9d.svg';

interface StyleProps {
  valueProp: React.CSSProperties;
  valuePropContent: React.CSSProperties;
  mainMessage: React.CSSProperties;
  mainSubtitle: React.CSSProperties;
  mainPhoto: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      valueProp: {
        backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url(${Header})`,
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'top',
        backgroundSize: 'cover',
        width: '100%',
        display: 'inline-block',
      },
      valuePropContent: {
        height: '80vh',
        display: 'grid',
        gridTemplateColumns: 'repeat(8, 1fr)',
        gridTemplateRows: 'repeat(8, 1fr)',
        rowGap: '0.25rem',
        marginBottom: '2em',
        padding: '2em',
        maxWidth: '75rem',
        margin: '0 auto',
        [theme.breakpoints.up('sm')]: {
          height: '50vh',
          margin: '2rem auto 3rem auto',
        },
      },
      mainMessage: {
        gridColumn: 'span 8',
        gridRow: 'span 5',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        textAlign: 'center',
        '& p': {
          marginTop: 0,
        },
        '& h1': {
          color: '#fff',
        },
        [theme.breakpoints.up('sm')]: {
          gridColumn: 'span 4',
          gridRow: 'span 8',
          alignItems: 'flex-start',
          textAlign: 'left',
          '& button': {
            margin: 0,
          },
        },
      },
      mainSubtitle: {
        color: '#fff',
        fontSize: '1.5rem',
        fontWeight: 500,
      },
      mainPhoto: {
        gridColumn: 'span 8',
        gridRow: 'span 3',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignItems: 'center',
        background: `url(${MainPhoto}) no-repeat top`,
        backgroundSize: '100% 100%',
        height: '100%',
        padding: '0',
        width: '100%',
        maxWidth: '50rem',
        margin: '0 auto',
        [theme.breakpoints.up('sm')]: {
          gridColumn: 'span 4',
          gridRow: 'span 8',
        },
      },
    } as any),
);

const ValueProp: React.FC = (): JSX.Element => {
  const classes = useStyles({} as StyleProps);
  return (
    <section className={classes.valueProp}>
      <div className={classes.valuePropContent}>
        <div className={classes.mainMessage}>
          <h1>Car Maintenance Tracking. Simplified.</h1>
          <p className={classes.mainSubtitle}>
            Keep track of ToDos, Mileage, Expenses and more wherever you go.
          </p>
          <Button label="Get Started" />
        </div>
        <div className={classes.mainPhoto}></div>
      </div>
    </section>
  );
};

export default ValueProp;
