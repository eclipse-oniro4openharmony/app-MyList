import Constants from '../Constants';
import ShoppingItem from '../../model/ShoppingItem'

@Component
export struct ShoppingListItem {
  @Prop isDay: boolean;
  @Watch('syncDrafts') @Prop shoppingItem: ShoppingItem = new ShoppingItem('', 1, false, 'Food');
  @State oldQuantity: number = this.shoppingItem.quantity;
  @State oldName: string = this.shoppingItem.name;
  @State editName: string = this.shoppingItem.name;
  @State editQuantity: string = String(this.shoppingItem.quantity);
  private namePending: boolean = false;
  private quantityPending: boolean = false;
  @Prop index: number = 0;
  @Prop selectionColor: string;
  @State widthDel: number = 0;
  @State heightDel: number = 0;
  @Prop doneColor: string;
  private regex: RegExp = new RegExp('^[0-9a-zA-Z\\s.%]*$');
  onEditItem: (currentSelection: number, selectionCategory: string, changedValue: string,
    changedParameter: string, oldName?: string, onComplete?: (success: boolean) => void) => void = () => {};
  onDeleteItem: (currentSelection: number, selectionCategory: string) => void = () => {};

  aboutToAppear() {
    this.syncDrafts();
  }

  syncDrafts() {
    if (this.namePending || this.quantityPending || this.editName !== this.oldName ||
      this.editQuantity !== String(this.oldQuantity)) {
      return;
    }
    this.oldName = this.shoppingItem.name;
    this.oldQuantity = this.shoppingItem.quantity;
    this.editName = this.shoppingItem.name;
    this.editQuantity = String(this.shoppingItem.quantity);
  }

  showValidationError(message: string) {
    try {
      this.getUIContext().getPromptAction().showToast({ message: message });
    } catch (error) {
      console.error('Unable to display validation error');
    }
  }

  commitName() {
    if (this.namePending || this.editName === this.oldName) {
      return;
    }
    const name: string = this.editName.trim();
    if (name.length === 0 || !this.regex.test(name)) {
      this.editName = this.oldName;
      this.showValidationError('Enter a valid item name.');
      return;
    }
    this.namePending = true;
    this.onEditItem(this.index, this.shoppingItem.category, name, 'name', this.oldName, (success: boolean) => {
      this.namePending = false;
      if (success) {
        this.oldName = name;
        this.editName = name;
      } else {
        this.editName = this.oldName;
      }
    });
  }

  commitQuantity() {
    if (this.quantityPending || this.editQuantity === String(this.oldQuantity)) {
      return;
    }
    const quantity: number = Number(this.editQuantity);
    if (!/^[1-9][0-9]*$/.test(this.editQuantity) || quantity > 10000) {
      this.editQuantity = String(this.oldQuantity);
      this.showValidationError('Enter a quantity from 1 to 10000.');
      return;
    }
    this.quantityPending = true;
    this.onEditItem(this.index, this.shoppingItem.category, String(quantity), 'quantity', undefined,
      (success: boolean) => {
        this.quantityPending = false;
        if (success) {
          this.oldQuantity = quantity;
          this.editQuantity = String(quantity);
        } else {
          this.editQuantity = String(this.oldQuantity);
        }
      });
  }

  getColor(category: string) {
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
      case 'Clothing':
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

      TextInput({ placeholder: this.oldName, text: this.editName })
        .layoutWeight(1)
        .height('100%')
        .fontSize(16)
        .padding({ left: 6, right: 6 })
        .backgroundColor(this.doneColor)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .placeholderColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        .onChange((value: string) => {
          if (this.regex.test(value)) {
            this.editName = value;
          } else {
            this.getUIContext().getPromptAction().showToast({
              message: '* Item name contains letters, space,. and % only',
              duration: 3000,
              bottom: '80%'
            })
            this.editName = this.oldName;
          }
        })
        .onSubmit(() => {
          this.commitName();
        })
        .onBlur(() => { this.commitName(); })

      TextInput({
        placeholder: String(this.oldQuantity),
        text: this.editQuantity,
      })
        .width(54)
        .height('100%')
        .padding(2)
        .fontSize(15)
        .textAlign(TextAlign.Center)
        .backgroundColor(this.doneColor)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .placeholderColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        .inputFilter('[0-9]', () => {
        })
        .onChange((value: string) => {
          this.editQuantity = value;
        })
        .onSubmit(() => {
          this.commitQuantity();
        })
        .onBlur(() => { this.commitQuantity(); })

      Flex({ justifyContent: FlexAlign.End, alignItems: ItemAlign.Center }) {
        Checkbox({ name: 'checkbox1', group: 'checkboxGroup' })
          .width(24)
          .height(24)
          .select(this.shoppingItem.done)
          .selectedColor(Constants.ITEM_DONE_CHECKBOX_COLOR)
          .onChange((value: boolean) => {
            this.onEditItem(this.index, this.shoppingItem.category, value + '', 'done', undefined,
              (success: boolean) => {
                if (success) {
                  this.selectionColor = value ? (this.isDay ? Constants.ITEM_SELECTION_COLOR1 : '#35204F') :
                    (this.isDay ? '#FFFFFF' : '#22113D');
                  this.doneColor = value ? (this.isDay ? Constants.ITEM_DONE_COLOR1 : '#35204F') :
                    (this.isDay ? '#FFFFFF' : '#22113D');
                }
              });
          })
      }.width(40).height('100%')


      Text(String(this.index)).width(0).height(0)

      Text('Delete')
        .width(this.widthDel)
        .height(this.heightDel)
        .fontColor('#FFFFFF')
        .fontSize(14)
        .onClick(() => {
          this.onDeleteItem(this.index, this.shoppingItem.category);
        })
        .backgroundColor('#C51D72')
        .textAlign(TextAlign.Center)
        .border({ radius: 10 })
        .margin({ left: 8 })
    }
    .backgroundColor(this.selectionColor)
    .width('100%')
    .height(62)
    .padding({ left: 12, right: 10 })
    .margin({ top: 3 })
    .borderRadius(14)
    .gesture(
      PanGesture({ direction: PanDirection.Horizontal })
        .onActionEnd((event: GestureEvent) => {
          if (event) {
            console.log("event.offsetX" + event.offsetX);
            if (event.offsetX < 0) {
              this.heightDel = 36;
              this.widthDel = 70;
              this.selectionColor = this.isDay ? Constants.ITEM_DELETE_COLOR : '#4A173D';
              this.doneColor = this.isDay ? Constants.ITEM_DELETE_COLOR : '#4A173D';
            } else {
              this.heightDel = 0;
              this.widthDel = 0;
              this.selectionColor = this.isDay ? '#FFFFFF' : '#22113D';
              this.doneColor = this.isDay ? '#FFFFFF' : '#22113D';
            }
          }
        })
    )
  }
}
