import * as React from 'react';
import { useStaticQuery, graphql } from 'gatsby';

import Header from './Header';
import Footer from './Footer';
import '../../styles/index.scss';

export interface LayoutProps {
  children: any;
}
const Layout: React.FC<LayoutProps> = (props) => {
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
      <div className="container">
        <main className="container-main">{children}</main>
        <Footer siteTitle={data.site.siteMetadata.title} />
      </div>
    </>
  );
};

export default Layout;
