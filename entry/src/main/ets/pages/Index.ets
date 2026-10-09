import { common } from '@kit.AbilityKit';
import ShoppingItem from '../model/ShoppingItem';
import { AddItemDialogue } from './components/AddItemDialogue';
import { ReminderDialogue } from './components/ReminderDialogue';
import { ReminderModification } from './components/ReminderModification';
import { ShoppingListItem } from './components/ShoppingListItem';
import Constants from './Constants';
import ShoppingListItemTable from '../model/ShoppingListItemTable';

@Entry
@Component
struct Index {
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
  @State clothingList: ShoppingItem[] = [];
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
  @State clothingDoneCount: number = 0;
  @State clothingTotalCount: number = 0;
  @State foodDoneCount: number = 0;
  @State foodTotalCount: number = 0;
  @State jewelryTotalCount: number = 0;
  @State jewelryDoneCount: number = 0;
  @State homeFurnishingTotalCount: number = 0;
  @State homeFurnishingDoneCount: number = 0;
  @State otherTotalCount: number = 0;
  @State otherDoneCount: number = 0;
  @State showReminderName: boolean = false;
  @State isLoading: boolean = true;
  @State loadError: boolean = false;
  shoppingListItemTable: ShoppingListItemTable = new ShoppingListItemTable();
  private modificationCallback: (success: boolean) => void = () => {};

  aboutToAppear() {
    this.isLoading = true;
    this.shoppingListItemTable.getRdbStore(this.getUIContext().getHostContext() as common.UIAbilityContext,
      (ready: boolean) => {
        if (!ready) {
          this.isLoading = false;
          this.loadError = true;
          return;
        }
        let remaining: number = Constants.CATEGORY_KEYS.length;
        let failed: boolean = false;
        Constants.CATEGORY_KEYS.forEach((category: string) => {
          this.shoppingListItemTable.queryItemsByCategory(category, (list: ShoppingItem[] | undefined) => {
            if (list === undefined) {
              failed = true;
            } else {
              this.setCategoryList(category, list);
            }
            remaining--;
            if (remaining === 0) {
              this.loadError = failed;
              this.isLoading = false;
            }
          });
        });
      });
  }

  // aboutToDisappear() {
  //   this.dialogController = null // 将dialogController置空
  //   this.reminderDialogueController = null;
  //   this.reminderModificationController = null;
  // }

  build() {
    Column() {
      Row() {
        Column() {
          Text('My List')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          Text(this.totalItemCount() == 0 ? '0 items' : this.totalDoneCount() + ' of ' + this.totalItemCount() + ' items bought')
            .fontSize(14)
            .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start).layoutWeight(1)

        Button('+ Add')
          .height(44)
          .fontSize(15)
          .fontWeight(FontWeight.Medium)
          .fontColor('#FFFFFF')
          .backgroundColor('#6024B5')
          .borderRadius(14)
          .onClick(() => {
            if (this.dialogController != null) {
              this.dialogController.open();
            }
          })
      }
      .width('100%')
      .padding({ left: 22, right: 22, top: 22, bottom: 14 })

      Row() {
        Text('Dark mode')
          .fontSize(14)
          .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        Toggle({ type: ToggleType.Switch, isOn: !this.isDay })
          .selectedColor(Constants.DARK_SWITCH_SELECTED_COLOR)
          .switchPointColor(Constants.LIGHT_SWITCH_POINTER_COLOR)
          .margin({ left: 8 })
          .onChange((isOn: boolean) => {
            this.isDay = !isOn;
            this.dayTimeBackColor = this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR;
          })
        Blank()
        if (this.availableCate.length > 0) {
          Button('Clear list')
            .fontSize(14)
            .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
            .backgroundColor(Color.Transparent)
            .onClick(() => {
              this.reminderDialogueController.open();
            })
        }
      }
      .width('100%')
      .height(48)
      .padding({ left: 22, right: 22 })

      if (this.isLoading) {
        Column() {
          Text('Loading list…')
            .fontSize(16)
            .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.loadError) {
        Column() {
          Text('Could not load your list')
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          Button('Try again')
            .height(44)
            .margin({ top: 18 })
            .fontColor('#FFFFFF')
            .backgroundColor('#6024B5')
            .borderRadius(14)
            .onClick(() => {
              this.isLoading = true;
              this.aboutToAppear();
            })
        }.width('100%').layoutWeight(1).justifyContent(FlexAlign.Center)
      } else if (this.availableCate.length > 0) {
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
                        },
                        onDeleteItem: (currentSelection: number, selectionCategory: string) => {
                          this.onDeleteItem(currentSelection, selectionCategory);
                        }
                      })
                    }
                  })
                }
              } else if (category == 'Clothing') {
                if (!this.isFolded[3]) {
                  ForEach(this.clothingList, (item: ShoppingItem, index: number) => {
                    ListItem() {
                      ShoppingListItem({
                        shoppingItem: item,
                        index: index,
                        isDay: this.isDay,
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
                        selectionColor: item.done ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        doneColor: item.done ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') : (this.isDay ? '#FFFFFF' : '#22113D'),
                        onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => {
                          this.onEditItem(currentSelection, selectionCategory, changedValue, changedParameter, oldName ?? '', onComplete ?? (() => {}));
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
        .layoutWeight(1)
        .padding({ left: 16, right: 16, bottom: 24 })
        .scrollBar(BarState.Auto)
      } else {
        Column() {
          Text('Your list is empty')
            .fontSize(22)
            .fontWeight(FontWeight.Bold)
            .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          Text('Add an item to start your list.')
            .fontSize(15)
            .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
            .margin({ top: 8, bottom: 20 })
          Button('Add item')
            .height(44)
            .fontSize(15)
            .fontColor('#FFFFFF')
            .backgroundColor('#6024B5')
            .borderRadius(14)
            .onClick(() => {
              if (this.dialogController != null) {
                this.dialogController.open();
              }
            })
        }
        .width('100%')
        .layoutWeight(1)
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }.width('100%').height('100%').justifyContent(FlexAlign.Start).backgroundColor(this.dayTimeBackColor)

  }

  @Builder
  itemHead(category: string) {
    Flex({ justifyContent: FlexAlign.Start, direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Row() {
        if (category == 'Vegetable') {
          Row() {
            Image(this.isFolded[0] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.vege')).width(20).height(20).margin({ left: 5 })
        } else if (category == 'Fruit') {
          Row() {
            Image(this.isFolded[1] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.fruit')).width(20).height(20).margin({ left: 5 })
        } else if (category == 'Food') {
          Row() {
            Image(this.isFolded[2] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.food')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'Clothing') {
          Row() {
            Image(this.isFolded[3] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.clothing')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'Jewelry') {
          Row() {
            Image(this.isFolded[4] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.jewelry')).width(20).height(20).margin({ left: 5 })
        }
        else if (category == 'HomeFurnishing') {
          Row() {
            Image(this.isFolded[5] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)
          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.furniture')).width(20).height(20).margin({ left: 5 })
        }
        else {
          Row() {
            Image(this.isFolded[6] ? (this.isDay ? $r('app.media.right_dark') : $r('app.media.right_light')) : (this.isDay ? $r('app.media.down_dark') : $r('app.media.down_light')))
              .width(10).height(10)

          }
          .width(20)
          .height(20)

          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)

          Image($r('app.media.goods')).width(20).height(20).margin({ left: 5 })
        }

        Text(Constants.categoryLabel(category))
          .fontSize(17)
          .fontWeight(FontWeight.Medium)
          .margin({ left: 10 })
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
      }
      .width('70%')
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
        } else if (category == 'Clothing') {
          Text(String(this.clothingDoneCount)) {
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
        else if (category == 'Clothing') {
          Text(String(this.clothingTotalCount)) {
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
      }.width('30%')
      .alignItems(VerticalAlign.Center).justifyContent(FlexAlign.End)
    }
    .width('100%')
    .height(58)
    .padding({ left: 14, right: 14 })
    .margin({ top: 14 })
    .backgroundColor(this.isDay ? '#FFFFFF' : '#22113D')
    .borderRadius(16)
    .onClick(() => {
      this.toggleCategory(category);
    })
  }

  toggleCategory(category: string): void {
    let index: number = Constants.CATEGORY_KEYS.indexOf(category);
    if (index >= 0) {
      let folded: boolean[] = [...this.isFolded];
      folded[index] = !folded[index];
      this.isFolded = folded;
    }
  }

  totalItemCount(): number {
    return this.vegetablesTotalCount + this.fruitTotalCount + this.foodTotalCount + this.clothingTotalCount +
      this.jewelryTotalCount + this.homeFurnishingTotalCount + this.otherTotalCount;
  }

  totalDoneCount(): number {
    return this.vegetablesDoneCount + this.fruitDoneCount + this.foodDoneCount + this.clothingDoneCount +
      this.jewelryDoneCount + this.homeFurnishingDoneCount + this.otherDoneCount;
  }

  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: AddItemDialogue({
      showReminderName: $showReminderName,
      isDay: this.isDay,
      // cancel: () => {
      //   this.onCancel()
      // },
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
      case 'Clothing':
        this.reactiveRefreshList(this.clothingList, name, quantity, item, 'Clothing');
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

  reminderModificationController: CustomDialogController = new CustomDialogController({
    builder: ReminderModification({
      isDay: this.isDay,
      cancelModification: () => {
        this.onCancelModification()
      },
      confirmModification: () => {
        this.onConfirmModification()
      },
    })
  })

  onCancelModification() {
    this.modificationCallback(false);
  }

  onConfirmModification() {
    const source: ShoppingItem = this.modificationItems[this.modificationItemIndex];
    const replacement = new ShoppingItem(this.modifiedName, source.quantity, source.done, source.category);
    this.shoppingListItemTable.renameItem(source, replacement, true, (success: boolean) => {
      if (success) {
        const list: ShoppingItem[] = [...this.modificationItems];
        list[this.modificationItemIndex] = replacement;
        list.splice(this.beforeModificationItemIndex, 1);
        this.setCategoryList(this.modificationCategory, list);
      } else {
        this.showStorageError();
      }
      this.modificationCallback(success);
    });
  }

  reminderDialogueController: CustomDialogController = new CustomDialogController({
    builder: ReminderDialogue({
      isDay: this.isDay,
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
    this.shoppingListItemTable.deleteAll((rows: number | undefined) => {
      if (rows === undefined) {
        this.showStorageError();
        return;
      }
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
      this.clothingTotalCount = 0;
      this.clothingDoneCount = 0;
      this.clothingList = [];
      this.jewelryTotalCount = 0;
      this.jewelryDoneCount = 0;
      this.jewelryList = [];
      this.homeFurnishingTotalCount = 0;
      this.homeFurnishingDoneCount = 0;
      this.homeFurnishingList = [];
      this.otherTotalCount = 0;
      this.otherDoneCount = 0;
      this.otherList = [];
    })
  }

  changeName(tempList: ShoppingItem[], currentSelection: number, selectionCategory: string,
    changedValue: string, currentSelectionItem: ShoppingItem, callback: (success: boolean) => void) {
    const duplicateIndex: number = tempList.findIndex((item: ShoppingItem, index: number) =>
      index !== currentSelection && item.name === changedValue);
    if (duplicateIndex >= 0) {
      this.modificationItems = [...tempList];
      this.modifiedName = changedValue;
      this.modificationCategory = selectionCategory;
      this.modificationItemIndex = currentSelection;
      this.beforeModificationItemIndex = duplicateIndex;
      this.modificationCallback = callback;
      this.reminderModificationController.open();
      return;
    }
    const renamed = new ShoppingItem(changedValue, currentSelectionItem.quantity,
      currentSelectionItem.done, selectionCategory);
    this.shoppingListItemTable.renameItem(currentSelectionItem, renamed, false, (success: boolean) => {
      if (success) {
        tempList[currentSelection] = renamed;
        this.setCategoryList(selectionCategory, tempList);
      } else {
        this.showStorageError();
      }
      callback(success);
    });
  }

  changeQuantity(tempList: ShoppingItem[], currentSelection: number, selectionCategory: string,
    quantity: number, callback: (success: boolean) => void) {
    const currentItem = tempList[currentSelection];
    const updated = new ShoppingItem(currentItem.name, quantity, currentItem.done, selectionCategory);
    this.shoppingListItemTable.updateItem(updated, (rows: number | undefined) => {
      const success: boolean = rows === 1;
      if (success) {
        tempList[currentSelection] = updated;
        this.setCategoryList(selectionCategory, tempList);
      } else {
        this.showStorageError();
      }
      callback(success);
    });
  }

  changeDone(tempList: ShoppingItem[], currentSelection: number, selectionCategory: string,
    done: boolean, callback: (success: boolean) => void) {
    const currentItem = tempList[currentSelection];
    const updated = new ShoppingItem(currentItem.name, currentItem.quantity, done, selectionCategory);
    this.shoppingListItemTable.updateItem(updated, (rows: number | undefined) => {
      const success: boolean = rows === 1;
      if (success) {
        tempList[currentSelection] = updated;
        this.setCategoryList(selectionCategory, tempList);
      } else {
        this.showStorageError();
      }
      callback(success);
    });
  }

  onEditItem(currentSelection: number, selectionCategory: string, changedValue: string,
    changedParameter: string, oldName: string, callback: (success: boolean) => void = () => {}) {
    const tempList: ShoppingItem[] = this.getCategoryList(selectionCategory);
    if (currentSelection < 0 || currentSelection >= tempList.length) {
      callback(false);
      return;
    }
    if (changedParameter === 'name') {
      this.changeName(tempList, currentSelection, selectionCategory, changedValue,
        tempList[currentSelection], callback);
    } else if (changedParameter === 'quantity') {
      this.changeQuantity(tempList, currentSelection, selectionCategory, Number(changedValue), callback);
    } else {
      this.changeDone(tempList, currentSelection, selectionCategory, changedValue === 'true', callback);
    }
  }

  onDeleteItem(currentSelection: number, selectionCategory: string) {
    const list: ShoppingItem[] = this.getCategoryList(selectionCategory);
    if (currentSelection < 0 || currentSelection >= list.length) {
      return;
    }
    this.shoppingListItemTable.deleteItem(list[currentSelection], (rows: number | undefined) => {
      if (rows === 1) {
        list.splice(currentSelection, 1);
        this.setCategoryList(selectionCategory, list);
      } else {
        this.showStorageError();
      }
    });
  }

  getCategoryList(category: string): ShoppingItem[] {
    switch (category) {
      case 'Vegetable': return [...this.vegetableList];
      case 'Fruit': return [...this.fruitList];
      case 'Food': return [...this.foodList];
      case 'Clothing': return [...this.clothingList];
      case 'Jewelry': return [...this.jewelryList];
      case 'HomeFurnishing': return [...this.homeFurnishingList];
      default: return [...this.otherList];
    }
  }

  setCategoryList(category: string, list: ShoppingItem[]) {
    switch (category) {
      case 'Vegetable':
        this.vegetableList = [...list];
        this.getVegetableCount(list);
        break;
      case 'Fruit':
        this.fruitList = [...list];
        this.getFruitCount(list);
        break;
      case 'Food':
        this.foodList = [...list];
        this.getFoodCount(list);
        break;
      case 'Clothing':
        this.clothingList = [...list];
        this.getClothingCount(list);
        break;
      case 'Jewelry':
        this.jewelryList = [...list];
        this.getJewelryCount(list);
        break;
      case 'HomeFurnishing':
        this.homeFurnishingList = [...list];
        this.getHomeFurnishingCount(list);
        break;
      default:
        this.otherList = [...list];
        this.getOtherCount(list);
        break;
    }
    if (list.length === 0) {
      if (this.availableCate.includes(category)) {
        this.removeCate(category);
      }
    } else if (!this.availableCate.includes(category)) {
      this.initCategory(category);
    }
  }

  showStorageError() {
    try {
      this.getUIContext().getPromptAction().showToast({ message: 'Could not save your list.' });
    } catch (error) {
      console.error('Unable to display storage error');
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

  getClothingCount(list: ShoppingItem[]) {
    this.clothingTotalCount = list.length;
    this.clothingDoneCount = list.filter((item) => item.done).length;
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
      for (let i = 0; i < list.length; i++) {
        if (name == list[i].name) {
          exists = true;
          break;
        }
      }
    }
    if (!exists) {
      this.showReminderName = false;
      this.shoppingListItemTable.insertItem(item, (rowId: number | undefined) => {
        if (rowId !== undefined && rowId >= 0) {
          const tempList: ShoppingItem[] = this.getCategoryList(category);
          tempList.push(item);
          this.setCategoryList(category, tempList);
        } else {
          this.showStorageError();
        }
      })
    } else {
      this.showReminderName = true;
    }
  }

}
