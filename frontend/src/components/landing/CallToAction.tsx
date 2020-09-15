import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';

// @ts-ignore
import PlayStoreImage from '../../assets/playstore.png';
// @ts-ignore
import AppStoreImage from '../../assets/appstore.png';
import Button from './Button';

interface StyleProps {
  cta: React.CSSProperties;
  downloadButtons: React.CSSProperties;
  playStore: React.CSSProperties;
  appStore: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      cta: {
        color: theme.palette.primary.contrastText,
        backgroundColor: '#fff',
        display: 'flex',
        flexDirection: 'column',
        justifyContent: 'center',
        alignContent: 'center',
        flexWrap: 'wrap',
        textAlign: 'center',
        margin: '0 auto',
        padding: '1em',
        maxWidth: '50vw',
        '& p': {
          fontSize: '1.5rem',
          fontWeight: '500',
        },
      },
      downloadButtons: {
        margin: '1.5rem',
        display: 'flex',
        flexWrap: 'wrap',
        justifyContent: 'center',
      },
      playStore: {
        background: `url(${PlayStoreImage}) no-repeat center`,
        backgroundSize: 'contain',
        flex: '0 0 calc(50% - 1rem)',
        height: '50px',
        margin: 'auto 0.5rem',
      },
      appStore: {
        background: `url(${AppStoreImage}) no-repeat center`,
        backgroundSize: 'contain',
        flex: '0 0 calc(50% - 1rem)',
        height: '50px',
        margin: 'auto 0.5rem',
      },
    } as any),
);

const CallToAction = (props: any) => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  return (
    <section className={classes.cta}>
      <h1>Start Keeping Track of Your Car.</h1>
      <p>
        Create an account online instantly or download the auToDo mobile app for
        your phone.
      </p>
      <Button label="Get Started" />
      <div className={classes.downloadButtons}>
        <div className={classes.playStore} />
        <div className={classes.appStore} />
      </div>
    </section>
  );
};

export default CallToAction;
