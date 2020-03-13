import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:baseflutter/base/common/commonInsert.dart';

/// 文本输入弹窗
/// @author puppet
class ShowEditDialog extends StatefulWidget {

  ShowEditDialog({Key key,
    this.title : "",
    this.leftText : MyStrings.cancel,
    @required this.rightText,
    @required this.onRightListener,
    @required this.onLeftListener,
    this.hintText : "",
    this.onChanged,
    this.inputType : TextInputType.text,
    this.inputFormatter,
  }) :
        noTitle = false,
        super (key: key);

  ShowEditDialog.noTitle({Key key,
    this.leftText : MyStrings.cancel,
    @required this.rightText,
    @required this.onRightListener,
    @required this.onLeftListener,
    this.hintText : "",
    this.onChanged,
    this.inputType : TextInputType.text,
    this.inputFormatter,
  }) :
        noTitle = true,
        title = "",
        super (key: key);

  ///标题，仅在有标题的时候可以设置
  final String title;
//  ///内容
//  final String content;
  ///右侧按钮
  final String rightText;
  ///左侧按钮
  final String leftText;
  ///是否没有标题
  final bool noTitle;
  ///在两个按钮的时候，右侧按钮回调
  final ValueChanged<String> onRightListener;
  ///在两个按钮的时候，左侧按钮回调
  final Function onLeftListener;
  ///提示文字
  final String hintText;
  ///输入类型
  final TextInputType inputType;
  ///输入回调
  final ValueChanged<String> onChanged;
  ///输入规则
  final List<TextInputFormatter> inputFormatter;

  @override
  State<StatefulWidget> createState() => new ShowEditDialogState();

}

class ShowEditDialogState extends State<ShowEditDialog> {

  String _editValue = "";

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyColors.transparent,
      child: !widget.noTitle
          ? CupertinoAlertDialog(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 19.0,
            color: MyColors.text_font_black,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          margin: EdgeInsets.only(top: 10.0),
          alignment: Alignment.center,
          color: MyColors.background_grey,
          child: TextField(
            maxLines: 1,
            style: TextStyles.fontStyle,
            keyboardType: widget.inputType,
            inputFormatters: widget.inputFormatter,
            onChanged: (value) {
              _editValue = value;
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 4.0),
              hintText: widget.hintText,
              hintStyle: TextStyles.fontHintStyle ,
              border: InputBorder.none,
              counterText: "",
            ),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(widget.leftText),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onLeftListener();
            },
          ),
          CupertinoDialogAction(
            child: Text(widget.rightText),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRightListener(_editValue);
            },
          ),
        ],
      )
          : CupertinoAlertDialog(
        content: Container(
          height: 40.0,
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          margin: EdgeInsets.only(top: 5.0),
          alignment: Alignment.center,
          color: MyColors.background_grey,
          child: TextField(
            maxLines: 1,
            style: TextStyles.fontStyle,
            keyboardType: widget.inputType,
            onChanged: (value) {
              _editValue = value;
              widget.onChanged(value);
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(top: 4.0),
              hintText: widget.hintText,
              hintStyle: TextStyles.fontHintStyle ,
              border: InputBorder.none,
              counterText: "",
            ),
          ),
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(widget.leftText),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onLeftListener();
            },
          ),
          CupertinoDialogAction(
            child: Text(widget.rightText),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onRightListener(_editValue);
            },
          ),
        ],
      ),
    );
  }

}