import 'package:eshopmultivendor/Model/ProductModel/Product.dart';
import 'package:intl/intl.dart';


class Model {
  String? id,
      type,
      typeId,
      image,
      fromTime,
      toTime,
      lastTime,
      title,
      desc,
      status,
      email,
      date,
      msg,
      uid,
      prodId,
      varId;
  bool? isDel;
  var list;
  String? name, banner;
  List<attachment>? attach;
  Model(
      {this.id,
        this.type,
        this.typeId,
        this.image,
        this.name,
        this.banner,
        this.list,
        this.title,
        this.fromTime,
        this.toTime,
        this.desc,
        this.email,
        this.status,
        this.lastTime,
        this.msg,
        this.attach,
        this.uid,
        this.date,
        this.prodId,
        this.isDel,
        this.varId});

  factory Model.fromSlider(Map<String, dynamic> parsedJson) {
    var listContent = parsedJson["data"];
    if (listContent == null || listContent.isEmpty)
      listContent = [];
    else {
      listContent = listContent[0];
      if (parsedJson['type'] == "categories")
        listContent = new Product.fromCat(listContent);
      else if (parsedJson['type'] == "products")
        listContent = new Product.fromJson(listContent);
    }

    return new Model(
        id: parsedJson['id'],
        image: parsedJson['image'],
        type: parsedJson['type'],
        typeId: parsedJson['type_id'],
        list: listContent);
  }

  factory Model.fromTimeSlot(Map<String, dynamic> parsedJson) {
    return new Model(
        id: parsedJson['id'],
        name: parsedJson['title'],
        fromTime: parsedJson['from_time'],
        lastTime: parsedJson['last_order_time'],
        toTime: parsedJson['to_time']);
  }

  factory Model.fromTicket(Map<String, dynamic> parsedJson) {
    String date = parsedJson['date_created'];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    return new Model(
        id: parsedJson['id'],
        title: parsedJson['subject'],
        desc: parsedJson['description'],
        typeId: parsedJson['ticket_type_id'],
        email: parsedJson['email'],
        status: parsedJson['status'],
        date: date,
        type: parsedJson['ticket_type']);
  }

  factory Model.fromSupport(Map<String, dynamic> parsedJson) {
    return new Model(
      id: parsedJson['id'],
      title: parsedJson['title'],
    );
  }

  factory Model.fromChat(Map<String, dynamic> parsedJson) {
    //var listContent = parsedJson["attachments"];

    List<attachment> attachList;
    var listContent = (parsedJson["attachments"] as List?);
    if (listContent == null || listContent.isEmpty)
      attachList = [];
    else
      attachList =
          listContent.map((data) => new attachment.setJson(data)).toList();

    String date = parsedJson['date_created'];

    date = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(date));
    return new Model(
        id: parsedJson['id'],
        title: parsedJson['title'],
        msg: parsedJson['message'],
        uid: parsedJson['user_id'],
        name: parsedJson['name'],
        date: date,
        attach: attachList);
  }

  factory Model.setAllCat(String id, String name) {
    return new Model(
      id: id,
      name: name,
    );
  }

  factory Model.checkDeliverable(Map<String, dynamic> parsedJson) {
    return Model(
        prodId: parsedJson['product_id'],
        varId: parsedJson['variant_id'],
        isDel: parsedJson['is_deliverable']);
  }
}

class attachment {
  String? media, type;

  attachment({this.media, this.type});

  factory attachment.setJson(Map<String, dynamic> parsedJson) {
    return new attachment(
      media: parsedJson['media'],
      type: parsedJson['type'],
    );
  }
}
