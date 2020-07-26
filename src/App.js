import React, { useEffect } from 'react';
import { Router, Route } from 'react-router-dom';
import { useDispatch } from 'react-redux';

import logo from './logo.svg';
import { Counter } from './features/counter/Counter';
import './App.css';
import { history } from './_helpers';
import { LoginPage } from './login';
import { alertClear } from './_slices';

function App() {
  const dispatch = useDispatch();

  useEffect(() => {
    history.listen((location, action) => {
      dispatch(alertClear());
    });
  });

  return (
    <Router history={history}>
      <div>
        <Route exact path="/" component={homePage} />
        <Route path="/login" component={LoginPage} />
      </div>
    </Router>
  );
}

function homePage() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <Counter />
        <p>
          Edit <code>src/App.js</code> and save to reload.
        </p>
        <span>
          <span>Learn </span>
          <a
            className="App-link"
            href="https://reactjs.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            React
          </a>
          <span>, </span>
          <a
            className="App-link"
            href="https://redux.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            Redux
          </a>
          <span>, </span>
          <a
            className="App-link"
            href="https://redux-toolkit.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            Redux Toolkit
          </a>
          ,<span> and </span>
          <a
            className="App-link"
            href="https://react-redux.js.org/"
            target="_blank"
            rel="noopener noreferrer"
          >
            React Redux
          </a>
        </span>
      </header>
    </div>
  );
}

export default App;
