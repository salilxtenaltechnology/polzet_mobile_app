// // ignore_for_file: deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class DiamondIcon extends StatelessWidget {
//   final Color selectedColor;
//   final IconData icon;
//   final Color iconColor;
//   final String menuName;
//   final Color textColor;
//   DiamondIcon(
//       {required this.selectedColor,
//       required this.icon,
//       required this.iconColor,
//       required this.menuName,
//       required this.textColor});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Container(
//           width: 47,
//           height: 47,
//           decoration: BoxDecoration(
//             color: Colors.transparent,
//             shape: BoxShape.rectangle,
//             borderRadius: BorderRadius.circular(15),
//           ),
//           child: Transform.rotate(
//             angle: 0.78, // 45 degrees (pi/4 radians) for diamond shape
//             child: Container(
//               decoration: BoxDecoration(
//                 color: selectedColor,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Center(
//                 child: Transform.rotate(
//                   angle: -0.7854, // Rotate the icon back to normal
//                   child: Icon(icon, size: 20, color: iconColor),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         SizedBox(height: 5.h),
//         Text(
//           menuName,
//           style: TextStyle(
//               color: textColor,
//               fontSize: 12.sp,
//               fontWeight: FontWeight.w400),
//         )
//       ],
//     );
//   }
// }
