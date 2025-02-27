
import 'package:core/presentation/utils/html_transformer/html_utils.dart';
import 'package:core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';

typedef OnChangeContentEditorAction = Function(String? text);
typedef OnInitialContentEditorAction = Function(String text);
typedef OnMouseDownEditorAction = Function(BuildContext context);
typedef OnEditorSettingsChange = Function(EditorSettings settings);
typedef OnImageUploadSuccessAction = Function(FileUpload fileUpload);
typedef OnImageUploadFailureAction = Function(FileUpload? fileUpload, String? base64Str, UploadError error);
typedef OnEditorTextSizeChanged = Function(int? size);

class WebEditorWidget extends StatefulWidget {

  final String content;
  final TextDirection direction;
  final HtmlEditorController editorController;
  final OnInitialContentEditorAction? onInitial;
  final OnChangeContentEditorAction? onChangeContent;
  final VoidCallback? onFocus;
  final VoidCallback? onUnFocus;
  final OnMouseDownEditorAction? onMouseDown;
  final OnEditorSettingsChange? onEditorSettings;
  final OnImageUploadSuccessAction? onImageUploadSuccessAction;
  final OnImageUploadFailureAction? onImageUploadFailureAction;
  final OnEditorTextSizeChanged? onEditorTextSizeChanged;
  final double? width;
  final double? height;

  const WebEditorWidget({
    super.key,
    required this.content,
    required this.direction,
    required this.editorController,
    this.onInitial,
    this.onChangeContent,
    this.onFocus,
    this.onUnFocus,
    this.onMouseDown,
    this.onEditorSettings,
    this.onImageUploadSuccessAction,
    this.onImageUploadFailureAction,
    this.onEditorTextSizeChanged,
    this.width,
    this.height,
  });

  @override
  State<WebEditorWidget> createState() => _WebEditorState();
}

class _WebEditorState extends State<WebEditorWidget> {

  static const double _offsetHeight = 50;
  static const double _offsetWidth = 90;

  late HtmlEditorController _editorController;
  double? dropZoneWidth;
  double? dropZoneHeight;

  @override
  void initState() {
    super.initState();
    _editorController = widget.editorController;
    if (widget.height != null) {
      dropZoneHeight = widget.height! - _offsetHeight;
    }
    if (widget.width != null) {
      dropZoneWidth = widget.width! - _offsetWidth;
    }
    log('_WebEditorState::initState:dropZoneWidth: $dropZoneWidth | dropZoneHeight: $dropZoneHeight');
  }

  @override
  void didUpdateWidget(covariant WebEditorWidget oldWidget) {
    log('_EmailEditorState::didUpdateWidget():Old: ${oldWidget.direction} | current: ${widget.direction}');
    if (oldWidget.direction != widget.direction) {
      _editorController.updateBodyDirection(widget.direction.name);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return HtmlEditor(
      key: const Key('web_editor'),
      controller: _editorController,
      htmlEditorOptions: HtmlEditorOptions(
        shouldEnsureVisible: true,
        hint: '',
        darkMode: false,
        initialText: widget.content,
        customBodyCssStyle: HtmlUtils.customCssStyleHtmlEditor(direction: widget.direction),
      ),
      htmlToolbarOptions: const HtmlToolbarOptions(
        toolbarType: ToolbarType.hide,
        defaultToolbarButtons: [],
      ),
      otherOptions: OtherOptions(
        height: 550,
        dropZoneWidth: dropZoneWidth,
        dropZoneHeight: dropZoneHeight,
      ),
      callbacks: Callbacks(
        onBeforeCommand: widget.onChangeContent,
        onChangeContent: widget.onChangeContent,
        onInit: () => widget.onInitial?.call(widget.content),
        onFocus: widget.onFocus,
        onBlur: widget.onUnFocus,
        onMouseDown: () => widget.onMouseDown?.call(context),
        onChangeSelection: widget.onEditorSettings,
        onChangeCodeview: widget.onChangeContent,
        onImageUpload: widget.onImageUploadSuccessAction,
        onImageUploadError: widget.onImageUploadFailureAction,
        onTextFontSizeChanged: widget.onEditorTextSizeChanged,
      ),
    );
  }
}