import ShoppingItem from '../model/ShoppingItem';
import { AddItemDialogue } from './Components/AddItemDialogue';
import { ReminderDialogue } from './Components/ReminderDialogue';
import { ReminderModification } from './Components/ReminderModification';
import { ShoppingListItem } from './Components/ShoppingListItem';
import Constants from './Constants';
import ShoppingListItemTable from '../model/ShoppingListItemTable';

@Entry
@Component
struct Index {
  @State username: string = 'My';
  //当前修改的项目的临时信息
  @State modificationItems: ShoppingItem[] = [];
  @State modificationCategory: string = '';
  @State modificationItemIndex: number = 0;
  @State modifiedName: string = '';
  @State beforeModificationItemIndex: number = 0;
  @State availableCate: string[] = [];
  @State vegetableList: ShoppingItem[] = [];
  @State fruitList: ShoppingItem[] = [];
  @State foodList: ShoppingItem[] = [];
  @State clothList: ShoppingItem[] = [];
  @State jewelryList: ShoppingItem[] = [];
  @State homeFurnishingList: ShoppingItem[] = [];
  @State otherList: ShoppingItem[] = [];
  @State addCategory: string = '';
  @State addName: string = '';
  @State addQuantity: number = 1;
  @State dayTimeBackColor: string = Constants.LIGHT_BACKGROUND_COLOR;
  @State isDay: boolean = true;
  @State isFolded: boolean[] = [false, false, false, false, false, false, false];
  @State vegetablesTotalCount: number = 0;
  @State vegetablesDoneCount: number = 0;
  @State fruitDoneCount: number = 0;
  @State fruitTotalCount: number = 0;
  @State clothDoneCount: number = 0;
  @State clothTotalCount: number = 0;
  @State foodDoneCount: number = 0;
  @State foodTotalCount: number = 0;
  @State jewelryTotalCount: number = 0;
  @State jewelryDoneCount: number = 0;
  @State homeFurnishingTotalCount: number = 0;
  @State homeFurnishingDoneCount: number = 0;
  @State otherTotalCount: number = 0;
  @State otherDoneCount: number = 0;
  @State showReminderName: boolean = false;
  shoppingListItemTable: ShoppingListItemTable = new ShoppingListItemTable();

  aboutToAppear() {
    this.shoppingListItemTable.getRdbStore(() => {
      this.shoppingListItemTable.queryItemsByCategory('Vegetable', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.vegetableList = [...list];
          this.getVegetableCount(list);
          this.initCategory('Vegetable')
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('Fruit', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.fruitList = [...list];
          this.getFruitCount(list);
          this.initCategory('Fruit');
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('Food', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.foodList = [...list];
          this.getFoodCount(list);
          this.initCategory('Food');
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('Cloth', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.clothList = [...list];
          this.getClothCount(list);
          this.initCategory('Cloth');
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('Jewelry', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.jewelryList = [...list];
          this.getJewelryCount(list);
          this.initCategory('Jewelry');
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('HomeFurnishing', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.homeFurnishingList = [...list];
          this.getHomeFurnishingCount(list);
          this.initCategory('HomeFurnishing');
        }
      });

      this.shoppingListItemTable.queryItemsByCategory('Other', (list: ShoppingItem[]) => {
        if (list.length > 0) {
          this.otherList = [...list];
          this.getOtherCount(list);
          this.initCategory('Other');
        }
      });
    })
  }

  aboutToDisappear() {
    this.dialogController = null // 将dialogController置空
    this.reminderDialogueController = null;
    this.reminderModificationController = null;
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Row() {
            Image($r('app.media.basket')).width(40).height(40)
          }
          .width(40)
          .height(40)
          .borderRadius(20)
          .clip(true)
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Column() {
            Text(this.username)
              .fontSize(18)
              .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
            Text('shopping list')
              .fontSize(13)
              .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
          }.margin({ left: 5 }).alignItems(HorizontalAlign.Start).justifyContent(FlexAlign.Center)
        }.width(150).height('100%')

        Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
          Toggle({ type: ToggleType.Switch, isOn: false })
            .selectedColor(Constants.DARK_SWITCH_SELECTED_COLOR)
            .width(25)
            .height(25)
            .switchPointColor(Constants.LIGHT_SWITCH_POINTER_COLOR)
            .onChange((isOn: boolean) => {
              if (isOn) {
                this.isDay = false;
                this.dayTimeBackColor = Constants.DARK_BACKGROUND_COLOR;
              } else {
                this.isDay = true;
                this.dayTimeBackColor = Constants.LIGHT_BACKGROUND_COLOR;
              }
            })

          Image($r('app.media.add'))
            .width(23).height(23).margin({ left: 12 }).onClick(() => {
            if (this.dialogController != null) {
              this.dialogController.open()
            }
          })
          if (this.availableCate.length > 0) {
            Image(this.isDay ? $r('app.media.delete_dark') : $r('app.media.delete_light'))
              .width(22).height(22).margin({ left: 12 }).onClick(() => {
              if (this.dialogController != null) {
                this.reminderDialogueController.open()
              }
            })
          }
        }.width(100).height(34)
      }
      .width('100%')
      .height(70)
      .backgroundColor(this.isDay ? Constants.LIGHT_HEADER_BACKGROUND_COLOR : Constants.DARK_HEADER_BACKGROUND_COLOR)
      .padding({ top: 5, left: 10, bottom: 15, right: 20 })

      if (this.availableCate.length > 0) {
        List() {
          ForEach(this.availableCate, (category: string) => {
            ListItemGroup({ header: this.itemHead(category) }) {
              if (category == 'Vegetable') {
                if (!this.isFolded[0]) {
                  ForEach(this.vegetableList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'Fruit') {
                if (!this.isFolded[1]) {
                  ForEach(this.fruitList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'Food') {
                if (!this.isFolded[2]) {
                  ForEach(this.foodList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'Cloth') {
                if (!this.isFolded[3]) {
                  ForEach(this.clothList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'Jewelry') {
                if (!this.isFolded[4]) {
                  ForEach(this.jewelryList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'HomeFurnishing') {
                if (!this.isFolded[5]) {
                  ForEach(this.homeFurnishingList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else {
                if (!this.isFolded[6]) {
                  ForEach(this.otherList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        doneColor: this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR,
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName);
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              }
            }
          })
        }
        .listDirection(Axis.Vertical)
        .width('100%')
        .scrollBar(BarState.Auto)
      } else {
        Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
          Text('Shopping list is empty, add now')
            .height(20)
            .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
            .textAlign(TextAlign.End)
          Column() {
            Image($r('app.media.add'))
              .width(20).height(20).onClick(() => {
              if (this.dialogController != null) {
                this.dialogController.open()
              }
            })
          }
          .alignItems(HorizontalAlign.Center)
          .width(20)
          .height(20)
          .justifyContent(FlexAlign.Center)
          .margin({ left: 10 })
        }.width('100%').height('80%')
      }
    }.width('100%').height('100%').justifyContent(FlexAlign.Start).backgroundColor(this.dayTimeBackColor)

  }

  @Builder itemHead(category: string) {
    Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        if (category == 'Vegetable') {
          Row() {
            Image(this.isFolded[0] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[0] = !this.isFolded[0];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.vege')).width(20).height(20).margin({ left: 5 })
        } else if (category == 'Fruit') {
          Row() {
            Image(this.isFolded[1] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[1] = !this.isFolded[1];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.fruit')).width(20).height(20).margin({ left: 5 })
        } else if (category == 'Food') {
          Row() {
            Image(this.isFolded[2] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[2] = !this.isFolded[2];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.food')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'Cloth') {
          Row() {
            Image(this.isFolded[3] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[3] = !this.isFolded[3];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.cloth')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'Jewelry') {
          Row() {
            Image(this.isFolded[4] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[4] = !this.isFolded[4];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.jewelry')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'HomeFurnishing') {
          Row() {
            Image(this.isFolded[5] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)
          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[5] = !this.isFolded[5];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.furniture')).width(20).height(20).margin({ left: 5 })
        }
        else {
          Row() {
            Image(this.isFolded[6] ? $r('app.media.right_dark') : $r('app.media.down_dark'))
              .width(10).height(10)

          }
          .width(20)
          .height(20)
          .onClick((event: ClickEvent) => {
            this.isFolded[6] = !this.isFolded[6];
          })
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.goods')).width(20).height(20).margin({ left: 5 })
        }

        Text(category)
          .fontSize(16)
          .margin({ left: 10 })
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
      }
      .width('50%').margin({ left: 10 })
      .alignItems(VerticalAlign.Center).justifyContent(FlexAlign.Start)

      Row() {
        if (category == 'Vegetable') {
          Text(String(this.vegetablesDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'Fruit') {
          Text(String(this.fruitDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'Food') {
          Text(String(this.foodDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'Cloth') {
          Text(String(this.clothDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'Jewelry') {
          Text(String(this.jewelryDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'HomeFurnishing') {
          Text(String(this.homeFurnishingDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else {
          Text(String(this.otherDoneCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }

        Text('/') {
        }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)

        if (category == 'Vegetable') {
          Text(String(this.vegetablesTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        } else if (category == 'Fruit') {
          Text(String(this.fruitTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
        else if (category == 'Food') {
          Text(String(this.foodTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
        else if (category == 'Cloth') {
          Text(String(this.clothTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
        else if (category == 'Jewelry') {
          Text(String(this.jewelryTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
        else if (category == 'HomeFurnishing') {
          Text(String(this.homeFurnishingTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
        else {
          Text(String(this.otherTotalCount)) {
          }.height(15).fontSize(13).fontColor(Constants.ITEM_COUNT_COLOR)
        }
      }.width('50%').margin({ right: 10 })
      .alignItems(VerticalAlign.Center).justifyContent(FlexAlign.End)
    }.margin({ top: 5 })
  }

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AddItemDialogue({
      showReminderName: $showReminderName,
      isDay: this.isDay,
      cancel: () => {
        this.onCancel()
      },
      confirm: (category: string, name: string, quantity: number) => {
        this.onAccept(category, name, quantity)
      }
    }),
    cancel: this.exitApp,
    autoCancel: false,
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
  })

  onCancel() {

  }

  onAccept(category: string, name: string, quantity: number) {
    if (!this.availableCate.includes(category)) {
      this.availableCate.push(category)
    }
    let item: ShoppingItem = new ShoppingItem(name, quantity, false, category);
    switch (category) {
      case 'Vegetable':
        this.reactiveRefreshList(this.vegetableList, name, quantity, item, 'Vegetable');
        break;
      case 'Fruit':
        this.reactiveRefreshList(this.fruitList, name, quantity, item, 'Fruit');
        break;
      case 'Food':
        this.reactiveRefreshList(this.foodList, name, quantity, item, 'Food');
        break;
      case 'Cloth':
        this.reactiveRefreshList(this.clothList, name, quantity, item, 'Cloth');
        break;
      case 'Jewelry':
        this.reactiveRefreshList(this.jewelryList, name, quantity, item, 'Jewelry');
        break;
      case 'HomeFurnishing':
        this.reactiveRefreshList(this.homeFurnishingList, name, quantity, item, 'HomeFurnishing');
        break;
      default:
        this.reactiveRefreshList(this.otherList, name, quantity, item, 'Other');
        break;
    }
  }

  exitApp() {
    console.info('Click the callback in the blank area')
  }

  reminderModificationController: CustomDialogController | null = new CustomDialogController({
    builder: ReminderModification({
      cancelModification: () => {
        this.onCancelModification()
      },
      confirmModification: () => {
        this.onConfirmModification()
      },
    })
  })

  onCancelModification() {
    console.info('Callback when the first button is clicked')
  }

  onConfirmModification() {
    let item: ShoppingItem = this.modificationItems[this.modificationItemIndex];
    let name: string = this.modificationItems[this.beforeModificationItemIndex].name;
    let quantity: number = item.quantity;
    let done: boolean = item.done;
    let category: string = item.category;
    item.name = this.modifiedName;
    this.modificationItems[this.beforeModificationItemIndex].quantity = quantity;
    item.done = done;
    this.shoppingListItemTable.deleteItem(item, (res) => {
      if (res != undefined) {
        let newItem: ShoppingItem = new ShoppingItem(name, quantity, done, this.modificationCategory);
        this.shoppingListItemTable.updateItem(newItem, (res) => {
          this.modificationItems.splice(this.modificationItemIndex, 1);
          switch (category) {
            case 'Vegetable':
              this.vegetableList = [...this.modificationItems];
              break;
            case 'Fruit':
              this.fruitList = [...this.modificationItems];
              break;
            case 'Food':
              this.foodList = [...this.modificationItems];
              break;
            case 'Cloth':
              this.clothList = [...this.modificationItems];
              break;
            case 'Jewelry':
              this.jewelryList = [...this.modificationItems];
              break;
            case 'HomeFurnishing':
              this.homeFurnishingList = [...this.modificationItems];
              break;
            default:
              this.otherList = [...this.modificationItems];
              break;
          }
        })
      }
    })

  }

  reminderDialogueController: CustomDialogController | null = new CustomDialogController({
    builder: ReminderDialogue({
      cancelDeleteAll: () => {
        this.onCancelDeleteAll()
      },
      confirmDeleteAll: () => {
        this.onConfirmDeleteAll()
      },
    })
  })

  onCancelDeleteAll() {
    console.info('Callback when the first button is clicked')
  }

  onConfirmDeleteAll() {
    this.shoppingListItemTable.deleteAll((result) => {
      if (result != false) {
        this.availableCate = [];
        this.vegetablesTotalCount = 0;
        this.vegetablesDoneCount = 0;
        this.vegetableList = [];
        this.fruitTotalCount = 0;
        this.fruitDoneCount = 0;
        this.fruitList = [];
        this.foodTotalCount = 0;
        this.foodDoneCount = 0;
        this.foodList = [];
        this.clothTotalCount = 0;
        this.clothDoneCount = 0;
        this.clothList = [];
        this.jewelryTotalCount = 0;
        this.jewelryDoneCount = 0;
        this.jewelryList = [];
        this.homeFurnishingTotalCount = 0;
        this.homeFurnishingDoneCount = 0;
        this.homeFurnishingList = [];
        this.otherTotalCount = 0;
        this.otherDoneCount = 0;
        this.otherList = [];
      }
    })
  }

  changeName(tempList: ShoppingItem[], currentSelection: number, selectionCategory: string, changedValue: string, currentSelectionItem: ShoppingItem, oldName: string, callback: Function) {
    let exists: boolean = false;
    for (let i = 0;i < tempList.length; i++) {
      if (tempList[i].name == changedValue && i != currentSelection) {
        exists = true;
        this.modificationItems = tempList;
        this.modifiedName = oldName;
        this.modificationCategory = selectionCategory;
        this.modificationItemIndex = currentSelection;
        this.beforeModificationItemIndex = i;
        this.reminderModificationController.open();
        break;
      }
      if (!exists) {
        this.shoppingListItemTable.insertItem(currentSelectionItem, (res) => {
          if (res != undefined) {
            callback(tempList);
          }
        })
        let oldItem: ShoppingItem = currentSelectionItem;
        oldItem.name = oldName;
        this.shoppingListItemTable.deleteItem(oldItem, (res) => {
          if (res != undefined) {
            callback(tempList);
          }
        });
      }
    }
  }

  changeQuantity(tempList: ShoppingItem[], currentSelectionItem: ShoppingItem, callback: Function) {
    this.shoppingListItemTable.updateItem(currentSelectionItem, (res) => {
      if (res != undefined && res != 0) {
        callback(tempList);
      }
    })
  }

  changeDone(tempList: ShoppingItem[], currentSelectionItem: ShoppingItem, callback: Function, selectionCategory: string) {
    this.shoppingListItemTable.updateItem(currentSelectionItem, (res) => {
      if (res != undefined) {
        switch (selectionCategory) {
          case 'Vegetable':
            this.getVegetableCount(tempList);
            break;
          case 'Fruit':
            this.getFruitCount(tempList);
            break;
          case 'Food':
            this.getFoodCount(tempList);
            break;
          case 'Cloth':
            this.getClothCount(tempList);
            break;
          case 'Jewelry':
            this.getJewelryCount(tempList);
            break;
          case 'HomeFurnishing':
            this.getHomeFurnishingCount(tempList);
            break;
          default:
            this.getOtherCount(tempList);
            break;
        }
        callback(tempList);
      }
    })
  }

  onEditItem(currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName: string) {
    if (currentSelection != undefined) {
      let tempList: ShoppingItem[] = [];
      let currentSelectionItem: ShoppingItem;
      switch (selectionCategory) {
        case 'Vegetable':
          tempList = [...this.vegetableList];
          currentSelectionItem = this.vegetableList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.vegetableList = [...res];
          });
          break;
        case 'Fruit':
          tempList = [...this.fruitList];
          currentSelectionItem = this.fruitList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.fruitList = [...res];
          });
          break;
        case 'Food':
          tempList = [...this.foodList];
          currentSelectionItem = this.foodList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.foodList = [...res];
          });
          break;
        case 'Cloth':
          tempList = [...this.clothList];
          currentSelectionItem = this.clothList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.clothList = [...res];
          });
          break;
        case 'Jewelry':
          tempList = [...this.jewelryList];
          currentSelectionItem = this.jewelryList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.jewelryList = [...res];
          });
          break;
        case 'HomeFurnishing':
          tempList = [...this.homeFurnishingList];
          currentSelectionItem = this.homeFurnishingList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.homeFurnishingList = [...res];
          });
          break;
        default:
          tempList = [...this.otherList];
          currentSelectionItem = this.otherList[currentSelection];
          this.editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, (res: ShoppingItem[]) => {
            this.otherList = [...res];
          });
          break;
      }
    }
  }

  onDeleteItem(currentSelection: number, selectionCategory: string) {
    let tempList: ShoppingItem[] = [];
    switch (selectionCategory) {
      case 'Vegetable':
        this.shoppingListItemTable.deleteItem(this.vegetableList[currentSelection], (result) => {
          if (result != false) {
            tempList = [...this.vegetableList];
            tempList.splice(currentSelection, 1);
            this.getVegetableCount(tempList);
            this.vegetableList = [...tempList];
            if (this.vegetableList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        })
        break;
      case 'Fruit':
        this.shoppingListItemTable.deleteItem(this.fruitList[currentSelection], (result) => {
          if (result != false) {
            tempList = [...this.fruitList];
            tempList.splice(currentSelection, 1);
            this.getFruitCount(tempList);
            this.fruitList = [...tempList];
            if (this.fruitList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
      case 'Food':
        this.shoppingListItemTable.deleteItem(this.foodList[currentSelection], (result) => {
          if (result != false) {
            tempList = [...this.foodList];
            tempList.splice(currentSelection, 1);
            this.getFoodCount(tempList);
            this.foodList = [...tempList];
            if (this.foodList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
      case 'Cloth':
        this.shoppingListItemTable.deleteItem(this.clothList[currentSelection], (result) => {
          if (result.code == Constants.SUCCESS_CODE) {
            tempList = [...this.clothList];
            tempList.splice(currentSelection, 1);
            this.getClothCount(tempList);
            this.clothList = [...tempList];
            if (this.clothList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
      case 'jewelry':
        this.shoppingListItemTable.deleteItem(this.jewelryList[currentSelection], (result) => {
          if (result.code == Constants.SUCCESS_CODE) {
            tempList = [...this.jewelryList];
            tempList.splice(currentSelection, 1);
            this.getJewelryCount(tempList);
            this.jewelryList = [...tempList];
            if (this.jewelryList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
      case 'HomeFurnishing':
        this.shoppingListItemTable.deleteItem(this.homeFurnishingList[currentSelection], (result) => {
          if (result != false) {
            tempList = [...this.homeFurnishingList];
            tempList.splice(currentSelection, 1);
            this.getHomeFurnishingCount(tempList);
            this.homeFurnishingList = [...tempList];
            if (this.homeFurnishingList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
      default:
        this.shoppingListItemTable.deleteItem(this.otherList[currentSelection], (result) => {
          if (result != false) {
            tempList = [...this.otherList];
            tempList.splice(currentSelection, 1);
            this.getOtherCount(tempList);
            this.otherList = [...tempList];
            if (this.otherList.length <= 0) {
              this.removeCate(selectionCategory);
            }
          }
        });
        break;
    }
  }

  getVegetableCount(list: ShoppingItem[]) {
    this.vegetablesTotalCount = list.length;
    this.vegetablesDoneCount = list.filter((item) => item.done).length;
  }

  getFruitCount(list: ShoppingItem[]) {
    this.fruitTotalCount = list.length;
    this.fruitDoneCount = list.filter((item) => item.done).length;
  }

  getFoodCount(list: ShoppingItem[]) {
    this.foodTotalCount = list.length;
    this.foodDoneCount = list.filter((item) => item.done).length;
  }

  getClothCount(list: ShoppingItem[]) {
    this.clothTotalCount = list.length;
    this.clothDoneCount = list.filter((item) => item.done).length;
  }

  getJewelryCount(list: ShoppingItem[]) {
    this.jewelryTotalCount = list.length;
    this.jewelryDoneCount = list.filter((item) => item.done).length;
  }

  getHomeFurnishingCount(list: ShoppingItem[]) {
    this.homeFurnishingTotalCount = list.length;
    this.homeFurnishingDoneCount = list.filter((item) => item.done).length;
  }

  getOtherCount(list: ShoppingItem[]) {
    this.otherTotalCount = list.length;
    this.otherDoneCount = list.filter((item) => item.done).length;
  }

  removeCate(category: string) {
    let indexRemove = this.availableCate.indexOf(category);
    let tempCate: string[] = [...this.availableCate];
    tempCate.splice(indexRemove, 1);
    this.availableCate = [...tempCate];
  }

  initCategory(category: string) {
    let tempCate: string[] = [...this.availableCate];
    tempCate.push(category);
    this.availableCate = [...tempCate];
  }

  reactiveRefreshList(list: ShoppingItem[], name: string, quantity: number, item: ShoppingItem, category: string) {
    let exists: boolean = false;
    if (list.length > 0) {
      for (let i = 0;i < list.length; i++) {
        if (name == list[i].name) {
          exists = true;
          break;
        }
      }
    }
    if (!exists) {
      this.showReminderName = false;
      this.shoppingListItemTable.insertItem(item, (result) => {
        let tempList: ShoppingItem[] = [...list];
        if (result != undefined && result != 0) {
          tempList.push(item);
          switch (category) {
            case 'Vegetable':
              this.vegetableList = [...tempList];
              this.getVegetableCount(tempList);
              break;
            case 'Fruit':
              this.fruitList = [...tempList];
              this.getFruitCount(tempList);
              break;
            case 'Food':
              this.foodList = [...tempList];
              this.getFoodCount(tempList);
              break;
            case 'Cloth':
              this.clothList = [...tempList];
              this.getClothCount(tempList);
              break;
            case 'Jewelry':
              this.jewelryList = [...tempList];
              this.getJewelryCount(tempList);
              break;
            case 'HomeFurnishing':
              this.homeFurnishingList = [...tempList];
              this.getHomeFurnishingCount(tempList);
              break;
            default:
              this.otherList = [...tempList];
              this.getOtherCount(tempList);
              break;
          }
        }
      })
    } else {
      this.showReminderName = true;
    }
  }

  editItem(changedParameter, currentSelectionItem, tempList, currentSelection, selectionCategory, changedValue, oldName, callback: Function) {
    if (changedParameter == 'name') {
      this.changeName(tempList, currentSelection, selectionCategory, changedValue, currentSelectionItem, oldName, callback);
    } else if (changedParameter == 'quantity') {
      this.changeQuantity(tempList, currentSelectionItem, callback);
    } else {
      currentSelectionItem.done = changedValue == 'false' ? false : true;
      this.changeDone(tempList, currentSelectionItem, callback, selectionCategory);
    }
  }
}