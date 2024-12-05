import promptAction from '@ohos.promptAction';
import Constants from '../Constants';
import ShoppingItem from '../../model/ShoppingItem'

@Component
export struct ShoppingListItem {
  @Prop isDay: boolean;
  @State shoppingItem: ShoppingItem = new ShoppingItem('', 1, false, 'Food');
  @State oldQuantity: number = this.shoppingItem.quantity;
  @State oldName: string = this.shoppingItem.name;
  @State defaultQuantity: string = '1';
  @State index: number = 0;
  @Prop selectionColor: string;
  @State widthDel: number = 0;
  @State heightDel: number = 0;
  @State done: boolean = false;
  @Prop doneColor: string;
  @State focusableName: boolean = false;
  @State focusableQuantity: boolean = false;
  onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string, changedParameter: string, oldName?: string) => void
  onDeleteItem: (currentSelection: number, selectionCategory: string) => void

  aboutToAppear() {
    this.oldName = this.shoppingItem.name;
  }

  getColor(category) {
    switch (category) {
      case 'Vegetable':
        return Constants.ITEM_COLORS[0];
        break;
      case 'Fruit':
        return Constants.ITEM_COLORS[1];
        break;
      case 'Food':
        return Constants.ITEM_COLORS[2];
        break;
      case 'Cloth':
        return Constants.ITEM_COLORS[3];
        break;
      case 'Jewelry':
        return Constants.ITEM_COLORS[4];
        break;
      case 'HomeFurnishing':
        return Constants.ITEM_COLORS[5];
        break;
      default:
        return Constants.ITEM_COLORS[6];
        break;
    }
  }

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {

      TextInput({ placeholder: this.shoppingItem.name, text: this.shoppingItem.name })
        .width(150)
        .height('100%')
        .fontSize(15)
        .padding(2)
        .backgroundColor(this.doneColor)
        .fontColor(this.getColor(this.shoppingItem.category))
        .onChange((value: string) => {
          if (/^[0-9a-zA-Z\s.%]*$/.test(value)) {
            this.shoppingItem.name = value.trim();
          } else {
            promptAction.showToast({
              message: '* Item name contains letters, space,. and % only',
              duration: 3000,
              bottom: '80%'
            });
            this.shoppingItem.name = this.oldName;
          }
        })
        .onSubmit(() => {
          if (this.shoppingItem.name == '') {
            promptAction.showToast({
              message: '* Item name cannot be empty',
              duration: 3000,
              bottom: '80%'
            });
            this.shoppingItem.name = this.oldName;
          } else if (this.oldName == this.shoppingItem.name) {
            promptAction.showToast({
              message: '* Item name is not changed',
              duration: 3000,
              bottom: '80%'
            });
            this.shoppingItem.name = this.oldName;
          } else {
            this.onEditItem(this.index, this.shoppingItem.category, this.shoppingItem.name, 'name', this.oldName);
            this.oldName = this.shoppingItem.name;
          }
        })

      TextInput({
        placeholder: String(this.shoppingItem.quantity),
        text: String(this.shoppingItem.quantity),
      })
        .width(150)
        .height('100%')
        .padding(2)
        .fontSize(15)
        .backgroundColor(this.doneColor)
        .fontColor(this.getColor(this.shoppingItem.category))
        .inputFilter('[0-9]', () => {
        })
        .onChange((value: string) => {
          if (Number(value.trim()) > 10000 || Number(value.trim()) <= 0) {
            promptAction.showToast({
              message: '* Quantity max 10000, min 1.',
              duration: 3000,
              bottom: '80%'
            });
            this.shoppingItem.quantity = this.oldQuantity;
          } else {
            this.shoppingItem.quantity = Number(value.trim());
          }
        })
        .onSubmit((event: EnterKeyType) => {
          if(this.shoppingItem.quantity <= 10000 && this.shoppingItem.quantity>0 && this.oldQuantity != this.shoppingItem.quantity){
            this.onEditItem(this.index, this.shoppingItem.category, String(this.shoppingItem.quantity), 'quantity');
          }else{
            promptAction.showToast({
              message: '* Quantity max 10000, min 1.',
              duration: 3000,
              bottom: '80%'
            });
            this.shoppingItem.quantity = this.oldQuantity;
            this.oldQuantity=this.shoppingItem.quantity;
          }
        })

      Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
        Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
          .width(13)
          .height(13)
          .select(this.shoppingItem.done)
          .selectedColor(Constants.ITEM_DONE_CHECKBOX_COLOR)
          .onChange((value: boolean) => {
            this.done = value;
            this.onEditItem(this.index, this.shoppingItem.category, value + '', 'done');
            if (value) {
              this.selectionColor = Constants.ITEM_SELECTION_COLOR1;
              this.doneColor = Constants.ITEM_DONE_COLOR1;
            } else {
              this.selectionColor = this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR;
              this.doneColor = this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR;
            }
          })
      }.width(30).height('100%')


      Text(String(this.index)).width(0).height(0)

      Text('Delete')
        .width(this.widthDel)
        .height(this.heightDel)
        .fontColor(Constants.ITEM_DONE_COLOR1)
        .fontSize(15)
        .onClick(() => {
          this.onDeleteItem(this.index, this.shoppingItem.category);
        })
        .backgroundColor('#FF6F6F')
        .textAlign(TextAlign.Center)
        .border({ radius: 10 })
        .margin({ left: 15 })
    }
    .backgroundColor(this.selectionColor)
    .width('100%')
    .height(25)
    .padding({ left: 30, right: 30 })
    .gesture(
      PanGesture({ direction: PanDirection.Horizontal })
        .onActionEnd((event: GestureEvent) => {
          if (event) {
            console.log("event.offsetX" + event.offsetX);
            if (event.offsetX < 0) {
              this.heightDel = 22;
              this.widthDel = 60;
              this.selectionColor = Constants.ITEM_DELETE_COLOR;
              this.doneColor = Constants.ITEM_DELETE_COLOR;
            } else {
              this.heightDel = 0;
              this.widthDel = 0;
              this.selectionColor = this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR;
              this.doneColor = this.isDay ? Constants.LIGHT_BACKGROUND_COLOR : Constants.DARK_BACKGROUND_COLOR;
            }
          }
        })
    )
  }
}