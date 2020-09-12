import * as React from 'react';

export interface ButtonProps {
  label: string;
}
const Button: React.FC<ButtonProps> = (props) => {
  const { label } = props;
  return <button className="button">{label}</button>;
};

export default Button;
