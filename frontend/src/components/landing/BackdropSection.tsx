import * as React from 'react';

export interface BackDropProps {
  activeClass: string;
  click: any;
}
const BackDrop: React.FC<BackDropProps> = (props) => {
  const { activeClass, click } = props;
  return <div className={activeClass} onClick={click}></div>;
};

export default BackDrop;
