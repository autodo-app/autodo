import * as React from 'react';
import { useStaticQuery, graphql } from 'gatsby';
import { Theme, makeStyles } from '@material-ui/core';

import Header from './Header';
import Footer from './Footer';
import '../../styles/index.scss';

interface StyleProps {
  container: React.CSSProperties;
  containerMain: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      container: {
        backgroundColor: '#fff',
        height: '100%',
        position: 'absolute',
        left: 0,
        right: 0,
      },
      containerMain: {
        backgroundColor: 'inherit',
        margin: '0 auto',
        [theme.breakpoints.down('sm')]: {
          margin: '8vh 0 0 0',
        },
      },
    } as any),
);

export interface LayoutProps {
  children: any;
}
const Layout: React.FC<LayoutProps> = (props) => {
  const classes = useStyles({} as StyleProps);
  const { children } = props;
  const data = useStaticQuery(graphql`
    query SiteTitleQuery {
      site {
        siteMetadata {
          title
        }
      }
    }
  `);

  return (
    <>
      <Header siteTitle={data.site.siteMetadata.title} />
      <div className={classes.container}>
        <main className={classes.containerMain}>{children}</main>
        <Footer siteTitle={data.site.siteMetadata.title} />
      </div>
    </>
  );
};

export default Layout;
