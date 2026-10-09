export default class Constants {
  public static readonly CATEGORY_KEYS: string[] = ['Vegetable', 'Fruit', 'Food', 'Clothing', 'Jewelry', 'HomeFurnishing', 'Other'];
  public static readonly CATEGORY_LABELS: string[] = ['Vegetables', 'Fruit', 'Food', 'Clothing', 'Jewelry', 'Home', 'Other'];

  public static categoryLabel(category: string): string {
    let index: number = Constants.CATEGORY_KEYS.indexOf(category);
    return index >= 0 ? Constants.CATEGORY_LABELS[index] : category;
  }

  //主题背景色
  public static readonly LIGHT_BACKGROUND_COLOR: string = '#F8F3FF';
  public static readonly DARK_BACKGROUND_COLOR: string = '#0F0026';

  //分类标题栏字体色
  public static readonly DARK_TEXT_COLOR: string = '#0F0026';
  public static readonly LIGHT_TEXT_COLOR: string = '#F8F3FF';

  //用户名副标题字体色
  public static readonly DARK_TEXT_SUBTITLE_COLOR: string = '#665C78';
  public static readonly LIGHT_TEXT_SUBTITLE_COLOR: string = '#C6B7DD';

  //页头颜色
  public static readonly DARK_HEADER_BACKGROUND_COLOR = '#0F0026';
  public static readonly LIGHT_HEADER_BACKGROUND_COLOR = '#F8F3FF';

  //项目字体色
  public static readonly ITEM_COLORS: string[] = ['#6024B5', '#6024B5', '#6024B5', '#6024B5', '#6024B5', '#6024B5', '#6024B5'];

  //已购项目背景色
  public static readonly ITEM_DONE_COLOR: string = '#FFFFFF';
  public static readonly ITEM_DONE_COLOR1: string = '#EEE4FA';

  //
  public static readonly ITEM_SELECTION_COLOR: string = '#FFFFFF';
  public static readonly ITEM_SELECTION_COLOR1: string = '#EEE4FA';
  //已购项目选择框背景色
  public static readonly ITEM_DONE_CHECKBOX_COLOR: string = '#6024B5';

  //删除时项目背景色
  public static readonly ITEM_DELETE_COLOR: string = '#FBE6F5';

  //switch颜色
  public static readonly DARK_SWITCH_SELECTED_COLOR: string = '#6024B5';
  public static readonly LIGHT_SWITCH_SELECTED_COLOR: string = '#6024B5';
  public static readonly LIGHT_SWITCH_POINTER_COLOR: string = '#FFFFFF';

  //#7F7C7C

  //数量颜色
  public static readonly ITEM_COUNT_COLOR: string = '#665C78';

  //添加表单背景
  public static readonly LIGHT_ADD_ITEM_BACKGROUND_COLOR: string = '#FFFFFF';
  public static readonly DARK_ADD_ITEM_BACKGROUND_COLOR: string = '#22113D';
  public static readonly LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR: string = '#F8F3FF';
  public static readonly DARK_ADD_ITEM_FORM_BACKGROUND_COLOR: string = '#35204F';
  public static readonly LIGHT_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR: string = '#6024B5';
  public static readonly DARK_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR: string = '#6024B5';
  public static readonly LIGHT_ADD_CANCEL_BUTTON_BACKGROUND_COLOR: string = '#EEE4FA';
  public static readonly DARK_ADD_CANCEL_BUTTON_BACKGROUND_COLOR: string = '#35204F';
  public static readonly CREATE_SHOPPING_LIST_TABLE_SQL = 'CREATE TABLE IF NOT EXISTS SHOPPINGITEM (ID TEXT PRIMARY KEY, NAME  TEXT NOT NULL, QUANTITY INTEGER DEFAULT 1,CATEGORY TEXT NOT NULL, DONE INTEGER DEFAULT 0)'; // 建表Sql语句
  public static readonly SHOPPING_LIST_TABLE_NAME: string = 'SHOPPINGITEM';
  public static readonly SUCCESS_CODE: number = 200;
  public static readonly FAIL_CODE: number = 400;
  public static readonly FAIL_DELETE_CODE: number = 400001;
  public static readonly FAIL_UPDATE_CODE: number = 400002;
  public static readonly FAIL_INSERT_CODE: number = 400003;
  public static readonly FAIL_QUERY_CODE: number = 400003;
  public static readonly DELETE_ITEM_ERROR: string = 'error while deleting';
  public static readonly INSERT_ITEM_ERROR: string = 'error while inserting';
  public static readonly UPDATE_ITEM_ERROR: string = "error while updating";
  public static readonly QUERY_ITEM_ERROR: string = "error while updating";
}
