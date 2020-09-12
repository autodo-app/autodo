import * as React from 'react';

export interface FooterProps {
  siteTitle: string;
}
const Footer: React.FC<FooterProps> = (props) => {
  const { siteTitle } = props;
  return (
    <footer className="footer">
      <div className="footer-belt">
        <div className="company-sign">&copy; 2020 {siteTitle}</div>
        <div className="social-media">
          <a href="https://www.twitter.com/auToDoApp">
            <div className="social-twitter">Twitter</div>
          </a>
          <a href="https://www.instagram.com">
            <div className="social-instagram">Instagram</div>
          </a>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
