export default class ShoppingItem {
  id: string;
  name: string;
  quantity: number;
  done: boolean;
  category: string

  constructor(name: string, quantity: number, done: boolean, category: string) {
    this.id = category + name;
    this.name = name;
    this.quantity = quantity;
    this.done = done;
    this.category = category;
  }
}