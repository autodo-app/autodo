import { Link } from 'gatsby';
import * as React from 'react';
import { useState } from 'react';
import { Theme, makeStyles } from '@material-ui/core';
import clsx from 'clsx';

// @ts-ignore
import Icon from '../../assets/icon-green.svg';
import Backdrop from './BackdropSection';

interface StyleProps {
  navbar: React.CSSProperties;
  navBelt: React.CSSProperties;
  logo: React.CSSProperties;
  logoImage: React.CSSProperties;
  navLinks: React.CSSProperties;
  navItemBold: React.CSSProperties;
  burger: React.CSSProperties;
  backdrop: React.CSSProperties;
  backdropActive: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      navbar: {
        zIndex: 200,
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        backgroundColor: '#fff',
      },
      navBelt: {
        display: 'flex',
        justifyContent: 'space-between',
        alignItems: 'center',
        minHeight: '8vh',
        width: '100%',
        maxWidth: '75rem',
        margin: '0 auto',
        padding: '0 1em',
      },
      logo: {
        color: theme.palette.primary.contrastText,
        letterSpacing: '0.2rem',
        fontSize: '1.5rem',
        textTransform: 'uppercase',
        textDecoration: 'none',
        display: 'flex',
        justifyContent: 'center',
        alignItems: 'center',
      },
      logoImage: {
        width: '4rem',
        height: '2rem',
        background: `url(${Icon}) no-repeat center`,
        backgroundSize: '100% 100%',
      },
      navLinks: {
        display: 'flex',
        justifyContent: 'space-around',
        alignItems: 'center',
        maxHeight: '50vh',
        margin: 0,
        width: '40%',
        '& a': {
          textDecoration: 'none',
          letterSpacing: '0.1rem',
          fontSize: '0.9rem',
          fontWeight: 700,
          color: theme.palette.primary.contrastText,
        },
        '& li': {
          listStyle: 'none',
        },
        [theme.breakpoints.down('sm')]: {
          position: 'absolute',
          top: '8vh',
          right: 0,
          height: '92vh',
          backgroundColor: '#fff',
          display: 'flex',
          flexDirection: 'column',
          alignItems: 'center',
          width: '50%',
          transform: 'translateX(100%)',
          transition: 'transform 300ms ease-in',
          '& li': {
            opacity: 0,
          },
        },
      },
      navItemBold: {
        border: 'solid',
        borderColor: theme.palette.primary.dark,
        borderRadius: '1.5rem',
        padding: '0.25em 0.75em',
        '& a': {
          color: theme.palette.primary.dark,
        },
        '&:hover': {
          backgroundColor: theme.palette.primary.dark,
          '& a': {
            color: '#fff',
          },
        },
        [theme.breakpoints.down('sm')]: {
          border: 'none',
          padding: 0,
          '& a': {
            color: theme.palette.primary.contrastText,
          },
          '&:hover': {
            backgroundColor: '#fff',
            '& a': {
              color: theme.palette.primary.contrastText,
            },
          },
        },
      },
      burger: {
        display: 'none',
        [theme.breakpoints.down('sm')]: {
          display: 'block',
          cursor: 'pointer',
          '& div': {
            width: '1.25rem',
            height: '0.15rem',
            backgroundColor: '#333',
            margin: '0.3rem',
          },
        },
      },
      backdrop: {
        [theme.breakpoints.down('sm')]: {
          position: 'absolute',
          height: '100%',
          width: '100%',
          backgroundColor: 'rgba(0, 0, 0, 0.3)',
          zIndex: -100,
          display: 'none',
          top: 0,
          left: 0,
          right: 0,
        },
      },
      backdropActive: {
        [theme.breakpoints.down('sm')]: {
          zIndex: 100,
          display: 'block',
        },
      },
      navActive: {
        [theme.breakpoints.down('sm')]: {
          transform: 'translateX(0%)',
        },
      },
      '@keyframes navLinkFade': {
        from: {
          opacity: 0,
          transform: 'translateX(2.5rem)',
        },
        to: {
          opacity: 1,
          transform: 'translateX(0rem)',
        },
      },
      navLinkItemActive: {
        [theme.breakpoints.down('sm')]: {
          animation: 'navLinkFade 300ms ease forwards 300ms',
        },
      },
      burgerLine1Toggled: {
        transform: 'rotate(-45deg) translate(-0.6rem, 0px)',
      },
      burgerLine2Toggled: {
        opacity: 0,
      },
      burgerLine3Toggled: {
        transform: 'rotate(45deg) translate(-0.6rem, 0px)',
      },
    } as any),
);

export interface HeaderProps {
  siteTitle: string;
}
const Header: React.FC<HeaderProps> = (props) => {
  const classes = useStyles({} as StyleProps);
  const { siteTitle } = props;
  const [isOpen, setIsOpen] = useState(false);
  const toggle = () => setIsOpen(!isOpen);

  let navClasses = classes.navLinks;
  let navItemClasses = classes.navLinkItem;
  let burgerClass = classes.burger;
  let backdropClass = classes.backdrop;
  let burgerLine1 = '';
  let burgerLine2 = '';
  let burgerLine3 = '';
  if (isOpen) {
    navClasses = clsx(classes.navLinks, classes.navActive);
    navItemClasses = classes.navLinkItemActive;
    burgerClass = clsx(classes.burger, classes.toggle);
    backdropClass = clsx(classes.backdrop, classes.backdropActive);
    burgerLine1 = classes.burgerLine1Toggled;
    burgerLine2 = classes.burgerLine2Toggled;
    burgerLine3 = classes.burgerLine3Toggled;
  }
  const navItemBold = clsx(navItemClasses, classes.navItemBold);

  return (
    <header>
      <Backdrop activeClass={backdropClass} click={toggle} />
      <nav className={classes.navbar}>
        <div className={classes.navBelt}>
          <div>
            <h4>
              <Link className={classes.logo} to="/">
                <div className={classes.logoImage}></div>
                {siteTitle}
              </Link>
            </h4>
          </div>
          <ul className={navClasses}>
            <li className={navItemClasses}>
              <a href="#about">About</a>
            </li>
            <li className={navItemClasses}>
              <a href="blog">Blog</a>
            </li>
            <li className={navItemClasses}>
              <a href="login">Login</a>
            </li>
            <li className={navItemBold}>
              <a href="signup">Sign Up</a>
            </li>
          </ul>
          <div className={burgerClass} onClick={toggle}>
            <div className={burgerLine1}></div>
            <div className={burgerLine2}></div>
            <div className={burgerLine3}></div>
          </div>
        </div>
      </nav>
    </header>
  );
};

export default Header;
