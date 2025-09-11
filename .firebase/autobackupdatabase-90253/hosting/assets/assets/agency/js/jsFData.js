

var url = window.location.href;
var VNO = (getUrlParams(url, "VNO"));
var YearChange = (getUrlParams(url, "YearChange"));
var VNO_Less_Value = 0;
var BLS;
var DET;
var BLSdata;
var DETdata;
var ccdpcode = '';
var ccdcity = '';
var ccdbroker = '';
var ccdlabel = '';
var ccdMO = '';
var ccdATYPE = '';


	function load_data() {
		jsGetObjectByKey(DSN, "BLS", "").then(function (dataBLS) {
			BLSdata = dataBLS;
			if (YearChange != '' && YearChange != null) {
				DSN = ClDb + YearChange;
			}
			jsGetObjectByKey(DSN, "DET", "").then(function (dataDET) {
				DETdata = dataDET;
				loadCall(IDE);
			});
		});
	}
	function loadCall(IDE) {
try {

		console.log(IDE);
		var div = '';
		console.log(BLSdata);

		$("#loader").addClass('has-loader');
		BLS = BLSdata.filter(function (data) {
			return data.billDetails.some((billDetails) => billDetails['IDE'].toUpperCase() == IDE.toUpperCase());
		}).map(function (subdata) {
			return {
				code: subdata.COD,
				ATP: subdata.ATP,
				CT: subdata.CT,
				billDetails: subdata.billDetails.filter(function (billDetails) {
					return ((billDetails['IDE'].toUpperCase() == IDE.toUpperCase()));
				})
			}
		})
		console.log(BLS);
		if (BLS.length > 0) {
			partyArray = getPartyDetailsBySendCode(BLS[0].code);
			
			if (partyArray.length > 0) {
				pcode = getValueNotDefine(partyArray[0].partyname);
				city = getValueNotDefine(partyArray[0].city);
				broker = getValueNotDefine(partyArray[0].broker);
				label = getValueNotDefine(partyArray[0].label);
				MO = getValueNotDefine(partyArray[0].MO);
				ATYPE = getValueNotDefine(partyArray[0].ATYPE);
				lbl = parseInt(ATYPE) == 1 ? "CUST : " : parseInt(ATYPE) == 2 ? "SUPP : " : "";

			}
			firmArray = getFirmDetailsBySendCode(BLS[0].billDetails[0].CNO);
			ReportType = " SALES ";
			ReportATypeCode = "1";
			ReportSeriesTypeCode = "S";
			var partyEmail = partyArray[0].EML == null ? '' : partyArray[0].EML;
			ReportDOC_TYPECode = "";
			var hrefLink = "?ntab=NTAB&partycode=" + encodeURIComponent(BLS[0].code) + "&partyname=" + encodeURIComponent(partyArray[0].partyname) + "&FIRM=" + encodeURIComponent(firmArray[0].FIRM) + "&ReportType=" + ReportType + "&ReportATypeCode=" + ReportATypeCode + "&ReportSeriesTypeCode=" + ReportSeriesTypeCode + "&ReportDOC_TYPECode=" + ReportDOC_TYPECode + "&mobileNo=" + partyArray[0].MO + "&partyEmail=" + encodeURIComponent(partyEmail);
		document.getElementById("hrefBILLPDF").href = "Billpdf.html?ntab=NTAB&IDE=" + IDE + "&CNO=" + BLS[0].billDetails[0].CNO + "&TYPE=" + BLS[0].billDetails[0].TYPE + "&VNO=" + VNO + "&YearChange=" + YearChange + "&mobileNo=" + partyArray[0].MO;

			var titleBill = BLS[0].billDetails[0].BLL;
			titleBill = titleBill.replace("\/", "-");
			document.title = "BILL NO- " + titleBill
			div += `		
					<div id="FullData" class="row">
					<div class="col-xs-12">
					<div class="invoice-title">
						<h2>`+ firmArray[0].FIRM + `</h2>
						<p>`+ firmArray[0].ADDRESS1 + `,` + firmArray[0].ADDRESS2 + `,<b>` + firmArray[0].CITY1 + `,MO.` + firmArray[0].MOBILE + `</b></p>
						<h3 class="pull-right"><strong>BILL -`+ BLS[0].billDetails[0].BLL + `</strong></h3><BR><BR>						
					</div>
					<hr>
					<div class="row">
						<div class="col-xs-6">
						<strong>
							<address>
							`+ lbl + `	` + pcode + `<br>
								`+ getValueNotDefine(partyArray[0].AD1) + `,` + getValueNotDefine(partyArray[0].AD2) + `<br>
								`+ partyArray[0].city + `<br>`;

			div += `	</strong><br>`;
			if ((BLS[0].billDetails[0].BCODE) != null) {
				div += `<strong>BROKER:</strong> ` + getPartyDetailsBySendCode(BLS[0].billDetails[0].BCODE)[0].partyname;
			}

			ccode = getPartyDetailsBySendName(BLS[0].billDetails[0].ccd);
			ccdlbl = "";
			if (ccode.length > 0) {
				ccdpcode = getValueNotDefine(ccode[0].partyname);
				ccdcity = getValueNotDefine(ccode[0].city);
				ccdbroker = getValueNotDefine(ccode[0].broker);
				ccdlabel = getValueNotDefine(ccode[0].label);
				ccdMO = getValueNotDefine(ccode[0].MO);
				ccdATYPE = getValueNotDefine(ccode[0].ATYPE);
				ccdlbl = parseInt(ccdATYPE) == 1 ? "CUST : " : parseInt(ccdATYPE) == 2 ? "SUPPLIER : " : "";
			}

			div += `<br>
							</address>
						</div>
						<div class="col-xs-6 text-right">
							<address class="">
							<strong>
							<h4>	BILL DATE : `+ formatDate(BLS[0].billDetails[0].DTE) + `</h4>
							<a style="color:blue;">`+ ccdlbl + `</a>` + ccdpcode + `</strong><br>
								<b></b><br>
								<b></b><br>
							</address>
						</div>
						
						</div>`;
			if (getValueNotDefine(BLS[0].billDetails[0].TRN) != "" || getValueNotDefine(BLS[0].billDetails[0].RNO) != "") {
				div += `
						<div align="center">
							<div style="width:100%;display:inline;">
								<div style="width:50%;float:left;text-align:center;font-weight:bold;">
									TRANSPORT : `+ getValueNotDefine(BLS[0].billDetails[0].TRN) + `
								</div>
								<div style="width:50%;float:left;text-align:center;font-weight:bold;">
									LR NO : `+ getValueNotDefine(BLS[0].billDetails[0].RNO) + `
								</div>
							</div>
						</div>

						`;
			}
			div += `

				</div>
			</div><div class="row">
				<div class="col-md-12">
					<div class="panel panel-default">
						<div class="panel-heading">
							<h3 class="panel-title"><strong>Order summary</strong></h3>
						</div>
						<div class="panel-body">
							<div class="table-responsive">
								<table class="table table-condensed" style="border: 1px solid black;">
									<thead>
										<tr>
											<td><strong>ITEM</strong></td>
				   							<td class="text-center"><strong>PCS</strong></td>
											<td class="text-center"><strong>PACK</strong></td>
											<td class="text-center"><strong>MTS</strong></td>
											<td class="text-center"><strong>RATE</strong></td>
											<td class="text-right"><strong>Total</strong></td>
										</tr>
									</thead>
									<tbody>`;
			try {


				DET = DETdata.filter(function (data) {
					return data.CNO.toUpperCase() == BLS[0].billDetails[0].CNO.toUpperCase() &&
						data.TYPE.toUpperCase() == BLS[0].billDetails[0].TYPE.toUpperCase() &&
						data.VNO.toUpperCase() == BLS[0].billDetails[0].VNO.toUpperCase();
				})

				console.log("billDetails", DET, VNO);
				if (DET.length > 0) {
					var billDet = DET[0].billDetails;
					var SUBTOTAL = 0;
					var SUBTOTALPCS = 0;
					for (var i = 0; i < billDet.length; i++) {
						div += `
											<tr>
												<td>`+ getValueNotDefine(billDet[i].qual) + `</td>
												<td class="text-center">`+ Number(billDet[i].PCS) + `</td>
												<td class="text-center">`+ getValueNotDefine(billDet[i].PCK) + `</td>
												<td class="text-center">`+ getValueNotDefine(billDet[i].MTS) + `</td>
												<td class="text-center">`+ getValueNotDefine(billDet[i].RATE) + `</td>
												<td class="text-right">`+ getValueNotDefine(billDet[i].AMT) + `</td>

											</tr>`;
						if (billDet[i].DET != undefined && billDet[i].DET != null && billDet[i].DET != "") {
							div += `
												<tr>
												<td colspan="6">`+ billDet[i].DET + `</td>
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
												<td class="text-center">`+ Number(BLS[0].billDetails[0].PCS) + `</td>
												<td class="text-center"></td>
												<td class="text-center">`+ getValueNotDefine(BLS[0].billDetails[0].MTS) + `</td>
												<td class="text-center">`+ getValueNotDefine(BLS[0].billDetails[0].GRT) + `</td>
												<td class="text-right">`+ getValueNotDefine(BLS[0].billDetails[0].GAMT) + `</td>

											</tr>`;
				}

			} catch (error) {
				console.log(error);
			}
			div += `
										<tr>
											<td class="thick-line text-right"><strong>Subtotal</strong></td>
											<td class="thick-line text-center"><STRONG>`+ BLS[0].billDetails[0].PCS + `</STRONG></td>
											<td class="no-line"></td>
											<td class="thick-line text-center">MTS:`+ BLS[0].billDetails[0].MTS + `</td>
											<td class="thick-line"></td>
											<td class="thick-line text-right"><STRONG>`+ BLS[0].billDetails[0].GAMT + `</STRONG></td>
										</tr>`;
			if (getValueNotDefineNo(BLS[0].billDetails[0].OT_LS) != 0) {
				div += `<tr>
																			<td class="no-line"></td>
																			<td class="no-line"></td>
																			<td class="no-line"></td>
																			<td class="no-line">DISCOUNT: </td>
																			<td class="no-line text-center"></td>
																			<td class="no-line text-right">`+ BLS[0].billDetails[0].OT_LS + `</td>
																		</tr>`;
			}
			if (getValueNotDefineNo(BLS[0].billDetails[0].LA1RT) != 0) {
				div += `<tr>
												<td class="no-line"></td>
												<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA1RMK) + `</td>
												<td class="no-line">`+ SUBTOTAL + ` X</td>
												<td class="no-line"></td>
												<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA1RT + `%</strong></td>
												<td class="no-line text-right">`+ BLS[0].billDetails[0].LA1AMT + `</td>
											</tr>`;
			}
			if (getValueNotDefineNo(BLS[0].billDetails[0].LA2RT) != 0) {
				div += `<tr>
												<td class="no-line"></td>
												<td class="no-line"></td>
												<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA2RMK) + `</td>
												<td class="no-line">`+ BLS[0].billDetails[0].LA2qty + `X</td>
												<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA2RT + `%</strong></td>
												<td class="no-line text-right">`+ BLS[0].billDetails[0].LA2AMT + `</td>
											</tr>`;
			}
			if (getValueNotDefineNo(BLS[0].billDetails[0].LA3RT) != 0) {
				div += `<tr>
												<td class="no-line"></td>
												<td class="no-line"></td>
												<td class="no-line">`+ getValueNotDefine(BLS[0].billDetails[0].LA3RMK) + `</td>
												<td class="no-line">`+ BLS[0].billDetails[0].LA3qty + `X</td>
												<td class="no-line text-center"><strong>`+ BLS[0].billDetails[0].LA3RT + `%</strong></td>
												<td class="no-line text-right">`+ BLS[0].billDetails[0].LA3AMT + `</td>
											</tr>`;
			}
			if (BLS[0].billDetails[0].VTAMT != 0) {
				if (BLS[0].billDetails[0].STC == 24) {

					div += `	<tr>
													<td class="no-line"></td>
													<td class="no-line"></td>
													<td class="no-line"></td>
													<td class="no-line">CGST</td>
													<td class="no-line text-center"><strong>`;
					if (BLS[0].billDetails[0].VTRT != 0) {
						div += BLS[0].billDetails[0].VTRT + '%';
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
					if (BLS[0].billDetails[0].ADVTRT != 0) {
						div += BLS[0].billDetails[0].ADVTRT + '%';
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
					if (BLS[0].billDetails[0].VTRT != 0) {
						div += BLS[0].billDetails[0].VTRT + '%';
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
									</tbody>
								</table>
							</div>
							<div style="display: inline;">
								<div>
									<h5 align="left" style="width:40%;float: left;"><strong style="color:blue;">DAYS : `+ (getDaysDif(BLS[0].billDetails[0].DTE, new Date())) + `</strong></h5>
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
							<h3 align="center"class="panel-title">`+ ccdlbl + `BANK A/C :<strong>` + getValueNotDefine(ccode[0].AD3) + `</strong> IFSC : <strong>` + getValueNotDefine(ccode[0].AD4) + `</strong></h3>
						</div>
					</div>
				</div>
			</div>`;
			if ((BLS[0].billDetails[0].PD) == 'Y' || (BLS[0].billDetails[0].PRT) == 'Y') {
				div += `<div class="panel panel-default">
					<div class="panel-heading">
						<h3 class="panel-title"><strong>PAYMENT DETAILS</strong></h3>
					</div>
					<div class="panel-body">
						<div class="table-responsive">
							<table class="table table-condensed">
								<tr>
									<td class="no-line">PAID:<a style="color:blue;">`+ BLS[0].billDetails[0].PD + `</a>,PART:<a style="color:blue;">` + BLS[0].billDetails[0].PRT + `</a></td>
									<td class="no-line">DATE:</td>
									<td class="no-line">`;
				if ((BLS[0].billDetails[0].PDT != '')) {
					div += formatDate(BLS[0].billDetails[0].PDT);
				}
				div += `
									</td>
									<td class="no-line text-right"></td>
									<td class="no-line text-center"></td>
								</tr>
								<tr>
									<td class="no-line">CHEQUE NO:<a style="color:blue;">`+ getValueNotDefine(BLS[0].billDetails[0].PYCQ) + `</a></td>
									<td class="no-line">REC AMT:</td>
									<td class="no-line"><strong>`+ BLS[0].billDetails[0]['RAMT'] + `</strong></td>
									<td class="no-line"></td>
									<td class="no-line"></td>
								</tr>`;
				if (BLS[0].billDetails[0].PDT != '' && BLS[0].billDetails[0].PDT != null) {
					div += `
									<tr>
										<td class="no-line">PAYMENT REC. IN</td>
										<td class="no-line">`+ getDaysDif(BLS[0].billDetails[0].PDT, new Date()) + `</td>
										<td class="no-line">DAYS</td>
										<td class="no-line"></td>
										<td class="no-line"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].CLM) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">G/R:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].CLM + `/-</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].DSC) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">DISCOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].DSC + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].O_LS) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">OTHER LESS:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].O_LS + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].SWTAMT) != 0) {
					div += `
									<tr>
										<td class="no-line"></td>
										<td class="no-line">SWEET AMOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].SWTAMT + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				if ((BLS[0].billDetails[0].ADAMT) != 0) {
					div +=
						`<tr>
										<td class="no-line"></td>
										<td class="no-line">ADD AMOUNT:<a style="color:blue;"></a></td>
										<td class="no-line"><strong>`+ BLS[0].billDetails[0].ADAMT + `</strong></td>
										<td class="no-line"></td>
										<td class="no-line text-right"></td>
									</tr>`;
				}
				div += `
							</table>`;
				var balance = BLS[0].billDetails[0]['FAMT'] - BLS[0].billDetails[0]['RAMT'] - BLS[0].billDetails[0]['DCAMT'] - BLS[0].billDetails[0]['O_LS'] - BLS[0].billDetails[0]['RDAMT'] - BLS[0].billDetails[0]['CLM'] - BLS[0].billDetails[0]['SWTAMT'] - BLS[0].billDetails[0]['DDCM'];
				if (balance > 10000000000000000000000000000000000) {
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
	} catch (error) {
		alert(error);
	}
	}
