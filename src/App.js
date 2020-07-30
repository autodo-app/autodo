import React from 'react';
import { Route, BrowserRouter } from 'react-router-dom';

import logo from './logo.svg';
import { Counter } from './features/counter/Counter';
import './App.css';
import { LoginPage } from './login';
import { DataPage } from './home';
import { TodosList } from './features/todos/todos_list';
import { AddTodoForm } from './features/todos/add_todo_form';
import { EditTodoForm } from './features/todos/edit_todo_form';
import { RouteListener } from './_helpers/alert_container';
import Dashboard from './home/dashboard';

function App() {
  return (
    <BrowserRouter>
      <RouteListener />
      {/* <Route exact path="/" component={TodosList} /> */}
      <Route exact path="/" component={Dashboard} />
      <Route exact path="/todos/new" component={AddTodoForm} />
      <Route exact path="/editTodo/:todoId" component={EditTodoForm} />
      <Route exact path="/login" component={LoginPage} />
      <Route exact path="/data" component={DataPage} />
    </BrowserRouter>
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
