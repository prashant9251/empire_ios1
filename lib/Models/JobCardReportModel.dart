class JobCardReportModel {
  String? error;
  String? cno;
  String? type;
  String? vno;
  String? srno;
  String? stageName;
  String? date;
  String? refPartyName;
  String? qual;
  String? component;
  String? chalNo;
  String? pcs;
  String? mts;
  String? freshPcs;
  String? rate;
  String? secPcs1;
  String? secPcs2;
  String? lostPcs;
  String? lacePcs;
  String? stageBill;
  String? stageCno;
  String? stageType;
  String? stageVno;
  String? stageSrno;
  String? trackBill;
  String? trackCno;
  String? trackType;
  String? trackVno;
  String? trackSrno;
  String? trackSeries;
  String? stageMain;
  String? PEND_PCS;
  String? PEND_MTS;
  String? PATH;
  String? createTime;
  String? pty_designNo;

  JobCardReportModel({
    this.error = '',
    this.cno,
    this.type,
    this.vno,
    this.srno,
    this.stageName,
    this.date,
    this.refPartyName,
    this.qual,
    this.component,
    this.chalNo,
    this.pcs,
    this.mts,
    this.freshPcs,
    this.rate,
    this.secPcs1,
    this.secPcs2,
    this.lostPcs,
    this.lacePcs,
    this.stageBill,
    this.stageCno,
    this.stageType,
    this.stageVno,
    this.stageSrno,
    this.trackBill,
    this.trackCno,
    this.trackType,
    this.trackVno,
    this.trackSrno,
    this.trackSeries,
    this.stageMain,
    this.PEND_PCS,
    this.PEND_MTS,
    this.PATH,
    this.createTime,
    this.pty_designNo,
  });

  factory JobCardReportModel.fromJson(Map<String, dynamic> json) {
    return JobCardReportModel(
      error: json['error']?.toString() ?? '',
      cno: json['CNO']?.toString() ?? '',
      type: json['TYPE']?.toString() ?? '',
      vno: json['VNO']?.toString() ?? '',
      srno: json['SRNO']?.toString() ?? '',
      stageName: json['STAGE_NAME']?.toString() ?? '',
      date: json['DATE']?.toString() ?? '',
      refPartyName: json['REF_PARTY_NAME']?.toString() ?? '',
      qual: json['QUAL']?.toString() ?? '',
      component: json['COMPONENT']?.toString() ?? '',
      chalNo: json['CHAL_NO']?.toString() ?? '',
      pcs: json['PCS']?.toString() ?? '',
      mts: json['MTS']?.toString() ?? '',
      freshPcs: json['FRESH_PCS']?.toString() ?? '',
      rate: json['RATE']?.toString() ?? '',
      secPcs1: json['SEC_PCS1']?.toString() ?? '',
      secPcs2: json['SEC_PCS2']?.toString() ?? '',
      lostPcs: json['LOST_PCS']?.toString() ?? '',
      lacePcs: json['LACE_PCS']?.toString() ?? '',
      stageBill: json['STAGE_BILL']?.toString() ?? '',
      stageCno: json['STAGE_CNO']?.toString() ?? '',
      stageType: json['STAGE_TYPE']?.toString() ?? '',
      stageVno: json['STAGE_VNO']?.toString() ?? '',
      stageSrno: json['STAGE_SRNO']?.toString() ?? '',
      trackBill: json['TRACK_BILL']?.toString() ?? '',
      trackCno: json['TRACK_CNO']?.toString() ?? '',
      trackType: json['TRACK_TYPE']?.toString() ?? '',
      trackVno: json['TRACK_VNO']?.toString() ?? '',
      trackSrno: json['TRACK_SRNO']?.toString() ?? '',
      trackSeries: json['TRACK_SERIES']?.toString() ?? '',
      stageMain: json['STAGE_MAIN']?.toString() ?? '',
      PEND_PCS: json['PEND_PCS']?.toString() ?? '',
      PEND_MTS: json['PEND_MTS']?.toString() ?? '',
      PATH: json['PATH']?.toString() ?? '',
      createTime: json['CREATETIME']?.toString() ?? '',
      pty_designNo: json['PTY_DESIGNNO']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'CNO': cno,
      'TYPE': type,
      'VNO': vno,
      'SRNO': srno,
      'STAGE_NAME': stageName,
      'DATE': date,
      'REF_PARTY_NAME': refPartyName,
      'QUAL': qual,
      'COMPONENT': component,
      'CHAL_NO': chalNo,
      'PCS': pcs,
      'MTS': mts,
      'FRESH_PCS': freshPcs,
      'RATE': rate,
      'SEC_PCS1': secPcs1,
      'SEC_PCS2': secPcs2,
      'LOST_PCS': lostPcs,
      'LACE_PCS': lacePcs,
      'STAGE_BILL': stageBill,
      'STAGE_CNO': stageCno,
      'STAGE_TYPE': stageType,
      'STAGE_VNO': stageVno,
      'STAGE_SRNO': stageSrno,
      'TRACK_BILL': trackBill,
      'TRACK_CNO': trackCno,
      'TRACK_TYPE': trackType,
      'TRACK_VNO': trackVno,
      'TRACK_SRNO': trackSrno,
      'TRACK_SERIES': trackSeries,
      'STAGE_MAIN': stageMain,
      'PEND_PCS': PEND_PCS,
      'PEND_MTS': PEND_MTS,
      'PATH': PATH,
      'CREATETIME': createTime,
      'PTY_DESIGNNO': pty_designNo,
    };
  }
}
