import * as React from 'react';
import { useState } from 'react';
import { useSelector } from 'react-redux';
import {
  Theme,
  makeStyles,
  Paper,
  Button,
  IconButton,
  TextField,
} from '@material-ui/core';
import ClearIcon from '@material-ui/icons/Clear';
import SearchIcon from '@material-ui/icons/Search';
import MoreVert from '@material-ui/icons/MoreVert';
import { Autocomplete } from '@material-ui/lab';
import Fuse from 'fuse.js';

import { grey } from '@material-ui/core/colors';
import classNames from 'classnames';
import { Todo } from '../_models';
import { selectAllTodos } from '../_store';
import TodoAddEditForm from '../features/todos/add_edit_form';

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
  optionButton: React.CSSProperties;
  option: React.CSSProperties;
  optionLabel: React.CSSProperties;
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
      optionButton: {
        width: '100%',
        margin: 0,
        padding: theme.spacing(1.5),
      },
      option: {
        padding: 0,
      },
      optionLabel: {
        paddingLeft: theme.spacing(1),
        paddingRight: theme.spacing(1),
        textTransform: 'none',
        flexDirection: 'row',
        alignItems: 'flex-start',
        justifyContent: 'flex-start',
      },
    } as any),
);

interface SearchbarState {
  value: string;
  suggestions: Array<Fuse.FuseResult<Todo>>;
}

interface AddEditState {
  open: boolean;
  todo?: Todo;
}

export const SearchBar: React.FC<{}> = (): JSX.Element => {
  const classes: StyleClasses = useStyles({} as StyleProps);
  const [state, setState] = useState<SearchbarState>({
    value: '',
    suggestions: [],
  });
  const [addEditState, setAddEditState] = useState<AddEditState>({
    open: false,
  });

  const list = useSelector(selectAllTodos);
  const options = {
    minMatchCarLength: 2,
    threshold: 0.3,
    keys: ['name'],
  };
  const fuse = new Fuse(list, options);

  const handleFocus = (e: React.FocusEvent<HTMLInputElement>) => {};

  const handleBlur = (e: React.FocusEvent<HTMLInputElement>) => {
    setState({ value: '', suggestions: [] });
  };

  const handleInput = (
    e: React.ChangeEvent<HTMLInputElement>,
    value: string,
  ) => {
    if (value.length < 1) {
      setState({
        value: value ?? '',
        suggestions: [],
      });
    } else {
      setState({
        value: value ?? '',
        suggestions: fuse.search(value),
      });
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

  const handleRequestSearch = () => {};

  const handleClickOpen = (option: string, e: any) => {
    const todo = list.find((t) => t.id === parseInt(option.split('/')[1]));
    setAddEditState({
      open: true,
      todo: todo,
    });
    setState({ value: '', suggestions: [] });
  };

  const handleClose = () => {
    setAddEditState({ open: false });
  };

  return (
    <div className={classes.root}>
      <Paper className={classes.paper}>
        <div className={classes.searchContainer}>
          <Autocomplete
            freeSolo
            clearOnBlur
            onBlur={handleBlur}
            value={state.value}
            onInputChange={handleInput}
            onKeyUp={handleKeyUp}
            onFocus={handleFocus}
            fullWidth
            disableClearable
            classes={{
              root: classes.input,
              option: classes.option,
            }}
            options={state.suggestions
              .slice(0, 5)
              .map(
                (option) =>
                  `${option.item.name} (${option.item.dueMileage} mi)/${option.item.id}`,
              )}
            renderOption={(option, { selected }) => {
              return (
                <Button
                  classes={{
                    root: classes.optionButton,
                    label: classes.optionLabel,
                  }}
                  onClick={(e) => handleClickOpen(option, e)}
                >
                  {option.split('/')[0]}
                </Button>
              );
            }}
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
              [classes.iconButtonHidden]: state.value !== '',
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
      <TodoAddEditForm
        todo={addEditState.todo}
        open={addEditState.open}
        handleClose={handleClose}
      />
    </div>
  );
};

export default SearchBar;
