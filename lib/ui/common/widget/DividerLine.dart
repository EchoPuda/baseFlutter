import 'package:baseflutter/base/common/commonInsert.dart';

/// 分割线
/// @author puppet
class DividerLine extends StatelessWidget {

  DividerLine.horizontal({Key key,
    this.margin : 0,
    this.width : double.maxFinite,
    this.height : 1.0,
  })
      :
        isHorizontal = true,
        super(key: key);

  DividerLine.vertical({Key key,
    this.margin : 0,
    this.width : 1.0,
    this.height : double.maxFinite,
  })
      :
        isHorizontal = false,
        super(key: key);

  final bool isHorizontal;
  final double margin;
  final double width;
  final double height;


  @override
  Widget build(BuildContext context) {
    return isHorizontal ? new Container(
      color: MyColors.divider,
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: height,
      width: width,
    ) : new Container(
      color: MyColors.divider,
      margin: EdgeInsets.symmetric(vertical: margin),
      height: height,
      width: width,
    );
  }

}