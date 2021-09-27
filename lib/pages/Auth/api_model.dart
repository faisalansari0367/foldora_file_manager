// // To parse this JSON data, do
// //
// //     final welcome = welcomeFromJson(jsonString);

// import 'dart:convert';

// OrderListModel welcomeFromJson(String str) => OrderListModel.fromJson(json.decode(str));

// String welcomeToJson(OrderListModel data) => json.encode(data.toJson());

// class OrderListModel {
//   OrderListModel({
//     this.id,
//     this.message,
//     this.status,
//     this.statusCode,
//     this.restraunt,
//   });

//   int id;
//   String message;
//   String status;
//   int statusCode;
//   Restraunt restraunt;

//   factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
//         id: json["id"],
//         message: json["message"],
//         status: json["status"],
//         statusCode: json["statusCode"],
//         restraunt: Restraunt.fromJson(json["restraunt"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "message": message,
//         "status": status,
//         "statusCode": statusCode,
//         "restraunt": restraunt.toJson(),
//       };
// }

// class Restraunt {
//   Restraunt({
//     this.restaurantId,
//     this.restaurantName,
//     this.restaurantType,
//     this.noOfTables,
//     this.section,
//   });

//   int restaurantId;
//   String restaurantName;
//   String restaurantType;
//   int noOfTables;
//   List<Section> section;

//   factory Restraunt.fromJson(Map<String, dynamic> json) => Restraunt(
//         restaurantId: json["restaurantId"],
//         restaurantName: json["restaurantName"],
//         restaurantType: json["restaurantType"],
//         noOfTables: json["noOfTables"],
//         section: List<Section>.from(json["section"].map((x) => Section.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "restaurantId": restaurantId,
//         "restaurantName": restaurantName,
//         "restaurantType": restaurantType,
//         "noOfTables": noOfTables,
//         "section": List<dynamic>.from(section.map((x) => x.toJson())),
//       };
// }

// class Section {
//   Section({
//     this.sectionId,
//     this.sectionDescription,
//     this.status,
//     this.tableList,
//   });

//   int sectionId;
//   String sectionDescription;
//   String status;
//   List<TableList> tableList;

//   factory Section.fromJson(Map<String, dynamic> json) => Section(
//         sectionId: json["sectionId"],
//         sectionDescription: json["sectionDescription"],
//         status: json["status"],
//         tableList: List<TableList>.from(json["tableList"].map((x) => TableList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "sectionId": sectionId,
//         "sectionDescription": sectionDescription,
//         "status": status,
//         "tableList": List<dynamic>.from(tableList.map((x) => x.toJson())),
//       };
// }

// class TableList {
//   TableList({
//     this.tableId,
//     this.tableNo,
//     this.orderList,
//   });

//   int tableId;
//   int tableNo;
//   List<OrderList> orderList;

//   factory TableList.fromJson(Map<String, dynamic> json) => TableList(
//         tableId: json["tableID"],
//         tableNo: json["tableNo"],
//         orderList: List<OrderList>.from(json["orderList"].map((x) => OrderList.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "tableID": tableId,
//         "tableNo": tableNo,
//         "orderList": List<dynamic>.from(orderList.map((x) => x.toJson())),
//       };
// }

// class OrderList {
//   OrderList({
//     this.orderId,
//     this.orderDate,
//     this.isRepeatOrder,
//     this.orderNo,
//     this.orderAmount,
//     this.orderTransaction,
//     this.status,
//   });

//   int orderId;
//   DateTime orderDate;
//   String isRepeatOrder;
//   int orderNo;
//   int orderAmount;
//   List<OrderTransaction> orderTransaction;
//   String status;

//   factory OrderList.fromJson(Map<String, dynamic> json) => OrderList(
//         orderId: json["orderID"],
//         orderDate: DateTime.parse(json["orderDate"]),
//         isRepeatOrder: json["isRepeatOrder"],
//         orderNo: json["orderNo"],
//         orderAmount: json["orderAmount"],
//         orderTransaction: List<OrderTransaction>.from(
//             json["orderTransaction"].map((x) => OrderTransaction.fromJson(x))),
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "orderID": orderId,
//         "orderDate": orderDate.toIso8601String(),
//         "isRepeatOrder": isRepeatOrder,
//         "orderNo": orderNo,
//         "orderAmount": orderAmount,
//         "orderTransaction": List<dynamic>.from(orderTransaction.map((x) => x.toJson())),
//         "status": status,
//       };
// }

// class OrderTransaction {
//   OrderTransaction({
//     this.id,
//     this.qty,
//     this.additionalDescription,
//     this.price,
//     this.note,
//     this.amount,
//     this.isDineIn,
//     this.addons,
//     this.status,
//     this.product,
//   });

//   int id;
//   int qty;
//   String additionalDescription;
//   int price;
//   String note;
//   int amount;
//   String isDineIn;
//   List<Addon> addons;
//   String status;
//   Product product;

//   factory OrderTransaction.fromJson(Map<String, dynamic> json) => OrderTransaction(
//         id: json["id"],
//         qty: json["qty"],
//         additionalDescription:
//             json["additionalDescription"] == null ? null : json["additionalDescription"],
//         price: (json['price'] as double).toInt(),
//         note: json["note"] == null ? null : json["note"],
//         amount: json["amount"].toInt(),
//         isDineIn: json["isDineIn"],
//         addons: List<Addon>.from(json["addons"].map((x) => Addon.fromJson(x))),
//         status: json["status"],
//         product: Product.fromJson(json["product"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "qty": qty,
//         "additionalDescription": additionalDescription == null ? null : additionalDescription,
//         "price": price,
//         "note": note == null ? null : note,
//         "amount": amount,
//         "isDineIn": isDineIn,
//         "addons": List<dynamic>.from(addons.map((x) => x.toJson())),
//         "status": status,
//         "product": product.toJson(),
//       };
// }

// class Addon {
//   Addon({
//     this.id,
//     this.addName,
//     this.addPrice,
//     this.addQty,
//     this.addAmount,
//   });

//   int id;
//   String addName;
//   int addPrice;
//   int addQty;
//   int addAmount;

//   factory Addon.fromJson(Map<String, dynamic> json) => Addon(
//         id: json["id"],
//         addName: json["addName"],
//         addPrice: json["addPrice"],
//         addQty: json["addQty"],
//         addAmount: json["addAmount"].toInt(),
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "addName": addName,
//         "addPrice": addPrice,
//         "addQty": addQty,
//         "addAmount": addAmount,
//       };
// }

// class Product {
//   Product({
//     this.productId,
//     this.productExternalName,
//     this.productInternalName,
//     this.sku,
//     this.unitPrice,
//     this.isAgeValidationRequired,
//     this.isDisplayRequired,
//     this.currency,
//     this.image,
//   });

//   int productId;
//   String productExternalName;
//   String productInternalName;
//   String sku;
//   int unitPrice;
//   String isAgeValidationRequired;
//   String isDisplayRequired;
//   String currency;
//   List<Image> image;

//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//         productId: json["productId"],
//         productExternalName: json["productExternalName"],
//         productInternalName: json["productInternalName"],
//         sku: json["sku"],
//         unitPrice: json["unitPrice"].toInt(),
//         isAgeValidationRequired: json["isAgeValidationRequired"],
//         isDisplayRequired: json["isDisplayRequired"],
//         currency: json["currency"],
//         image: List<Image>.from(json["image"].map((x) => Image.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "productId": productId,
//         "productExternalName": productExternalName,
//         "productInternalName": productInternalName,
//         "sku": sku,
//         "unitPrice": unitPrice,
//         "isAgeValidationRequired": isAgeValidationRequired,
//         "isDisplayRequired": isDisplayRequired,
//         "currency": currency,
//         "image": List<dynamic>.from(image.map((x) => x.toJson())),
//       };
// }

// class Image {
//   Image({
//     this.imageId,
//     this.imagePath,
//     this.status,
//   });

//   int imageId;
//   String imagePath;
//   String status;

//   factory Image.fromJson(Map<String, dynamic> json) => Image(
//         imageId: json["imageId"],
//         imagePath: json["imagePath"],
//         status: json["status"],
//       );

//   Map<String, dynamic> toJson() => {
//         "imageId": imageId,
//         "imagePath": imagePath,
//         "status": status,
//       };
// }
