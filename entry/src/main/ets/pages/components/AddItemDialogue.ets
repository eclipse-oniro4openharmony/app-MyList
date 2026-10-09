import inputMethod from '@ohos.inputMethod';
import Constants from '../Constants';

@CustomDialog
@Component
export struct AddItemDialogue {
  @Link showReminderName: boolean;
  @State showReminderNamePatten: boolean = false;
  @State showReminderQuality: boolean = false;
  @State category: string = 'Food';
  @State name: string = '';
  @State quantity: number = 1;
  @State selected: number = 2;
  @Prop isDay: boolean;
  cancel: () => void = () => {};
  confirm: (category: string, name: string, quantity: number) => void = () => {};
  controller: CustomDialogController = new CustomDialogController({
    builder: AddItemDialogue({ showReminderName: this.showReminderName, isDay: this.isDay })
  });
  private regex1: RegExp = new RegExp('^[0-9a-zA-Z\\s.%]+$');
  private regex2: RegExp = new RegExp('^((?!0)\\d{1,5}|10000)$');

  build() {
    Scroll() {
      Column() {
      Row() {
        Text('Add item')
          .fontSize(22).fontWeight(FontWeight.Bold)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .layoutWeight(1)
        Button('Close')
          .fontSize(14)
          .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
          .backgroundColor(Color.Transparent)
          .onClick(() => { this.controller.close(); })
      }.width('100%').margin({ bottom: 10 })

      Text('Category')
        .fontSize(14).fontWeight(FontWeight.Medium)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .width('100%').margin({ bottom: 4 })
      Select([{ value: Constants.CATEGORY_LABELS[0], icon: $r('app.media.vege') },
        { value: Constants.CATEGORY_LABELS[1], icon: $r('app.media.fruit') },
        { value: Constants.CATEGORY_LABELS[2], icon: $r('app.media.food') },
        { value: Constants.CATEGORY_LABELS[3], icon: $r('app.media.clothing') },
        { value: Constants.CATEGORY_LABELS[4], icon: $r('app.media.jewelry') },
        { value: Constants.CATEGORY_LABELS[5], icon: $r('app.media.furniture') },
        { value: Constants.CATEGORY_LABELS[6], icon: $r('app.media.goods') }])
        .value(Constants.categoryLabel(this.category)).selected(this.selected)
        .font({ size: 15 })
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
        .optionFont({ size: 15 })
        .optionFontColor(Constants.DARK_TEXT_COLOR)
        .optionBgColor('#FFFFFF')
        .selectedOptionFont({ size: 15 })
        .selectedOptionFontColor('#6024B5')
        .selectedOptionBgColor('#EEE4FA')
        .width('100%').height(40).borderRadius(12)
        .onSelect((index: number, value: string) => {
          this.selected = index;
          this.category = Constants.CATEGORY_KEYS[index];
        })

      Text('Name')
        .fontSize(14).fontWeight(FontWeight.Medium)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .width('100%').margin({ top: 10, bottom: 4 })
      TextInput({ placeholder: 'What do you need?', text: this.name })
        .height(40).width('100%').fontSize(15)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .placeholderColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
        .borderRadius(12)
        .onChange((value: string) => {
          this.name = value.trim();
          this.showReminderNamePatten = this.name.length > 0 && !this.regex1.test(this.name);
          this.showReminderName = false;
        })
      if (this.showReminderNamePatten || this.showReminderName) {
        Text(this.showReminderName ? 'This item is already in the category.' : 'Enter a name using letters, numbers, spaces, . or %.')
          .fontSize(12).fontColor('#C51D72').width('100%').margin({ top: 6 })
      }

      Text('Quantity')
        .fontSize(14).fontWeight(FontWeight.Medium)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .width('100%').margin({ top: 10, bottom: 4 })
      TextInput({ placeholder: '1', text: String(this.quantity) })
        .height(40).width('100%').fontSize(15)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .placeholderColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_FORM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_FORM_BACKGROUND_COLOR)
        .borderRadius(12)
        .inputFilter('[0-9]', () => {})
        .onChange((value: string) => {
          this.showReminderQuality = !this.regex2.test(value) || Number(value) > 10000;
          if (!this.showReminderQuality) {
            this.quantity = Number(value);
          }
        })
      if (this.showReminderQuality) {
        Text('Enter a quantity from 1 to 10000.')
          .fontSize(12).fontColor('#C51D72').width('100%').margin({ top: 6 })
      }

      Row() {
        Button('Cancel')
          .layoutWeight(1).height(42)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_CANCEL_BUTTON_BACKGROUND_COLOR : Constants.DARK_ADD_CANCEL_BUTTON_BACKGROUND_COLOR)
          .borderRadius(12)
          .onClick(() => { this.controller.close(); })
        Button('Add item')
          .layoutWeight(1).height(42).margin({ left: 10 })
          .fontColor('#FFFFFF').backgroundColor('#6024B5').borderRadius(12)
          .onClick(() => {
            this.showReminderNamePatten = this.name.length == 0 || !this.regex1.test(this.name);
            if (!this.showReminderNamePatten && !this.showReminderQuality) {
              this.confirm(this.category, this.name, this.quantity);
              if (!this.showReminderName) {
                inputMethod.getController().stopInputSession();
                this.controller.close();
                this.name = '';
                this.quantity = 1;
                this.category = 'Food';
                this.selected = 2;
              }
            }
          })
      }.width('100%').margin({ top: 12 })
      }
      .width('100%').padding(14).alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .constraintSize({ maxHeight: 350 })
    .scrollBar(BarState.Auto)
    .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_BACKGROUND_COLOR)
    .borderRadius(22)
  }
}
