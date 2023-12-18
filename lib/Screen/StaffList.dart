import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Screen/createStaff.dart';
import 'package:eshopmultivendor/Screen/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class StaffList extends StatefulWidget {
  const StaffList({Key? key}) : super(key: key);

  @override
  State<StaffList> createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  bool loading = false;
  String? User_id;
  List staffList=[];
  //bool active = false;

  getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_id = prefs.getString('user_id');
  }

  getStaffApi() async{
    await getUserId();
    setState(() {loading = true;});

    Map<String, dynamic> params = {
      'seller_id': User_id!.toString(),
    };

    print("get_staffApi_is__ ${get_staffApi} & params___ $params");

    final response = await http.post(get_staffApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if(jsonResponse["error"] == false){
      staffList = jsonResponse["data"];
      print("get_staffApi_response_is__ ${staffList}");
    }else{
      toast('${jsonResponse["message"]}');
    }
  }

  @override
  void initState() {
    getStaffApi();
    super.initState();
  }
  var active = false;
  staffUpdateApi(String staffId) async{
    Map<String, dynamic> params = {
      "staff_id":staffId.toString(),
      'status': active == true? "1" : "0",
    };

    print("update_deliveryApi_is__ ${updateStatusApi} & params___ $params");

    final response = await http.post(updateStatusApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    if(jsonResponse["error"] == false){
      jsonResponse["data"]['active'].toString() == "1" ? active = true : active = false;
      print("update_deliveryApi_response_is__ ${jsonResponse["data"]} delivery_onOf______________ $active");
    }
    else{
      toast('${jsonResponse["message"]}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(getTranslated(context, "Staff")!, context),
      body:
      loading == true? Center(child: CircularProgressIndicator()):
      ListView.builder(
          itemCount: staffList.length,
          itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, ),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${getTranslated(context, "Name")!}:  ',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text("${staffList[index]['username']}"),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${getTranslated(context, "Email")!}:  ",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text("${staffList[index]['email']}"),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${getTranslated(context, "Mobile Number")!}:  ",
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text("${staffList[index]['mobile']}"),
                        ],
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                          onTap: () async{
                            await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateStaff(isEdit: true, staff_id: staffList[index]['id'],),));
                            getStaffApi();
                          },
                          child: Icon(Icons.edit, color: primary,)),
                      CupertinoSwitch(

                          trackColor: primary,
                          value: active,
                          onChanged: (value) {
                            setState(() {
                              active = value;
                              print("active___${active}");
                            });
                            staffUpdateApi(staffList[index]['id']);
                          }),
                      active == true  ? Text("Deactive") :Text("Active")
                    ],
                  ),

                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
