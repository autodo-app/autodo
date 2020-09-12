import * as React from 'react';
import Button from './Button';

interface ValueProps {}

const ValueProp: React.FC<ValueProps> = (props): JSX.Element => {
  return (
    <section className="value-prop">
      <div className="value-prop-content">
        <div className="main-message">
          <h1>Here is our amazing product</h1>
          <p className="main-subtitle">
            Please buy our amazing product. You&apos;re gonna love it. Promise.
          </p>
          <Button label="Get Started" />
        </div>
        <div className="main-photo"></div>
      </div>
    </section>
  );
};

export default ValueProp;
