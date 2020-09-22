import * as React from 'react';
import { makeStyles, Theme } from '@material-ui/core';

import { CarList } from '../cars';

interface StyleProps {
  root: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>((theme: Theme) => ({} as any));

export const GaragePage = () => {
  const styles = useStyles({} as StyleProps);

  return <CarList />;
};
