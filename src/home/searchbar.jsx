import React, { useState } from 'react';
// import OutlinedInput from '@material-ui/core/OutlinedInput';
import ClearIcon from '@material-ui/icons/Clear';
import SearchIcon from '@material-ui/icons/Search';
import { makeStyles, Paper, Input, IconButton } from '@material-ui/core';
import { grey } from '@material-ui/core/colors';
import classNames from 'classnames';

const useStyles = makeStyles((theme) => ({
  root: {
    height: 48,
    display: 'flex',
    justifyContent: 'space-between',
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
}));

export const SearchBar = () => {
  const classes = useStyles();
  const [value, setValue] = useState('');
  const [focus, setFocus] = useState(false);
  const [active, setActive] = useState(false);

  const handleFocus = (e) => {
    setFocus(true);
  };

  const handleBlur = (e) => {
    setFocus(false);
    if (value.trim().length === 0) {
      setValue('');
    }
    // any specific blurring logic here
  };

  const handleInput = (e) => {
    setValue(e.target.value);
  };

  const handleCancel = () => {
    setActive(false);
    setValue('');
  };

  const handleKeyUp = (e) => {
    if (e.charCode === 13 || e.key === 'Enter') {
      handleRequestSearch();
    } else if (e.charCode === 27 || e.key === 'Escape') {
      handleCancel();
    }
  };

  const handleRequestSearch = () => {
    // if (this.props.onRequestSearch) {
    //   this.props.onRequestSearch(this.state.value);
    // }
  };

  return (
    <Paper className={classes.root}>
      <div className={classes.searchContainer}>
        <Input
          placeholder="Looking for..."
          onBlur={handleBlur}
          value={value}
          onChange={handleInput}
          onKeyUp={handleKeyUp}
          onFocus={handleFocus}
          fullWidth
          disableUnderline
          className={classes.input}
        />
      </div>
      <IconButton
        onClick={handleRequestSearch}
        classes={{
          root: classNames(classes.iconButton, classes.searchIconButton, {
            [classes.iconButtonShifted]: value !== '',
          }),
        }}
      >
        <SearchIcon style={{ color: grey[500] }} classes={classes.icon} />
      </IconButton>
      <IconButton
        onClick={handleCancel}
        classes={{
          root: classNames(classes.iconButton, {
            [classes.iconButtonHidden]: value === '',
          }),
        }}
      >
        <ClearIcon style={{ color: grey[500] }} classes={classes.icon} />
      </IconButton>
    </Paper>
  );
};

export default SearchBar;
