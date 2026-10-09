import { common } from '@kit.AbilityKit';
import { relationalStore } from '@kit.ArkData';
import Constants from '../pages/Constants'
import RDBUtil from './RDBUtil'
import ShoppingItem from './ShoppingItem';

export default class ShoppingListItemTable {
  private table = new RDBUtil(Constants.SHOPPING_LIST_TABLE_NAME, Constants.CREATE_SHOPPING_LIST_TABLE_SQL, ['ID', 'NAME', 'QUANTITY', 'CATEGORY', 'DONE']);

  getRdbStore(context: common.Context, callback: (ready: boolean) => void = () => {
  }) {
    this.table.getRdbStore(context, callback);
  }

  insertItem(item: ShoppingItem, callback: (rowId: number | undefined) => void) {
    const value: relationalStore.ValuesBucket = generateBuket(item);
    this.table.insertData(value, callback);
  }

  deleteItem(item: ShoppingItem, callback: (rows: number | undefined) => void) {
    try {
      const predicatesDel = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
      predicatesDel.equalTo('ID', item.category + item.name);
      this.table.deleteData(predicatesDel, callback);
    } catch (error) {
      callback(undefined);
    }
  }

  deleteAll(callback: (rows: number | undefined) => void) {
    const predicatesDelAll = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
    this.table.deleteData(predicatesDelAll, callback);
  }

  updateItem(item: ShoppingItem, callback: (rows: number | undefined) => void) {
    try {
      const value: relationalStore.ValuesBucket = generateBuket(item);
      const predicatesUpdate = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
      predicatesUpdate.equalTo('ID', item.category + item.name);
      this.table.updateData(value, predicatesUpdate, callback);
    } catch (error) {
      callback(undefined);
    }
  }

  renameItem(oldItem: ShoppingItem, newItem: ShoppingItem, replaceExisting: boolean,
    callback: (success: boolean) => void) {
    const data: relationalStore.ValuesBucket = generateBuket(newItem);
    this.table.renameData(oldItem.category + oldItem.name, data, replaceExisting).then(callback);
  }

  queryItemsByCategory(category: string, callback: (items: ShoppingItem[] | undefined) => void) {
    try {
      const predicatesQuery = new relationalStore.RdbPredicates(Constants.SHOPPING_LIST_TABLE_NAME);
      predicatesQuery.equalTo('CATEGORY', category);
      this.table.queryData(predicatesQuery, (resultSet: relationalStore.ResultSet | undefined) => {
        if (resultSet === undefined) {
          callback(undefined);
          return;
        }
        const itemList: ShoppingItem[] = [];
        let readSucceeded: boolean = false;
        try {
          while (resultSet.goToNextRow()) {
            const name: string = resultSet.getString(resultSet.getColumnIndex('NAME'));
            const quantity: number = resultSet.getLong(resultSet.getColumnIndex('QUANTITY'));
            const done: number = resultSet.getLong(resultSet.getColumnIndex('DONE'));
            const itemCategory: string = resultSet.getString(resultSet.getColumnIndex('CATEGORY'));
            itemList.push(new ShoppingItem(name, quantity, Boolean(done), itemCategory));
          }
          readSucceeded = true;
        } catch (error) {
        } finally {
          try {
            resultSet.close();
          } catch (error) {
            readSucceeded = false;
          }
        }
        callback(readSucceeded ? itemList : undefined);
      });
    } catch (error) {
      callback(undefined);
    }
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
