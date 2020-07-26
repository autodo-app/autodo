import React from 'react'
import {
  BrowserRouter as Router,
  Switch,
  Route,
  Redirect
} from 'react-router-dom'

import { Navbar } from './app/navbar'

import { TodosList } from './features/todos/todos_list'
import { AddTodoForm } from './features/todos/add_todo_form'
import { SingleTodoPage } from './features/todos/todo'
import { EditTodoForm } from './features/todos/edit_todo_form'

function App() {
  return (
    <Router>
      <Navbar />
      <div className="App">
        <Switch>
          <Route
            exact
            path="/"
            render={() => (
              <React.Fragment>
                <AddTodoForm />
                <TodosList />
              </React.Fragment>
            )}
          />
          <Route exact path="/todos/:todoId" component={SingleTodoPage} />
          <Route
            key="edit"
            path="/editTodo/:todoId" 
            component={EditTodoForm} />
          <Redirect to="/" />
        </Switch>
      </div>
    </Router>
  )
}

export default App