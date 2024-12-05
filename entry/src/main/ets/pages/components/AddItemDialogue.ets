import inputMethod from '@ohos.inputMethod';
import Constants from '../Constants';

@CustomDialog
@Component
export struct AddItemDialogue {
  @Link showReminderName: boolean;
  @State showReminderNamePatten: boolean = false;
  @State showReminderQuality: boolean = false;
  @State category: string = 'Food';
  @State name: string = 'bread';
  @State quantity: number = 1;
  @State selected: number = 1;
  @Prop isDay: boolean;
  controller?: CustomDialogController;
  cancel: () => void;
  confirm: (category: string, name: string, quantity: number) => void;
  textController: TextInputController = new TextInputController()

  build() {
    Flex({ justifyContent: FlexAlign.SpaceAround, direction: FlexDirection.Column, alignItems: ItemAlign.Center }) {
      Row() {

        Button() {
          Image($r('app.media.close')).width(20).height(20).onClick(() => {
            this.controller.close();
          })
        }
        .width(30)
        .height(30)
        .backgroundColor('#00000000')

      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.End)
      .height(40)
      .width('90%')
      .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_BACKGROUND_COLOR)
      .border({ radius: 15 })
      .margin({ top: 10 })


      Row() {
        Text('Category:')
          .fontSize(13)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .width('35%')
          .height(35)
          .padding({ left: 10 })
          .textAlign(TextAlign.Start)

        Select([{ value: 'Vegetable', icon: $r('app.media.vege') },
          { value: 'Fruit', icon: $r('app.media.fruit') },
          { value: 'Food', icon: $r('app.media.food') },
          { value: 'Cloth', icon: $r('app.media.cloth') },
          { value: 'Jewelry', icon: $r('app.media.jewelry') },
          { value: 'HomeFurnishing', icon: $r('app.media.furniture') },
          { value: 'Other', icon: $r('app.media.goods') }])
          .value(this.category.trim())
          .selected(this.selected)
          .font({ size: 12 })
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
          .selectedOptionFont({ size: 12 })
          .optionFontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .optionBgColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
          .selectedOptionBgColor(this.isDay ? Constants.LIGHT_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR : Constants.DARK_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR)
          .optionFont({ size: 12 })
          .onSelect((index: number, value: string) => {
            this.selected = index;
            this.category = value;
            console.log('category:' + value)
          })
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .height(40)
      .width('90%')
      .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
      .border({ radius: 15 })
      .margin({ top: 10 })

      Text(this.showReminderNamePatten ? 'Item name cannot be empty,only contains letters,. and % only.' : (this.showReminderName ? '* Item name added already.' : ''))
        .fontSize(13)
        .fontColor(Color.Red)
        .height(30)
        .width('90%')
        .padding({ left: 10 })

      Row() {
        Text('Name:')
          .fontSize(13)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .height(35)
          .width('35%')
          .padding({ left: 10 })
        TextInput({ placeholder: 'input name...', text: this.name.trim() })
          .height(35)
          .width('60%')
          .fontSize(12)
          .borderRadius(0)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
          .onChange((value: string) => {
            if (/^[0-9a-zA-Z\s.%]+$/.test(value)) {
              this.showReminderNamePatten = false;
              this.showReminderName = false;
              this.name = value.trim()
            } else {
              this.showReminderNamePatten = true;
            }
          })
      }
      .height(40)
      .width('90%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
      .border({ radius: 15 })

      Text(this.showReminderQuality ? '* Quantity max 10000' : '')
        .fontSize(13)
        .fontColor(Color.Red)
        .height(30)
        .width('90%')
        .padding({ left: 10 })

      Row() {
        Text('Quantity:')
          .fontSize(13)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .height('100%')
          .width('35%')
          .padding({ left: 10 })
        TextInput({ placeholder: '1', text: String(this.quantity) })
          .height(35)
          .fontSize(13)
          .width('60%')
          .borderRadius(0)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor((this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR))
          .inputFilter('[0-9]', () => {
          })
          .onChange((value: string) => {
            if ( /^((?!0)\d{1,5}|10000)$/.test(value)) {
              this.showReminderQuality = false;
              this.quantity = Number(value.trim());
            } else {
              this.showReminderQuality = true;
            }
          })
      }
      .height(40)
      .width('90%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Start)
      .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
      .border({ radius: 15 })

      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('Cancel')
          .fontSize(13)
          .onClick(() => {
            if (this.controller != undefined) {
              this.controller.close()
            }
          })
          .width(80)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_CANCEL_BUTTON_BACKGROUND_COLOR : Constants.DARK_ADD_CANCEL_BUTTON_BACKGROUND_COLOR)

        Button('OK')
          .fontSize(13)
          .onClick(() => {
            if (this.controller != undefined) {
              if (!this.showReminderNamePatten && !this.showReminderQuality) {
                this.confirm(this.category.trim(), this.name.trim(), this.quantity);
                inputMethod.getController().stopInputSession();
              }
            }
          })
          .width(80)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR : Constants.DARK_ADD_CONFIRM_BUTTON_BACKGROUND_COLOR)
      }.padding({ top: 5 }).height(40).width('90%').margin({ top:20,bottom: 20 })
    }
    .borderRadius(5)
    .width('100%')
    .height(320)
    .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_BACKGROUND_COLOR)
  }
}