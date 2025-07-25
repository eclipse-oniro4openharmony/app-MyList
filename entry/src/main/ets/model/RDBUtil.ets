import ShoppingItem from './ShoppingItem';
import { BusinessError } from '@kit.BasicServicesKit';
import { relationalStore } from '@kit.ArkData';
import { UIContext } from '@kit.ArkUI';

interface StoreConfig {
  name: string
  securityLevel: relationalStore.SecurityLevel
}

export default class RDBUtil {
  // private store!: relationalStore.RdbStore;
  private store: relationalStore.RdbStore | undefined;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: Array<string>;
  private uiContext: UIContext | undefined;

  constructor(tableName: string, sqlCreateTable: string, columns: Array<string>) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(callback: Function = () => {
  }) {
    if (this.store != null) {
      callback();
      return;
    }
    let context = this.uiContext?.getHostContext()
    relationalStore.getRdbStore(context, storeconfig, (err: BusinessError, store: relationalStore.RdbStore) => {
      if (err) {
        return;
      }
      this.store = store;
      this.store.executeSql(this.sqlCreateTable);
      callback();
    })
  }

  insertData(data: relationalStore.ValuesBucket, callback: Function = () => {
  }) {
    if (this.store) {
      this.store.insert(this.tableName, data, (err: Error, rowId) => {
        if (err) {
          callback();
        } else {
          callback(rowId);
        }
      });
    } else {
      callback();
    }
  }

  deleteData(predicatesDel: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    let flag = false;
    if (this.store != undefined) {
      (this.store as relationalStore.RdbStore).delete(predicatesDel, (err, rows: number) => {
        if (err) {
          callback(flag);
        } else {
          callback(rows);
        }
      })
    } else {
      callback();
    }
  }

  updateData(data: relationalStore.ValuesBucket, predicatesUpdate: relationalStore.RdbPredicates,
    callback: Function = () => {
    }) {
    if (this.store != undefined) {
      this.store.update(data, predicatesUpdate, (err: Error, rows: number) => {
        if (err) {
          callback();
        } else {
          callback(rows);
        }
      })
    } else {
      callback();
    }
  }

  queryData(predicateQuery: relationalStore.RdbPredicates, callback: Function = () => {
  }) {
    if (this.store) {
      this.store.query(predicateQuery, this.columns, (err: Error, resultSet) => {
        if (err) {
          callback();
        } else {
          callback(resultSet);
        }
      })
    } else {
      callback();
    }
  }
}

export class STORE_CONFIG implements StoreConfig {
  name: string = 'ShoppingList.db'
  securityLevel: relationalStore.SecurityLevel = relationalStore.SecurityLevel.S1
}

let storeconfig = new STORE_CONFIG()

export class SQLiteData {
  shoppingList: ShoppingItem[];
  category: string;

  constructor(shoppingList: ShoppingItem[], category: string) {
    this.shoppingList = shoppingList;
    this.category = category;
  }
}