import relationalStore from '@ohos.data.relationalStore';
import Constants from '../pages/Constants'
import RDBUtil from './RDBUtil'
import ShoppingItem from './ShoppingItem';

export default class ShoppingListItemTable {
  private table = new RDBUtil(Constants.SHOPPING_LIST_TABLE_NAME, Constants.CREATE_SHOPPING_LIST_TABLE_SQL, ['ID', 'NAME', 'QUANTITY', 'CATEGORY', 'DONE']);

  constructor(callback: Function = () => {
  }) {
    this.table.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.table.getRdbStore(callback);
  }

  insertItem(item: ShoppingItem, callback: Function) {
    let value: relationalStore.ValuesBucket = generateBuket(item);
    this.table.insertData(value, callback);
  }

  deleteItem(item: ShoppingItem, callback: Function) {
    let predicatesDel = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
    predicatesDel.equalTo('ID', item.category+item.name);
    this.table.deleteData(predicatesDel, callback);
  }

  deleteAll(callback: Function) {
    let predicatesDelAll = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
    this.table.deleteData(predicatesDelAll, callback);
  }

  updateItem(item: ShoppingItem, callback: Function) {
    let value: relationalStore.ValuesBucket = generateBuket(item);
    let predicatesUpdate = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
    predicatesUpdate.equalTo('ID', item.category + item.name);
    this.table.updateData(value, predicatesUpdate, callback);
  }

  queryItemsByCategory(category: string, callback: Function) {
    let predicatesUpdate = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
    predicatesUpdate.equalTo('CATEGORY', category);

    this.table.queryData(predicatesUpdate, (resultSet: relationalStore.ResultSet) => {
      let itemList: ShoppingItem[] = [];
      if ((resultSet != undefined) && (resultSet.rowCount > 0)) {
        while (resultSet.goToNextRow()) {
          let name: string = resultSet.getString(resultSet.getColumnIndex('NAME'));
          let quantity: number = resultSet.getLong(resultSet.getColumnIndex('QUANTITY'));
          let done: number = resultSet.getLong(resultSet.getColumnIndex('DONE'));
          let category: string = resultSet.getString(resultSet.getColumnIndex('CATEGORY'));
          itemList.push(new ShoppingItem(name, quantity, Boolean(done), category));
        }
        resultSet.close();
      }
      callback(itemList)
    });
  }
}

function generateBuket(item: ShoppingItem): relationalStore.ValuesBucket {
  let value: relationalStore.ValuesBucket = {
    ID: item.category + item.name,
    NAME: item.name,
    QUANTITY: item.quantity,
    CATEGORY: item.category,
    DONE: item.done
  };
  return value;
}