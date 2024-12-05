@CustomDialog
@Component
export struct ReminderDialogue {
  cancelDeleteAll?: () => void
  confirmDeleteAll?: () => void
  controller: CustomDialogController = new CustomDialogController({
    builder: ReminderDialogue({}),
  })

  build() {
    Column() {
      Text('Are you sure to delete all?')
        .fontSize(16)
        .margin({ top: 20, bottom: 20 })
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('No')
          .fontSize(15)
          .onClick(() => {
            this.controller.close()
            if (this.cancelDeleteAll) {
              this.cancelDeleteAll()
            }
          })
          .fontColor('#FFF2F2')
          .backgroundColor("#FAB0B0")
          .width(60)
        Button('Yes')
          .fontSize(15)
          .onClick(() => {
            this.controller.close()
            if (this.confirmDeleteAll) {
              this.confirmDeleteAll()
            }
          })
          .fontColor('#2C1F1F')
          .backgroundColor('#EBEBEB')
          .width(60)
      }.margin({ bottom: 10 })
    }
  }
}