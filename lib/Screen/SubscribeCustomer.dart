import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Helper/Color.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';
import '../Model/Customer/SubscribeCustomerModel.dart';

class SuscribeCustomer extends StatefulWidget {
  const SuscribeCustomer({Key? key}) : super(key: key);

  @override
  State<SuscribeCustomer> createState() => _SuscribeCustomerState();
}

class _SuscribeCustomerState extends State<SuscribeCustomer> {
  Widget? appBarTitle;
  @override
  void initState() {
    appBarTitle = Text(
      //getTranslated(context, "CUST_LBL")!,
      "Subscribe Customer",
      style: TextStyle(color: grad2Color),
    );
    getSubscribeCustomer();
    super.initState();
  }

  SubscribeCustomerModel? customerData;
  getSubscribeCustomer() async {
    var headers = {
      'Cookie': 'ci_session=84b217fc19c0d05880ff9d530fb1d953f99e9bda'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/mt/app/v1/api/recent_search_for_seller'));
    request.fields.addAll({
      'seller_id':"$CUR_USERID"
    });
    print("get customer parameteer ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = SubscribeCustomerModel.fromJson(json.decode(finalResponse));
      setState(() {
        customerData = jsonResponse;
      });
      print("gfgfgfgfgfg $jsonResponse $finalResponse");
    }
    else {
      print(response.reasonPhrase);
    }
  }
  Icon iconSearch = Icon(
    Icons.search,
    color: primary,
  );
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();

  void _handleSearchStart() {
    if (!mounted) return;
    setState(() {
      isSearching = true;
    });
  }
  bool? isSearching;
  String _searchText = "", _lastsearch = "";
  void _handleSearchEnd() {
    if (!mounted) return;
    setState(() {
      iconSearch = Icon(
        Icons.search,
        color: primary,
      );
      appBarTitle = Text(
        getTranslated(context, "CUST_LBL")!,
        style: TextStyle(color: grad2Color),
      );
      isSearching = false;
      _controller.clear();
    });
  }

  AppBar getAppbar() {
    return AppBar(
      titleSpacing: 0,
      title: appBarTitle,
      backgroundColor: white,
      iconTheme: IconThemeData(color: primary),
      leading: Builder(builder: (BuildContext context) {
        return Container(
          margin: EdgeInsets.all(10),
          decoration: shadow(),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: Icon(
                Icons.keyboard_arrow_left,
                color: primary,
                size: 30,
              ),
            ),
          ),
        );
      }),
      actions: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: shadow(),
          child: InkWell(
            borderRadius: BorderRadius.circular(4),
            onTap: () {
              if (!mounted) return;
              setState(
                    () {
                  if (iconSearch.icon == Icons.search) {
                    iconSearch = Icon(
                      Icons.close,
                      color: primary,
                      size: 25,
                    );
                    appBarTitle = TextField(
                      controller: _controller,
                      autofocus: true,
                      style: TextStyle(
                        color: grad2Color,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search, color: primary),
                        hintText: getTranslated(context, "Search")!,
                        hintStyle: TextStyle(color: primary),
                      ),
                      //  onChanged: searchOperation,
                    );
                    _handleSearchStart();
                  } else {
                    _handleSearchEnd();
                  }
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: iconSearch,
            ),
          ),
        ),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppbar(),
      backgroundColor: lightWhite,
      body:
      // customerData?.date?.length == "" || customerData?.date?.length == null ? Padding(
      //   padding:
      //   const EdgeInsetsDirectional.only(top: kToolbarHeight),
      //   child: Center(
      //     child: Text(getTranslated(context, "NOCUSTOMERFOUND")!),
      //   ),
      // ):
      Column(
        children: [
          Container(
            height: 500,
            decoration: BoxDecoration(color: Colors.red),
            child: ListView.builder(
              shrinkWrap: true,
              //  controller: controller,
              itemCount: customerData?.date?.length,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                // return (index == notiList.length && isLoadingmore)
                //     ? Center(child: CircularProgressIndicator())
                //     : listItem(index);
               listItem(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  _launchMail(String? email) async {
    var url = "mailto:${email}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchCaller(String? mobile) async {
    var url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget listItem(int index) {
    return GestureDetector(
      child: Card(
        elevation: 0,
        color: white,
        margin: EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text:
                              getTranslated(context, "Customer ID")! + " : ",
                              style: TextStyle(color: primary),
                            ),
                            TextSpan(
                              text: customerData?.date?[index].id!,
                              style: TextStyle(color: black),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        // if(model.status == "1"){
                        //   activeDeactiveCustomer("0", model.id);
                        //   setState(() {
                        //   });
                        // }else{
                        //   activeDeactiveCustomer("1", model.id);
                        // }
                      },
                      child: Text("")
                      // Container(
                      //   margin: EdgeInsets.only(left: 8),
                      //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      //   decoration: BoxDecoration(
                      //     color: model.status == "1" ? Colors.green : red,
                      //     borderRadius: new BorderRadius.all(
                      //       const Radius.circular(4.0),
                      //     ),
                      //   ),
                      //   child: Text(
                      //     model.status == "1"
                      //         ? getTranslated(context, "Active")!
                      //         : getTranslated(context, "Deactive")!,
                      //     style: TextStyle(
                      //       color: white,
                      //     ),
                      //   ),
                      // ),
                    ),
                    // const SizedBox(width: 10,),
                    // CupertinoSwitch(
                    //     trackColor: primary,
                    //     value: activeDeactive,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         activeDeactive = value;
                    //       });
                    //       if(model.status == "1"){
                    //         activeDeactiveCustomer("0", model.id);
                    //         setState(() {
                    //         });
                    //       }else{
                    //         activeDeactiveCustomer("1", model.id);
                    //       }
                    //     }),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // add.length > 2
                          //     ?
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                    getTranslated(context, "Addresh")! +
                                        ": ",
                                    style: TextStyle(color: grey),
                                  ),
                                  TextSpan(
                                    text:  customerData?.date?[index].address,
                                    style: TextStyle(color: black),
                                  ),
                                  // TextSpan(
                                  //   text:  customerData?.date?[index].area! + " ",
                                  //   style: TextStyle(color: black),
                                  // ),
                                  // TextSpan(
                                  //   text: customerData?.date?[index].city! + ".",
                                  //   style: TextStyle(color: black),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                          //     : Container(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //           text:
                          //           getTranslated(context, "Addresh")! +
                          //               " : ",
                          //           style: TextStyle(color: grey),
                          //         ),
                          //         TextSpan(
                          //           text: getTranslated(
                          //               context, "Not Available!")!,
                          //           style: TextStyle(color: black),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          customerData?.date?[index].email!= ""
                              ? Padding(
                            padding:
                            const EdgeInsets.symmetric(vertical: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:
                                    getTranslated(context, "E-mail")! +
                                        " : ",
                                    style: TextStyle(color: grey),
                                  ),
                                  TextSpan(
                                    text: customerData?.date?[index].email!,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchMail(customerData?.date?[index].email);
                                      },
                                    style: TextStyle(
                                      color: pink,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Container(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getTranslated(context, "Email")! +
                                        " : ",
                                    style: TextStyle(color: grey),
                                  ),
                                  TextSpan(
                                    text: getTranslated(
                                        context, "Not Available!")!,
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          customerData?.date?[index].mobile!= ""
                              ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getTranslated(
                                        context, "Mobile No")! +
                                        "." +
                                        " : ",
                                    style: TextStyle(
                                      color: grey,
                                    ),
                                  ),
                                  TextSpan(
                                    text: customerData?.date?[index].mobile!,
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        _launchCaller(customerData?.date?[index].mobile);
                                      },
                                    style: TextStyle(
                                      color: pink,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Container(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getTranslated(
                                        context, "Mobile No")! +
                                        "." +
                                        " : ",
                                    style: TextStyle(color: fontColor),
                                  ),
                                  TextSpan(
                                    text: getTranslated(
                                        context, "Not Available!")!,
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          customerData?.date?[index].balance!= ""
                              ? Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getTranslated(
                                        context, "BALANCE_LBL")! +
                                        " :  ",
                                    style: TextStyle(color: grey),
                                  ),
                                  TextSpan(
                                    text: customerData?.date?[index].balance!.toString(),
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : Container(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: getTranslated(
                                        context, "BALANCE_LBL")! +
                                        " : ",
                                    style: TextStyle(color: grey),
                                  ),
                                  TextSpan(
                                    text: "---",
                                    style: TextStyle(color: black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // customerData?.date?[index].!= ""
                          //     ? Padding(
                          //   padding: EdgeInsets.only(bottom: 5),
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //           text: getTranslated(
                          //               context, "Joining Date")! +
                          //               " : ",
                          //           style: TextStyle(color: grey),
                          //         ),
                          //         TextSpan(
                          //           text: model.date! + " ",
                          //           style: TextStyle(color: black),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // )
                          //     : Container(
                          //   child: RichText(
                          //     text: TextSpan(
                          //       children: <TextSpan>[
                          //         TextSpan(
                          //           text: getTranslated(context, "Joining Date")! + " : ",
                          //           style: TextStyle(color: grey),
                          //         ),
                          //         TextSpan(
                          //           text: "---",
                          //           style: TextStyle(color: black),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // GestureDetector(
                          //   behavior: HitTestBehavior.opaque,
                          //   onTap: iconTapped == true? null : () async{
                          //     await callChat(index);
                          //     if(iconTapped == true){
                          //       setSnackbar('Please wait, Chat screen getting opened');
                          //     }
                          //     print("going to chat screen");
                          //   },
                          //   child: Container(
                          //       child: Text("Chat With Customer", style: TextStyle(color: fontColor, fontSize: 14, fontWeight: FontWeight.w600),)
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    //row
                    Column(
                      children: [
                        customerData?.date?[index].image != null &&  customerData?.date?[index].image != ''
                            ? Container(
                          width: 70,
                          height: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3.0),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage( customerData?.date?[index].image !),
                              radius: 25,
                            ),
                          ),
                        )
                            : Container(height: 0),
                        Container(
                          width: 80,
                          child: Text(
                            customerData?.date?[index].username ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: fontColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
