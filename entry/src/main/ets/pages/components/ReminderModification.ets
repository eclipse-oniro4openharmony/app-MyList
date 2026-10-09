import Constants from '../Constants';

@CustomDialog
@Component
export struct ReminderModification {
  @Prop isDay: boolean = true;
  cancelModification?: () => void;
  confirmModification?: () => void;
  controller: CustomDialogController = new CustomDialogController({
    builder: ReminderModification({}),
  });

  build() {
    Column() {
      Text('Replace item?')
        .fontSize(21).fontWeight(FontWeight.Bold)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .width('100%')
      Text('An item with this name already exists. Replace it?')
        .fontSize(14)
        .fontColor(this.isDay ? Constants.DARK_TEXT_SUBTITLE_COLOR : Constants.LIGHT_TEXT_SUBTITLE_COLOR)
        .width('100%').margin({ top: 10, bottom: 24 })
      Row() {
        Button('Cancel')
          .layoutWeight(1).height(44)
          .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
          .backgroundColor(this.isDay ? Constants.LIGHT_ADD_CANCEL_BUTTON_BACKGROUND_COLOR : Constants.DARK_ADD_CANCEL_BUTTON_BACKGROUND_COLOR)
          .borderRadius(12)
          .onClick(() => {
            this.controller.close();
            if (this.cancelModification) { this.cancelModification(); }
          })
        Button('Replace')
          .layoutWeight(1).height(44).margin({ left: 10 })
          .fontColor('#FFFFFF').backgroundColor('#6024B5').borderRadius(12)
          .onClick(() => {
            this.controller.close();
            if (this.confirmModification) { this.confirmModification(); }
          })
      }.width('100%')
    }
    .width('100%').padding(22).alignItems(HorizontalAlign.Start)
    .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_BACKGROUND_COLOR)
    .borderRadius(22)
  }
}
