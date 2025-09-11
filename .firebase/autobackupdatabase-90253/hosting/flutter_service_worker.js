'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "9f9bf59973b7f06cb7509de256e1eb2e",
"version.json": "7b9dc551b4699a172a07c033b5ce4e4c",
"index.html": "a115cf49e861345abf9c669ef24956b2",
"/": "a115cf49e861345abf9c669ef24956b2",
"main.dart.js": "cf490c542b36137841bcf0e2ee239b20",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "7f0a15691a17a86ef62b051fab013b03",
"assets/AssetManifest.json": "c850924fa913d609278f0423531d51db",
"assets/NOTICES": "13ca502439bb9e9fd0bd5abf2cd0d297",
"assets/FontManifest.json": "bf56da640282efe5571fec13e7e79ec1",
"assets/AssetManifest.bin.json": "69baf0c81b32476377a3e4b788f79b4a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "9404b0c92588b0a890182c261dfbdea3",
"assets/packages/flutter_inappwebview_web/assets/web/web_support.js": "509ae636cfdd93e49b5a6eaf0f06d79f",
"assets/packages/flutter_image_compress_web/assets/pica.min.js": "6208ed6419908c4b04382adc8a3053a2",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js.map": "1d2af1f0a021761b289f4bf0fed87242",
"assets/packages/amplify_auth_cognito_dart/lib/src/workers/workers.min.js": "77727e3a27ad3662c8fe30922a27626e",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/amplify_authenticator/assets/social-buttons/SocialIcons.ttf": "376fbf368ffe39e045978e3d3197efbd",
"assets/packages/amplify_authenticator/assets/social-buttons/google.png": "a1e1d65465c69a65f8d01226ff5237ec",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js.map": "9b2bffbaa129cc1c87dc497827f159bd",
"assets/packages/amplify_secure_storage_dart/lib/src/worker/workers.min.js": "c21f04e68a1c1dcfecfad44bcd2e8953",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d7a9da7865f1f17bcd905cd12337199a",
"assets/fonts/MaterialIcons-Regular.otf": "175aea801508e546a2073595c36823b9",
"assets/assets/html2canvas.js": "d0742edd178c84f1a681c5f61d871359",
"assets/assets/jsPDF.js": "b9ee7f21dce277ad27dad7e3d1b643ff",
"assets/assets/favicon.ico": "be3874de31253abcb55d7f7beae327df",
"assets/assets/ENC.iv": "d0976f8f30baeef6e2c3a2b1c7947508",
"assets/assets/agency/jsLoadCallCOMM_backup.js": "1c3da55eea63a6a51cf02c8d746973e8",
"assets/assets/agency/bulkPdfBill.html": "65b2e3dc8b4c2b1429b2258333ab3cb3",
"assets/assets/agency/orderFormList_FRM.html": "e12240a5941318ff9b253084b6f062ab",
"assets/assets/agency/orderFormList.html": "5d29f0dcc1e36c1871df8671dd9e2c23",
"assets/assets/agency/bankPassBook_FRMReport.html": "3389ff7adf0b47fc00c1c51c82b5c729",
"assets/assets/agency/paymentSlip.html": "394a78d867f5396dfe3d19bd76a8367d",
"assets/assets/agency/ALLSALE_FRMReport.html": "23fd9b63e200f1ee6d8ca765119cddba",
"assets/assets/agency/gstin_search.html": "71fbfd4fb7ec023684101fd1ebf963ab",
"assets/assets/agency/LEDGER_AJXREPORT.html": "766536c94786ae9dc1ad37c0e243c5b1",
"assets/assets/agency/BillpdfPurchase.html": "929286d534d26f8943ad4aca9b201fee",
"assets/assets/agency/favicon.ico": "be3874de31253abcb55d7f7beae327df",
"assets/assets/agency/findBill.html": "6cdf5bcf57f7cc5ac8a5172b2ea2428e",
"assets/assets/agency/3.3.1/jquery.min.js": "9ac39dc31635a363e377eda0f6fbe03f",
"assets/assets/agency/3.3.1/jquery.min%2520-%2520Copy.js": "a46fb81762396b7bf2020774a2fb4d9e",
"assets/assets/agency/LEDGER_FRMReport.html": "98b927e60d47d2f5571d709cdb143045",
"assets/assets/agency/3.3.6/bootstrap.min.css": "44417d2b3ac02e1cb424cd9cb226d317",
"assets/assets/agency/3.3.6/bootstrap.min.js": "fb0e635db142b1b9fce20fe2370ec6cc",
"assets/assets/agency/jsonSyncToIndexeddb.html": "a0e3c4e7ae01ff467dba58cf77e770ae",
"assets/assets/agency/acgroup.html": "087dea88797a2f65ee6bd27d9106250b",
"assets/assets/agency/master.html": "ab9b67ad91ec42599607dd3b833f10e9",
"assets/assets/agency/firebasejs/8.6.2/initializeFirebase.js": "00b7ace70a05a2fe5ff0fe0804997b79",
"assets/assets/agency/firebasejs/8.6.2/retrieveImg.js": "29269d295e3f798b013b9c5c543582b4",
"assets/assets/agency/firebasejs/8.6.2/connFirebase.js": "0fc52655175c9d6d4a5ce636372cd01f",
"assets/assets/agency/firebasejs/8.6.2/firebase-app.js": "1069e3997c89b18e1d426a89e055b9c9",
"assets/assets/agency/firebasejs/8.6.2/SelectOrUploadFileFirebase.js": "42a9e192a53828bede4a6e43f867f215",
"assets/assets/agency/firebasejs/8.6.2/firebase-auth.js": "593c4b5d072671b312195c12c96ec0a5",
"assets/assets/agency/firebasejs/8.6.2/DataTrfirebase.js": "a714ba7d0f3be140a180c7bc2e2a928b",
"assets/assets/agency/firebasejs/8.6.2/firebase-database.js": "d732a727d48dd48aba2eb25c374d5a64",
"assets/assets/agency/firebasejs/8.6.2/firebase-storage.js": "bfb852b5eb47e351583e814b8a86b1c0",
"assets/assets/agency/ALLSALE_AJXREPORT.html": "71364d499f412e3abdd8ee0a371c58e4",
"assets/assets/agency/jsKey.js": "a8c09873a106fa41f4b19626fe7cfd9a",
"assets/assets/agency/Billpdf.html": "bbdd1ff0d3302be247d1bebb5a4b4598",
"assets/assets/agency/3.3.7/bootstrap.min.css": "5057f321f0dc85cd8da94a0c5f67a8f4",
"assets/assets/agency/3.3.7/bootstrap.min.js": "ce109ab9e64a879d06e045a0492ac502",
"assets/assets/agency/bankPassBook_AJXREPORT.html": "078e7ee760245b29de2a80865b1111bb",
"assets/assets/agency/2.1.3/jquery.min.js": "adb784ef9dc257b32965a5da7ee82a8b",
"assets/assets/agency/css/styleLoader.css": "2bbe5b64d8dc4e4b8d042c27d6f62904",
"assets/assets/agency/css/orderForm.css": "f87f76f3a698b432d304fc0522873263",
"assets/assets/agency/css/fs-modal.min.css": "093d80283a23f5ef6c1cbc947663a9fa",
"assets/assets/agency/css/styleSideNav.css": "3bc3c3b4e7d2e5ee6f3faaac161e1407",
"assets/assets/agency/css/stylePrint.css": "7bddd8effb513e69d7b6b43f594a4421",
"assets/assets/agency/css/style.css": "021d5979e007b2919b89463cecbdd331",
"assets/assets/agency/css/print.css": "b05339afd0205fcb8d27f182515c8a74",
"assets/assets/agency/css/styleAutoComplete.css": "96611684f8ca544bd40ee7dc4a284459",
"assets/assets/agency/css/billPdf.css": "8d0a8b3b4d74b412bf83b8e27f762450",
"assets/assets/agency/jszip.min.js": "7a4daf0415f1e96242758bbb617272b8",
"assets/assets/agency/js/jsLoadCallCOMM_backup.js": "1c3da55eea63a6a51cf02c8d746973e8",
"assets/assets/agency/js/jsgetArrayProductdetailsbyIDE.js": "b4acd24aa6d447055b874d5a8fc7fc43",
"assets/assets/agency/js/jsGetBillDataFromJson.js": "95fcff076659b020165556140af18128",
"assets/assets/agency/js/jsLoadCallPURCHASEOUTSTANDING_DATEWISE.js": "2bf8bd9cd1ea1d58b968e197f8357837",
"assets/assets/agency/js/jsgetPartyListBySendBrokerCityCode.js": "a89e86dae28be22960d25ea4f3c50e7e",
"assets/assets/agency/js/jsmakePdf1.js": "ae97d4edf3133e57a78928c2c6ddbbbd",
"assets/assets/agency/js/jsPdfMillChalan.js": "6342c9dc80c42031b13415f6310e01e5",
"assets/assets/agency/js/jsPdfOrderForm.js": "962789d6e40a0fa516752761c6e5bee1",
"assets/assets/agency/js/jsLoadCallDDREG.js": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/agency/js/jsLoadCallBLS_DATEWISE.js": "614d45ecbeed9deb2f51b235a33edf90",
"assets/assets/agency/js/jsPaymentSlipPdf.js": "61c859c5ad13239413d2ec869696d4f3",
"assets/assets/agency/js/jsconnectionDatabase-min.js": "a9c7eb5550d206758ce308ccabf9de72",
"assets/assets/agency/js/jsLoadCallPURCHASEOUTSTANDING.js": "6ca9a726fb1e593693fd763243547bde",
"assets/assets/agency/js/jsGetCookies.js": "44ca13c5fe815a6ea670b8e753ef5381",
"assets/assets/agency/js/jstoFixedNumber.js": "9a47be69aec160cdbe66137cce50f215",
"assets/assets/agency/js/localStorageGet.js": "e5abd60603b20df79f9541c6aa0bc52f",
"assets/assets/agency/js/jsFData.js": "48487ec24a795aefdfe44cc216454490",
"assets/assets/agency/js/jsGetDateFormate.js": "e017ad86a3544eeddc66b699becb7bb1",
"assets/assets/agency/js/jsFirmCnoOperate.js": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/agency/js/jsHeaderTbl.js": "a658f25e22aea33bfa475e46d67cabdd",
"assets/assets/agency/js/jsSearchEngfrm.js": "1760c7cf2666dbd6ce571e2b8d824b94",
"assets/assets/agency/js/jsLoadCallBLS_SUPP_WISE_PARTY_WISE.js": "4ffa4c28d469f7f29118176546aa7203",
"assets/assets/agency/js/jscreateDatabase.js": "d5e35fdd9a9a1a80e7d4830004d17c36",
"assets/assets/agency/js/jsLoadCallMASTER_NEW.js": "75126761810a9c5654e881d34770eafb",
"assets/assets/agency/js/jsSearchfrm.js": "2521a5f4b0ea02c8466ca6b710c0863d",
"assets/assets/agency/js/paymentSlip.js": "e4f75fb04c3ff402eed3f22e0fd87bb0",
"assets/assets/agency/js/jsoptionFirmSelect.js": "94bd2b75eba33089da0feb85dff7d60c",
"assets/assets/agency/js/COMM_AJXREPORT.html": "bf0791c6c56dad31659411a6dcef8d91",
"assets/assets/agency/js/COMM_FRMReport.html": "b11dc974ebff0b35ce0bbd3c969b6b89",
"assets/assets/agency/js/creditDebitBill.js": "8d78b1e48ca10a26a24fe262eb800cac",
"assets/assets/agency/js/jsLoadCallQualChart.js": "374ffc0f856f44785630d41d99d30c69",
"assets/assets/agency/js/jsLoadCallOUTSTANDING_SUPP_WISE_PARTY_WISE.js": "39aeb6376a6cf10da10ca35431d795d3",
"assets/assets/agency/js/jsoptionSeriesSelect.js": "086d863d0a985ea48b31a55777378f0e",
"assets/assets/agency/js/jsgetValueNotDefineNo.js": "90584c85459009c4db0e6df5c66c1504",
"assets/assets/agency/js/localStorageSet.js": "eddd7cdf59f979789d4ace5b4ec1ea2a",
"assets/assets/agency/js/jsopenSubReport.js": "ad7aa808b1b2b2c603d68b067d027486",
"assets/assets/agency/js/jsLoadCallOUTSTANDING_backup.js": "fb754ddb5e8ebc43864b32f8e6cba5c6",
"assets/assets/agency/js/jsStoreDatatoIndexeddb.js": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/agency/js/jsLoadCallLEDGER.js": "67ca83a602c46031dec66e357678087a",
"assets/assets/agency/js/jsgetFullDataLinkByMillCardNo.js": "a5c272dd1b5e07f9b9a36f1ed9f64da3",
"assets/assets/agency/js/jsGetPartyListJsonByCity.js": "3df21a258a8f62915001e59a97505bb2",
"assets/assets/agency/js/jsLoadCallorderFormList.js": "9310d98e08a11864d51aadadf8e2abc3",
"assets/assets/agency/js/setTitle.js": "81051bcc2cf1bedf378224b0a93e2877",
"assets/assets/agency/js/jsLoadCallBLS.js": "585f48d2495692038630d14a56d9d5ec",
"assets/assets/agency/js/jsLoadCallMASTER.js": "9a799b796e53302c8ad28862239e81d8",
"assets/assets/agency/js/jsLoadCallOUTSTANDING_DATEWISE.js": "71c6fada40f1392e802693a03394cd65",
"assets/assets/agency/js/cloudOrderGtD.js": "9a7eef433521977bde39e9c1fb2b0f98",
"assets/assets/agency/js/jsgetValueNotDefine.js": "68e771c9f85124718a0950f1e9589374",
"assets/assets/agency/js/jsLoadCallOUTSTANDING_MONTH_WISE.js": "c4fb3bc6cea16a15833beb92e157b722",
"assets/assets/agency/js/jsGetObjectByKey.js": "0c3784410c82f6d6914237b15a286910",
"assets/assets/agency/js/jsGetPartyListJsonByBroker.js": "71bebc151e8576c44de5f9090d3e1d5f",
"assets/assets/agency/js/jsLoadCallPCORDER_SUMMERY.js": "fb3aa29b5cc693b5c772633bcf732b78",
"assets/assets/agency/js/jsLoadCallBLS_MONTH_WISE_PARTY_WISE.js": "bfa6f6873ecb805a3561f297a27b15ed",
"assets/assets/agency/js/creditDebitPurchaseBill.js": "50a56d4d5e6771923dcc0600912684d1",
"assets/assets/agency/js/jsPopUpModelParty.js": "6f1dc5ac4ee83d849bc83093603e7eea",
"assets/assets/agency/js/cloudOrderStD.js": "6c0b44c0d348bd06de3f93855471343c",
"assets/assets/agency/js/fs-modal.min.js": "d04aa95dded5309a95619cfd18af4c60",
"assets/assets/agency/js/jsLoadCallPCORDER.js": "6f40fc4653540710693f9f38eb3ebbd7",
"assets/assets/agency/js/jsLoadCallOUTSTANDING.js": "b2646c7c7a9ee6bdbdced1661c64dcf9",
"assets/assets/agency/js/jsgetEMPdata.js": "6d806f313f2b8f9c0af6ab003b2f0b5b",
"assets/assets/agency/js/jsLoadCallCOMM.js": "aa7e6b4b40a7dada159dce0b6b8212dc",
"assets/assets/agency/js/jsLoadCallACGROUP.js": "9445b59f1ce87250d337eab5871ce699",
"assets/assets/agency/js/jsprevents.js": "802976ba775a1f5bdcca99dacc18cb60",
"assets/assets/agency/js/jsonHandler.php": "d74bb2388d8e9258dfb6328c7ab18f1f",
"assets/assets/agency/js/jsfindBill.js": "774ac9e0f1819ec1fb0dfa4a79effca3",
"assets/assets/agency/js/jsGetDaysDif.js": "be8f57bd7ee2843562a9b72ae161719d",
"assets/assets/agency/js/jsopenSubReportCOMM.js": "2459222b8774da0d2b1661e0afcf5da7",
"assets/assets/agency/js/filterSelected.js": "03a16ec0ecd11bdb453b99503720eff4",
"assets/assets/agency/js/jsconnectionDatabase.js": "88065cdae408908eca9bba39c11ab32c",
"assets/assets/agency/js/jsOpenBillDetilasAsTable.js": "5a876ade10ef62fdf897a73d3d3b2451",
"assets/assets/agency/js/jspushDataToIndexDb.js": "efa6068d53cdb52a1b9a6772eb4fe6e6",
"assets/assets/agency/js/jsLoadCallBANK.js": "8eda95aa1cf75ae5b516d7306edd81a5",
"assets/assets/agency/js/jsPopUpTblSetting.js": "061054c83e84578502b64c63c0605f08",
"assets/assets/agency/js/jsLoadCallCOMM_DATEWISE.js": "615339c0527bff67ea5e88ef0e916397",
"assets/assets/agency/js/jstoFixed.js": "a950fe97d4b38419d6f03bb68e2014de",
"assets/assets/agency/js/jsLoadCallPENDINGLR.js": "315d5343c31c68d577e5e921c9637e33",
"assets/assets/agency/js/jsfunction.js": "38ae2cb5b5457953ca0cedc6da091bde",
"assets/assets/agency/js/jsDeleteIndexeddb.js": "b7ad3bf4c554802aa15334b4261118f7",
"assets/assets/agency/js/jsmakePdf2.js": "8b60eaf031e95b17a64d2a3429990d29",
"assets/assets/agency/js/jsGetSaleData.js": "0963ad9c20c759cf4bad450d6d93ec33",
"assets/assets/agency/js/jsGetUrlParams.js": "1cb9cb9de7994614e251190ed00a5b92",
"assets/assets/agency/js/jsGetYearChange.js": "b417e83708beb79a113508c52ad4a2cb",
"assets/assets/agency/js/jsOrderFormAutoComplet.js": "f0f3403ac93ffafe0d7f2e97c41bc5c4",
"assets/assets/agency/1.10.2/jquery%2520-%2520Copy.js": "9942970f31d917fa6aae66fa3b9b09ff",
"assets/assets/agency/1.10.2/jquery.js": "adb784ef9dc257b32965a5da7ee82a8b",
"assets/assets/agency/COMM_AJXREPORT.html": "19756561a6e193efca6118db0acbc9b0",
"assets/assets/agency/1.10.4/jquery-ui.css": "58437360aa21a61ea9db0b43d8e3900a",
"assets/assets/agency/1.10.4/jquery-ui.js": "e725015d340350624b52583945efaefa",
"assets/assets/agency/COMM_FRMReport.html": "b11dc974ebff0b35ce0bbd3c969b6b89",
"assets/assets/agency/chart.html": "0f4c04475b3de6e02ab34f1dfcd650e6",
"assets/assets/agency/4.1.1/bootstrap.min.css": "e59aa29ac4a3d18d092f6ba813ae1997",
"assets/assets/agency/Errorchecker.vbs": "1aa009d9befb3bc98eae38b3856056a1",
"assets/assets/agency/PURCHASE_AJXREPORT.html": "eeab5788a689bc5c6307fe52b235a61c",
"assets/assets/agency/fData.html": "92c9d9d6b26eef28d57849d77d6a4654",
"assets/assets/agency/OUTSTANDING_AJXREPORT.html": "94be7ded3e3ee6ff6d27b06412042fdd",
"assets/assets/agency/deleteDatabase.html": "8e2f8856c09973f1bb8fa2be7fa90ece",
"assets/assets/agency/OUTSTANDING_FRMReport.html": "6570fba13fbd963bd6a8d360f7f72370",
"assets/assets/agency/jsonSyncToIndexeddbFirebase.html": "cca4f58d2538938e1b73eca22afb96af",
"assets/assets/agency/debug.log": "c675b647b79050f05e96df8b4bda12c8",
"assets/assets/agency/PURCHASE_FRMReport.html": "10082c054d4725d3a74e0e5d76bb6bb9",
"assets/assets/agency/jsLoadCallCOMM.js": "27fa35a75847343b67af968b2d4f26e9",
"assets/assets/agency/DDREG_FRMReport.html": "74315f78ae071bde0bd3fef4e3a2f8f3",
"assets/assets/agency/upi.webp": "03137e8e3974ec104afdb3c57e84583c",
"assets/assets/agency/PCORDER_FRMReport.html": "2e53676af7a16869d75f59340c08cf83",
"assets/assets/agency/PURCHASEOUTSTANDING_FRMReport.html": "727effe0df1db4b4f3d0d89cb50267e5",
"assets/assets/agency/PURCHASEOUTSTANDING_AJXREPORT.html": "7dfcabb064751aafd04b4ae196120637",
"assets/assets/agency/jsLoadCallCOMM_DATEWISE.js": "9734859c6f621001be84a9e67d38b4d8",
"assets/assets/agency/QualChart.html": "c66c29e5144efe24f9bc172abdd3a76f",
"assets/assets/agency/PCORDER_AJXREPORT.html": "11de659376b48ce5067e76c197dd5ad3",
"assets/assets/agency/headlessSync.html": "a3d0544d3a5a156970a047bc45d05669",
"assets/assets/agency/orderForm.html": "878cc0e93e5d6d2e7a034f06af90801b",
"assets/assets/agency/DDREG_AJXREPORT.html": "e4972b0a1c69c7371e41872b56bfd62c",
"assets/assets/ENC.key": "b81e92fb32caeb6831195a33bdce6af1",
"assets/assets/uniquesoftwares/syncing.svg": "f12a2ff905a2eb944259715a141535b1",
"assets/assets/uniquesoftwares/checkmark.svg": "a0fd0a978d1f1817cc72a5462dd9d396",
"assets/assets/uniquesoftwares/LEDGER_INTEREST_AJXREPORT.html": "84eb3456d7209ba96ca21db32959f7d5",
"assets/assets/uniquesoftwares/bulkPdfBill.html": "75629c2d0ce59f47fb9dbf787d118af8",
"assets/assets/uniquesoftwares/orderFormList_FRM.html": "7900a086b4ba648d1a0fc71bfd81da88",
"assets/assets/uniquesoftwares/orderFormList.html": "dbef8da9c03ecfeca0192fd009f31724",
"assets/assets/uniquesoftwares/bankPassBook_FRMReport.html": "cdd9a263d5e9f5aa4cd8849f457f177d",
"assets/assets/uniquesoftwares/PURCHASEFINISH_AJXREPORT.html": "b86f98baede8862ee27467a57fd3d1cd",
"assets/assets/uniquesoftwares/RETURNGOODS_FRMReport.html": "782461c616b0a3a939cc77f0f00ecd89",
"assets/assets/uniquesoftwares/TDS_AJXREPORT.html": "0e762866131836d804cd3f49a735a8c8",
"assets/assets/uniquesoftwares/ALLSALE_FRMReport.html": "2b191271c62428057e5ce81b421ef52f",
"assets/assets/uniquesoftwares/gstin_search.html": "f6688d0549be32612deba452bb09cc88",
"assets/assets/uniquesoftwares/LEDGER_AJXREPORT.html": "d0bc428b6c697090135d9893d4057ff8",
"assets/assets/uniquesoftwares/favicon.ico": "be3874de31253abcb55d7f7beae327df",
"assets/assets/uniquesoftwares/findBill.html": "c52b159d52e81f3b56f2ef79081cd3bd",
"assets/assets/uniquesoftwares/3.3.1/jquery.min.js": "a46fb81762396b7bf2020774a2fb4d9e",
"assets/assets/uniquesoftwares/LEDGER_FRMReport.html": "3ef01e5171a2fe428ba5e710981993ac",
"assets/assets/uniquesoftwares/3.3.6/bootstrap.min.css": "44417d2b3ac02e1cb424cd9cb226d317",
"assets/assets/uniquesoftwares/3.3.6/bootstrap.min.js": "fb0e635db142b1b9fce20fe2370ec6cc",
"assets/assets/uniquesoftwares/jsonSyncToIndexeddb.html": "c079a514aaaefff7545b072302029293",
"assets/assets/uniquesoftwares/clearCache.html": "6e26ef5acb481a51ca711ae6eb65b49d",
"assets/assets/uniquesoftwares/firebaseImageUpload.html": "2f0a6b5168173a97e0f1638c5b07ab32",
"assets/assets/uniquesoftwares/master.html": "39885d4e0238e7feb01095e2783c0434",
"assets/assets/uniquesoftwares/TDS_FRMReport.html": "f3215810cea6ecef264a7b85b08bc181",
"assets/assets/uniquesoftwares/RETURNGOODS_AJXREPORT.html": "ac60e5ed3ddc4feb9aa1334deba49666",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/initializeFirebase.js": "00b7ace70a05a2fe5ff0fe0804997b79",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/retrieveImg.js": "66210b4c8729b8bab0934c1e8ce83ce2",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/connFirebase.js": "0fc52655175c9d6d4a5ce636372cd01f",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/firebase-app.js": "1069e3997c89b18e1d426a89e055b9c9",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/SelectOrUploadFileFirebase.js": "42a9e192a53828bede4a6e43f867f215",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/firebase-auth.js": "593c4b5d072671b312195c12c96ec0a5",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/DataTrfirebase.js": "8cc10cb20482199d5f6212a619f3dfb5",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/firebase-database.js": "d732a727d48dd48aba2eb25c374d5a64",
"assets/assets/uniquesoftwares/firebasejs/8.6.2/firebase-storage.js": "bfb852b5eb47e351583e814b8a86b1c0",
"assets/assets/uniquesoftwares/ALLSALE_AJXREPORT.html": "cb90a06e32b54f52d60179e87f8259b8",
"assets/assets/uniquesoftwares/toDaysDueList.html": "ead601532b5a7742693d7b9dd5086999",
"assets/assets/uniquesoftwares/jsKey.js": "b7ccded355bb53db3273917cab1bbf26",
"assets/assets/uniquesoftwares/Billpdf.html": "0e5ea83440d027086fa008f4dc049e80",
"assets/assets/uniquesoftwares/3.3.7/bootstrap.min.css": "5057f321f0dc85cd8da94a0c5f67a8f4",
"assets/assets/uniquesoftwares/3.3.7/bootstrap.min.js": "ce109ab9e64a879d06e045a0492ac502",
"assets/assets/uniquesoftwares/ALLSALE_FRM.html": "b44838fb14916b212b51d768c4393eab",
"assets/assets/uniquesoftwares/PURCHASEFINISH_FRMReport.html": "a31b48f75d2db10e8e923365640c2e01",
"assets/assets/uniquesoftwares/FDispatchChallan.html": "cfe2d394fbe03863df7f399e49183a86",
"assets/assets/uniquesoftwares/bankPassBook_AJXREPORT.html": "e97a81642273e5ee5d1be49ef851f6ff",
"assets/assets/uniquesoftwares/upidemoViewUpi.html": "1dfc3857a2cd784f8fd1a32c99089f43",
"assets/assets/uniquesoftwares/2.1.3/jquery.min.js": "8e65e8606c70994e503ac69ba288f9f2",
"assets/assets/uniquesoftwares/css/styleLoader.css": "2bbe5b64d8dc4e4b8d042c27d6f62904",
"assets/assets/uniquesoftwares/css/orderForm.css": "ac8c866adaf7fef6a91412857e8faf24",
"assets/assets/uniquesoftwares/css/fs-modal.min.css": "093d80283a23f5ef6c1cbc947663a9fa",
"assets/assets/uniquesoftwares/css/styleSideNav.css": "3bc3c3b4e7d2e5ee6f3faaac161e1407",
"assets/assets/uniquesoftwares/css/stylePrint.css": "7bddd8effb513e69d7b6b43f594a4421",
"assets/assets/uniquesoftwares/css/style.css": "be3253bdd34551b5fc51a75b66bf94c2",
"assets/assets/uniquesoftwares/css/print.css": "b05339afd0205fcb8d27f182515c8a74",
"assets/assets/uniquesoftwares/css/styleAutoComplete.css": "70da828503b4f76342d3875472e34aba",
"assets/assets/uniquesoftwares/css/billPdf.css": "9b71e40e0d22b8493ee215f9b78e733b",
"assets/assets/uniquesoftwares/css/uploadImg.css": "83055837865838b78d5f0fd5c1df1d68",
"assets/assets/uniquesoftwares/qr-code.png": "afd094636bcf796dad5722856786edac",
"assets/assets/uniquesoftwares/jszip.min.js": "7a4daf0415f1e96242758bbb617272b8",
"assets/assets/uniquesoftwares/js/jsLoadCallMillDispatch.js": "644b0bc13418df5d22602baa4a60d99f",
"assets/assets/uniquesoftwares/js/jsLoadCallBANK_BAL.js": "b622dc01ae47a34565d287e3a9c181d9",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_ITEM_WISE.js": "e36e9fd18d6da2e9e92fd7f133e7bf7e",
"assets/assets/uniquesoftwares/js/jsgetArrayProductdetailsbyIDE.js": "e0cd62d1bbeb6fa27106a3717e95cbe1",
"assets/assets/uniquesoftwares/js/jsGetBillDataFromJson.js": "95fcff076659b020165556140af18128",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_SUMMERY.js": "428fff9f25a4acfe60c1cad465ed2055",
"assets/assets/uniquesoftwares/js/hideUnhide.js": "abbf4878deb1f229df5246685e4a7cab",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_PARTYWISE_FIRMWISE.js": "3bf0fb9932990869c274ab445b9553a1",
"assets/assets/uniquesoftwares/js/jsgetPartyListBySendBrokerCityCode.js": "a89e86dae28be22960d25ea4f3c50e7e",
"assets/assets/uniquesoftwares/js/jsmakePdf1.js": "cf6d5ef213c8e466e197e43ef33df5e1",
"assets/assets/uniquesoftwares/js/jsPdfMillChalan.js": "67645c75f15bb7abf2e3d230fb8c2c27",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_ALLSALE.js": "81db6ee400dccfdec89977d615ae4666",
"assets/assets/uniquesoftwares/js/jsToolTips.js": "0d00a9987b98f2d7ab36228072e9fd3e",
"assets/assets/uniquesoftwares/js/jsLoadCallJOBWORK_PARTYWISE_TRWISE.js": "88c42faefaf3d23641f2b492ea9261d0",
"assets/assets/uniquesoftwares/js/jsPdfOrderForm.js": "4e55e8b8ab4848305b613aae7cd5b4e1",
"assets/assets/uniquesoftwares/js/jsLoadCallJOBWORK.js": "5699a53fc3884cf9e497a0343fb5a2e4",
"assets/assets/uniquesoftwares/js/jsmakePdf1%2520copy.js": "837cf31a5c3435fde963e8bfebec1803",
"assets/assets/uniquesoftwares/js/getDataUserSetting.js": "e3f042a372f97eb63b63263191b09e45",
"assets/assets/uniquesoftwares/js/reminders.js": "b5909bbc6896062f6efe2953310791e6",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_PARTYWISE_MONTHWISE.js": "ac025551c579791c50fa478c8d09059e",
"assets/assets/uniquesoftwares/js/jsLoadCallMillStockQualWise.js": "f4e2f2171bf120696bbffcebb91405fb",
"assets/assets/uniquesoftwares/js/jsPaymentSlipPdf.js": "6dc39b55004530ec8dd9fe2f00eb7e6a",
"assets/assets/uniquesoftwares/js/jsconnectionDatabase-min.js": "a9c7eb5550d206758ce308ccabf9de72",
"assets/assets/uniquesoftwares/js/jsLoadCallITEMWISESALE.js": "7ca9fcda56a555da9d134e3223ea1cb8",
"assets/assets/uniquesoftwares/js/jsGetCookies.js": "44ca13c5fe815a6ea670b8e753ef5381",
"assets/assets/uniquesoftwares/js/jsPopUpModelParty%25203.js": "01e3689ad5fc4e1bbf4b2982972db878",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_TRANSACTION_WISE.js": "431ff0ca4427563cd4e5987d3b0d050a",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_SUMMERY.js": "b294fb5417fa53e7c0fc959265a9f825",
"assets/assets/uniquesoftwares/js/jstoFixedNumber.js": "8a9fa1956681c8a1c42ee22fbfed4ee2",
"assets/assets/uniquesoftwares/js/syncOperation.js": "4fb78f5127a3eaa3cb6979427a6f2250",
"assets/assets/uniquesoftwares/js/localStorageGet.js": "359adb4a6ca17d28e77336e46ad9a951",
"assets/assets/uniquesoftwares/js/jsFData.js": "0c401808d38901204f8a6b0abd7ac902",
"assets/assets/uniquesoftwares/js/jsGetDateFormate.js": "8c940d82e0451a4ebc871362476277f5",
"assets/assets/uniquesoftwares/js/jsFirmCnoOperate.js": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/uniquesoftwares/js/jsHeaderTbl.js": "5605e512d3b5d613609a5c9454e204fe",
"assets/assets/uniquesoftwares/js/Untitled-1.sh": "ed19ca99581136d44b35bbb2240a6bf6",
"assets/assets/uniquesoftwares/js/jsLoadCallFINISHSTOCK.js": "f461be79d2287d4d5560b11b59f21ea6",
"assets/assets/uniquesoftwares/js/jsSearchEngfrm.js": "1760c7cf2666dbd6ce571e2b8d824b94",
"assets/assets/uniquesoftwares/js/jscreateDatabase.js": "1b4d9d0312d2869ecc59b04cd1572fa9",
"assets/assets/uniquesoftwares/js/jsLoadCallMASTER_NEW.js": "ce46f39020ee6d2a2b0d05ea54bc6c34",
"assets/assets/uniquesoftwares/js/jsSearchfrm.js": "5d087bf18ce3cf3e22f1816ccc124f19",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDINGPURCHASE.js": "7b35bdcc0353bbdcd82f3c8473ab3b40",
"assets/assets/uniquesoftwares/js/jsoptionFirmSelect.js": "294b86e233d0b285382f2d221c4c204f",
"assets/assets/uniquesoftwares/js/jsLoadCallPENDINGLR_DATEWISE.js": "a5ffc2d3c99c9423259e7035b372749f",
"assets/assets/uniquesoftwares/js/creditDebitBill.js": "a6ede3960a3f7820283736852a97da0c",
"assets/assets/uniquesoftwares/js/jsLoadCallQualChart.js": "fa90656a47fa3d95103545c3bc7603fd",
"assets/assets/uniquesoftwares/js/sendingOption.js": "5fa454d9486232f75938c29ca1382fc2",
"assets/assets/uniquesoftwares/js/jsLoadCallSALES_COMM_PARTY_WISE.js": "5b271977e61b43dc493c3f2f43647638",
"assets/assets/uniquesoftwares/js/jsoptionSeriesSelect.js": "03bcc574aafe25408c489fc8dd71c289",
"assets/assets/uniquesoftwares/js/jsgetValueNotDefineNo.js": "f562beba96478b24d8278e494049196e",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_BROKERWISE.js": "8dbb5214a5f3f2483a24ae45d5a1bad7",
"assets/assets/uniquesoftwares/js/localStorageSet.js": "6b37ef7c3405651451e779ddf6306bdd",
"assets/assets/uniquesoftwares/js/jsopenSubReport.js": "7cb86289b6ebd2e9a914b7db5e6c5708",
"assets/assets/uniquesoftwares/js/jsStoreDatatoIndexeddb.js": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/uniquesoftwares/js/jsLoadCallLEDGER.js": "647a5cf97ba0f63c060ef7d04d3eaea9",
"assets/assets/uniquesoftwares/js/jsgetFullDataLinkByMillCardNo.js": "351f25f1e9826bae16a0d5d710de090f",
"assets/assets/uniquesoftwares/js/jsPdfMillChalanRec.js": "64a4f5ad68f9bc8577d273cf8379078d",
"assets/assets/uniquesoftwares/js/jsGetPartyListJsonByCity.js": "3df21a258a8f62915001e59a97505bb2",
"assets/assets/uniquesoftwares/js/jsLoadCallorderFormList.js": "24b018888be31b24181bc456cef2b26c",
"assets/assets/uniquesoftwares/js/jsLoadCallLEDGER_SUMMERY.js": "eb31722cb14ae99c274e3936b91728bc",
"assets/assets/uniquesoftwares/js/setTitle.js": "81051bcc2cf1bedf378224b0a93e2877",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS.js": "300e1736bcb12cd6a039115a679016b8",
"assets/assets/uniquesoftwares/js/jsLoadCallMASTER.js": "a2326199efbea1e7d172b9bcf1b6c4a1",
"assets/assets/uniquesoftwares/js/cloudOrderGtD.js": "d26ad624e1aca0ec9464d87eafdcece5",
"assets/assets/uniquesoftwares/js/jsgetValueNotDefine.js": "256e957bdcc00423c97eda952f542396",
"assets/assets/uniquesoftwares/js/jsGetObjectByKey.js": "ee6e9e8e341154a4d9a79fbf532e02d1",
"assets/assets/uniquesoftwares/js/jsGetPartyListJsonByBroker.js": "71bebc151e8576c44de5f9090d3e1d5f",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDINGPURCHASE_DATEWISE.js": "2b74f9f8c7b6a0f41d963490f3e624cf",
"assets/assets/uniquesoftwares/js/jsLoadCallBANK_BROKERWISE_PARTYWISE.js": "8128b047964c7b436e8dde44c3f4209f",
"assets/assets/uniquesoftwares/js/toDaysDueList.js": "4ebf716df673edde68f8e042758396f2",
"assets/assets/uniquesoftwares/js/jsLoadCallABC_ANALITICS.js": "94a351b9c4ff1907304e8bd16ac3fc13",
"assets/assets/uniquesoftwares/js/jsLoadCallPENDINGLR_TRANSPORTWISE.js": "c8cfa69c4e4154a0228e9b66f233fe0a",
"assets/assets/uniquesoftwares/js/jsPopUpModelParty.js": "530c31f478b6b05c58cc9ba69fd0bb28",
"assets/assets/uniquesoftwares/js/cloudOrderStD.js": "3aaabfc66f842750228dcd0099449f5f",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_.js": "cfa6b90e278c7386eb52aec57dbec56c",
"assets/assets/uniquesoftwares/js/fs-modal.min.js": "d04aa95dded5309a95619cfd18af4c60",
"assets/assets/uniquesoftwares/js/jsGetObjectByKeyBackup.js": "cd6a5cb657b94eeaf1de2c7816fedf8c",
"assets/assets/uniquesoftwares/js/jsLoadCallTransport.js": "806ebe303b3ec830689288a684efe6fb",
"assets/assets/uniquesoftwares/js/getUrlWithOutStringData.js": "53af404b560ba3fc648db73a44916500",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING.js": "a089eecad81d566a8d5b5e6ec875e8e4",
"assets/assets/uniquesoftwares/js/jsgetEMPdata.js": "6d806f313f2b8f9c0af6ab003b2f0b5b",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_AG.js": "cf97234fdba9328dd3432f78e1168656",
"assets/assets/uniquesoftwares/js/jsMillChallanTakaDetails.js": "be1af9decee4546cca4504d2fcee2bc4",
"assets/assets/uniquesoftwares/js/jsLoadCallTDS.js": "8ab6ef5e7593095db8f55089a8b1a441",
"assets/assets/uniquesoftwares/js/jsprevents.js": "802976ba775a1f5bdcca99dacc18cb60",
"assets/assets/uniquesoftwares/js/xlsx.full.min.js": "2909d83c5525e0a05cd05db8ff920dc3",
"assets/assets/uniquesoftwares/js/jsLoadCallMillStock_MILLWISE_QUALITY_WISE.js": "625e38dbc7832b1a3f28ec8751993df9",
"assets/assets/uniquesoftwares/js/upi.webp": "6edfa1a8d5531beee63f619e9cabccbc",
"assets/assets/uniquesoftwares/js/jsonHandler.php": "d74bb2388d8e9258dfb6328c7ab18f1f",
"assets/assets/uniquesoftwares/js/jsfindBill.js": "b20d41928bf1847ffd5eafaf67cd6c6f",
"assets/assets/uniquesoftwares/js/jsGetDaysDif.js": "8f35c55717708c247aa60050b03248ab",
"assets/assets/uniquesoftwares/js/jsLoadCallOUTSTANDING_BROKERWISE_PARTYWISE.js": "597aa12d24ba77f53c31d1bee1e81a7c",
"assets/assets/uniquesoftwares/js/filterSelected.js": "0e7057f3f5b17b3f1ecefc59e34dd503",
"assets/assets/uniquesoftwares/js/jsconnectionDatabase.js": "88065cdae408908eca9bba39c11ab32c",
"assets/assets/uniquesoftwares/js/jsLoadCallLEDGER_INTEREST.js": "cb98fab7a6be31b865dc2b83626fea40",
"assets/assets/uniquesoftwares/js/jsLoadCallBANK_UNCLEARED_PAYMENT.js": "b759e30946e34bdfb08ccd81082e9cb0",
"assets/assets/uniquesoftwares/js/jsOpenBillDetilasAsTable.js": "1baf342038ac99eed3a5835b86fe9a0f",
"assets/assets/uniquesoftwares/js/jspushDataToIndexDb.js": "efa6068d53cdb52a1b9a6772eb4fe6e6",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_ITEMWISE_PARTYWISE.js": "c1c2041ecbf9c3b6fb130bce8af18a8c",
"assets/assets/uniquesoftwares/js/jsLoadCallBANK.js": "cb4b29ad3d84b6a51e1dea2b8ffdc9e1",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_PARTY_WISE_ITEM_WISE.js": "43358c1b2de018c7c2a16640d33d995e",
"assets/assets/uniquesoftwares/js/jsPopUpTblSetting.js": "8e8d9728c193ec389604a0499f9c23d9",
"assets/assets/uniquesoftwares/js/jstoFixed.js": "5787d8fea07c498598dc954b8123c699",
"assets/assets/uniquesoftwares/js/jsLoadCallPENDINGLR.js": "8e973dc1a37f39c7e001a1872fbc02ab",
"assets/assets/uniquesoftwares/js/jsLoadCallBLSTEST.js": "5e53f4a431c377f038c6e4e3f3abd18d",
"assets/assets/uniquesoftwares/js/jsfunction.js": "0af806a597ffda9e4029c2e03e608876",
"assets/assets/uniquesoftwares/js/jsDeleteIndexeddb.js": "b7ad3bf4c554802aa15334b4261118f7",
"assets/assets/uniquesoftwares/js/jsmakePdf2.js": "7290a9910fc7ea28fc0c12e9f72bce7b",
"assets/assets/uniquesoftwares/js/jsLoadCallLEDGER_PARTY_WISE.js": "194bf0e9564d698ce3ea02f0a5c61ba7",
"assets/assets/uniquesoftwares/js/jsGetSaleData.js": "0963ad9c20c759cf4bad450d6d93ec33",
"assets/assets/uniquesoftwares/js/jsLoadCallBLS_BROKERWISE_PARTYWISE.js": "6c6adaaf08afe6266cc68bd92b0a9a5f",
"assets/assets/uniquesoftwares/js/jsLoadCallMillStock.js": "e76dafa1e32303810fbed31a5fbfb92c",
"assets/assets/uniquesoftwares/js/jsGetUrlParams.js": "4f5596af1814a706a7911f9c73caae86",
"assets/assets/uniquesoftwares/js/jsGetYearChange.js": "b417e83708beb79a113508c52ad4a2cb",
"assets/assets/uniquesoftwares/js/jsOrderFormAutoComplet.js": "61be081ed82470946cdb9df9c72eae25",
"assets/assets/uniquesoftwares/paymentSlipPdf.html": "07f5b2d46009f2c7fdf0d900a32ad356",
"assets/assets/uniquesoftwares/1.10.2/jquery.js": "9942970f31d917fa6aae66fa3b9b09ff",
"assets/assets/uniquesoftwares/SALES_COMM_FRMReport.html": "948ebf4c9c0a2662d4ae6ad1fe4db8c1",
"assets/assets/uniquesoftwares/PCSSTOCK_FRMReport.html": "43ba9d2684effa3aec79610496ac0b58",
"assets/assets/uniquesoftwares/ITEMWISESALE_AJXREPORT.html": "7e11e4aa87227e45a38ea4ea33d0e245",
"assets/assets/uniquesoftwares/FDispatchChallanRec.html": "038e596058cecaaa062dbd6822932ef6",
"assets/assets/uniquesoftwares/CatalogView.html.html": "7f8e52ff8d0a78602747225959475eb5",
"assets/assets/uniquesoftwares/1.10.4/jquery-ui.css": "b7f4fe22535c242fef1f0bb3ec7143f6",
"assets/assets/uniquesoftwares/1.10.4/jquery-ui.js": "e725015d340350624b52583945efaefa",
"assets/assets/uniquesoftwares/interestCal.html": "b0799c2b5bbab8adde25ed60fb0ef435",
"assets/assets/uniquesoftwares/transport.html": "7a6cc0e5a24b497eb5fd45a67a9b3243",
"assets/assets/uniquesoftwares/AJX_CMN_js.html": "92e28348365a4ef5b285fbab47bda72d",
"assets/assets/uniquesoftwares/Untitled-1.txt": "18b7bce0ced83ebbf18b6c3cfd3e5386",
"assets/assets/uniquesoftwares/SALES_COMM_AJXREPORT.html": "51d207b579d3a9a31fa9c703101e253d",
"assets/assets/uniquesoftwares/ITEMWISESALE_FRMReport.html": "cabc307f5d4be3971ef66b2e9a1b2e08",
"assets/assets/uniquesoftwares/PCSSTOCK_AJXREPORT.html": "6db7cf0d55be51ed757cfa9294172080",
"assets/assets/uniquesoftwares/whatsappIcon.png": "65e2fb8087488cd04deb80b55fd5da02",
"assets/assets/uniquesoftwares/ABC_ANALITICS_AJXREPORT.html": "0a6b26801667c3b9becd28cd56f64748",
"assets/assets/uniquesoftwares/LedgerInterestCal.html": "fd00fa8182c7820ead8a757d769b4f3a",
"assets/assets/uniquesoftwares/BANK_UNCLEARED_PAYMENT_AJX.html": "ca5ea25dffee05e49f921bf6cd451155",
"assets/assets/uniquesoftwares/retrieveImg.html": "5fda17d79db12997da0f0a3aa6f897c1",
"assets/assets/uniquesoftwares/JOBWORK_FRMReport.html": "ebf145326b07e40e3fd0ef3cdef1fe8f",
"assets/assets/uniquesoftwares/chart.html": "eb3c2a63898ec8330d3aa72c47246cb9",
"assets/assets/uniquesoftwares/4.1.1/bootstrap.min.css": "e59aa29ac4a3d18d092f6ba813ae1997",
"assets/assets/uniquesoftwares/Errorchecker.vbs": "790eb147880def2e71a15a11d25fa5c0",
"assets/assets/uniquesoftwares/PURCHASE_AJXREPORT.html": "b30616b6c71f23b9e9a75bc6282c1d70",
"assets/assets/uniquesoftwares/millstock_AJXREPORT.html": "a064dddc573739605b5cc4bc97d14bd7",
"assets/assets/uniquesoftwares/ALLREPORT_FRMReport.html": "5d990d0a3edee963330502284dfa7f8b",
"assets/assets/uniquesoftwares/test.php": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/uniquesoftwares/fData.html": "ef1724d51faa11f9afa2adff8eeebdb9",
"assets/assets/uniquesoftwares/TEST.HTML": "a8e96f33887531b686b87666f65526f1",
"assets/assets/uniquesoftwares/transport.png": "969fa774e51b0026f86d01f4a3832dea",
"assets/assets/uniquesoftwares/uploadImg.html": "2744311a10533d034b2861ae49254890",
"assets/assets/uniquesoftwares/OUTSTANDING_AJXREPORT.html": "613ffd83e8e9b83cdfda8d274b8b8a92",
"assets/assets/uniquesoftwares/deleteDatabase.html": "8e2f8856c09973f1bb8fa2be7fa90ece",
"assets/assets/uniquesoftwares/WhatsApp%2520Image%25202022-09-17%2520at%25208.27.00%2520AM.jpeg": "6edfa1a8d5531beee63f619e9cabccbc",
"assets/assets/uniquesoftwares/OUTSTANDING_FRMReport.html": "20cc2ab2b121ee8050302dceab29fc6f",
"assets/assets/uniquesoftwares/COMPMST_FRMReport.html": "3b2a81ba4a6e695e04539c758bd85faf",
"assets/assets/uniquesoftwares/jsonSyncToIndexeddbFirebase.html": "1e05f339d17fe229b0d314823ac37b83",
"assets/assets/uniquesoftwares/debug.log": "817f3442c323d07c72751897791803e7",
"assets/assets/uniquesoftwares/PURCHASE_FRMReport.html": "b780e6155d0e2a3b5ef5ea4b4621cb7b",
"assets/assets/uniquesoftwares/millstock_FRMReport.html": "40af0a8d3fa5c819c0699c8cd1586e4b",
"assets/assets/uniquesoftwares/ALLSALE.html": "ba992d19f59e39c344c32c0a406c3f3d",
"assets/assets/uniquesoftwares/JOBWORK_AJXREPORT.html": "736d1876435731e0296310a80715c3ab",
"assets/assets/uniquesoftwares/WaSender.html": "470e8c7f7f42eacd341fe13e20b4f68d",
"assets/assets/uniquesoftwares/upi.webp": "6edfa1a8d5531beee63f619e9cabccbc",
"assets/assets/uniquesoftwares/upidemoExample.jpeg": "e2eaef26833b8ce7087bffbc6e7a9d6e",
"assets/assets/uniquesoftwares/OUTSTANDING_AG_AJXREPORT.html": "50941bc8bfba9b14b4e9aac5c6cb096b",
"assets/assets/uniquesoftwares/PCORDER_FRMReport.html": "1d1d5c311d9641fa05b73e9ce7b2fa93",
"assets/assets/uniquesoftwares/desktop.ini": "e5657d21a7a732e73c2a6ca38726cc25",
"assets/assets/uniquesoftwares/test.css": "4abcc889b16ca3b200026677328034b8",
"assets/assets/uniquesoftwares/PENDINGLR_AJXREPORT.html": "31e684343046c793b53d99554349c6db",
"assets/assets/uniquesoftwares/saveContact.png": "697548e8f7658d7c77b175b6bf67794e",
"assets/assets/uniquesoftwares/upi.html": "80ee84f1fed3e4669d6a83c3bab7b709",
"assets/assets/uniquesoftwares/PURCHASEOUTSTANDING_FRMReport.html": "8d4cd62e581d6f2080c45dc0a2503489",
"assets/assets/uniquesoftwares/whatsapp.png": "9a6c567452f7b8bea48d6caf24df4acc",
"assets/assets/uniquesoftwares/online-business-ideas-featured-image-scaled.jpg": "3cc6686b6516fef876b03e79924fc732",
"assets/assets/uniquesoftwares/BANK_BAL_AJXREPORT.html": "0151e3246fecd414adf0d979a42b1ee6",
"assets/assets/uniquesoftwares/PURCHASEOUTSTANDING_AJXREPORT.html": "7435bbd44a8e86ab275e2e5737cfa5da",
"assets/assets/uniquesoftwares/upload.svg": "95264c6f88920a41c801016d3e2f4338",
"assets/assets/uniquesoftwares/error.html": "6e26ef5acb481a51ca711ae6eb65b49d",
"assets/assets/uniquesoftwares/QualChart.html": "ac7b984c23a7310d02fd36bbf8da4070",
"assets/assets/uniquesoftwares/OUTSTANDING_AG_FRMReport.html": "e1e22d720d09b5f964051ed49103b210",
"assets/assets/uniquesoftwares/SaleItemchart.html": "f194d1f61aebd6a1b59be0b40969d7ce",
"assets/assets/uniquesoftwares/PCORDER_AJXREPORT.html": "54fa47b5964fa5933fb4637452c49906",
"assets/assets/uniquesoftwares/headlessSync.html": "507d6c6ee120c8e3ac8ad5ef3805f196",
"assets/assets/uniquesoftwares/PENDINGLR_FRMReport.html": "e2f382709a327d9fb77611c9e9919a79",
"assets/assets/uniquesoftwares/orderForm.html": "3908609f23c7a154dc0178f095076e38",
"assets/assets/html2canvas.min.js": "d0742edd178c84f1a681c5f61d871359",
"assets/assets/imagemanagement.html": "cbb45a36f349e3c2a41044a7dc656c41",
"assets/assets/img/1024.png": "776c20fccc72a235bd862cb2e6e40d38",
"assets/assets/img/referandearn.jpeg": "9f3d1d2ddaa2504a6564996bbb592baf",
"assets/assets/img/orderform.png": "18544b1ac69e46507558c55c4c476417",
"assets/assets/img/chatBackground.png": "adbccee0708ae3b7a71d9652fb353299",
"assets/assets/img/click.gif": "2e13d58b791fb5883599b5c3c239f226",
"assets/assets/img/sale.png": "4812f9fe47e917bba6b49d1a2f28b281",
"assets/assets/img/favicon.ico": "bfcd21dc44923a99e13ccd877481860d",
"assets/assets/img/login.png": "cf20609f5b1c6c739306d2c5caedf386",
"assets/assets/img/backuplist.png": "b712b93580e65e0767923898e55b2b9b",
"assets/assets/img/qrcode.png": "afd094636bcf796dad5722856786edac",
"assets/assets/img/appProductGalleryIcon.jpeg": "9ad58daccd64bfe7ca2a4b53e22d6e24",
"assets/assets/img/jobwork.png": "2b0af7f0779873dfb1498e8606e018c3",
"assets/assets/img/product.png": "aa8c0a7ac55b8bb3929c74362573be16",
"assets/assets/img/applogo.png": "62f0b1c42f4ced666e1781cac6b8d38d",
"assets/assets/img/stockinhouse.png": "c5e08d3d8fd7e9d5fc24825f60cc0e56",
"assets/assets/img/allreport.png": "4c974430cfaba7ac18362917ea21c5b1",
"assets/assets/img/purchase.png": "d4b919bc5bae2ec1d35d9fb5103df0ac",
"assets/assets/img/lr.png": "a283b29b33469c0baf3eab2f3c9bf468",
"assets/assets/img/orderlist2.png": "9b24a45931790329dcc40a39ebf7788b",
"assets/assets/img/login_image.png": "0f001e0939a679eccff18bc5c6a88a4d",
"assets/assets/img/neworder.png": "4529a59f6e3392f827645d276a586383",
"assets/assets/img/error.mp3": "8e855a6b086d2e64b7b1aea4ef3b8083",
"assets/assets/img/rg.png": "edfe5eadcfbaf0983a6b649edd126639",
"assets/assets/img/upi.jpeg": "6edfa1a8d5531beee63f619e9cabccbc",
"assets/assets/img/millstock.png": "bd6b280e72ccfb345f3b006ea8767f35",
"assets/assets/img/upi.png": "8fc0403850e1c84af9fc994d2ad6a8eb",
"assets/assets/img/addressbook.png": "be56360893228167e8647d00ee598f88",
"assets/assets/img/saleItemwise.png": "e6943f75e73be324c39349db34139396",
"assets/assets/img/purchase_outstanding.png": "be1c7b786ff05b9f59c11d06bb305533",
"assets/assets/img/animation_ll3r2bv1.json": "c4825bd186e04ebfbcf5de5a8518d9c6",
"assets/assets/img/accountno.png": "a806fd791597fd2f6efa47a9ae0ad38d",
"assets/assets/img/latter.png": "22c7515efb8bec10c51e0446899c667c",
"assets/assets/img/sorryweclosed.png": "f301c48875c8bb55f3e00ff457274748",
"assets/assets/img/purchaseoutstanding2.png": "4c1035fbcdf0a9a8fc16a2acd7fa86b6",
"assets/assets/img/transport.png": "969fa774e51b0026f86d01f4a3832dea",
"assets/assets/img/jsmnew.png": "63a05f210d2e33dc9645b11b33d3dfda",
"assets/assets/img/rootHome.png": "4ad503a1f58ce4c4d6afce2ca94af4ad",
"assets/assets/img/paymententry.png": "4f9c7899717e1cbae4c363d6b4b2270e",
"assets/assets/img/orderlist.png": "c47c7585208ac4c20bd9303ec561d297",
"assets/assets/img/findbill.png": "1de2d6192b1b7f0d86eac33e26bfd224",
"assets/assets/img/search.mp3": "badea6e28def0567210962e08525f6a3",
"assets/assets/img/otpVerifyscreen.png": "a9c4ca088d422a9cd684284a58d692c1",
"assets/assets/img/quality.png": "b46b27ede78f8ad026446a64cef41447",
"assets/assets/img/notFound.png": "2e57da51b281a0951c9bbe6acb251646",
"assets/assets/img/gstin.png": "964df65739f3ee6edce135fbf9e4401d",
"assets/assets/img/blankLogo.png": "75db99b125fe4e9afbe58696320bea73",
"assets/assets/img/productmanagement.png": "12d8d98ee029bbc144f035307bea736f",
"assets/assets/img/outstanding.png": "fec735dca79ac50643b7f84b954b2810",
"assets/assets/img/admin.png": "d136ae1bfe4f27a9de63b271a4e5977a",
"assets/assets/img/whatsapp.png": "9a6c567452f7b8bea48d6caf24df4acc",
"assets/assets/img/tds.png": "13db3d04ae953eb28943192e194f3c57",
"assets/assets/img/feedback.png": "cdd7076b63609c9a81d213fad2d26733",
"assets/assets/img/verify.png": "381355a1a243eec893cfa6e30ce09866",
"assets/assets/img/rating.png": "8742fe0a3f350d54e5611fcbeae6d7a3",
"assets/assets/img/ledger3.png": "181b6d1258c72f5c6028f3e604bcc638",
"assets/assets/img/ledger.png": "42609f815515ea068f98b0f1d7d481e7",
"assets/assets/img/syncing.gif": "afabafb383f259740ebc42a188941605",
"assets/assets/img/bulkpdf.png": "17a00db5e0b63dafd9651aec609ce1aa",
"assets/assets/syncAgain.jpeg": "aa2073622e198e8f1dd93a47bfaaa505",
"assets/assets/html2pdf.js": "e7ce1785d41d4f65f24a2ee09f49aa80",
"assets/assets/upi.webp": "6edfa1a8d5531beee63f619e9cabccbc",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
