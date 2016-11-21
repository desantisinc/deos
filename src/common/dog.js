// @flow

export default class Dog {

  name: string;

  constructor(name: string) { this.name = name; }

  bark(): string { return `Wah wah, I am ${this.name}`; }

  /* eslint-disable no-console */

  barkInConsole() { console.log(this.bark()); }

  /* eslint-enable no-console */

}
