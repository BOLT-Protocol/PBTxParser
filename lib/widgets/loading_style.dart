import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class LoadingStyleLineupDiamond extends StatefulWidget {
  const LoadingStyleLineupDiamond({
    Key key,
    this.size = 50.0,
    this.color,
    this.itemBuilder,
    this.duration = const Duration(milliseconds: 1200),
    this.controller,
  })  : assert(
            !(itemBuilder is IndexedWidgetBuilder && color is Color) &&
                !(itemBuilder == null && color == null),
            'You should specify either a itemBuilder or a color'),
        assert(size != null),
        super(key: key);

  final Color color;
  final IndexedWidgetBuilder itemBuilder;
  final double size;
  final Duration duration;
  final AnimationController controller;

  @override
  _LoadingStyleLineupDiamondState createState() =>
      _LoadingStyleLineupDiamondState();
}

class _LoadingStyleLineupDiamondState extends State<LoadingStyleLineupDiamond>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _anim1, _anim2, _anim3, _anim4;
  Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _controller = (widget.controller ??
        AnimationController(vsync: this, duration: widget.duration))
      ..repeat(reverse: true);

    _anim1 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeIn)));
    _anim2 = Tween(begin: 1.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.7, curve: Curves.easeIn)));
    _anim3 = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.8, curve: Curves.easeIn)));
    _anim4 = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.1, 0.6, curve: Curves.easeIn)));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(widget.size),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _square(_anim1, 4),
              _square(_anim1, 3),
              _square(_anim1, 2),
              _square(_anim4, 1),
            ],
          ),
        ],
      ),
    );
  }

  Widget _square(Animation<double> animation, int index) {
    return SquareItem(
      color: widget.color,
      size: widget.size,
      animation: index == 1 ? _anim4 : _anim1,
      index: index,
    );
  }
}

class SquareItem extends StatelessWidget {
  const SquareItem({
    this.color,
    Key key,
    this.size = 50.0,
    @required this.animation,
    @required this.index,
  })  : assert(animation != null),
        assert(index != null && index >= 0),
        super(key: key);

  final Animation<double> animation;
  final double size;
  final Color color;
  final int index;

  @override
  Widget build(Object context) {
    return ScaleTransition(
      scale: animation,
      // ignore: missing_required_param
      child: Transform.rotate(
        angle: math.pi / 4,
        child: Container(
          margin: EdgeInsets.all(8),
          child: SizedBox.fromSize(
              size: Size.square(size / 3), child: _itemBuilder(index)),
        ),
      ),
    );
  }

  Widget _itemBuilder(int index) =>
      DecoratedBox(decoration: BoxDecoration(color: color));
}

/// Keeps a Dart [List] in sync with an [AnimatedList].
///
/// The [insert] and [removeAt] methods apply to both the internal list and
/// the animated list that belongs to [listKey].
///
/// This class only exposes as much of the Dart List API as is needed by the
/// sample app. More list methods are easily added, however methods that
/// mutate the list must make the same changes to the animated list in terms
/// of [AnimatedListState.insertItem] and [AnimatedList.removeItem].
class ListModel<E> {
  ListModel({
    @required this.listKey,
    @required this.removedItemBuilder,
    Iterable<E> initialItems,
  })  : assert(listKey != null),
        assert(removedItemBuilder != null),
        _items = List<E>.from(initialItems ?? <E>[]);

  final GlobalKey<AnimatedListState> listKey;
  final dynamic removedItemBuilder;
  final List<E> _items;

  AnimatedListState get _animatedList => listKey.currentState;

  void insert(int index, E item) {
    _items.insert(index, item);
    _animatedList.insertItem(index);
  }

  E removeAt(int index) {
    final E removedItem = _items.removeAt(index);
    if (removedItem != null) {
      _animatedList.removeItem(
        index,
        (BuildContext context, Animation<double> animation) =>
            removedItemBuilder(removedItem, context, animation),
      );
    }
    return removedItem;
  }

  int get length => _items.length;

  E operator [](int index) => _items[index];

  int indexOf(E item) => _items.indexOf(item);
}
