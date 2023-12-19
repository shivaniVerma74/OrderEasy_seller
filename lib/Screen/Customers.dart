import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:eshopmultivendor/Helper/ApiBaseHelper.dart';
import 'package:eshopmultivendor/Helper/AppBtn.dart';
import 'package:eshopmultivendor/Helper/Color.dart';
import 'package:eshopmultivendor/Helper/Constant.dart';
import 'package:eshopmultivendor/Helper/Session.dart';
import 'package:eshopmultivendor/Helper/String.dart';
import 'package:eshopmultivendor/Model/Customer/CustomerModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'ChatWithUser.dart';
class Customers extends StatefulWidget {
  const Customers({
    Key? key,
  }) : super(key: key);
  @override
  _CustomersState createState() => _CustomersState();
}

class _CustomersState extends State<Customers> with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Customer> tempList = [];
  List customerList = [];
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;

  ApiBaseHelper apiBaseHelper = ApiBaseHelper();

  bool _isNetworkAvail = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  List<Customer> notiList = [];
  // int offset = 0;
  int total = 0;
  //bool isLoadingmore = true;
  bool _isLoading = true;
  final TextEditingController _controller = TextEditingController();
  Icon iconSearch = Icon(
    Icons.search,
    color: primary,
  );
  Widget? appBarTitle;
  ScrollController? notificationcontroller;

  ///currently is searching
  bool? isSearching;
  String _searchText = "", _lastsearch = "";

  bool notificationisloadmore = true,
      notificationisgettingdata = false,
      notificationisnodata = false;
  int notificationoffset = 0;

//==============================================================================
//============================= initState Method ===============================

  @override
  void initState() {
    appBarTitle = Text(
      //getTranslated(context, "CUST_LBL")!,
      "Customer",
      style: TextStyle(color: grad2Color),
    );
    notificationoffset = 0;
    Future.delayed(Duration.zero, this.getDetails);
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    notificationcontroller = ScrollController(keepScrollOffset: true);
    notificationcontroller!.addListener(_transactionscrollListener);

    buttonSqueezeanimation = new Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      new CurvedAnimation(
        parent: buttonController!,
        curve: new Interval(
          0.0,
          0.150,
        ),
      ),
    );

    _controller.addListener(() {
      if (_controller.text.isEmpty) {
        if (mounted)
          setState(() {
            _searchText = "";
          });
      } else {
        if (mounted)
          setState(() {
            _searchText = _controller.text;
          });
      }

      if (_lastsearch != _searchText &&
          (_searchText == '' || (_searchText.length >= 2))) {
        _lastsearch = _searchText;
        notificationisloadmore = true;
        notificationoffset = 0;
        getDetails();
      }
    });

    super.initState();
  }


  ///for firebase chat
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool chatLoading = false;
  bool iconTapped = false;
  callChat(index) async {
    setState(() {
      iconTapped = true;
    });

    Customer model = notiList[index];

    var otherUser1 = types.User(
      firstName: model.name!.toString(),
      id: model.fuid.toString(),///fuid should be the other user with whome we chat
      imageUrl: 'https://i.pravatar.cc/300?u=${model.email}',
      lastName: "",
    );

    print("otherUser1 $otherUser1");

    _handlePressed(otherUser1, context, model.fuid.toString(), model);
  }

  _handlePressed( types.User otherUser, BuildContext context, String fcmID, Customer model) async {
    print("model.id! is ${model.id!}");

     if(model.email == null || model.email == ""){
    print("User_email is null");
    setState(() {
    chatLoading = false;
    iconTapped = false;
    });
    setSnackbar('Please ask user to update email.');
    }else if(fcmID == null || fcmID == ''){
      print('fuid is null');
      setState(() {
        chatLoading = false;
        iconTapped = false;
      });
      setSnackbar('Something went wrong, please ask user to relogin.');
    }else{
      final room = await FirebaseChatCore.instance.createRoom(otherUser);
      setState(() {
        chatLoading = false;
        iconTapped = false;
      });
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatWithUser(
            room: room,
            fcm: fcmID,
            fuid: fcmID,
            id: model.id!,
            name: model.name!, mobile: model.mobile!
          ),
        ),
      );
    }

  }

  _transactionscrollListener() {
    if (notificationcontroller!.offset >=
            notificationcontroller!.position.maxScrollExtent &&
        !notificationcontroller!.position.outOfRange) {
      if (mounted)
        setState(() {
          notificationisloadmore = true;
          getDetails();
        });
    }
  }

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: getAppbar(),
      backgroundColor: lightWhite,
      body: _isNetworkAvail
          ? _isLoading
              ? shimmer()
              : notificationisnodata
                  ? Padding(
                      padding:
                          const EdgeInsetsDirectional.only(top: kToolbarHeight),
                      child: Center(
                        child: Text(getTranslated(context, "NOCUSTOMERFOUND")!),
                      ),
                    )
                  : NotificationListener<ScrollNotification>(
                      //   onNotification: (scrollNotification) {} as bool Function(ScrollNotification)?,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: RefreshIndicator(
                              key: _refreshIndicatorKey,
                              onRefresh: _refresh,
                              child:
                              ListView.builder(
                                controller: notificationcontroller,
                                // shrinkWrap: true,
                                //  controller: controller,
                                itemCount: notiList.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // return (index == notiList.length && isLoadingmore)
                                  //     ? Center(child: CircularProgressIndicator())
                                  //     : listItem(index);
                                  Customer? item;
                                  try {
                                    item = notiList.isEmpty
                                        ? null
                                        : notiList[index];
                                    if (notificationisloadmore &&
                                        index == (notiList.length - 1) &&
                                        notificationcontroller!
                                                .position.pixels <=
                                            0) {
                                      getDetails();
                                    }
                                  } on Exception catch (_) {}

                                  return item == null
                                      ? Container()
                                      : listItem(index);
                                },
                              ),
                            ),
                          ),
                          notificationisgettingdata
                              ? Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      top: 5, bottom: 5),
                                  child: CircularProgressIndicator(),
                                )
                              : Container(),
                        ],
                      ),
                    )
          : noInternet(context),
    );
  }

//==============================================================================
//============================ No Internet Widget ==============================

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(Duration(seconds: 2)).then(
                  (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                      getDetails();
                    } else {
                      await buttonController!.reverse();
                      if (mounted) setState(() {});
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

//==============================================================================
//============================ AppBar ==========================================

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

  void _handleSearchStart() {
    if (!mounted) return;
    setState(() {
      isSearching = true;
    });
  }

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

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Widget listItem(int index) {
    Customer model = notiList[index];
    activeDeactive = notiList[index].status == "1" ? true : false;

    String add = model.street! + " " + model.area! + " " + model.city!;

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
                              text: model.id!,
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
                      child: Container(
                        margin: EdgeInsets.only(left: 8),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: model.status == "1" ? Colors.green : red,
                          borderRadius: new BorderRadius.all(
                            const Radius.circular(4.0),
                          ),
                        ),
                        child: Text(
                          model.status == "1"
                              ? getTranslated(context, "Active")!
                              : getTranslated(context, "Deactive")!,
                          style: TextStyle(
                            color: white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    CupertinoSwitch(
                        trackColor: primary,
                        value: activeDeactive,
                        onChanged: (value) {
                          setState(() {
                            activeDeactive = value;
                          });
                          if(model.status == "1"){
                            activeDeactiveCustomer("0", model.id);
                            setState(() {
                            });
                          }else{
                            activeDeactiveCustomer("1", model.id);
                          }
                        }),
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
                          add.length > 2
                              ? Padding(
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
                                          text: model.street! + " ",
                                          style: TextStyle(color: black),
                                        ),
                                        TextSpan(
                                          text: model.area! + " ",
                                          style: TextStyle(color: black),
                                        ),
                                        TextSpan(
                                          text: model.city! + ".",
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
                                          text:
                                              getTranslated(context, "Addresh")! +
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
                          model.email != ""
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
                                          text: model.email!,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _launchMail(model.email);
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
                          model.mobile != ""
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
                                          text: model.mobile!,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              _launchCaller(model.mobile);
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
                          model.balance != ""
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
                                          text:
                                              CUR_CURRENCY + model.balance! + " ",
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
                          model.date != ""
                              ? Padding(
                                  padding: EdgeInsets.only(bottom: 5),
                                  child: RichText(
                                    text: TextSpan(
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: getTranslated(
                                                  context, "Joining Date")! +
                                              " : ",
                                          style: TextStyle(color: grey),
                                        ),
                                        TextSpan(
                                          text: model.date! + " ",
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
                                          text: getTranslated(context, "Joining Date")! + " : ",
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
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: iconTapped == true? null : () async{
                              await callChat(index);
                              if(iconTapped == true){
                                setSnackbar('Please wait, Chat screen getting opened');
                              }
                              print("going to chat screen");
                            },
                            child: Container(
                                    child: Text("Chat With Customer", style: TextStyle(color: fontColor, fontSize: 14, fontWeight: FontWeight.w600),)
                                  ),
                          ),
                        ],
                      ),
                    ),
                    //row
                    Column(
                      children: [
                        model.image != null && model.image != ''
                            ? Container(
                                width: 70,
                                height: 70,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(3.0),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(model.image!),
                                    radius: 25,
                                  ),
                                ),
                              )
                            : Container(height: 0),
                         Container(
                          width: 80,
                          child: Text(
                            model.name!,
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

  _launchCaller(String? mobile) async {
    var url = "tel:$mobile";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<Null> _refresh() {
    if (mounted)
      setState(() {
        notiList.clear();
        notificationisloadmore = true;
        notificationoffset = 0;
      });

    total = 0;
    notiList.clear();
    return getDetails();
  }

  bool activeDeactive = false;
  String? User_id;
  activeDeactiveCustomer(String status, customerId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User_id = prefs.getString('user_id');

    CUR_USERID = await getPrefrence(Id);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request = http.MultipartRequest('POST', Uri.parse(activeDeactiveCustomerApi.toString()));
    request.fields.addAll({
      UserId : customerId.toString(),
      'status': status.toString(),
      'seller_id': User_id!.toString()
      //activeDeactive ? "1" : "0"
    });

    print("this is refer request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      if(result != null) {
          Fluttertoast.showToast(msg: result['message']);
          _refresh();
        }
      // var finalResponse = MyPostsModel.fromJson(result);
      // setState(() {
      //   myPosts = finalResponse.data!;
      //   _isLoading = false;
      // });
      // print("this is referral data ${myPosts.length}");
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<Null> getDetails() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        if (notificationisloadmore) {
          if (mounted)
            setState(() {
              notificationisloadmore = false;
              notificationisgettingdata = true;
              if (notificationoffset == 0) {
                notiList = [];
              }
            });
          var parameter = {
            SellerId: CUR_USERID,
            LIMIT: perPage.toString(),
            OFFSET: notificationoffset.toString(),
            SEARCH: _searchText.trim(),
          };
          print("getCustomersApi_is__ ${getCustomersApi} & params___ $parameter");
          // final response = await http.post(getCustomersApi, body: parameter);
          // log("body_is__________${response.body}");
          // var jsonResponse = convert.jsonDecode(response.body);
          //
          // if(jsonResponse["error"] == false){
          //   customerList.clear();
          //   customerList = jsonResponse["data"];
          //   log("getCustomersApi_response______________ $customerList");
          // }else{
          //   log("getCustomersApi_response______________ $jsonResponse");
          // }
          apiBaseHelper.postAPICall(getCustomersApi, parameter).then(
            (getdata) async {
              bool error = getdata["error"];
              String? msg = getdata["message"];
              notificationisgettingdata = false;
              if (notificationoffset == 0) notificationisnodata = error;

              if (!error) {
                tempList.clear();
                var mainList = getdata["data"];
                log("getCustomersApi_response______________ $mainList");
                if (mainList.length != 0) {
                  tempList = (mainList as List).map((data) => new Customer.fromJson(data)).toList();
                  notiList.addAll(tempList);
                  notificationisloadmore = true;
                  notificationoffset = notificationoffset + perPage;
                } else {
                  notificationisloadmore = false;
                }
              } else {
                // if (msg != "Products Not Found !") setSnackbar(msg);
                // isLoadingmore = false;
                notificationisloadmore = false;
              }
              if (mounted)
                setState(() {
                  notificationisloadmore = false;
                  _isLoading = false;
                });
            },
            onError: (error) {
              _isLoading = false;
              setSnackbar(error.toString());
            },
          );
        }
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, "somethingMSg")!);
        if (mounted) setState(() {});
      }
    } else if (mounted) {
      setState(() {
        _isNetworkAvail = false;
      });
      setSnackbar('You have not authorized permission for read.!!');
      return null;
    }
  }

  _launchMail(String? email) async {
    var url = "mailto:${email}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      new SnackBar(
        content: new Text(
          msg,
          textAlign: TextAlign.center,
          style: TextStyle(color: black),
        ),
        backgroundColor: white,
        elevation: 1.0,
      ),
    );
  }
}
