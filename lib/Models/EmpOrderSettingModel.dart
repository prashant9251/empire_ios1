import 'package:empire_ios/Models/HideUnhideModel.dart';
import 'package:empire_ios/main.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class EmpOrderSettingModel {
  bool? photoOnWifi;
  bool? setsSystemOn;
  bool? colorSystemOn;
  String? colorImageSystemEntry;
  bool? colorExportInCsv;
  bool? showRateSelectionOnEntryFormOrder;
  bool? showFrmDate;
  bool? showPackingSelectionAtBottom;
  bool? packingRateAddInProductRate;
  bool? frmItmShowSets;
  bool? frmItmPcsInSets;
  bool? frmItmCut;
  bool? frmItmMtr;
  bool? frmItmRate;
  bool? frmItmRmk;
  bool? frmItmDno;
  bool? frmItmPacking;
  bool? pdfItmcategory;
  bool? askForSharePdfRate;
  bool? autoConfimOrder;
  int? pcReqTimeOut;
  String? fixorderRmk;
  One1ZaModel? one1Za;

  bool? pdfPackingAtBottom;
  bool? pdfItmPacking;
  bool? pdfItmCut;
  bool? pdfItmRate;
  bool? pdfItmRmk;
  bool? pdfItmSets;
  bool? pdfItmAmt;
  bool? pdfItmDno;
  int? IniOrderVno;
  int? pdfProductViewLimit;
  bool? pdfHeaderDetails;
  bool? showImgInOrder;
  bool? sRmk;
  bool? sDhara;
  String? urlPdfBackground;
  List<HideUnhideModel>? hideUnhideSettings;
  String? digiSignUrl;
  bool? gatePassPrintDirect;
  bool? validatRate;

  EmpOrderSettingModel({
    this.photoOnWifi = true,
    this.colorExportInCsv,
    this.setsSystemOn,
    this.colorSystemOn,
    this.colorImageSystemEntry,
    this.showRateSelectionOnEntryFormOrder,
    this.showPackingSelectionAtBottom,
    this.packingRateAddInProductRate,
    this.frmItmShowSets,
    this.frmItmPcsInSets,
    this.frmItmCut,
    this.frmItmMtr,
    this.frmItmRate,
    this.frmItmRmk,
    this.frmItmPacking,
    this.pdfItmcategory,
    this.pdfItmPacking,
    this.pdfItmCut,
    this.pdfItmRate,
    this.pdfItmRmk,
    this.frmItmDno,
    this.pdfItmSets,
    this.pdfPackingAtBottom,
    this.showFrmDate,
    this.IniOrderVno,
    this.askForSharePdfRate,
    this.pdfHeaderDetails,
    this.urlPdfBackground,
    this.pcReqTimeOut,
    this.pdfItmAmt,
    this.fixorderRmk,
    this.pdfProductViewLimit,
    this.one1Za,
    this.pdfItmDno,
    this.autoConfimOrder = false,
    this.showImgInOrder = false,
    this.sRmk,
    this.hideUnhideSettings,
    this.digiSignUrl,
    this.gatePassPrintDirect,
    this.validatRate = true,
    this.sDhara,
  });

  factory EmpOrderSettingModel.fromJson(Map<String, dynamic> json) {
    List<HideUnhideModel> hideUnhideSettingsModel = [];
    if (json['hideUnhideSettings'] != null) {
      json['hideUnhideSettings'].forEach((v) {
        hideUnhideSettingsModel.add(HideUnhideModel.fromJson(Myf.convertMapKeysToString(v)));
      });
    }
    return EmpOrderSettingModel(
      photoOnWifi: json['photoOnWifi'] ?? false,
      colorExportInCsv: json['colorExportInCsv'],
      setsSystemOn: json['setsSystemOn'],
      colorSystemOn: json['colorSystemOn'],
      colorImageSystemEntry: json['colorImageSystemEntry'] ?? "image",
      showRateSelectionOnEntryFormOrder: json['showRateSelectionOnEntryFormOrder'],
      showPackingSelectionAtBottom: json['showPackingSelectionAtBottom'],
      packingRateAddInProductRate: json['packingRateAddInProductRate'],
      frmItmShowSets: json['frmItmShowSets'],
      frmItmPcsInSets: json['frmItmPcsInSets'],
      frmItmCut: json['frmItmCut'],
      frmItmMtr: json['frmItmMtr'],
      frmItmRate: json['frmItmRate'],
      frmItmRmk: json['frmItmRmk'],
      frmItmPacking: json['frmItmPacking'],
      pdfItmcategory: json['pdfItmcategory'],
      pdfItmPacking: json['pdfItmPacking'],
      pdfItmCut: json['pdfItmCut'],
      pdfItmRate: json['pdfItmRate'],
      pdfItmRmk: json['pdfItmRmk'],
      frmItmDno: json['frmItmDno'],
      pdfItmSets: json['pdfItmSets'],
      pdfPackingAtBottom: json['pdfPackingAtBottom'],
      showFrmDate: json['showFrmDate'],
      IniOrderVno: json['IniOrderVno'],
      pdfItmAmt: json['pdfItmAmt'] ?? false,
      askForSharePdfRate: json['askForSharePdfRate'],
      pdfHeaderDetails: json['pdfHeaderDetails'],
      urlPdfBackground: json['urlPdfBackground'],
      fixorderRmk: json['fixorderRmk'],
      pcReqTimeOut: json['pcReqTimeOut'] ?? 1,
      pdfProductViewLimit: json['pdfProductViewLimit'],
      pdfItmDno: json['pdfItmDno'],
      one1Za: One1ZaModel.fromJson(json['one1Za'] ?? {}),
      autoConfimOrder: json['autoConfimOrder'] ?? false,
      showImgInOrder: json['showImgInOrder'] ?? false,
      sRmk: json['sRmk'] ?? true,
      hideUnhideSettings: hideUnhideSettingsModel,
      digiSignUrl: json['digiSignUrl'],
      gatePassPrintDirect: json['gpd'],
      validatRate: json['validatRate'] ?? true,
      sDhara: json['sDhara'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pdfItmAmt'] = this.pdfItmAmt ?? false;
    data['photoOnWifi'] = this.photoOnWifi ?? false;
    data['setsSystemOn'] = this.setsSystemOn;
    data['colorSystemOn'] = this.colorSystemOn;
    data['colorImageSystemEntry'] = this.colorImageSystemEntry ?? "image";
    data['colorExportInCsv'] = this.colorExportInCsv;
    data['showRateSelectionOnEntryFormOrder'] = this.showRateSelectionOnEntryFormOrder;
    data['showPackingSelectionAtBottom'] = this.showPackingSelectionAtBottom;
    data['packingRateAddInProductRate'] = this.packingRateAddInProductRate;
    data['frmItmShowSets'] = this.frmItmShowSets;
    data['frmItmPcsInSets'] = this.frmItmPcsInSets;
    data['frmItmCut'] = this.frmItmCut;
    data['frmItmMtr'] = this.frmItmMtr;
    data['frmItmRate'] = this.frmItmRate;
    data['frmItmRmk'] = this.frmItmRmk;
    data['frmItmPacking'] = this.frmItmPacking;
    data['pdfItmcategory'] = this.pdfItmcategory;
    data['pdfItmPacking'] = this.pdfItmPacking;
    data['pdfItmCut'] = this.pdfItmCut;
    data['pdfItmRate'] = this.pdfItmRate;
    data['pdfItmRmk'] = this.pdfItmRmk;
    data['frmItmDno'] = this.frmItmDno;
    data['pdfItmSets'] = this.pdfItmSets;
    data['pdfPackingAtBottom'] = this.pdfPackingAtBottom;
    data['showFrmDate'] = this.showFrmDate;
    data['IniOrderVno'] = this.IniOrderVno;
    data['askForSharePdfRate'] = this.askForSharePdfRate;
    data['pcReqTimeOut'] = this.pcReqTimeOut ?? 1;
    data['pdfHeaderDetails'] = this.pdfHeaderDetails;
    data['fixorderRmk'] = this.fixorderRmk;
    data['urlPdfBackground'] = this.urlPdfBackground;
    data['pdfProductViewLimit'] = this.pdfProductViewLimit;
    data['pdfItmDno'] = this.pdfItmDno;
    data['sRmk'] = this.sRmk ?? true;
    data['validatRate'] = this.validatRate ?? true;
    if (this.one1Za != null) {
      data['one1Za'] = this.one1Za!.toJson();
    }
    data['autoConfimOrder'] = this.autoConfimOrder ?? false;
    data['showImgInOrder'] = this.showImgInOrder ?? false;
    if (this.hideUnhideSettings != null) {
      data['hideUnhideSettings'] = this.hideUnhideSettings!.map((v) => v.toJson()).toList();
    }
    data['digiSignUrl'] = this.digiSignUrl;
    data['gpd'] = this.gatePassPrintDirect;
    data['sDhara'] = this.sDhara ?? false;
    return data;
  }
}

///
class One1ZaModel {
  One1ZaModel({
    required this.apiUrl,
    required this.originWebsite,
    required this.authToken,
    required this.defTempName,
    this.orderTempName,
  });

  final String? apiUrl;
  final String? originWebsite;
  final String? authToken;
  final String? defTempName;
  final String? orderTempName;

  factory One1ZaModel.fromJson(Map<String, dynamic> json) {
    return One1ZaModel(
      apiUrl: json["apiUrl"],
      originWebsite: json["originWebsite"],
      authToken: json["authToken"],
      defTempName: json["defTempName"],
      orderTempName: json["orderTempName"],
    );
  }

  Map<String, dynamic> toJson() => {
        "apiUrl": apiUrl,
        "originWebsite": originWebsite,
        "authToken": authToken,
        "defTempName": defTempName,
        "orderTempName": orderTempName,
      };
}

/*
{
	"apiUrl": "1492",
	"originWebsite": "1492",
	"authToken": "1492"
}*/
