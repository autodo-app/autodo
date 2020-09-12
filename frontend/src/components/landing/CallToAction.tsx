import * as React from 'react';
import Button from './Button';

const CallToAction = (props: any) => {
  return (
    <section className="cta">
      <h1>Start Keeping Track of Your Car.</h1>
      <p>
        Create an account online instantly or download the auToDo mobile app for
        your phone.
      </p>
      <Button label="Get Started" />
      <div className="download-buttons">
        <div className="play-store" />
        <div className="app-store" />
      </div>
    </section>
  );
};

export default CallToAction;
