

var url = window.location.href;
var VNO = (getUrlParams(url, "VNO"));
var YearChange = (getUrlParams(url, "YearChange"));
var CNO = (getUrlParams(url, "CNO"));
var TYPE = (getUrlParams(url, "TYPE"));
var VNO = (getUrlParams(url, "VNO"));
var VNO_Less_Value = 0;
var BLS;
var DET;
var BLSdata;
var DETdata;

try {
	function load_data() {
		if (YearChange != '' && YearChange != null) {
        yearChangeDSN= DSN.replace(Currentyear,YearChange);
	} else {
		yearChangeDSN = DSN;
	}
		jsGetObjectByKey(DSN, "MST", "").then(function (data) {
			masterData = data;
			jsGetObjectByKey(yearChangeDSN, "BLS", "").then(function (dataBLS) {
				BLSdata = dataBLS;
				
				jsGetObjectByKey(yearChangeDSN, "DET", "").then(function (dataDET) {
					DETdata = dataDET;
					loadCall(IDE);
				});
			});
		});
	}
	function loadCall(IDE) {
		var div = '';
		$("#loader").addClass('has-loader');

		if (CNO != null && CNO != "" && TYPE != null && TYPE != "" && VNO != null && VNO != "") {
			BLS = BLSdata.filter(function (data) {
				return data.billDetails.some((billDetails) => billDetails['CNO'].toUpperCase() == CNO.toUpperCase()
					&& billDetails['TYPE'].toUpperCase() == TYPE.toUpperCase()
					&& billDetails['VNO'].toUpperCase() == VNO.toUpperCase());
			}).map(function (subdata) {
				return {
					code: subdata.code,
					billDetails: subdata.billDetails.filter(function (billDetails) {
						return ((billDetails['CNO'].toUpperCase() == CNO.toUpperCase()
							&& billDetails['TYPE'].toUpperCase() == TYPE.toUpperCase())
							&& billDetails['VNO'].toUpperCase() == VNO.toUpperCase());
					})
				}
			})
		} else {
			BLS = BLSdata.filter(function (data) {
				return data.billDetails.some((billDetails) => billDetails['IDE'].toUpperCase() == IDE.toUpperCase());
			}).map(function (subdata) {
				return {
					code: subdata.code,
					billDetails: subdata.billDetails.filter(function (billDetails) {
						return ((billDetails['IDE'].toUpperCase() == IDE.toUpperCase()));
					})
				}
			})
		}


		console.log(BLS);
		if (BLS.length > 0) {
			partyArray = getPartyDetailsBySendCode(BLS[0].code);
			// console.log(partyArray);
			firmArray = getFirmDetailsBySendCode(BLS[0].billDetails[0].CNO);
			ReportType = " SALES ";
			ReportATypeCode = "1";
			ReportSeriesTypeCode = "S";
			var partyEmail = partyArray[0].EML == null ? '' : partyArray[0].EML;
			ReportDOC_TYPECode = "";
			var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(BLS[0].code) + "&partyname=" + encodeURIComponent(partyArray[0].partyname) + "&FIRM=" + encodeURIComponent(firmArray[0].FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + partyArray[0].MO + "&partyEmail=" + encodeURIComponent(partyEmail);
			// console.log(hrefLink)
			document.getElementById("hrefSALE").href = "ALLSALE_AJXREPORT.html" + hrefLink + "&";
			document.getElementById("hrefOUTSTANDING").href = "OUTSTANDING_AJXREPORT.html" + hrefLink;
			document.getElementById("hrefLEDGER").href = "LEDGER_AJXREPORT.html" + hrefLink;
			document.getElementById("hrefITEMWISESALE").href = "ALLSALE_AJXREPORT.html" + hrefLink+"&REPORTTYPE=ITEM+WISE+PARTY+WISE";
			document.getElementById("hrefBILLPDF").href = "Billpdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + BLS[0].billDetails[0].CNO + "&TYPE=" + BLS[0].billDetails[0].TYPE + "&VNO=" + VNO + "&YearChange=" + YearChange + "&mobileNo=" + partyArray[0].MO;

			var titleBill = BLS[0].billDetails[0].BILL;
			titleBill = titleBill.replace("\/", "-");
			document.title = "BILL NO- " + titleBill
			div += `		
					<div id="FullData" class="row">
					<div class="col-xs-12">
					<div class="invoice-title">
						<h2>`+ firmArray[0].FIRM + `</h2>
						<p style="text-align:center;">`+ firmArray[0].ADDRESS1 + `,` + firmArray[0].ADDRESS2 + `,<b>` + firmArray[0].CITY1 + `</b></p>
						<h3 style="text-align:right;"class="pull-right"><strong>BILL -`+ BLS[0].billDetails[0].BILL + `</strong></h3>
					</div>
					<hr>
					<div class="row">
						<div class="col-xs-6">
							<address>
								<strong>Billed To:</strong><br>
								`+ partyArray[0].partyname + `<br>
								`+ getValueNotDefine(partyArray[0].AD1) + `,` + getValueNotDefine(partyArray[0].AD2) + `<br>
								`+ partyArray[0].city + `<br>`;
			if ((BLS[0].billDetails[0].PLC) != null) {
				div += ` <strong>STATION:</strong>  ` + (BLS[0].billDetails[0].PLC);
			}
			div += `	<br>`;
			if ((BLS[0].billDetails[0].BCODE) != null) {
				div += `<strong>BROKER:</strong> ` + (BLS[0].billDetails[0].BCODE);
			}
			div += `<br>`;
			if ((BLS[0].billDetails[0].haste) != null && (BLS[0].billDetails[0].haste) != '') {
				div += `<strong>HASTE:</strong> ` + (BLS[0].billDetails[0].haste);
			}
			div += `<br>
							</address>
						</div>
						<div class="col-xs-6 text-right">
							<address>
								<strong>`+ BLS[0].billDetails[0].SERIES + `</strong><br>
								DATE :<b>`+ formatDate(BLS[0].billDetails[0].DATE) + `</b><br>
								LR NO.`+ BLS[0].billDetails[0].RRNO + `<br>
								EWB.`+ getValueNotDefine(BLS[0].billDetails[0].EWB) + `<br>
								`+ BLS[0].billDetails[0].TRNSP + `
							</address>
						</div>
					</div>

				</div>
			</div><div class="row">
				<div class="col-md-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title"><strong>Order summary</strong></h3>
						</div>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-condensed" style="border: 1px solid black;width:100%;">
									<thead>
										<tr>
										<th>SR. PARTICULARS</th>
										<th class="hideCategory" style="display:none;">CATEGORY</th>
										<th class="hidePCK" style="display:none;">PACKING</th>
										<th class="hideHSN">HSN</th>
										<th class="hidePCS">PCS</th>
										<th class="hideCUT">CUT</th>
										<th class="hideMTR">MTR</th>
										<th class="hideNETMTS"  style="display:none;">NET MTS.</th>
										<th class="hideFOLDLESS"  style="display:none;" >FOLD.LESS.</th>
										<th class="hideRATE">RATE</th>
										<th class="hidePER">PER</th>                          
										<th class="hideDISC" style="display:none;">DISC</th>
										<th class="hideAMOUNT">AMOUNT</th>
										</tr>
									</thead>
									<tbody>`;
			try {


				DET = DETdata.filter(function (data) {
					return data.CNO == BLS[0].billDetails[0].CNO &&
						data.TYPE.toUpperCase() == BLS[0].billDetails[0].TYPE.toUpperCase() &&
						data.VNO == (VNO);
				})

				if (DET.length > 0) {
					//console.log("billDetails", DET);
					var billDet = DET[0].billDetails;
					var SUBTOTAL = 0;
					var SUBTOTALPCS = 0;
					var sr = 0;
					for (var i = 0; i < billDet.length; i++) {
						sr += 1
						var CTGRY = billDet[i].CTGRY == null || billDet[i].CTGRY == "" ? "" : billDet[i].CTGRY;
						var LESS_FOLD = parseFloat(billDet[i].LF);;
						var NET_MTS = parseFloat(billDet[i].MTS);
						if (billDet[i].LF != "" && billDet[i].LF != null && billDet[i].LF != undefined) {
							var MTS = parseFloat(billDet[i].MTS);
							LESS_FOLD = parseFloat(billDet[i].LF);
							var lessMts = (MTS * LESS_FOLD) / 100;
							NET_MTS = MTS - lessMts;
						}
						div += `
											<tr>
												<td >`+ sr + `-` + getValueNotDefine(billDet[i].qual) + `</td>
												<td  class="hideCategory" style="display:none;">`+ CTGRY + `</td>
												<td  class="hidePCK" style="display:none;">`+ getValueNotDefine((billDet[i].PCK)) + `</td>
												<td  class="hideHSN" >`+ ((billDet[i].hsn)) + `</td>
												<td  class="hidePCS" >`+ getValueNotDefine(valuetoFixedNo(billDet[i].PCS)) + `</td>
												<td  class="hideCUT" >`+ getValueNotDefine(parseInt(billDet[i].CUT).toFixed(2)) + `</td>
												<td  class="hideMTR" >`+ getValueNotDefine(parseInt(billDet[i].MTS).toFixed(2)) + `</td>
												<td  class="hideNETMTS"  style="display:none;" >`+ NET_MTS + `</td>
												<td  class="hideFOLDLESS"  style="display:none;">`+ (parseFloat(LESS_FOLD).toFixed(2)) + `</td>
												<td  class="hideRATE" >`+ getValueNotDefine(valuetoFixed(billDet[i].RATE)) + `</td>
												<td  class="hidePER" >`+ getValueNotDefine(billDet[i].UNIT) + `</td>
												<td  class="hideDISC"  style="display:none;">`+ getValueNotDefine(valuetoFixed(billDet[i].DR)) + `</td>
												<td  class="hideAMOUNT">`+ getValueNotDefine(valuetoFixed(billDet[i].AMT)) + `</td>
											</tr>`;
						if (billDet[i].DET != undefined && billDet[i].DET != null && billDet[i].DET != "") {
							div += `
												<tr>
												<td colspan="10">`+ billDet[i].DET + `</td>
												</tr>
											   `;
						}
						SUBTOTAL += parseFloat(billDet[i].AMT);
						SUBTOTALPCS += parseFloat(billDet[i].PCS);
					}
				} else {
					div += `
											<tr>
											<td>`+ getValueNotDefine(BLS[0].billDetails[0].QUAL) + `</td>
											<td class="text-center">`+ Number(BLS[0].billDetails[0].TPCS) + `</td>
											<td class="text-center"></td>
											<td class="text-center">`+ getValueNotDefine(billDet[i].MTS) + `</td>
											<td class="text-center">`+ getValueNotDefine(BLS[0].billDetails[0].GRT) + `</td>
											<td class="text-right">`+ getValueNotDefine(BLS[0].billDetails[0].grsamt) + `</td>

											</tr>`;
				}

			} catch (error) {
				console.log(error);
			}
			div += `
									</tbody>
								</table>
								`;


			div += `
			<table style="width:100%;">
			<tr>
			
				<td class="thick-line text-right"><strong>Subtotal</strong></td>
				<td class="thick-line text-center"><STRONG>`+ BLS[0].billDetails[0].TPCS + `</STRONG></td>
				<td class="no-line"></td>
				<td class="thick-line text-center">MTS:`+ BLS[0].billDetails[0].TMTS + `</td>
				<td class="thick-line"></td>
				<td class="thick-line text-right"><STRONG>`+ BLS[0].billDetails[0].grsamt + `</STRONG></td>
			</tr>`;
			if (parseFloat(BLS[0].billDetails[0].TDSAMT) != 0 || parseFloat(BLS[0].billDetails[0].TDSRATE) != 0) {
				div += `<tr>
				<td class="no-line"></td>
				<td class="no-line">TDS : </td>
				<td class="no-line">  X </td>
				<td class="no-line"> </td>
				<td class="no-line text-center"><strong>`+ parseFloat(BLS[0].billDetails[0].TDSRATE) + `%</strong></td>
				<td class="no-line text-right">`+ parseFloat(BLS[0].billDetails[0].TDSAMT) + `</td>
				</tr>`;

			}
			if ((getValueNotDefineNo(BLS[0].billDetails[0].LA1RATE)) != 0 || (getValueNotDefineNo(BLS[0].billDetails[0].LA1AMT)) != 0) {
				div += `<tr>
					<td class="no-line"></td>
					<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA1RMK) + `</td>
					<td class="no-line">`+ SUBTOTAL + ` X</td>
					<td class="no-line"></td>
					<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA1RATE + `%</strong></td>
					<td class="no-line text-right">`+ BLS[0].billDetails[0].LA1AMT + `</td>
				</tr>`;
			}
			if ((getValueNotDefineNo(BLS[0].billDetails[0].LA2RATE)) != 0 || (getValueNotDefineNo(BLS[0].billDetails[0].LA2AMT)) != 0) {
				div += `<tr>
					<td class="no-line"></td>
					<td class="no-line"></td>
					<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA2RMK) + `</td>
					<td class="no-line">`+ BLS[0].billDetails[0].LA2qty + `X</td>
					<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA2RATE + `%</strong></td>
					<td class="no-line text-right">`+ BLS[0].billDetails[0].LA2AMT + `</td>
				</tr>`;
			}
			if ((getValueNotDefineNo(BLS[0].billDetails[0].LA3RATE)) != 0 || (getValueNotDefineNo(BLS[0].billDetails[0].LA3AMT)) != 0) {
				div += `<tr>
					<td class="no-line"></td>
					<td class="no-line"></td>
					<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA3RMK) + `</td>
					<td class="no-line">`+ BLS[0].billDetails[0].LA3qty + `X</td>
					<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA3RATE + `%</strong></td>
					<td class="no-line text-right">`+ BLS[0].billDetails[0].LA3AMT + `</td>
				</tr>`;
			}
			if (BLS[0].billDetails[0].VTAMT != 0) {
				var stateCode = parseInt(firmArray[0].COMPANY_GSTIN.substring(0, 2));
				if (BLS[0].billDetails[0].STC == stateCode) {

					div += `	<tr>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line">CGST</td>
						<td class="no-line text-center"><strong>`;
					if (BLS[0].billDetails[0].VTRET != 0) {
						div += BLS[0].billDetails[0].VTRET + '%';
					}
					div += `</strong></td>
						<td class="no-line text-right">`+ BLS[0].billDetails[0].VTAMT + `</td>
					</tr>
					<tr>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line">SGST</td>
						<td class="no-line text-center"><strong>`;
					if (BLS[0].billDetails[0].ADVTRET != 0) {
						div += BLS[0].billDetails[0].ADVTRET + '%';
					}
					div += `</strong></td>
						<td class="no-line text-right">`+ BLS[0].billDetails[0].ADVTAMT + `</td>
					</tr>`;
				} else {
					div += `
					<tr>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line"></td>
						<td class="no-line">GST</td>
						<td class="no-line text-center"><strong>`;
					if (BLS[0].billDetails[0].VTRET != 0) {
						div += BLS[0].billDetails[0].VTRET + '%';
					}
					div += `</strong></td>
						<td class="no-line text-right">`+ BLS[0].billDetails[0].VTAMT + `</td>
					</tr>`;
				}
			}
			div += `
			<tr>
				<td class="no-line"></td>
				<td class="no-line"></td>
				<td class="no-line"></td>
				<td class="no-line"></td>
				<td class="no-line text-center"><strong>Total</strong></td>
				<td class="no-line text-right">`+ BLS[0].billDetails[0].BAMT + `</td>
			</tr>
			</table>
							</div>
							<div style="display: inline;">
								<div>
									<h5 align="left" style="width:100%;float: left;"><strong style="color:blue;">RMK : `+ getValueNotDefine(BLS[0].billDetails[0].RMK) + `</strong></h5>
								</div>
							</div>
							<div style="display: inline;">
								<div>
									<h5 align="left" style="width:40%;float: left;"><strong style="color:blue;">DAYS : `+ (getDaysDif(BLS[0].billDetails[0].DATE, new Date())) + `</strong></h5>
								</div>
								<div>
									<h5 align="right" style="width:60%;float: right;"><strong>GRAND TOTAL:`+ BLS[0].billDetails[0].BAMT + `</strong></h5>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="col-md-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 align="center"class="panel-title">BANK A/C :<strong>`+ firmArray[0].ADDRESS3 + `</strong> IFSC : <strong>` + firmArray[0].ADDRESS4 + `</strong></h3>
						</div>
					</div>
				</div>
			</div>`;
			if ((BLS[0].billDetails[0].paid) == 'Y' || (BLS[0].billDetails[0].PART) == 'Y') {
				div += `<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title"><strong>PAYMENT DETAILS</strong></h3>
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-condensed">
								<tr>
									<td class="no-line">PAID:<a style="color:blue;">`+ BLS[0].billDetails[0].paid + `</a></td>
									<td class="no-line">DATE:</td>
									<td class="no-line">`;
				if ((BLS[0].billDetails[0].PAYDET != '')) {
					div += formatDate(BLS[0].billDetails[0].PAYDET);
				}
				div += `
									</td>
									<td class="no-line text-right"></td>
									<td class="no-line text-center"></td>
								</tr>
								<tr>
									<td class="no-line">CHEQUE NO:<a style="color:blue;">`+ BLS[0].billDetails[0].PAYCHQ + `</a></td>
									<td class="no-line">REC AMT:</td>
									<td class="no-line"><strong>`+ BLS[0].billDetails[0]['RC_AMT'] + `</strong></td>
									<td class="no-line"></td>
									<td class="no-line"></td>
								</tr>`;
				if (BLS[0].billDetails[0].PAYDET != '' || BLS[0].billDetails[0].PAYDET != null) {
					div += `
									<tr>
										<td class="no-line">PAYMENT REC. IN</td>
										<td class="no-line">`+ getDaysDif(BLS[0].billDetails[0].DATE, BLS[0].billDetails[0].PAYDET) + `</td>
										<td class="no-line">DAYS</td>
										<td class="no-line"></td>
										<td class="no-line"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].clms) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">G/R:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].clms + `/-</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].DISC) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">DISCOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].DISC + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].OTH_LS) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">OTHER LESS:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].OTH_LS + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].SWTS_AMT) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">SWEET AMOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].SWTS_AMT + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].AD_AMT) != 0) {
					div +=
						`<tr>
										<td class="no-line"></td>
										<td class="no-line">ADD AMOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].AD_AMT + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				div += `
							</table>`;
				var balance = BLS[0].billDetails[0]['BAMT'] - BLS[0].billDetails[0]['RC_AMT'] - BLS[0].billDetails[0]['DISC'] - BLS[0].billDetails[0]['OTH_LS'] - BLS[0].billDetails[0]['RD_AMT'] - BLS[0].billDetails[0]['clms'] - BLS[0].billDetails[0]['SWTS_AMT'] - BLS[0].billDetails[0]['DDCOM'];
				if (balance > 0) {
					div += `
						</div>
						<div style="display: inline;">
							<div>
								<h5 align="right" style="width:60%;float: right;"><strong>BALANCE:`+ balance + `/-</strong></h5>
							</div>
						</div>`;
				}
				div += `
					</div>
				</div>`;
			}

			$('#fData').html(div);
			$("#loader").removeClass('has-loader');
		} else {
			document.getElementById("fData").innerHTML = "<h1>NO DATA FOUND<h1>";
			$("#loader").removeClass('has-loader');
		}
	}
} catch (error) {
	$('#fData').html(div);
	$("#loader").removeClass('has-loader');
}