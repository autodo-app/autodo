import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core';

interface StyleProps {
  button: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      button: {
        margin: '1.5em',
        padding: '0.75em 1.25em',
        backgroundColor: theme.palette.primary.main,
        color: theme.typography.subtitle2.color,
        borderRadius: '1.5rem',
        border: '0',
        fontSize: '1.25rem',
        fontWeight: '700',
        cursor: 'pointer',
      },
    } as any),
);

export interface ButtonProps {
  label: string;
}
const Button: React.FC<ButtonProps> = (props) => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const { label } = props;

  return <button className={classes.button}>{label}</button>;
};

export default Button;
