import { LightningElement } from 'lwc';

export default class HelloWorld extends LightningElement {
  name = 'World';

  handleChange(event) {
    this.name = event.target.value;
  }

  reset() {
    this.name = 'World';
  }
}