import React from 'react';
import './App.css';

class Header extends React.Component {
  render() {
    return (
      <header className="App-header">
          <h1>auToDo</h1>
      </header>
    )
  }
}

class TodoCategoryRow extends React.Component {
  render() {
    const category = this.props.category;
    return (
      <tr>
        <th colSpan="2">
          {category}
        </th>
      </tr>
    );
  }
}

class TodoRow extends React.Component {
  render() {
    const todo = this.props.todo;
    const name = todo.name;
    return (
      <tr>
        <td>{name}</td>
        <td>{todo.price}</td>
      </tr>
    );
  }
}

class Todos extends React.Component {
  render() {
    const filterText = this.props.filterText;
    const inStockOnly = this.props.inStockOnly;
    const rows = [];
    let lastCategory = null;

    this.props.todos.forEach((t) => {
      if ((t.name.indexOf(filterText) === -1) || 
          (inStockOnly && !t.stocked)) {
        return;
      }
      if (t.category !== lastCategory) {
        rows.push( 
          <TodoCategoryRow category={t.category} key={t.category} />
        );
      }
      rows.push(  
        <TodoRow todo={t} key={t.name} />
      );
      lastCategory = t.category;
    });

    return (
      <table>
        <thead></thead>
        <tbody>{rows}</tbody>
      </table>
    );
  }
}

class SearchBar extends React.Component {
  constructor(props) {
    super(props);
    this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
    this.handleInStockChange = this.handleInStockChange.bind(this);
  }

  handleFilterTextChange(e) {
    this.props.onFilterTextChange(e.target.value);
  }

  handleInStockChange(e) {
    this.props.onInStockChange(e.target.checked);
  }

  render() {
    const filterText = this.props.filterText;
    const inStockOnly = this.props.inStockOnly;

    return (
      <form>
        <input
          type="text"
          placeholder="Search..."
          value={filterText} 
          onChange={this.handleFilterTextChange}
        />
        <p>
          <input
            type="checkbox"
            checked={inStockOnly} 
            onChange={this.handleInStockChange}  
          />
          {' '}
          Only show products in stock
        </p>
      </form>
    );
  }
}

const PRODUCTS = [
  {category: 'Sporting Goods', price: '$49.99', stocked: true, name: 'Football'},
  {category: 'Sporting Goods', price: '$9.99', stocked: true, name: 'Baseball'},
  {category: 'Sporting Goods', price: '$29.99', stocked: false, name: 'Basketball'},
  {category: 'Electronics', price: '$99.99', stocked: true, name: 'iPod Touch'},
  {category: 'Electronics', price: '$399.99', stocked: false, name: 'iPhone 5'},
  {category: 'Electronics', price: '$199.99', stocked: true, name: 'Nexus 7'}
];

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      filterText: '',
      inStockOnly: false
    };

    this.handleFilterTextChange = this.handleFilterTextChange.bind(this);
    this.handleInStockChange = this.handleInStockChange.bind(this);
  }

  handleFilterTextChange(filterText) {
    this.setState({
      filterText: filterText
    });
  }
  
  handleInStockChange(inStockOnly) {
    this.setState({
      inStockOnly: inStockOnly
    })
  }

  render() {
    return (
      <div className="App">
          <Header />
          <SearchBar 
            filterText={this.state.filterText}
            inStockOnly={this.state.inStockOnly}
            onFilterTextChange={this.handleFilterTextChange}
            onInStockChange={this.handleInStockChange}
          />
          <Todos 
            todos={PRODUCTS}
            filterText={this.state.filterText}
            inStockOnly={this.state.inStockOnly}
          />
      </div>
    );
  }
}

export default App;
