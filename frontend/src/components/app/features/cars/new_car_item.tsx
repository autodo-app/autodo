import * as React from 'react';
import { useState } from 'react';
import {
  Theme,
  makeStyles,
  GridListTile,
  Card,
  Typography,
  CardActionArea,
} from '@material-ui/core';
import AddIcon from '@material-ui/icons/Add';

import { GRAY } from '../../../theme';
import CarAddEditForm from './add_edit_form';

interface StyleProps {
  root: React.CSSProperties;
  actionArea: React.CSSProperties;
  content: React.CSSProperties;
}

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        backgroundColor: 'rgba(0, 0, 0, 0)',
        borderStyle: 'dashed',
        borderColor: GRAY,
        width: 250,
        height: 340,
        marginTop: '3rem',
        marginBottom: '3rem',
        marginLeft: '0',
        marginRight: '2rem',
      },
      actionArea: {
        height: '100%',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        flexDirection: 'column',
      },
      content: {
        color: GRAY,
      },
    } as any),
);

export const NewCarItem = () => {
  const classes = useStyles({} as StyleProps);

  const [open, setOpen] = useState(false);
  const onClick = () => setOpen(true);
  const handleClose = () => setOpen(false);

  return (
    <>
      <GridListTile className={classes.tile}>
        <Card className={classes.root}>
          <CardActionArea className={classes.actionArea} onClick={onClick}>
            <AddIcon fontSize="large" className={classes.content} />
            <Typography variant="h5" className={classes.content}>
              ADD CAR
            </Typography>
          </CardActionArea>
        </Card>
      </GridListTile>
      <CarAddEditForm open={open} handleClose={handleClose} />
    </>
  );
};
