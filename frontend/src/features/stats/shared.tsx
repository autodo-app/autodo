import * as React from 'react';
import { Theme, makeStyles } from '@material-ui/core/styles';
import { Typography } from '@material-ui/core';

export interface TitleProps {
  children: string;
}

export const Title = (props: TitleProps): JSX.Element => (
  <Typography
    component="h2"
    variant="h6"
    color="primary"
    align="center"
    gutterBottom
  >
    {props.children}
  </Typography>
);

export interface StyleProps {
  fixedHeight: React.CSSProperties;
  paper: React.CSSProperties;
  labelText: React.CSSProperties;
}

export type StyleClasses = Record<keyof StyleProps, string>;

export const useBaseStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      paper: {
        padding: theme.spacing(2),
        display: 'flex',
        overflow: 'auto',
        flexDirection: 'column',
      },
      fixedHeight: {
        height: 344, // 80 + 240 + theme.spacing(3)
      },
      labelText: {
        fill: theme.palette.text.primary,
        textAnchor: 'middle',
      },
    } as any),
);
