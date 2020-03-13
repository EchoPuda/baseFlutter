import 'package:flutter/cupertino.dart';
import 'package:baseflutter/base/common/commonInsert.dart';

/// 基本弹窗样式
/// @author puppet
class ShowMyDialog extends StatefulWidget {

  ShowMyDialog({Key key,
    this.title : MyStrings.tip,
    this.leftText : MyStrings.cancel,
    @required this.content,
    @required this.rightText,
    @required this.onRightListener,
    @required this.onLeftListener,
  }) :
      isSingle = false,
      onButtonListener = null,
      noTitle = false,
      buttonText = "",
      super (key: key);

  ShowMyDialog.single({Key key,
    this.title : MyStrings.tip,
    @required this.content,
    @required this.buttonText,
    @required this.onButtonListener,
  }) :
      isSingle = true,
      noTitle = false,
      onLeftListener = null,
      onRightListener = null,
      rightText = "",
      leftText = "",
      super (key: key);

  ShowMyDialog.noTitle({Key key,
    this.leftText : MyStrings.cancel,
    @required this.content,
    @required this.rightText,
    @required this.onRightListener,
    @required this.onLeftListener,
  }) :
        isSingle = false,
        onButtonListener = null,
        noTitle = true,
        title = "",
        buttonText = "",
        super (key: key);

  ShowMyDialog.singleNoTitle({Key key,
    @required this.content,
    @required this.buttonText,
    @required this.onButtonListener,
  }) :
        isSingle = true,
        noTitle = true,
        onLeftListener = null,
        onRightListener = null,
        rightText = "",
        leftText = "",
        title = "",
        super (key: key);
  ///标题，仅在有标题的时候可以设置
  final String title;
  ///内容
  final String content;
  ///右侧按钮
  final String rightText;
  ///左侧按钮
  final String leftText;
  ///只有一个按钮时的按钮内容
  final String buttonText;
  ///是否只有一个按钮
  final bool isSingle;
  ///是否没有标题
  final bool noTitle;
  ///在两个按钮的时候，右侧按钮回调
  final Function onRightListener;
  ///在两个按钮的时候，左侧按钮回调
  final Function onLeftListener;
  ///在单个按钮的时候，按钮回调
  final Function onButtonListener;

  @override
  State<StatefulWidget> createState() => new ShowMyDialogState();

}

class ShowMyDialogState extends State<ShowMyDialog> {
  @override
  Widget build(BuildContext context) {
    return !widget.isSingle ? !widget.noTitle
        ? CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 19.0,
          color: MyColors.text_font_black,
          fontWeight: FontWeight.bold
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          widget.content,
          style: TextStyle(
            fontSize: 17.0,
            color: MyColors.text_font_black,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            widget.leftText,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onLeftListener();
          },
        ),
        CupertinoDialogAction(
          child: Text(widget.rightText),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onRightListener();
          },
        ),
      ],
    ) : CupertinoAlertDialog(
      content: Text(
        widget.content,
        style: TextStyle(
          fontSize: 17.0,
          color: MyColors.text_font_black,
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
            widget.onRightListener();
          },
        ),
      ],
    ) : !widget.noTitle ? CupertinoAlertDialog(
      title: Text(
        widget.title,
        style: TextStyle(
            fontSize: 19.0,
            color: MyColors.text_font_black,
            fontWeight: FontWeight.bold
        ),
      ),
      content: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          widget.content,
          style: TextStyle(
            fontSize: 17.0,
            color: MyColors.text_font_black,
          ),
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(widget.buttonText),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onButtonListener();
          },
        ),
      ],
    ) : CupertinoAlertDialog(
      content: Text(
        widget.content,
        style: TextStyle(
          fontSize: 17.0,
          color: MyColors.text_font_black,
        ),
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: Text(
            widget.buttonText,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            widget.onButtonListener();
          },
        ),
      ],
    );
  }

}