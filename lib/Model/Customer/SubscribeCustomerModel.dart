/// error : false
/// message : "Get Data successfully!"
/// date : [{"id":"1440","ip_address":"223.235.102.96","username":"Alpha Backery 2","password":"$2y$10$SHWYQKHgM7YJSXzGMKjF7.KiGOeU7PntnK2622r38n189eJPJI9NC","email":"","mobile":"9988552233","image":null,"balance":"0","activation_selector":null,"activation_code":null,"forgotten_password_selector":null,"forgotten_password_code":null,"forgotten_password_time":null,"remember_selector":null,"remember_code":null,"created_on":"1702983411","last_login":null,"active":"1","company":null,"address":null,"bonus":null,"cash_received":"0.00","dob":null,"country_code":"972","city":"1","area":null,"street":null,"qrcode":null,"qr_number":null,"pincode":null,"serviceable_zipcodes":null,"apikey":null,"referral_code":"V3kMgSId","friends_code":null,"fcm_id":"coI_i2jOTjmEoCgSpdcr10:APA91bGsutOaBPJ85M8aMXBDGmrvuzffhpqneM_8FTxSe6A1P7F3OpnkqLoSufyOgODCe-CPyjTLLVR5_gONBK2UBDI9yDbp8HYw2G7OIOwKbK9j1j8Vcu16GqTHtv1IHji1slEAEspH","otp":"581548","verify_otp":"0","latitude":null,"longitude":null,"created_at":"2023-12-19 16:26:51","online":"0","current_password":"","fuid":"","seller_id":null},{"id":"1441","ip_address":"49.43.0.137","username":"New","password":"$2y$10$2vAC0BeB.364lxwcBQH8Hu6RFkaI03xWu41j9Ys5gVanKI4XhidOi","email":"","mobile":"9977777777","image":null,"balance":"0","activation_selector":null,"activation_code":null,"forgotten_password_selector":null,"forgotten_password_code":null,"forgotten_password_time":null,"remember_selector":null,"remember_code":null,"created_on":"1702984483","last_login":null,"active":"1","company":null,"address":null,"bonus":null,"cash_received":"0.00","dob":null,"country_code":"972","city":"1","area":null,"street":null,"qrcode":null,"qr_number":null,"pincode":null,"serviceable_zipcodes":null,"apikey":null,"referral_code":"BUOxqzGk","friends_code":null,"fcm_id":"coI_i2jOTjmEoCgSpdcr10:APA91bGsutOaBPJ85M8aMXBDGmrvuzffhpqneM_8FTxSe6A1P7F3OpnkqLoSufyOgODCe-CPyjTLLVR5_gONBK2UBDI9yDbp8HYw2G7OIOwKbK9j1j8Vcu16GqTHtv1IHji1slEAEspH","otp":"237141","verify_otp":"0","latitude":null,"longitude":null,"created_at":"2023-12-19 16:44:43","online":"0","current_password":"","fuid":"","seller_id":null}]

class SubscribeCustomerModel {
  SubscribeCustomerModel({
      bool? error, 
      String? message, 
      List<SuscribeData>? date,}){
    _error = error;
    _message = message;
    _date = date;
}

  SubscribeCustomerModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['date'] != null) {
      _date = [];
      json['date'].forEach((v) {
        _date?.add(SuscribeData.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<SuscribeData>? _date;
SubscribeCustomerModel copyWith({  bool? error,
  String? message,
  List<SuscribeData>? date,
}) => SubscribeCustomerModel(  error: error ?? _error,
  message: message ?? _message,
  date: date ?? _date,
);
  bool? get error => _error;
  String? get message => _message;
  List<SuscribeData>? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_date != null) {
      map['date'] = _date?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "1440"
/// ip_address : "223.235.102.96"
/// username : "Alpha Backery 2"
/// password : "$2y$10$SHWYQKHgM7YJSXzGMKjF7.KiGOeU7PntnK2622r38n189eJPJI9NC"
/// email : ""
/// mobile : "9988552233"
/// image : null
/// balance : "0"
/// activation_selector : null
/// activation_code : null
/// forgotten_password_selector : null
/// forgotten_password_code : null
/// forgotten_password_time : null
/// remember_selector : null
/// remember_code : null
/// created_on : "1702983411"
/// last_login : null
/// active : "1"
/// company : null
/// address : null
/// bonus : null
/// cash_received : "0.00"
/// dob : null
/// country_code : "972"
/// city : "1"
/// area : null
/// street : null
/// qrcode : null
/// qr_number : null
/// pincode : null
/// serviceable_zipcodes : null
/// apikey : null
/// referral_code : "V3kMgSId"
/// friends_code : null
/// fcm_id : "coI_i2jOTjmEoCgSpdcr10:APA91bGsutOaBPJ85M8aMXBDGmrvuzffhpqneM_8FTxSe6A1P7F3OpnkqLoSufyOgODCe-CPyjTLLVR5_gONBK2UBDI9yDbp8HYw2G7OIOwKbK9j1j8Vcu16GqTHtv1IHji1slEAEspH"
/// otp : "581548"
/// verify_otp : "0"
/// latitude : null
/// longitude : null
/// created_at : "2023-12-19 16:26:51"
/// online : "0"
/// current_password : ""
/// fuid : ""
/// seller_id : null

class SuscribeData {
  SuscribeData({
      String? id, 
      String? ipAddress, 
      String? username, 
      String? password, 
      String? email, 
      String? mobile, 
      dynamic image, 
      String? balance, 
      dynamic activationSelector, 
      dynamic activationCode, 
      dynamic forgottenPasswordSelector, 
      dynamic forgottenPasswordCode, 
      dynamic forgottenPasswordTime, 
      dynamic rememberSelector, 
      dynamic rememberCode, 
      String? createdOn, 
      dynamic lastLogin, 
      String? active, 
      dynamic company, 
      dynamic address, 
      dynamic bonus, 
      String? cashReceived, 
      dynamic dob, 
      String? countryCode, 
      String? city, 
      dynamic area, 
      dynamic street, 
      dynamic qrcode, 
      dynamic qrNumber, 
      dynamic pincode, 
      dynamic serviceableZipcodes, 
      dynamic apikey, 
      String? referralCode, 
      dynamic friendsCode, 
      String? fcmId, 
      String? otp, 
      String? verifyOtp, 
      dynamic latitude, 
      dynamic longitude, 
      String? createdAt, 
      String? online, 
      String? currentPassword, 
      String? fuid, 
      dynamic sellerId,}){
    _id = id;
    _ipAddress = ipAddress;
    _username = username;
    _password = password;
    _email = email;
    _mobile = mobile;
    _image = image;
    _balance = balance;
    _activationSelector = activationSelector;
    _activationCode = activationCode;
    _forgottenPasswordSelector = forgottenPasswordSelector;
    _forgottenPasswordCode = forgottenPasswordCode;
    _forgottenPasswordTime = forgottenPasswordTime;
    _rememberSelector = rememberSelector;
    _rememberCode = rememberCode;
    _createdOn = createdOn;
    _lastLogin = lastLogin;
    _active = active;
    _company = company;
    _address = address;
    _bonus = bonus;
    _cashReceived = cashReceived;
    _dob = dob;
    _countryCode = countryCode;
    _city = city;
    _area = area;
    _street = street;
    _qrcode = qrcode;
    _qrNumber = qrNumber;
    _pincode = pincode;
    _serviceableZipcodes = serviceableZipcodes;
    _apikey = apikey;
    _referralCode = referralCode;
    _friendsCode = friendsCode;
    _fcmId = fcmId;
    _otp = otp;
    _verifyOtp = verifyOtp;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _online = online;
    _currentPassword = currentPassword;
    _fuid = fuid;
    _sellerId = sellerId;
}

  SuscribeData.fromJson(dynamic json) {
    _id = json['id'];
    _ipAddress = json['ip_address'];
    _username = json['username'];
    _password = json['password'];
    _email = json['email'];
    _mobile = json['mobile'];
    _image = json['image'];
    _balance = json['balance'];
    _activationSelector = json['activation_selector'];
    _activationCode = json['activation_code'];
    _forgottenPasswordSelector = json['forgotten_password_selector'];
    _forgottenPasswordCode = json['forgotten_password_code'];
    _forgottenPasswordTime = json['forgotten_password_time'];
    _rememberSelector = json['remember_selector'];
    _rememberCode = json['remember_code'];
    _createdOn = json['created_on'];
    _lastLogin = json['last_login'];
    _active = json['active'];
    _company = json['company'];
    _address = json['address'];
    _bonus = json['bonus'];
    _cashReceived = json['cash_received'];
    _dob = json['dob'];
    _countryCode = json['country_code'];
    _city = json['city'];
    _area = json['area'];
    _street = json['street'];
    _qrcode = json['qrcode'];
    _qrNumber = json['qr_number'];
    _pincode = json['pincode'];
    _serviceableZipcodes = json['serviceable_zipcodes'];
    _apikey = json['apikey'];
    _referralCode = json['referral_code'];
    _friendsCode = json['friends_code'];
    _fcmId = json['fcm_id'];
    _otp = json['otp'];
    _verifyOtp = json['verify_otp'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _online = json['online'];
    _currentPassword = json['current_password'];
    _fuid = json['fuid'];
    _sellerId = json['seller_id'];
  }
  String? _id;
  String? _ipAddress;
  String? _username;
  String? _password;
  String? _email;
  String? _mobile;
  dynamic _image;
  String? _balance;
  dynamic _activationSelector;
  dynamic _activationCode;
  dynamic _forgottenPasswordSelector;
  dynamic _forgottenPasswordCode;
  dynamic _forgottenPasswordTime;
  dynamic _rememberSelector;
  dynamic _rememberCode;
  String? _createdOn;
  dynamic _lastLogin;
  String? _active;
  dynamic _company;
  dynamic _address;
  dynamic _bonus;
  String? _cashReceived;
  dynamic _dob;
  String? _countryCode;
  String? _city;
  dynamic _area;
  dynamic _street;
  dynamic _qrcode;
  dynamic _qrNumber;
  dynamic _pincode;
  dynamic _serviceableZipcodes;
  dynamic _apikey;
  String? _referralCode;
  dynamic _friendsCode;
  String? _fcmId;
  String? _otp;
  String? _verifyOtp;
  dynamic _latitude;
  dynamic _longitude;
  String? _createdAt;
  String? _online;
  String? _currentPassword;
  String? _fuid;
  dynamic _sellerId;
  SuscribeData copyWith({  String? id,
  String? ipAddress,
  String? username,
  String? password,
  String? email,
  String? mobile,
  dynamic image,
  String? balance,
  dynamic activationSelector,
  dynamic activationCode,
  dynamic forgottenPasswordSelector,
  dynamic forgottenPasswordCode,
  dynamic forgottenPasswordTime,
  dynamic rememberSelector,
  dynamic rememberCode,
  String? createdOn,
  dynamic lastLogin,
  String? active,
  dynamic company,
  dynamic address,
  dynamic bonus,
  String? cashReceived,
  dynamic dob,
  String? countryCode,
  String? city,
  dynamic area,
  dynamic street,
  dynamic qrcode,
  dynamic qrNumber,
  dynamic pincode,
  dynamic serviceableZipcodes,
  dynamic apikey,
  String? referralCode,
  dynamic friendsCode,
  String? fcmId,
  String? otp,
  String? verifyOtp,
  dynamic latitude,
  dynamic longitude,
  String? createdAt,
  String? online,
  String? currentPassword,
  String? fuid,
  dynamic sellerId,
}) => SuscribeData(  id: id ?? _id,
  ipAddress: ipAddress ?? _ipAddress,
  username: username ?? _username,
  password: password ?? _password,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  image: image ?? _image,
  balance: balance ?? _balance,
  activationSelector: activationSelector ?? _activationSelector,
  activationCode: activationCode ?? _activationCode,
  forgottenPasswordSelector: forgottenPasswordSelector ?? _forgottenPasswordSelector,
  forgottenPasswordCode: forgottenPasswordCode ?? _forgottenPasswordCode,
  forgottenPasswordTime: forgottenPasswordTime ?? _forgottenPasswordTime,
  rememberSelector: rememberSelector ?? _rememberSelector,
  rememberCode: rememberCode ?? _rememberCode,
  createdOn: createdOn ?? _createdOn,
  lastLogin: lastLogin ?? _lastLogin,
  active: active ?? _active,
  company: company ?? _company,
  address: address ?? _address,
  bonus: bonus ?? _bonus,
  cashReceived: cashReceived ?? _cashReceived,
  dob: dob ?? _dob,
  countryCode: countryCode ?? _countryCode,
  city: city ?? _city,
  area: area ?? _area,
  street: street ?? _street,
  qrcode: qrcode ?? _qrcode,
  qrNumber: qrNumber ?? _qrNumber,
  pincode: pincode ?? _pincode,
  serviceableZipcodes: serviceableZipcodes ?? _serviceableZipcodes,
  apikey: apikey ?? _apikey,
  referralCode: referralCode ?? _referralCode,
  friendsCode: friendsCode ?? _friendsCode,
  fcmId: fcmId ?? _fcmId,
  otp: otp ?? _otp,
  verifyOtp: verifyOtp ?? _verifyOtp,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  createdAt: createdAt ?? _createdAt,
  online: online ?? _online,
  currentPassword: currentPassword ?? _currentPassword,
  fuid: fuid ?? _fuid,
  sellerId: sellerId ?? _sellerId,
);
  String? get id => _id;
  String? get ipAddress => _ipAddress;
  String? get username => _username;
  String? get password => _password;
  String? get email => _email;
  String? get mobile => _mobile;
  dynamic get image => _image;
  String? get balance => _balance;
  dynamic get activationSelector => _activationSelector;
  dynamic get activationCode => _activationCode;
  dynamic get forgottenPasswordSelector => _forgottenPasswordSelector;
  dynamic get forgottenPasswordCode => _forgottenPasswordCode;
  dynamic get forgottenPasswordTime => _forgottenPasswordTime;
  dynamic get rememberSelector => _rememberSelector;
  dynamic get rememberCode => _rememberCode;
  String? get createdOn => _createdOn;
  dynamic get lastLogin => _lastLogin;
  String? get active => _active;
  dynamic get company => _company;
  dynamic get address => _address;
  dynamic get bonus => _bonus;
  String? get cashReceived => _cashReceived;
  dynamic get dob => _dob;
  String? get countryCode => _countryCode;
  String? get city => _city;
  dynamic get area => _area;
  dynamic get street => _street;
  dynamic get qrcode => _qrcode;
  dynamic get qrNumber => _qrNumber;
  dynamic get pincode => _pincode;
  dynamic get serviceableZipcodes => _serviceableZipcodes;
  dynamic get apikey => _apikey;
  String? get referralCode => _referralCode;
  dynamic get friendsCode => _friendsCode;
  String? get fcmId => _fcmId;
  String? get otp => _otp;
  String? get verifyOtp => _verifyOtp;
  dynamic get latitude => _latitude;
  dynamic get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get online => _online;
  String? get currentPassword => _currentPassword;
  String? get fuid => _fuid;
  dynamic get sellerId => _sellerId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ip_address'] = _ipAddress;
    map['username'] = _username;
    map['password'] = _password;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['image'] = _image;
    map['balance'] = _balance;
    map['activation_selector'] = _activationSelector;
    map['activation_code'] = _activationCode;
    map['forgotten_password_selector'] = _forgottenPasswordSelector;
    map['forgotten_password_code'] = _forgottenPasswordCode;
    map['forgotten_password_time'] = _forgottenPasswordTime;
    map['remember_selector'] = _rememberSelector;
    map['remember_code'] = _rememberCode;
    map['created_on'] = _createdOn;
    map['last_login'] = _lastLogin;
    map['active'] = _active;
    map['company'] = _company;
    map['address'] = _address;
    map['bonus'] = _bonus;
    map['cash_received'] = _cashReceived;
    map['dob'] = _dob;
    map['country_code'] = _countryCode;
    map['city'] = _city;
    map['area'] = _area;
    map['street'] = _street;
    map['qrcode'] = _qrcode;
    map['qr_number'] = _qrNumber;
    map['pincode'] = _pincode;
    map['serviceable_zipcodes'] = _serviceableZipcodes;
    map['apikey'] = _apikey;
    map['referral_code'] = _referralCode;
    map['friends_code'] = _friendsCode;
    map['fcm_id'] = _fcmId;
    map['otp'] = _otp;
    map['verify_otp'] = _verifyOtp;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['created_at'] = _createdAt;
    map['online'] = _online;
    map['current_password'] = _currentPassword;
    map['fuid'] = _fuid;
    map['seller_id'] = _sellerId;
    return map;
  }

}