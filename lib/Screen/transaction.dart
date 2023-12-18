import 'dart:convert';

import 'package:eshopmultivendor/Model/get_transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Helper/Color.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';

class TransactionDetails extends StatefulWidget {
  const TransactionDetails({Key? key}) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  bool isAll = true;
  bool isToday = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightWhite,
      appBar: getAppBar("Transaction", context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        isAll = true;
                        isToday = false;
                      });
                    },
                    child: Text("All",
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isAll ? primary : white,
                      onPrimary: isAll ? white : primary,
                      maximumSize: Size(200, 50),
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (){
                      setState(() {
                        isAll = false;
                        isToday = true;
                      });
                    },
                    child: Text("Today",
                      style: TextStyle(
                          fontSize: 18
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: isToday ? primary : white,
                      onPrimary: isToday ? white : primary,
                      maximumSize: Size(200, 50),
                      minimumSize: Size(150, 40),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)
                      ),
                    ),
                  )
                ],
              ),
            ),

            isAll == true
                ? FutureBuilder(
                future: getTransaction("all"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  GetTransactionModel? model = snapshot.data;
                  if (snapshot.hasData) {
                    return model!.error == false
                        ? ListView.builder(
                        itemCount: model.data!.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(model.data![index].dateCreated.toString()));
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.all(5.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  ORDER_ID + " - ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "${model.data![index].orderId}",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                            // Spacer(),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.account_balance_wallet_outlined,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Transaction Amount" + " - ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "$CUR_CURRENCY ${model.data![index].amount}",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.chat,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  " " + "Message" + ": ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Container(
                                                  width: 220,
                                                  child: Text(
                                                    "${model.data![index].message}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: black,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  " " + "Date" + ": ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "$date",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {},
                              ),
                            ),
                          );
                        }
                    )
                        : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: Text("NO TRANSACTION FOUND!!"),)
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: Icon(Icons.error_outline))
                    );
                  } else {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: CircularProgressIndicator())
                    );
                  }
                })
                : SizedBox.shrink(),

            isToday != true
                ? SizedBox.shrink()
                : FutureBuilder(
                future: getTransaction("today"),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  GetTransactionModel? model1 = snapshot.data;
                  if (snapshot.hasData) {
                    return model1!.error == false
                        ? ListView.builder(
                        itemCount: model1.data!.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          String date = DateFormat('dd-MM-yyyy').format(DateTime.parse(model1.data![index].dateCreated.toString()));
                          return Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 0,
                              margin: EdgeInsets.all(5.0),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Text(
                                                  ORDER_ID + " - ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "${model1.data![index].orderId}",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                            // Spacer(),
                                          ],
                                        ),
                                      ),
                                      Divider(),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.account_balance_wallet_outlined,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "Transaction Amount" + " - ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "$CUR_CURRENCY ${model1.data![index].amount}",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.chat,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  " " + "Message" + ": ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Container(
                                                  width: 220,
                                                  child: Text(
                                                    "${model1.data![index].message}",
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: TextStyle(color: black,),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.date_range,
                                              size: 14,
                                              color: secondary,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  " " + "Date" + ": ",
                                                  style: TextStyle(color: Colors.grey),
                                                ),
                                                Text(
                                                  "$date",
                                                  style: TextStyle(color: black),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                onTap: () async {},
                              ),
                            ),
                          );
                        }
                    )
                        : Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: Text("NO TRANSACTION FOUND!!"),));
                  } else if (snapshot.hasError) {
                    print("Error msg == ${snapshot.error}");
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: Icon(Icons.error_outline)));
                  } else {
                    return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Center(child: CircularProgressIndicator()));
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<GetTransactionModel?> getTransaction(String type) async {
    CUR_USERID = await getPrefrence(Id);
    var request = http.MultipartRequest('POST', getTransactionApi);
    request.fields.addAll({
      'user_id': '$CUR_USERID',
      'filter_type': '$type'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    print(request);
    print(request.fields);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      return GetTransactionModel.fromJson(json.decode(str));
    }
    else {
      return null;
    }
  }
}
