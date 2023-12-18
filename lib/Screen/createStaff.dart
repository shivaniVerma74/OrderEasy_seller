import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Screen/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Helper/Color.dart';


class CreateStaff extends StatefulWidget {
  bool? isEdit;
  String? staff_id;
  CreateStaff({Key? key, this.isEdit, this.staff_id}) : super(key: key);

  @override
  State<CreateStaff> createState() => _CreateStaffState();
}

class _CreateStaffState extends State<CreateStaff> {
  TextEditingController  nameCont = TextEditingController();
  TextEditingController  emailCont = TextEditingController();
  TextEditingController  mobCont = TextEditingController();
  TextEditingController  passCont = TextEditingController();
  TextEditingController  confPassCont = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  String formattedTime = '';
  String formattedTime2 = '';
  String? categoryValue;
  bool loading = false;
  bool loading2 = false;
  bool order_read = false;
  bool prod_read = false;
  bool cus_read = false;
  bool order_update = false;
  bool prod_update = false;
  bool cus_update = false;
  bool order_delete = false;
  bool prod_delete = false;
  bool prod_create = false;
  String? User_id;
  String? type;
  List cityList=[];
  bool loading3 = false;
  List staffList=[];

  getStaffApi() async{
    await getUserId();
    setState(() {loading3 = true;});

    Map<String, dynamic> params = {
      'seller_id': User_id!.toString(),
      'id': widget.staff_id?.toString(),
    };

    print("get_staffApi_is__ ${get_staffApi} & params___ $params");

    final response = await http.post(get_staffApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading3 = false;
    });

    if(jsonResponse["error"] == false){
      staffList = jsonResponse["data"];
      print("get_staffApi_response_is__ ${staffList}");
    }else{
      toast('${jsonResponse["message"]}');
    }
    autoFill();
  }

  getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_id = prefs.getString('user_id');
  }

  // getCity() async{
  //   // await getUserId();
  //   setState(() {loading = true;});
  //
  //   Map<String, dynamic> params = {
  //     'seller_id': User_id!.toString(),
  //   };
  //
  //   print("getCitiesApi_is__ ${getCitiesApi} & params___ $params");
  //
  //   final response = await http.post(getCitiesApi, body: params);
  //   var jsonResponse = convert.jsonDecode(response.body);
  //
  //   setState(() {
  //     loading = false;
  //   });
  //
  //   if(jsonResponse["error"] == false){
  //     cityList = jsonResponse["data"];
  //     print("getCitiesApi_response_is__ ${cityList}");
  //   }else{
  //     toast('${jsonResponse["message"]}');
  //   }
  // }


  Widget City() {
    return DropdownButtonFormField(
      iconEnabledColor: fontColor,
      isDense: true,
      hint: new Text('Select City',
        style: Theme.of(this.context).textTheme.subtitle2!.copyWith(
            color: fontColor,
            fontWeight: FontWeight.normal),
      ),
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        fillColor: white,
        contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
      value: type,
      style: Theme.of(context)
          .textTheme
          .subtitle2!
          .copyWith(color: fontColor),
      onChanged: (String? newValue) {
        if (mounted)
          setState(() {
            type = newValue;
          });
        print("type_________${type}");
      },
      items: cityList.map((user) {
        return DropdownMenuItem<String>(
          value: user['id'],
          child: Text(
            user['name']!,
          ),
        );
      }).toList(),
    );
  }

  createStaffApi()async{
    if(nameCont.text.length == 0){
      toast('${getTranslated(context, 'name_empty')}');
    }else if(mobCont.text.length == 0 || mobCont.text.length<10 || mobCont.text.length>12){
      toast('${getTranslated(context, 'VALID_MOB')}');
    }else if(mobCont.text.length == 0){
      toast('${getTranslated(context, 'VALID_MOB')}');
    }else if(passCont.text.length == 0){
      toast('${getTranslated(context, 'PWD_REQUIRED')}');
    }else if(confPassCont.text.length == 0){
      toast('${getTranslated(context, 'CON_PASS_REQUIRED_MSG')}');
    }else if(confPassCont.text != passCont.text){
      toast('${getTranslated(context, 'CON_PASS_NOT_MATCH_MSG')}');
    }
    else {
      setState(() {
        loading = true;
      });
      Map<String, dynamic> orderMap = {
        "read": "${order_read}",
        "update": "${order_update}",
        "delete": "${order_delete}"
      };
      Map<String, dynamic> prodMap = {
        "create": "${prod_create}",
        "read": "${prod_read}",
        "update": "${prod_update}",
        "delete": "${prod_delete}"
      };
      Map<String, dynamic> custMap = {
        "read": "${cus_read}",
        "update": "${cus_update}",
      };
      Map<String, dynamic> permission = {
        'orders': orderMap,
        'product': prodMap,
        'customers': custMap,
      };
      print("permission_json___________$permission");


      Map<String, dynamic> params = {
        'seller_id': User_id!.toString(),
        // 'city':type,
        'username': nameCont.text,
        'mobile': mobCont.text,
        'email': emailCont.text,
        'password': passCont.text,
        'permissions': permission
      };

      print("create_staffApi_is__ ${create_staffApi} & params___ ${convert.jsonEncode(params)}");

      final response = await http.post(create_staffApi, body: convert.jsonEncode(params));
      var jsonResponse = convert.jsonDecode(response.body);

      setState(() {
        loading = false;
      });

      if (jsonResponse["error"] == false) {
        print("create_staffApi_response_is__ ${jsonResponse["data"]}");
        Navigator.pop(context);
        toast('${jsonResponse["message"]}');
      } else {
        toast('${jsonResponse["message"]}');
      }
    }
  }
  updateStaffApi()async{
    setState(() {
      loading3 = true;
    });
    Map<String, dynamic> orderMap = {
      "read": "${order_read}",
      "update": "${order_update}",
      "delete": "${order_delete}"
    };
    Map<String, dynamic> prodMap = {
      "create": "${prod_create}",
      "read": "${prod_read}",
      "update": "${prod_update}",
      "delete": "${prod_delete}"
    };
    Map<String, dynamic> custMap = {
      "read": "${cus_read}",
      "update": "${cus_update}",
    };
    Map<String, dynamic> permission = {
      'orders': orderMap,
      'product': prodMap,
      'customers': custMap,
    };
    print("permission_json___________$permission");


    Map<String, dynamic> params = {
      'seller_id': User_id!.toString(),
      'edit_id': widget.staff_id!.toString(),
      // 'city':type,
      'username': nameCont.text,
      'mobile': mobCont.text,
      'email': emailCont.text,
      'password': staffList[0]['password'],
      'permissions': permission
    };

    print("update_staffApi_is__ ${update_staffApi} & params___ ${convert.jsonEncode(params)}");

    final response = await http.post(update_staffApi, body: convert.jsonEncode(params));
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading3 = false;
    });

    if (jsonResponse["error"] == false) {
      print("update_staffApi_response_is__ ${jsonResponse["data"]}");
      Navigator.pop(context);
      toast('${jsonResponse["message"]}');
    } else {
      toast('${jsonResponse["message"]}');
    }
  }

  autoFill() async{
    if(widget.isEdit==true){
      nameCont.text= staffList[0]['username'];
      emailCont.text= staffList[0]['email'];
      mobCont.text= staffList[0]['mobile'];
      order_read= staffList[0]['permissions']['orders']['read'].toString() == 'true' ? true: false;
      order_update= staffList[0]['permissions']['orders']['update'].toString() == 'true' ? true: false;
      order_delete= staffList[0]['permissions']['orders']['delete'].toString() == 'true' ? true: false;
      prod_create= staffList[0]['permissions']['product']['create'].toString() == 'true' ? true: false;
      prod_read= staffList[0]['permissions']['product']['read'].toString() == 'true' ? true: false;
      prod_update= staffList[0]['permissions']['product']['update'].toString() == 'true' ? true: false;
      prod_delete= staffList[0]['permissions']['product']['delete'].toString() == 'true' ? true: false;
      cus_read= staffList[0]['permissions']['customers']['read'].toString() == 'true' ? true: false;
      cus_update= staffList[0]['permissions']['customers']['update'].toString() == 'true' ? true: false;
    }
    setState(() {});
  }

  @override
  void initState() {

    getUserId();
    if(widget.isEdit==true)
    getStaffApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(widget.isEdit==true?  getTranslated(context, "Manage_staff")! : getTranslated(context, "Create_staff")!, context),
      body:
      loading == true? Center(child: CircularProgressIndicator()):
      loading3 == true && widget.isEdit==true? Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black54),
                        controller: nameCont,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '${getTranslated(context, "Staff_Name")}',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black54),
                        controller: emailCont,
                        keyboardType: TextInputType.emailAddress,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '${getTranslated(context, "Email")}',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        maxLength: 10,
                        style: const TextStyle(color: Colors.black54),
                        controller: mobCont,
                        keyboardType: TextInputType.number,
                        decoration:  InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '${getTranslated(context, "Mobile Number")}',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  widget.isEdit==true? Text(''):
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black54),
                        controller: passCont,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '${getTranslated(context, "PASSHINT_LBL")}',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  widget.isEdit==true? Text(''):
                  SizedBox(height: 10,),
                  widget.isEdit==true? Text(''):
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: primary)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextFormField(
                        style: const TextStyle(color: Colors.black54),
                        controller: confPassCont,
                        decoration:  InputDecoration(
                          contentPadding: EdgeInsets.only(left: 10),
                          border: InputBorder.none,
                          hintText: '${getTranslated(context, "CONFIRMPASSHINT_LBL")}',
                          hintStyle: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
                  widget.isEdit==true? Text(''):
                  SizedBox(height: 10,),

                  // Container(
                  //   padding: EdgeInsets.all(8),
                  //   height: 50,
                  //   width: MediaQuery.of(context).size.width,
                  //   decoration: BoxDecoration(
                  //       color: white,
                  //       borderRadius: BorderRadius.circular(10),
                  //       border: Border.all(color: primary)
                  //   ),
                  //   child: City(),
                  // ),


                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("${getTranslated(context, "Permissions")}",
                    style: TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w600, color: primary
                    ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${getTranslated(context, "ORDERS")}",
                        style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: black
                        ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Read")}",
                            style: TextStyle(
                              fontSize: 14,  color: black
                            ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: order_read,
                              onChanged: (value) {
                                setState(() {
                                  order_read = value;
                                  print("order_read___${order_read}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Update")}",
                            style: TextStyle(
                              fontSize: 14,  color: black
                            ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: order_update,
                              onChanged: (value) {
                                setState(() {
                                  order_update = value;
                                  print("order_update___${order_update}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Delete")}",
                            style: TextStyle(
                              fontSize: 14,  color: black
                            ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: order_delete,
                              onChanged: (value) {
                                setState(() {
                                  order_delete = value;
                                  print("order_delete___${order_delete}");
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${getTranslated(context, "PRODUCT")}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: black
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Create")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: prod_create,
                              onChanged: (value) {
                                setState(() {
                                  prod_create = value;
                                  print("prod_create___${prod_create}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Read")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: prod_read,
                              onChanged: (value) {
                                setState(() {
                                  prod_read = value;
                                  print("prod_read___${prod_read}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Update")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: prod_update,
                              onChanged: (value) {
                                setState(() {
                                  prod_update = value;
                                  print("prod_update___${prod_update}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Delete")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: prod_delete,
                              onChanged: (value) {
                                setState(() {
                                  prod_delete = value;
                                  print("prod_delete___${prod_delete}");
                                });
                              }),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text("${getTranslated(context, "Customers")}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600, color: black
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Read")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: cus_read,
                              onChanged: (value) {
                                setState(() {
                                  cus_read = value;
                                  print("cus_read___${cus_read}");
                                });
                              }),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("${getTranslated(context, "Update")}",
                              style: TextStyle(
                                  fontSize: 14,  color: black
                              ),
                            ),
                          ),
                          CupertinoSwitch(
                              trackColor: primary,
                              value: cus_update,
                              onChanged: (value) {
                                setState(() {
                                  cus_update = value;
                                  print("cus_update___${cus_update}");
                                });
                              }),
                        ],
                      ),

                    ],
                  ),

                ],
              ),
            ),
            //
            // loading2 == true? Positioned(
            //     top:300,
            //     left: 170,
            //     child: CircularProgressIndicator()): SizedBox()
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: (){
            if(widget.isEdit == false){
              createStaffApi();
            }else if(widget.isEdit == true){
              updateStaffApi();
            }
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Center(
              child: Text(getTranslated(context, "Submit")!,
                style: TextStyle(color: white, fontSize: 15, fontWeight: FontWeight.w600),),
            ),
          ),
        ),
      ),
    );
  }


}
