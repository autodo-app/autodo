import * as React from 'react';
import { useState } from 'react';
import { useSelector } from 'react-redux';
import { Theme, makeStyles, Paper, Input, IconButton } from '@material-ui/core';
import ClearIcon from '@material-ui/icons/Clear';
import SearchIcon from '@material-ui/icons/Search';
import MoreVert from '@material-ui/icons/MoreVert';
import { Button, TextField } from '@material-ui/core';
import { Autocomplete } from '@material-ui/lab';
import Fuse, { FuseResult } from 'fuse.js';

import { grey } from '@material-ui/core/colors';
import classNames from 'classnames';
import { selectAllTodos } from '../_store';

interface StyleProps {
  root: React.CSSProperties;
  paper: React.CSSProperties;
  iconButton: React.CSSProperties;
  iconButtonHidden: React.CSSProperties;
  iconButtonShifted: React.CSSProperties;
  iconButtonDisabled: React.CSSProperties;
  searchIconButton: React.CSSProperties;
  icon: React.CSSProperties;
  input: React.CSSProperties;
  searchContainer: React.CSSProperties;
}

type StyleClasses = Record<keyof StyleProps, string>;

const useStyles = makeStyles<Theme, StyleProps>(
  (theme: Theme) =>
    ({
      root: {
        display: 'flex',
      },
      paper: {
        // height: 48,
        width: '100%',
        display: 'flex',
        justifyContent: 'space-between',
        marginRight: 'auto',
      },
      iconButton: {
        opacity: 0.54,
        transform: 'scale(1, 1)',
        transition: 'transform 200ms cubic-bezier(0.4, 0.0, 0.2, 1)',
      },
      iconButtonHidden: {
        transform: 'scale(0, 0)',
        '& > $icon': {
          opacity: 0,
        },
      },
      iconButtonShifted: {
        transform: 'translateX(-36px)',
        transition: 'transform 200ms cubic-bezier(0.4, 0.0, 0.2, 1)',
      },
      iconButtonDisabled: {
        opacity: 0.38,
      },
      searchIconButton: {
        marginRight: -48,
      },
      icon: {
        opacity: 0.54,
        transition: 'opacity 200ms cubic-bezier(0.4, 0.0, 0.2, 1)',
      },
      input: {
        width: '100%',
      },
      searchContainer: {
        margin: 'auto 16px',
        width: 'calc(100% - 48px - 32px)', // 48px button + 32px margin
      },
    } as any),
);

export const SearchBar: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const [state, setState] = useState({
    value: '',
    suggestions: Array<FuseResult>(),
  });
  const list = useSelector(selectAllTodos);
  const options = {
    minMatchCarLength: 2,
    keys: ['name'],
  };
  const fuse = new Fuse(list, options);

  const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {};

  const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
    if (state.value.trim().length === 0) {
      setState({ value: '', suggestions: [] });
    }
  };

  const handleInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    if (e.target.value.length < 1) {
      setState({ value: e.target.value, suggestions: Array<FuseResult>() });
    } else {
      const res = fuse.search(e.target.value);
      setState({ value: e.target.value, suggestions: res });
    }
  };

  const handleCancel = () => {
    setState({ value: '', suggestions: [] });
  };

  const handleKeyUp = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.charCode === 13 || e.key === 'Enter') {
      handleRequestSearch();
    } else if (e.charCode === 27 || e.key === 'Escape') {
      handleCancel();
    }
  };

  const handleRequestSearch = () => {
    console.log();
  };

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
        <div className={classes.searchContainer}>
          <Autocomplete
            freeSolo
            onBlur={handleBlur}
            value={state.value}
            onInputChange={handleInput}
            onKeyUp={handleKeyUp}
            onFocus={handleFocus}
            fullWidth
            className={classes.input}
            disableClearable
            options={state.suggestions.map(
              (option) => `${option.item.name} (${option.item.dueMileage} mi)`,
            )}
            renderInput={(params: any) => (
              <TextField
                {...params}
                className={classes.input}
                placeholder="Looking for..."
                fullWidth
                margin="none"
                InputProps={{
                  ...params.InputProps,
                  disableUnderline: true,
                  type: 'search',
                }}
              />
            )}
          />
        </div>
        <IconButton
          onClick={handleRequestSearch}
          classes={{
            root: classNames(classes.iconButton, classes.searchIconButton, {
              [classes.iconButtonShifted]: state.value !== '',
            }),
          }}
        >
          <SearchIcon style={{ color: grey[500] }} className={classes.icon} />
        </IconButton>
        <IconButton
          onClick={handleCancel}
          classes={{
            root: classNames(classes.iconButton, {
              [classes.iconButtonHidden]: state.value === '',
            }),
          }}
        >
          <ClearIcon style={{ color: grey[500] }} className={classes.icon} />
        </IconButton>
      </Paper>
      <IconButton>
        <MoreVert />
      </IconButton>
      <Button color="primary">Upgrade!</Button>
    </div>
  );
};

export default SearchBar;
