@CustomDialog
@Component
export struct ReminderModification {
  cancelModification?: () => void
  confirmModification?: () => void
  controller: CustomDialogController = new CustomDialogController({
    builder: ReminderModification({}),
  })

  build() {
    Column() {
      Text('There is one item found in the same name,\n Do you want to replace it?')
        .fontSize(14)
        .margin({ top: 20, bottom: 20 }).textAlign(TextAlign.Center).lineHeight(20)
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('No')
          .fontSize(15)
          .onClick(() => {
            this.controller.close()
            if (this.cancelModification) {
              this.cancelModification()
            }
          })
          .fontColor('#FFF2F2')
          .backgroundColor("#FAB0B0")
          .width(60)
        Button('Yes')
          .fontSize(15)
          .onClick(() => {
            this.controller.close()
            if (this.confirmModification) {
              this.confirmModification()
            }
          })
          .fontColor('#2C1F1F')
          .backgroundColor('#EBEBEB')
          .width(60)
      }.margin({ bottom: 15 })
    }
  }
}