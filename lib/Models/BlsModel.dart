import 'package:empire_ios/Models/CompmstModel.dart';
import 'package:empire_ios/Models/DetModel.dart';
import 'package:empire_ios/Models/MasterModel.dart';
import 'package:empire_ios/screen/CRM/CrmModel/CrmFollowUpModel.dart';
import 'package:empire_ios/screen/EMPIRE/Myf.dart';

class BlsModel {
  String? code;
  CompmstModel? compmstModel = CompmstModel();
  MasterModel? masterModel;
  MasterModel? brokerModel;
  CrmFollowUpModel? crmFollowUpModel;
  List<BlsBillDetails>? billdetails;
  List<BlsBillDetails>? allbilldetails;

  BlsModel({
    this.code,
    this.billdetails,
    this.allbilldetails,
    this.masterModel,
    this.brokerModel,
    this.crmFollowUpModel,
    this.compmstModel,
  });

  factory BlsModel.fromJson(Map<String, dynamic> json) {
    List<BlsBillDetails> billDetails = [];
    if (json['billDetails'] != null) {
      for (var item in json['billDetails']) {
        if (item != null) billDetails.add(BlsBillDetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    List<BlsBillDetails> allbillDetails = [];
    if (json['allbillDetails'] != null) {
      for (var item in json['allbillDetails']) {
        if (item != null) allbillDetails.add(BlsBillDetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    MasterModel masterModel = MasterModel();
    if (json['masterModel'] != null) {
      masterModel = MasterModel.fromJson(Myf.convertMapKeysToString(json['masterModel']));
    }
    MasterModel brokerModel = MasterModel();
    if (json['brokerModel'] != null) {
      brokerModel = MasterModel.fromJson(Myf.convertMapKeysToString(json['brokerModel']));
    }
    CrmFollowUpModel crmFollowUpModel = CrmFollowUpModel();
    if (json['crmFollowUpModel'] != null) {
      crmFollowUpModel = CrmFollowUpModel.fromJson(Myf.convertMapKeysToString(json['crmFollowUpModel']));
    }
    CompmstModel compmstModel = CompmstModel();
    if (json['compmstModel'] != null) {
      compmstModel = CompmstModel.fromJson(Myf.convertMapKeysToString(json['compmstModel']));
    }

    return BlsModel(
        code: json["code"],
        billdetails: billDetails,
        allbilldetails: allbillDetails,
        masterModel: masterModel,
        brokerModel: brokerModel,
        crmFollowUpModel: crmFollowUpModel,
        compmstModel: compmstModel);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['masterModel'] = this.masterModel!.toJson();
    if (this.brokerModel != null) {
      data['brokerModel'] = this.brokerModel!.toJson();
    }
    data['crmFollowUpModel'] = this.crmFollowUpModel!.toJson();
    if (this.billdetails != null) {
      data['billDetails'] = this.billdetails!.map((v) => v.toJson()).toList();
    }
    if (this.allbilldetails != null) {
      data['allbilldetails'] = this.allbilldetails!.map((v) => v.toJson()).toList();
    }
    if (this.compmstModel != null) {
      data['compmstModel'] = this.compmstModel!.toJson();
    }
    return data;
  }
}

class BlsBillDetails {
  String? ide;
  String? sft;
  String? year;
  String? frm;
  String? city;
  String? series;
  String? accode;
  String? atyp;
  String? cno;
  String? type;
  String? vno;
  String? adat;
  String? bill;
  String? date;
  String? chln;
  String? rrno;
  String? rrdet;
  String? wgt;
  String? frt;
  String? csno;
  String? plc;
  String? trnsp;
  String? bamt;
  String? tmts;
  String? tpcs;
  String? rcAmt;
  String? disc;
  String? othLs;
  String? rdAmt;
  String? clms;
  String? swtsAmt;
  String? ddcom;
  String? adAmt;
  String? part;
  String? wtLs;
  String? wtLsrate;
  String? wtLsam;
  String? fnlamt;
  String? paid;
  String? rmk;
  String? grsamt;
  String? billdis;
  String? bcode;
  String? prcl;
  String? paychq;
  String? paydet;
  String? cnvtamt;
  String? adOth2;
  String? haste;
  String? wtLsbase;
  String? tdsrate;
  String? tdsamt;
  String? qual;
  String? grt;
  String? discamt;
  String? la1qty;
  String? la2qty;
  String? la3qty;
  String? la1rmk;
  String? la2rmk;
  String? la3rmk;
  String? la1rate;
  String? la2rate;
  String? la3rate;
  String? la1amt;
  String? la2amt;
  String? la3amt;
  String? othrtype;
  String? gryct;
  String? ldrrmk;
  String? vtret;
  String? vtamt;
  String? advtret;
  String? advtamt;
  String? ewb;
  String? stc;
  String? dt;
  String? grd;
  String? o;
  String? i;
  String? envQr;
  String? transport_id;
  bool? showSelect = true;
  List<DetBillDetails>? detBillDetails = [];

  BlsBillDetails({
    this.ide,
    this.sft,
    this.year,
    this.frm,
    this.city,
    this.series,
    this.accode,
    this.atyp,
    this.cno,
    this.type,
    this.vno,
    this.adat,
    this.bill,
    this.date,
    this.chln,
    this.rrno,
    this.rrdet,
    this.wgt,
    this.frt,
    this.csno,
    this.plc,
    this.trnsp,
    this.bamt,
    this.tmts,
    this.tpcs,
    this.rcAmt,
    this.disc,
    this.othLs,
    this.rdAmt,
    this.clms,
    this.swtsAmt,
    this.ddcom,
    this.adAmt,
    this.part,
    this.wtLs,
    this.wtLsrate,
    this.wtLsam,
    this.fnlamt,
    this.paid,
    this.rmk,
    this.grsamt,
    this.billdis,
    this.bcode,
    this.prcl,
    this.paychq,
    this.paydet,
    this.cnvtamt,
    this.adOth2,
    this.haste,
    this.wtLsbase,
    this.tdsrate,
    this.tdsamt,
    this.qual,
    this.grt,
    this.discamt,
    this.la1qty,
    this.la2qty,
    this.la3qty,
    this.la1rmk,
    this.la2rmk,
    this.la3rmk,
    this.la1rate,
    this.la2rate,
    this.la3rate,
    this.la1amt,
    this.la2amt,
    this.la3amt,
    this.othrtype,
    this.gryct,
    this.ldrrmk,
    this.vtret,
    this.vtamt,
    this.advtret,
    this.advtamt,
    this.ewb,
    this.stc,
    this.dt,
    this.grd,
    this.o,
    this.i,
    this.envQr,
    this.transport_id,
    this.showSelect,
    this.detBillDetails,
  });

  factory BlsBillDetails.fromJson(Map<String, dynamic> json) {
    List<DetBillDetails> detBillDetails = [];
    if (json['billDetails'] != null) {
      for (var item in json['billDetails']) {
        if (item != null) detBillDetails.add(DetBillDetails.fromJson(Myf.convertMapKeysToString(item)));
      }
    }
    return BlsBillDetails(
        detBillDetails: detBillDetails,
        ide: json['IDE'],
        sft: json['sft'],
        year: json['year'],
        frm: json['FRM'],
        city: json['CITY'],
        series: json['SERIES'],
        accode: (json['ACCODE'] ?? "").toString(),
        atyp: json['ATYP'],
        cno: json['CNO'],
        type: json['TYPE'],
        vno: json['VNO'],
        adat: json['ADAT'],
        bill: json['BILL'],
        date: json['DATE'],
        chln: json['CHLN'],
        rrno: json['RRNO'],
        rrdet: json['RRDET'],
        wgt: json['WGT'],
        frt: json['FRT'],
        csno: json['CSNO'],
        plc: json['PLC'],
        trnsp: json['TRNSP'],
        bamt: json['BAMT'],
        tmts: json['TMTS'],
        tpcs: json['TPCS'],
        rcAmt: json['RC_AMT'],
        disc: json['DISC'],
        othLs: json['OTH_LS'],
        rdAmt: json['RD_AMT'],
        clms: json['clms'],
        swtsAmt: json['SWTS_AMT'],
        ddcom: json['DDCOM'],
        adAmt: json['AD_AMT'],
        part: json['PART'],
        wtLs: json['WT_LS'],
        wtLsrate: json['WT_LSRATE'],
        wtLsam: json['WT_LSAMT'],
        fnlamt: json['fnlamt'],
        paid: json['paid'],
        rmk: json['RMK'],
        grsamt: json['grsamt'],
        billdis: json['billdis'],
        bcode: json['BCODE'],
        prcl: json['PRCL'],
        paychq: json['PAYCHQ'],
        paydet: json['PAYDET'],
        cnvtamt: json['CNVTAMT'],
        adOth2: json['ad_oth2'],
        haste: json['haste'],
        wtLsbase: json['WT_LSBASE'],
        tdsrate: json['TDSRATE'],
        tdsamt: json['TDSAMT'],
        qual: json['QUAL'],
        grt: json['GRT'],
        discamt: json['discamt'],
        la1qty: json['LA1qty'],
        la2qty: json['LA2qty'],
        la3qty: json['LA3qty'],
        la1rmk: json['LA1RMK'],
        la2rmk: json['LA2RMK'],
        la3rmk: json['LA3RMK'],
        la1rate: json['LA1RATE'],
        la2rate: json['LA2RATE'],
        la3rate: json['LA3RATE'],
        la1amt: json['LA1AMT'],
        la2amt: json['LA2AMT'],
        la3amt: json['LA3AMT'],
        othrtype: json['OTHRTYPE'],
        gryct: json['GRYCT'],
        ldrrmk: json['LDRRMK'],
        vtret: json['VTRET'],
        vtamt: json['VTAMT'],
        advtret: json['ADVTRET'],
        advtamt: json['ADVTAMT'],
        ewb: json['EWB'],
        stc: json['STC'],
        dt: json['DT'],
        grd: json['GRD'],
        o: json['O'],
        i: json['I'],
        envQr: json['envQr'],
        transport_id: json['trId'],
        showSelect: true);
  }

  Map<String, dynamic> toJson() {
    return {
      'IDE': ide,
      'sft': sft,
      'year': year,
      'FRM': frm,
      'CITY': city,
      'SERIES': series,
      'ACCODE': accode,
      'ATYP': atyp,
      'CNO': cno,
      'TYPE': type,
      'VNO': vno,
      'ADAT': adat,
      'BILL': bill,
      'DATE': date,
      'CHLN': chln,
      'RRNO': rrno,
      'RRDET': rrdet,
      'WGT': wgt,
      'FRT': frt,
      'CSNO': csno,
      'PLC': plc,
      'TRNSP': trnsp,
      'BAMT': bamt,
      'TMTS': tmts,
      'TPCS': tpcs,
      'RC_AMT': rcAmt,
      'DISC': disc,
      'OTH_LS': othLs,
      'RD_AMT': rdAmt,
      'clms': clms,
      'SWTS_AMT': swtsAmt,
      'DDCOM': ddcom,
      'AD_AMT': adAmt,
      'PART': part,
      'WT_LS': wtLs,
      'WT_LSRATE': wtLsrate,
      'WT_LSAMT': wtLsam,
      'fnlamt': fnlamt,
      'paid': paid,
      'RMK': rmk,
      'grsamt': grsamt,
      'billdis': billdis,
      'BCODE': bcode,
      'PRCL': prcl,
      'PAYCHQ': paychq,
      'PAYDET': paydet,
      'CNVTAMT': cnvtamt,
      'ad_oth2': adOth2,
      'haste': haste,
      'WT_LSBASE': wtLsbase,
      'TDSRATE': tdsrate,
      'TDSAMT': tdsamt,
      'QUAL': qual,
      'GRT': grt,
      'discamt': discamt,
      'LA1qty': la1qty,
      'LA2qty': la2qty,
      'LA3qty': la3qty,
      'LA1RMK': la1rmk,
      'LA2RMK': la2rmk,
      'LA3RMK': la3rmk,
      'LA1RATE': la1rate,
      'LA2RATE': la2rate,
      'LA3RATE': la3rate,
      'LA1AMT': la1amt,
      'LA2AMT': la2amt,
      'LA3AMT': la3amt,
      'OTHRTYPE': othrtype,
      'GRYCT': gryct,
      'LDRRMK': ldrrmk,
      'VTRET': vtret,
      'VTAMT': vtamt,
      'ADVTRET': advtret,
      'ADVTAMT': advtamt,
      'EWB': ewb,
      'STC': stc,
      'DT': dt,
      'GRD': grd,
      'O': o,
      'I': i,
      'envQr': envQr,
      'showSelect': showSelect,
      'trId': transport_id,
      "detBillDetails": detBillDetails != null ? detBillDetails!.map((v) => v.toJson()).toList() : [],
    };
  }
}
