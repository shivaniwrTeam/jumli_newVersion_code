# Tasks

- [x] Rename files and directories to follow dart convention (snake_case)
- [ ] Remove extension [lib/utils/extensions/textWidgetExtention.dart] and resolve its side effects
    - Builds up unnecessary overhead by creating multiple instances using copyWith constructors.
- [x] Remove extension [lib/utils/responsiveSize.dart] and resolve its side effects
    - Flutter framework automatically takes care of responsiveness when declaring static height,
      width and font. So no need to calculate them on the basis of screen size
- [ ] Figure out the use case and Maybe remove [lib/utils/touch_manager.dart]
    - Used in only one file so it would be better to create the same class private in that one file
      it is being used in
  - Associated with [lig/utils/cloud_state.dart]. No Idea what it is used for.
- [x] Unnecessary abstraction of [UiUtils.getTranslatedLabel]
  in [lib/utils/extension/translate.dart].
    - Move the code of [UiUtils.getTranslatedLabel] inside [lib/utils/extension/translate.dart] or
      just remove extension and use the method instead