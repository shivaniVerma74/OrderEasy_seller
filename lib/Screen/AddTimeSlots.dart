import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Screen/EditTimeSlot.dart';
import 'package:eshopmultivendor/Screen/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:intl/intl.dart';

import 'package:shared_preferences/shared_preferences.dart';


class AddTimeSlots extends StatefulWidget {
  const AddTimeSlots({Key? key}) : super(key: key);

  @override
  State<AddTimeSlots> createState() => _AddTimeSlotsState();
}

class _AddTimeSlotsState extends State<AddTimeSlots> {
  String? User_id;
  bool loading = false;
  List timeSlotsList =[];


  getTimeSlotsApi() async{
    setState(() {loading = true;});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_id = prefs.getString('user_id');

    Map<String, dynamic> params = {
      'seller_id': User_id!.toString()
    };

    print("time_slotsApi_is__ ${time_slotsApi} & params___ $params");

    final response = await http.post(time_slotsApi, body: params);
    var jsonResponse = convert.jsonDecode(response.body);

    setState(() {
      loading = false;
    });

    timeSlotsList=[];
    if(jsonResponse["error"] == false){
      timeSlotsList = jsonResponse["data"];

      for(int i=0; i<timeSlotsList.length; i++) {
        timeSlotsList[i]['isSelected'] = false;
      }
      print("time_slotsApi_response_is__ ${timeSlotsList} ");
    }else{
      toast('${jsonResponse["message"]}');
    }
  }

  @override
  void initState() {
    getTimeSlotsApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(getTranslated(context, "AddTimeSlots")!, context),
      body:
      loading == true? Center(child: CircularProgressIndicator()):
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    getTranslated(context, 'PREFERED_TIME')!,
                    style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 16,),
                  ),
                ),
                Divider(),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: timeSlotsList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        child: Row(
                          children: [
                            InkWell(
                                onTap:(){
                                  timeSlotsList.forEach((element) => element['isSelected'] = false);
                                  timeSlotsList[index]['isSelected'] = true;
                                  setState(() {});
                                },
                                child: radioButton(timeSlotsList[index]['isSelected'])),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(start: 15.0),
                              child:  Text('${timeSlotsList[index]['title']}',
                                style: Theme.of(context).textTheme.caption!.copyWith(color: black, fontWeight: FontWeight.w600,),
                              ),
                            ),
                            Padding(
                              padding:  EdgeInsetsDirectional.only(start: 15.0),
                              child:  Text('${formatTime(timeSlotsList[index]['from_time'], DateFormat('HH:mm'))} - ${formatTime(timeSlotsList[index]['to_time'], DateFormat('HH:mm'))}',
                                style: Theme.of(context).textTheme.caption!.copyWith(color: black, fontWeight: FontWeight.w600,),
                              ),
                            ),

                            Spacer(),
                            InkWell(
                                onTap: () async{
                                  await Navigator.push(context, MaterialPageRoute(builder: (context) => EditTimeSlot(timeData: timeSlotsList[index]),));
                                  getTimeSlotsApi();
                                },
                                child: Icon(Icons.edit, color: primary,))
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),

    );
  }
  String formatTime(String timeString, DateFormat format) {
    final time = TimeOfDay.fromDateTime(format.parse(timeString));
    return formatTimeOfDay(time);
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dateTime);
  }

  Widget radioButton(_item){
    return  Container(
      height: 20.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _item ? primary : white,
          border: Border.all(color: grad2Color)),
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: _item ? Icon(Icons.check, size: 15.0, color:white,) :
        Icon(Icons.circle, size: 15.0, color:white,),
      ),
    );
  }
}
