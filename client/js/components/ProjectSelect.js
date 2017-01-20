import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import Select from 'react-select';

export default class ProjectSelect extends Component {

  constructor() {
    super();
    this.state = { value: "one" };
  }

  render() {
    const options = [
      { value: 'one', label: 'One' },
      { value: 'two', label: 'Two' },
    ];

    const logChange = val => {
      this.setState({value: val.value});
    }

    return (
      <Select
        name="form-field-name"
        value={this.state.value}
        options={options}
        onChange={logChange} />
    );
  }
}
