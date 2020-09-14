import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';

interface StyleProps {
  footer: React.CSSProperties;
  footerBelt: React.CSSProperties;
  companySign: React.CSSProperties;
  socialMedia: React.CSSProperties;
  socialTwitter: React.CSSProperties;
  socialInstagram: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      footer: {
        backgroundColor: theme.typography.body1.color,
      },
      footerBelt: {
        display: 'flex',
        height: '6vh',
        justifyContent: 'space-between',
        alignItems: 'center',
        padding: '0 1em',
        maxWidth: '90%',
        margin: '0 auto',
      },
      companySign: {
        textTransform: 'uppercase',
        fontSize: '1.25rem',
        fontWeight: 700,
        color: '#fff',
      },
      socialMedia: {
        display: 'flex',
        justifyContent: 'space-around',
        minWidth: '6rem',
        [theme.breakpoints.up('sm')]: {
          minWidth: '10rem',
        },
      },
    } as any),
);

export interface FooterProps {
  siteTitle: string;
}
const Footer: React.FC<FooterProps> = (props) => {
  const classes = useStyles({} as StyleProps);
  const { siteTitle } = props;

  return (
    <footer className={classes.footer}>
      <div className={classes.footerBelt}>
        <div className={classes.companySign}>&copy; 2020 {siteTitle}</div>
        <div className={classes.socialMedia}>
          <a href="https://www.twitter.com/auToDoApp">
            <div className={classes.socialTwitter}>Twitter</div>
          </a>
          <a href="https://www.instagram.com">
            <div className={classes.socialInstagram}>Instagram</div>
          </a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
