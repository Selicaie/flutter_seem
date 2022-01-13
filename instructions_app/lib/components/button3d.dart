
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

// class Button3dStyle {
//   final Color topColor;
//   final Color backColor;
//   final BorderRadius borderRadius;
//   final double z;
//   final double tappedZ;
//   const Button3dStyle(
//       {this.topColor = const Color(0xFF45484c),
//       this.backColor = const Color(0xFF191a1c),
//       this.borderRadius = const BorderRadius.all(Radius.circular(7.0)),
//       this.z = 8.0,
//       this.tappedZ = 3.0});
//
//   static const RED = const Button3dStyle(
//       topColor: const Color(0xFFc62f2f), backColor: const Color(0xFF922525));
//   static const BLUE = const Button3dStyle(
//       topColor: const Color(0xFF25a09c), backColor: const Color(0xFF197572));
//   static const WHITE = const Button3dStyle(
//       topColor: const Color(0xFFffffff), backColor: const Color(0xFFCFD8DC));
// }
//
// class Button3d extends StatefulWidget {
//   final VoidCallback onPressed;
//   final VoidCallback onLongPressed;
//   final Widget child;
//   final Button3dStyle style;
//   final double width;
//   final double height;
//
//   Button3d(
//       {@required this.onPressed,
//       @required this.onLongPressed,
//       @required this.child,
//       this.style = Button3dStyle.WHITE,
//       this.width = 100.0,
//       this.height = 90.0});
//   Button3dState createState() => Button3dState();
//   // @override
//   // State<StatefulWidaget> createState() => Button3dState();
// }
//
// class Button3dState extends State<Button3d> {
//   bool isTapped = false;
//
//   Widget _buildBackLayout() {
//     return Padding(
//       padding: EdgeInsets.only(top: widget.style.z),
//       child: DecoratedBox(
//         position: DecorationPosition.background,
//         decoration: BoxDecoration(
//             borderRadius: widget.style.borderRadius,
//             boxShadow: [BoxShadow(color: widget.style.backColor)]),
//         child: ConstrainedBox(
//           constraints: BoxConstraints.expand(
//               width: widget.width, height: widget.height - widget.style.z),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTopLayout() {
//     return Padding(
//       padding: EdgeInsets.only(
//           top: isTapped ? widget.style.z - widget.style.tappedZ : 0.0),
//       child: DecoratedBox(
//         position: DecorationPosition.background,
//         decoration: BoxDecoration(
//             borderRadius: widget.style.borderRadius,
//             boxShadow: [BoxShadow(color: widget.style.topColor)]),
//         child: ConstrainedBox(
//           constraints: BoxConstraints.expand(
//               width: widget.width, height: widget.height - widget.style.z),
//           child: Container(
//             padding: EdgeInsets.zero,
//             alignment: Alignment.center,
//             child: widget.child,
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       child: Stack(
//         alignment: AlignmentDirectional.topCenter,
//         children: <Widget>[_buildBackLayout(), _buildTopLayout()],
//       ),
//       onLongPress: (){
//         widget.onLongPressed();
//       },
//       onTapDown: (TapDownDetails event) {
//         setState(() {
//           isTapped = true;
//         });
//       },
//       onTapCancel: () {
//         setState(() {
//           isTapped = false;
//         });
//       },
//       onTapUp: (TapUpDetails event) {
//         setState(() {
//           isTapped = false;
//         });
//         widget.onPressed();
//       },
//     );
//   }
// }


class Button3dStyle {
  final Color topColor;
  final Color backColor;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final double z;
  final double tapped;

  const Button3dStyle({
    this.width,
    this.height,
    this.topColor = const Color(0xFF45484c),
    this.backColor = const Color(0xFF191a1c),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(7.0),
    ),
    this.z = 8.0,
    this.tapped = 3.0,
  });
  static const DEFAULT = const Button3dStyle(
    topColor: const Color(0xFFffffff),
    backColor: const Color(0xFFCFD8DC),
  );
}

class Button3d extends StatefulWidget {
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;
  final ValueSetter<Color> pressed_color;
  final Widget child;
  final Button3dStyle style;
  final double width;
  final double height;
  // Color ?pressed_color ;
  bool pressed;

  Button3d({
    @required this.onPressed,this.onLongPressed,
    @required this.child,@required this.pressed_color,
    this.style = Button3dStyle.DEFAULT,
    this.width = 120,@required this.pressed,
    this.height = 60,
  });

  @override
  State<StatefulWidget> createState() => Button3DState();
}

class Button3DState extends State<Button3d> {
  bool isTapped = false;

  Widget _buildBackLayout() {
    return Padding(
      padding: EdgeInsets.only(top: widget.style.z),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          borderRadius: widget.style.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.style.backColor,
              // blurRadius: 1.0,
              // spreadRadius: 0.0,
              offset: Offset(1, 1),//Offset(2, 0)
            )
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: widget.width ,
            height: widget.height - widget.style.z,
          ),
        ),
      ),
    );
  }

  Widget _buildTopLayout() {
    return Padding(
      padding: EdgeInsets.only(
        top: isTapped ? widget.style.z - widget.style.tapped: 3,
      ),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          borderRadius: widget.style.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.style.topColor,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: widget.width,
            height: widget.height - widget.style.z,
          ),
          child: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget.pressed?AvatarGlow(
              glowColor: Colors.white,
              endRadius: 90.0,
              duration: Duration(milliseconds: 2000),
              repeat: true,showTwoGlows: true,
              shape: BoxShape.circle,
              repeatPauseDuration: Duration(milliseconds: 100),
              child:widget.child ,
            ):widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[_buildBackLayout(), _buildTopLayout()],
      ),
      onTapDown: (TapDownDetails event) {
        setState(()  {
          isTapped = true;
          widget.pressed_color(widget.style.topColor);

          Future.delayed(Duration(seconds: 1)).then((_) {
            if(isTapped) {
              widget.onLongPressed();
              isTapped=false;
            }
          });
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      onTapUp: (TapUpDetails event) {
        setState(() {
          if(isTapped) {
            widget.onPressed();
          }
          isTapped = false;
        });
      },
    );
  }
}
