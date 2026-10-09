import ShoppingItem from './ShoppingItem';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import { relationalStore } from '@kit.ArkData';

interface StoreConfig {
  name: string
  securityLevel: relationalStore.SecurityLevel
}

export default class RDBUtil {
  private store: relationalStore.RdbStore | undefined;
  private tableName: string;
  private sqlCreateTable: string;
  private columns: string[];

  constructor(tableName: string, sqlCreateTable: string, columns: string[]) {
    this.tableName = tableName;
    this.sqlCreateTable = sqlCreateTable;
    this.columns = columns;
  }

  getRdbStore(context: common.Context, callback: (ready: boolean) => void = () => {
  }) {
    if (this.store != null) {
      callback(true);
      return;
    }
    relationalStore.getRdbStore(context, storeconfig, (err: BusinessError, store: relationalStore.RdbStore) => {
      if (err) {
        callback(false);
        return;
      }
      this.store = store;
      this.store.executeSql(this.sqlCreateTable).then(() => {
        callback(true);
      }).catch(() => {
        this.store = undefined;
        callback(false);
      });
    })
  }

  insertData(data: relationalStore.ValuesBucket, callback: (rowId: number | undefined) => void = () => {
  }) {
    if (this.store) {
      this.store.insert(this.tableName, data, (err: Error, rowId: number) => {
        if (err) {
          callback(undefined);
        } else {
          callback(rowId);
        }
      });
    } else {
      callback(undefined);
    }
  }

  deleteData(predicatesDel: relationalStore.RdbPredicates, callback: (rows: number | undefined) => void = () => {
  }) {
    if (this.store != undefined) {
      this.store.delete(predicatesDel, (err, rows: number) => {
        if (err) {
          callback(undefined);
        } else {
          callback(rows);
        }
      })
    } else {
      callback(undefined);
    }
  }

  updateData(data: relationalStore.ValuesBucket, predicatesUpdate: relationalStore.RdbPredicates,
    callback: (rows: number | undefined) => void = () => {
    }) {
    if (this.store != undefined) {
      this.store.update(data, predicatesUpdate, (err: Error, rows: number) => {
        if (err) {
          callback(undefined);
        } else {
          callback(rows);
        }
      })
    } else {
      callback(undefined);
    }
  }

  async renameData(oldId: string, data: relationalStore.ValuesBucket, replaceExisting: boolean): Promise<boolean> {
    if (this.store === undefined) {
      return false;
    }
    const store: relationalStore.RdbStore = this.store;
    let transactionStarted: boolean = false;
    try {
      if (replaceExisting) {
        store.beginTransaction();
        transactionStarted = true;
        const duplicate = new relationalStore.RdbPredicates(this.tableName);
        duplicate.equalTo('ID', data.ID as string);
        if (await store.delete(duplicate) !== 1) {
          throw new Error('The item to replace was not found');
        }
      }
      const original = new relationalStore.RdbPredicates(this.tableName);
      original.equalTo('ID', oldId);
      if (await store.update(data, original) !== 1) {
        throw new Error('The item to rename was not found');
      }
      if (transactionStarted) {
        store.commit();
      }
      return true;
    } catch (error) {
      if (transactionStarted) {
        try {
          store.rollBack();
        } catch (rollbackError) {
          // The operation still reports failure if rollback itself fails.
        }
      }
      return false;
    }
  }

  queryData(predicateQuery: relationalStore.RdbPredicates,
    callback: (resultSet: relationalStore.ResultSet | undefined) => void = () => {
  }) {
    if (this.store) {
      this.store.query(predicateQuery, this.columns, (err: Error, resultSet) => {
        if (err) {
          callback(undefined);
        } else {
          callback(resultSet);
        }
      })
    } else {
      callback(undefined);
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
