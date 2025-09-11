class LoginUserModel {
  var uniqOfficeUserAccess;
  bool? admin;
  var softwareName;
  var upi;
  var activetiondate;
  var mobilenoUser;
  var permissionScreen;
  var privateNetworkIp;
  var customerDBname;
  var encdb;
  var cLIENTNO;
  var loginUser;
  List? billDetSetting;
  var userSettings;
  var userPermission;
  var walletBal;
  var lineCode;
  var http;
  var android;
  var appLocalStorage;
  var pdfbillFormat;
  var emailadd;
  var user;
  var mCNO;
  var mTYPE;
  var wEB;
  var lFolder;
  var syncType;
  var storageType;
  var api;
  var ltoken;
  var sHOPNAME;
  var aCTYPE;
  var oRDERFORMAMC;
  var oRDERFORMACTDATE;
  var oRDERFORMENABLE;
  var complateSecure;
  var pAY;
  var demoExpired;
  var sftExpired;
  var appVersion;
  var cUOTP;
  var sAMC;
  var latestDataUpdateOn;
  var cTIME;
  var iD;
  var mAutoRefresh;
  List? permission;
  var subAdminIdforCheck;
  var meetingLink;
  var gSTIN;
  var year;
  var expiryDays;
  var sftExpiryDays;
  int? expiredDaysIn;
  var extraPathLIST;
  var extraPathLISTMAIN;
  var iosPermission;
  var firebaseUrl;
  var zipPassword;
  var subscriptionTAmt;
  var subscriptionBaseUserLimit;
  var subscriptionExtraUserAdded;
  var subscriptionExtraUserAddedAmt;
  var premiumType;
  var gatePassSystem;
  var photoGallerySystem;
  var saleDispatchSystem;
  var crmSystem;
  var WebViewType;

  var subAdminId;
  var yearSelected;
  var yearVal;
  var privateNetWorkSync;
  var extraPathSelected;
  var curentyearforlocalstorage;
  var fILENAME;
  var lastUpdateTimeForShow;
  var sft;
  var enotifyInstance;
  var bearer;
  var jobCardReportPermission;
  var taskCrmManager;

  LoginUserModel({
    this.uniqOfficeUserAccess,
    this.admin,
    this.softwareName,
    this.upi,
    this.activetiondate,
    this.mobilenoUser,
    this.permissionScreen,
    this.privateNetworkIp,
    this.customerDBname,
    this.encdb,
    this.cLIENTNO,
    this.loginUser,
    this.billDetSetting,
    this.userSettings,
    this.photoGallerySystem,
    this.saleDispatchSystem,
    this.userPermission,
    this.walletBal,
    this.lineCode,
    this.http,
    this.android,
    this.appLocalStorage,
    this.sft,
    this.pdfbillFormat,
    this.emailadd,
    this.user,
    this.mCNO,
    this.mTYPE,
    this.wEB,
    this.lFolder,
    this.syncType,
    this.storageType,
    this.crmSystem,
    this.api,
    this.ltoken,
    this.sHOPNAME,
    this.aCTYPE,
    this.oRDERFORMAMC,
    this.oRDERFORMACTDATE,
    this.oRDERFORMENABLE,
    this.complateSecure,
    this.pAY,
    this.demoExpired,
    this.sftExpired,
    this.appVersion,
    this.cUOTP,
    this.gatePassSystem,
    this.sAMC,
    this.latestDataUpdateOn,
    this.cTIME,
    this.iD,
    this.mAutoRefresh,
    this.permission,
    this.subAdminIdforCheck,
    this.meetingLink,
    this.gSTIN,
    this.year,
    this.expiryDays,
    this.sftExpiryDays,
    this.expiredDaysIn,
    this.extraPathLIST,
    this.extraPathLISTMAIN,
    this.iosPermission,
    this.firebaseUrl,
    this.zipPassword,
    this.subscriptionTAmt,
    this.subscriptionBaseUserLimit,
    this.subscriptionExtraUserAdded,
    this.subscriptionExtraUserAddedAmt,
    this.premiumType,
    this.subAdminId,
    this.yearSelected,
    this.yearVal,
    this.privateNetWorkSync,
    this.extraPathSelected,
    this.curentyearforlocalstorage,
    this.fILENAME,
    this.lastUpdateTimeForShow,
    this.enotifyInstance,
    this.bearer,
    this.jobCardReportPermission,
    this.WebViewType,
    this.taskCrmManager,
  });

  LoginUserModel.fromJson(Map<String, dynamic> json) {
    uniqOfficeUserAccess = json['uniqOfficeUserAccess'];
    admin = json['admin'];
    softwareName = json['software_name'];
    upi = json['upi'];
    activetiondate = json['Activetiondate'];
    photoGallerySystem = json['photoGallerySystem'];
    saleDispatchSystem = json['saleDispatchSystem'];
    mobilenoUser = json['mobileno_user'];
    permissionScreen = json['permissionScreen'];
    privateNetworkIp = json['privateNetworkIp'];
    customerDBname = json['customerDBname'];
    encdb = json['encdb'];
    crmSystem = json['crmSystem'];
    cLIENTNO = json['CLIENTNO'];
    loginUser = json['login_user'];
    billDetSetting = json['BillDetSetting'];
    userSettings = json['userSettings'];
    userPermission = json['userPermission'];
    walletBal = json['walletBal'];
    lineCode = json['line_code'];
    http = json['http'];
    android = json['android'];
    appLocalStorage = json['AppLocalStorage'];
    pdfbillFormat = json['pdfbillFormat'];
    emailadd = json['emailadd'];
    gatePassSystem = json['gatePassSystem'];
    user = json['user'];
    mCNO = json['MCNO'];
    mTYPE = json['MTYPE'];
    wEB = json['WEB'];
    sft = json['sft'];
    lFolder = json['LFolder'];
    syncType = json['SyncType'];
    storageType = json['StorageType'];
    api = json['api'];
    ltoken = json['Ltoken'];
    sHOPNAME = json['SHOPNAME'];
    aCTYPE = json['ACTYPE'];
    oRDERFORMAMC = json['ORDERFORM_AMC'];
    oRDERFORMACTDATE = json['ORDERFORM_ACTDATE'];
    oRDERFORMENABLE = json['ORDERFORM_ENABLE'];
    complateSecure = json['complateSecure'];
    pAY = json['PAY'];
    demoExpired = json['demoExpired'];
    sftExpired = json['sftExpired'];
    appVersion = json['AppVersion'];
    cUOTP = json['CUOTP'];
    sAMC = json['S_AMC'];
    latestDataUpdateOn = json['latestDataUpdateOn'];
    cTIME = json['CTIME'];
    iD = json['ID'];
    mAutoRefresh = json['MAutoRefresh'];
    permission = json['permission'];
    subAdminIdforCheck = json['subAdminIdforCheck'];
    meetingLink = json['MeetingLink'];
    gSTIN = json['GSTIN'];
    year = json['year'];
    expiryDays = json['expiryDays'];
    sftExpiryDays = json['sftExpiryDays'];
    expiredDaysIn = json['expiredDaysIn'];
    extraPathLIST = json['extraPathLIST'];
    extraPathLISTMAIN = json['extraPathLIST_MAIN'];
    iosPermission = json['iosPermission'];
    firebaseUrl = json['firebaseUrl'];
    zipPassword = json['zipPassword'];
    subscriptionTAmt = json['subscriptionTAmt'];
    subscriptionBaseUserLimit = json['subscriptionBaseUserLimit'];
    subscriptionExtraUserAdded = json['subscriptionExtraUserAdded'];
    subscriptionExtraUserAddedAmt = json['subscriptionExtraUserAddedAmt'];
    premiumType = json['premiumType'];
    subAdminId = json['subAdminId'];
    yearSelected = json['yearSelected'];
    yearVal = json['yearVal'];
    privateNetWorkSync = json['privateNetWorkSync'];
    extraPathSelected = json['extraPathSelected'];
    curentyearforlocalstorage = json['Curentyearforlocalstorage'];
    fILENAME = json['FILE_NAME'];
    lastUpdateTimeForShow = json['last_update_time_for_show'];
    enotifyInstance = json['enotifyInstance'];
    bearer = json['bearer'];
    jobCardReportPermission = json['jobCardReportPermission'];
    WebViewType = json['WebViewType'];
    taskCrmManager = json['taskCrmManager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uniqOfficeUserAccess'] = this.uniqOfficeUserAccess;
    data['admin'] = this.admin;
    data['software_name'] = this.softwareName;
    data['upi'] = this.upi;
    data['Activetiondate'] = this.activetiondate;
    data['mobileno_user'] = this.mobilenoUser;
    data['permissionScreen'] = this.permissionScreen;
    data['photoGallerySystem'] = this.photoGallerySystem;
    data['saleDispatchSystem'] = this.saleDispatchSystem;
    data['privateNetworkIp'] = this.privateNetworkIp;
    data['customerDBname'] = this.customerDBname;
    data['encdb'] = this.encdb;
    data['crmSystem'] = this.crmSystem;
    data['CLIENTNO'] = this.cLIENTNO;
    data['login_user'] = this.loginUser;
    data['BillDetSetting'] = this.billDetSetting;
    data['userSettings'] = this.userSettings;
    data['userPermission'] = this.userPermission;
    data['gatePassSystem'] = this.gatePassSystem;
    data['walletBal'] = this.walletBal;
    data['line_code'] = this.lineCode;
    data['http'] = this.http;
    data['android'] = this.android;
    data['AppLocalStorage'] = this.appLocalStorage;
    data['pdfbillFormat'] = this.pdfbillFormat;
    data['emailadd'] = this.emailadd;
    data['user'] = this.user;
    data['MCNO'] = this.mCNO;
    data['MTYPE'] = this.mTYPE;
    data['WEB'] = this.wEB;
    data['LFolder'] = this.lFolder;
    data['SyncType'] = this.syncType;
    data['StorageType'] = this.storageType;
    data['api'] = this.api;
    data['sft'] = this.sft;
    data['Ltoken'] = this.ltoken;
    data['SHOPNAME'] = this.sHOPNAME;
    data['ACTYPE'] = this.aCTYPE;
    data['ORDERFORM_AMC'] = this.oRDERFORMAMC;
    data['ORDERFORM_ACTDATE'] = this.oRDERFORMACTDATE;
    data['ORDERFORM_ENABLE'] = this.oRDERFORMENABLE;
    data['complateSecure'] = this.complateSecure;
    data['PAY'] = this.pAY;
    data['demoExpired'] = this.demoExpired;
    data['sftExpired'] = this.sftExpired;
    data['AppVersion'] = this.appVersion;
    data['CUOTP'] = this.cUOTP;
    data['S_AMC'] = this.sAMC;
    data['latestDataUpdateOn'] = this.latestDataUpdateOn;
    data['CTIME'] = this.cTIME;
    data['ID'] = this.iD;
    data['MAutoRefresh'] = this.mAutoRefresh;
    data['permission'] = this.permission;
    data['subAdminIdforCheck'] = this.subAdminIdforCheck;
    data['MeetingLink'] = this.meetingLink;
    data['GSTIN'] = this.gSTIN;
    data['year'] = this.year;
    data['expiryDays'] = this.expiryDays;
    data['sftExpiryDays'] = this.sftExpiryDays;
    data['expiredDaysIn'] = this.expiredDaysIn;
    data['extraPathLIST'] = this.extraPathLIST;
    data['extraPathLIST_MAIN'] = this.extraPathLISTMAIN;
    data['iosPermission'] = this.iosPermission;
    data['firebaseUrl'] = this.firebaseUrl;
    data['zipPassword'] = this.zipPassword;
    data['subscriptionTAmt'] = this.subscriptionTAmt;
    data['subscriptionBaseUserLimit'] = this.subscriptionBaseUserLimit;
    data['subscriptionExtraUserAdded'] = this.subscriptionExtraUserAdded;
    data['subscriptionExtraUserAddedAmt'] = this.subscriptionExtraUserAddedAmt;
    data['premiumType'] = this.premiumType;
    data['subAdminId'] = this.subAdminId;
    data['yearSelected'] = this.yearSelected;
    data['yearVal'] = this.yearVal;
    data['privateNetWorkSync'] = this.privateNetWorkSync;
    data['extraPathSelected'] = this.extraPathSelected;
    data['Curentyearforlocalstorage'] = this.curentyearforlocalstorage;
    data['FILE_NAME'] = this.fILENAME;
    data['last_update_time_for_show'] = this.lastUpdateTimeForShow;
    data['enotifyInstance'] = this.enotifyInstance;
    data['bearer'] = this.bearer;
    data['jobCardReportPermission'] = this.jobCardReportPermission;
    data['WebViewType'] = this.WebViewType;
    data['taskCrmManager'] = this.taskCrmManager;
    return data;
  }
}
