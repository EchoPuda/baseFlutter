import 'package:baseflutter/base/common/commonInsert.dart';
import 'package:baseflutter/utils/paint/TrianglePainter.dart';

/// pop菜单
/// @author jm
abstract class MenuItemProvider {
  String get menuTitle;
  Widget get menuImage;
  TextStyle get menuTextStyle;
}

class MenuItem extends MenuItemProvider {
  Widget image; // 图标名称
  String title; // 菜单标题
  TextStyle textStyle;

  MenuItem({this.title, this.image, this.textStyle});

  @override
  Widget get menuImage => image;

  @override
  String get menuTitle => title;

  @override
  TextStyle get menuTextStyle =>
      textStyle ?? TextStyle(color: MyColors.white, fontSize: 17.0);
}

class MyPopMenu {
  MyPopMenu({
    @required BuildContext context,
    VoidCallback onDismiss,
    @required List<MenuItem> items,
    MenuClickCallback onClickMenu,
    Color backgroundColor : MyColors.popup_menu_bg,
  }) {
    this.context = context;
    this.dismissCallback = onDismiss;
    this.items = items;
    this.onClickMenu = onClickMenu;
    this.backgroundColor = backgroundColor;
  }

  BuildContext context;
  Rect _showRect; // 显示在哪个view的rect
  VoidCallback dismissCallback;
  Offset _offset; //The left top point of this menu.
  OverlayEntry _entry;
  List<MenuItem> items;
  MenuClickCallback onClickMenu;
  Color backgroundColor;
  double dividerPercentage;
  ///建议在main中初始化设置
  static var arrowHeight = 7.0; //箭头高度
  static var itemHeight = 50.0; //item高度
  static var itemWidth = LocalStorage.get("windowWidth") * 0.5 - 10;  //宽度
  static var dividerPer = 0.7;  //分割线比例

  void show({Rect rect, GlobalKey widgetKey}) {
    if (rect == null && widgetKey == null) {
      print("'rect' and 'key' can't be both null");
      return;
    }
    this._showRect = rect ?? MyPopMenu.getWidgetGlobalRect(widgetKey);

    _calculatePosition(context);

    _entry = OverlayEntry(builder: (context) {
      return buildPopupMenuLayout(_offset);
    });

    Overlay.of(context).insert(_entry);

  }

  double menuHeight() {
    return itemHeight * items.length;
  }

  double menuWidth() {
    return LocalStorage.get("windowWidth") * 0.5 - 10;
  }

  static Rect getWidgetGlobalRect(GlobalKey key) {
    RenderBox renderBox = key.currentContext.findRenderObject();
    var offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
        offset.dx, offset.dy, renderBox.size.width, renderBox.size.height);
  }

  void _calculatePosition(BuildContext context) {
    _offset = _calculateOffset(this.context);
  }

  Offset _calculateOffset(BuildContext context) {
    double dx = _showRect.right;
    double dy = _showRect.height + _showRect.top;
    return Offset(dx,dy);
  }

  List<Widget> _getMenuItem() {
    List<Widget> listItem = new List();
    for (int i = 0; i < items.length; i++) {
      listItem.add(
          MenuItemWidget(
            position: i,
            image: items[i].image,
            text: items[i].title,
            textStyle: items[i].textStyle,
            showLine: i == items.length - 1 ? false : true,
            clickCallback: (int position) {
              onClickMenu(position);
              dismiss();
            },
          )
      );
    }
    return listItem;
  }

  LayoutBuilder buildPopupMenuLayout(Offset offset) {
    return LayoutBuilder(builder: (context, constraints){
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          dismiss();
        },
        onVerticalDragStart: (DragStartDetails details) {
          dismiss();
        },
        onHorizontalDragStart: (DragStartDetails details) {
          dismiss();
        },
        child: Container(
          child: Stack(
            children: <Widget>[
              // 三角形
              Positioned(
                left: offset.dx - arrowHeight - 15,
                top: offset.dy,
                child: CustomPaint(
                  size: Size(15.0, arrowHeight),
                  painter: TrianglePainter(color: backgroundColor,isDown: false),
                ),
              ),
              // 菜单
              Positioned(
                left: offset.dx - itemWidth + 5,
                top: offset.dy + arrowHeight,
                child: Container(
                  width: menuWidth(),
                  height: menuHeight(),
                  child: Column(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: menuWidth(),
                          height: menuHeight(),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: _getMenuItem(),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ),
            ],
          ),
        ),
      );
    },);
  }

  void dismiss() {
    if (_entry != null) {
      _entry.remove();
    }
//    _isShow = false;
    if (dismissCallback != null) {
      dismissCallback();
    }

//    if (this.stateChanged != null) {
//      this.stateChanged(false);
//    }
  }
}

typedef MenuClickCallback = Function(int position);
typedef PopupMenuStateChanged = Function(bool isShow);

class MenuItemWidget extends StatefulWidget {
  MenuItemWidget({
    Key key,
    this.showLine : true,
    this.clickCallback,
    @required this.position,
    this.image,
    this.textStyle : const TextStyle(fontSize: 17.0,color: MyColors.white),
    @required this.text,
  }) : super(key: key);
  final bool showLine;
  final Function(int position) clickCallback;
  final int position;
  final Widget image;
  final TextStyle textStyle;
  final String text;

  @override
  State<StatefulWidget> createState() => new MenuItemWidgetState();

}

class MenuItemWidgetState extends State<MenuItemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.clickCallback != null) {
          widget.clickCallback(widget.position);
        }
      },
      child: Stack(
        children: <Widget>[
          Container(
            height: MyPopMenu.itemHeight,
            width: MyPopMenu.itemWidth,
            child: DefaultTextStyle(
              style: TextStyle(
                decoration: TextDecoration.none,
              ),
              child: Center(
                child: widget.image != null ? Row(
                  children: <Widget>[
                    Container(
                      width: MyPopMenu.itemWidth * 0.30,
                      child: Center(
                        child: widget.image,
                      ),
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Center(
                            child: Text(
                              widget.text,
                              style: widget.textStyle,
                            ),
                          ),
                        )
                    ),
                  ],
                )
                    : Text(
                  widget.text,
                  style: widget.textStyle,
                ),
              ),
            )
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: widget.showLine ? new Container(
              color: MyColors.divider_popup_menu,
              height: 1.0,
              width: MyPopMenu.itemWidth * MyPopMenu.dividerPer,
            ) : Container(),
          )
        ],
      ),
    );
  }

}