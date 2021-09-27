// // import 'dart:convert';

// import 'package:files/pages/Auth/api_model.dart';
// import 'package:flutter/material.dart';
// // import 'package:oztap/api/list_api/dashboard_list_api.dart';
// // import 'package:oztap/order_list_model/order_list_model.dart';

// class Home extends StatefulWidget {
//   const Home({Key key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState ext"isDisplayRequired"ends State<Home> {
//   String _value;

//   OrderListModel orderModelList;

//   Future<OrderListModel> orderList() async {
//     // orderModelList = await fetchOrderList();
//     final json = await DefaultAssetBundle.of(context).loadString("assets/data.json");
//     // final data = await jsonDecode(json);
//     orderModelList = welcomeFromJson(json);
//     return orderModelList;
//   }

//   @override
//   void initState() {
//     orderList();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           backgroundColor: Colors.white,
//           title: Row(
//             children: [
//               // Image.asset(
//               //   "assets/images/logo.png",
//               //   height: 50.0,
//               // ),
//               // Text(
//               //   "  OZTAP",
//               //   style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22),
//               // ),
//             ],
//           ),
//         ),
//         body: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             if (orderModelList == null)
//               Container()
//             else
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: orderModelList.restraunt.section.length,
//                   shrinkWrap: true,
//                   itemBuilder: (context, int i) {
//                     var orderNo = 'not available';
//                     var tableNo = 'not available';
//                     var sectionDescription = 'not available';
//                     final section = orderModelList.restraunt.section[i];
//                     final tableLists = section.tableList;
//                     // print(section.tableList.elementAt(i));
//                     if (section.tableList.length > i) {
//                       final tableCheck = section.tableList.contains(section.tableList[i]);
//                       if (tableCheck) {
//                         final orderList = tableLists[i].orderList;
//                         final check = orderList.length > i;
//                         // if (check) {
//                         orderNo = orderList[i].orderNo.toString();
//                         // }
//                         // orderNo = tableLists[i].orderList.contains(i) ?
//                         tableNo = tableLists[i].tableNo.toString();
//                       }
//                     }
//                     sectionDescription = section.sectionDescription;
//                     final isTableListExist = section.tableList.contains(i);
//                     if (isTableListExist) {
//                       // tableNo = section.tableList[i].tableNo.toString();
//                       final list = section.tableList[i].orderList;
//                       final check = list.contains(i);
//                       if (check) {
//                         orderNo = list[i].orderNo.toString();
//                       }
//                     }
//                     // .tableList[i]
//                     // .orderList[i].orderNo;
//                     return Container(
//                         margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
//                         decoration: new BoxDecoration(
//                           color: Colors.white,
//                           border: Border.all(
//                             color: Colors.blue,
//                           ),
//                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                           /* boxShadow: [
//                           BoxShadow(
//                             color: Colors.blue,
//                             blurRadius: 2.0,
//                             spreadRadius: 0.0,
//                             offset: Offset(2.0, 2.0),

//                           )
//                         ]*/
//                         ),
//                         child: PhysicalModel(
//                           elevation: 5.0,
//                           color: Colors.white,
//                           shadowColor: Colors.blue,
//                           borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Order No",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             // orderModelList.restraunt.section[i].tableList[i]
//                                             //     .orderList[i].orderNo
//                                             //     .toString(),
//                                             orderNo,
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Section Name",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             sectionDescription,
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Table No.",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             // orderModelList.restraunt.section[i].tableList[i].tableNo
//                                             //         .toString() ??
//                                             //     'table no',
//                                             tableNo,
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Order Placed Item",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             "Prawns",
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "QTY",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             "2",
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             "Notes",
//                                             style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                           ),
//                                           Text(
//                                             "Add more",
//                                             style: TextStyle(
//                                                 fontSize: 12.0, fontWeight: FontWeight.bold),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Status",
//                                       style: TextStyle(fontSize: 10.0, color: Colors.grey),
//                                     ),
//                                     /*Container(
//                                     padding: const EdgeInsets.all(0.0),
//                                     child: DropdownButton<String>(
//                                       value: _value,
//                                       elevation: 5,
//                                       style: TextStyle(color: Colors.black),
//                                       items: <String>[
//                                         'Pending',
//                                         'Cancel',
//                                         'Order Placed',
//                                       ].map<DropdownMenuItem<String>>((String value) {
//                                         return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                                         );
//                                       }).toList(),
//                                       hint: Text(
//                                         "Pending",
//                                         style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 12,
//                       fontWeight: FontWeight.bold),
//                                       ),
//                                       onChanged: (String? value) {
//                                         setState(() {
//                     _value = value;
//                                         });
//                                       },
//                                     ),
//                                   ),*/
//                                     Container(
//                                       padding: const EdgeInsets.all(0.0),
//                                       child: DropdownButton<String>(
//                                         value: _value,
//                                         //elevation: 5,
//                                         style: TextStyle(color: Colors.black),

//                                         items: <String>['Pending', 'Cancel', 'Order Place']
//                                             .map<DropdownMenuItem<String>>((String value) {
//                                           return DropdownMenuItem<String>(
//                                             value: value,
//                                             child: Text(value),
//                                           );
//                                         }).toList(),
//                                         hint: Text(
//                                           "Please Select Status",
//                                           style: TextStyle(
//                                               color: Colors.black,
//                                               fontSize: 12,
//                                               fontWeight: FontWeight.w600),
//                                         ),
//                                         onChanged: (String value) {
//                                           setState(() {
//                                             _value = value;
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ));
//                   },
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }
// }
