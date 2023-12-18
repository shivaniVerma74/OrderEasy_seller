import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Screen/toast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import '../Helper/Color.dart';


class EditTimeSlot extends StatefulWidget {
  Map timeData;
  EditTimeSlot({Key? key, required this.timeData}) : super(key: key);

  @override
  State<EditTimeSlot> createState() => _EditTimeSlotState();
}

class _EditTimeSlotState extends State<EditTimeSlot> {
  TextEditingController  fromCon = TextEditingController();
  TextEditingController  toCon = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  TimeOfDay selectedTime2 = TimeOfDay.now();
  String formattedTime = '';
  String formattedTime2 = '';
  String? categoryValue;
  bool loading = false;
  String? User_id;

  getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_id = prefs.getString('user_id');
  }


  Future _selectDate1() async{
    final TimeOfDay? newTime =
    await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primary,
                accentColor: Colors.black,
                colorScheme: ColorScheme.light(primary: primary),
                buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (newTime != null) {
      setState(() {
        selectedTime = newTime;
        print("_time  ${selectedTime.hour}:${selectedTime.minute}");
        formattedTime = "${selectedTime.hour}:${selectedTime.minute}";
        print("formattedTime== $formattedTime");
        fromCon.text = selectedTime.format(context);
      });
    }
  }
  Future _selectDate2() async{
    final TimeOfDay? newTime =
    await showTimePicker(
        context: context,
        initialTime: selectedTime2,
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primary,
                accentColor: Colors.black,
                colorScheme: ColorScheme.light(primary: primary),
                buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (newTime != null) {
      setState(() {
        selectedTime2 = newTime;
        print("_time  ${selectedTime2.hour}:${selectedTime2.minute}");
        formattedTime2 = "${selectedTime2.hour}:${selectedTime2.minute}";
        print("formattedTime2== $formattedTime2");
        toCon.text = selectedTime2.format(context);
      });
    }
  }

  editTimeSlotApi()async{
    setState(() {loading = true;});

    Map<String, dynamic> params = {
      'seller_id': User_id!.toString(),
    'id': widget.timeData['id'].toString(),
    'from_time': formattedTime.toString(),
    'to_time':formattedTime2.toString(),
    'last_order_time': widget.timeData['last_order_time'].toString(),
    'status':categoryValue.toString()
    };

    print("update_time_slotApi_is__ ${update_time_slotApi} & params___ $params");

    final response = await http.post(update_time_slotApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    if(jsonResponse["error"] == false){
      print("update_time_slotApi_response_is__ ${jsonResponse["data"]}");
      Navigator.pop(context);
      toast('${jsonResponse["message"]}');
    }else{
      toast('${jsonResponse["message"]}');
    }
  }


  @override
  void initState() {
    getUserId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(getTranslated(context, "EditTimeSlots")!, context),
      body: Stack(
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
                      readOnly: true,
                      controller: fromCon,
                      onTap: () {
                        _selectDate1();
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: InputBorder.none,
                        hintText: 'From Time',
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
                      readOnly: true,
                      controller: toCon,
                      onTap: () {
                        _selectDate2();
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        border: InputBorder.none,
                        hintText: 'To Time',
                        hintStyle: TextStyle(color: Colors.black54),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.all(8),
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: primary)
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: Text('Select'), // Not necessary for Option 1
                      value: categoryValue,
                      onChanged: (String? newValue) {
                        setState(() {
                          categoryValue = newValue ;
                        });
                        print("this is_selected value $categoryValue");
                      },
                      items: <DropdownMenuItem<String>>[
                        new DropdownMenuItem(
                          child: new Text('Active'),
                          value: "1",
                        ),
                        new DropdownMenuItem(
                          child: new Text('Deactive'),
                          value:"0",
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          loading == true? Center(child: CircularProgressIndicator()): SizedBox()
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: GestureDetector(
          onTap: (){
            if(loading != true){
              editTimeSlotApi();
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
