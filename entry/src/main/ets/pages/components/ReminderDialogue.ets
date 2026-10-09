import Constants from '../Constants';

@CustomDialog
@Component
export struct ReminderDialogue {
  @Prop isDay: boolean = true;
  cancelDeleteAll?: () => void;
  confirmDeleteAll?: () => void;
  controller: CustomDialogController = new CustomDialogController({
    builder: ReminderDialogue({}),
  });

  build() {
    Column() {
      Text('Clear list?')
        .fontSize(21).fontWeight(FontWeight.Bold)
        .fontColor(this.isDay ? Constants.DARK_TEXT_COLOR : Constants.LIGHT_TEXT_COLOR)
        .width('100%')
      Text('This removes every item from your list.')
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
            if (this.cancelDeleteAll) { this.cancelDeleteAll(); }
          })
        Button('Clear list')
          .layoutWeight(1).height(44).margin({ left: 10 })
          .fontColor('#FFFFFF').backgroundColor('#C51D72').borderRadius(12)
          .onClick(() => {
            this.controller.close();
            if (this.confirmDeleteAll) { this.confirmDeleteAll(); }
          })
      }.width('100%')
    }
    .width('100%').padding(22).alignItems(HorizontalAlign.Start)
    .backgroundColor(this.isDay ? Constants.LIGHT_ADD_ITEM_BACKGROUND_COLOR : Constants.DARK_ADD_ITEM_BACKGROUND_COLOR)
    .borderRadius(22)
  }
}
