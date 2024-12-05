export default class Constants {
  //主题背景色
  public static readonly LIGHT_BACKGROUND_COLOR: string = '#FFFBFB';
  public static readonly DARK_BACKGROUND_COLOR: string = '#1A1A1A'; //#352f36

  //分类标题栏字体色
  public static readonly DARK_TEXT_COLOR: string = '#1A1A1A'; //用户名字体色
  public static readonly LIGHT_TEXT_COLOR: string = '#FFFAFA';

  //用户名副标题字体色
  public static readonly DARK_TEXT_SUBTITLE_COLOR: string = '#5A5A5A';
  public static readonly LIGHT_TEXT_SUBTITLE_COLOR: string = '#EFEAEA';

  //页头颜色
  public static readonly DARK_HEADER_BACKGROUND_COLOR = '#031602';
  public static readonly LIGHT_HEADER_BACKGROUND_COLOR = '#FFF5F5';

  //项目字体色
  public static readonly ITEM_COLORS: string[] = ['#92D87E', '#FFA0A0', '#FFB95C', '#8A94D8', '#DF9DED', '#E6E949', '#89683D'];

  //已购项目背景色
  public static readonly ITEM_DONE_COLOR: string = '#FFFBFB';
  public static readonly ITEM_DONE_COLOR1: string = '#E6FFE1';

  //
  public static readonly ITEM_SELECTION_COLOR: string = '#FFFBFB';
  public static readonly ITEM_SELECTION_COLOR1: string = '#E6FFE1';
  //已购项目选择框背景色
  public static readonly ITEM_DONE_CHECKBOX_COLOR: string = '#60A962';

  //删除时项目背景色
  public static readonly ITEM_DELETE_COLOR: string = '#FFD8D8';

  //switch颜色
  public static readonly DARK_SWITCH_SELECTED_COLOR: string = '#FFFBFB';
  public static readonly LIGHT_SWITCH_SELECTED_COLOR: string = '#0B1215';
  public static readonly LIGHT_SWITCH_POINTER_COLOR: string = "#FAB0B0"

  //#7F7C7C

  //数量颜色
  public static readonly ITEM_COUNT_COLOR: string = '#ABABAB';

  //添加表单背景
  public static readonly LIGHT_ADD_ITEM_BACKGROUND_COLOR: string = '#FFFBFB';
  public static readonly DARK_ADD_ITEM_BACKGROUND_COLOR: string = '#212121';
  public static readonly LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR: string = '#FFF2F2';
  public static readonly DARK_ADD_ITEM_FORM_BACKGROUND_COLOR: string = '#363636';
  public static readonly LIGHT_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR: string = '#FAB0B0';
  public static readonly DARK_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR: string = '#FAB0B0';
  public static readonly LIGHT_ADD_CANCEL_BUTTON_BACKGROUND_COLOR: string = '#E5E5E5';
  public static readonly DARK_ADD_CANCEL_BUTTON_BACKGROUND_COLOR: string = '#D6D6D6';
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