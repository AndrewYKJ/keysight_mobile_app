import 'package:flutter/widgets.dart';

class ExpandaleCardContainer extends StatefulWidget {
  final bool isExpanded;
  final Widget collapsedChild;
  final Widget expandedChild;

  const ExpandaleCardContainer(
      {Key? key,
      required this.isExpanded,
      required this.collapsedChild,
      required this.expandedChild})
      : super(key: key);

  @override
  State<ExpandaleCardContainer> createState() => _ExpandaleCardContainerState();
}

class _ExpandaleCardContainerState extends State<ExpandaleCardContainer> {
  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
      duration: new Duration(seconds: 1),
      curve: Curves.easeInOut,
      child: widget.isExpanded ? widget.expandedChild : widget.collapsedChild,
    );
  }
}
