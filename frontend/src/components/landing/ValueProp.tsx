import * as React from 'react';
import Button from './Button';

interface ValueProps {}

const ValueProp: React.FC<ValueProps> = (props): JSX.Element => {
  return (
    <section className="value-prop">
      <div className="value-prop-content">
        <div className="main-message">
          <h1>Car Maintenance Tracking. Simplified.</h1>
          <p className="main-subtitle">
            Keep track of ToDos, Mileage, Expenses and more wherever you go.
          </p>
          <Button label="Get Started" />
        </div>
        <div className="main-photo"></div>
      </div>
    </section>
  );
};

export default ValueProp;
