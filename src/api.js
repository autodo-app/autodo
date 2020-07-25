import React from 'react';
import axios from 'axios';

class MyComponent extends React.Component {
    constructor(props) {
      super(props);
      this.state = {
        error: null,
        isLoaded: false,
        items: []
      };
    }

    componentDidMount() {
        const instance = axios.create({
        });
        instance.post('http://localhost:8000/auth/token/', {'username': 'root', 'password': 'root1234'})
        .then((res) => {
            console.log(res.status);
            console.log(res.data);
        }).catch((error) => {
            console.log(error);
        });
    //   fetch("api/v1/todos")
    //     .then(res => res.json())
    //     .then(
    //       (result) => {
    //         this.setState({
    //           isLoaded: true,
    //           items: result.items
    //         });
    //       },
    //       // Note: it's important to handle errors here
    //       // instead of a catch() block so that we don't swallow
    //       // exceptions from actual bugs in components.
    //       (error) => {
    //         this.setState({
    //           isLoaded: true,
    //           error
    //         });
    //       }
    //     )
    }
  
    render() {
      const { error, isLoaded, items } = this.state;
      if (error) {
        return <div>Error: {error.message}</div>;
      } else if (!isLoaded) {
        return <div>Loading...</div>;
      } else {
        return (
          <ul>
            {items.map(item => (
              <li key={item.name}>
                {item.name}
              </li>
            ))}
          </ul>
        );
      }
    }
}
  
export default MyComponent;