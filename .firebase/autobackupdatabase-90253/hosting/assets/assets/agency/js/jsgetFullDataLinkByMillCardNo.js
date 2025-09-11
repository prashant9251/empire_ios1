
function getFullDataLinkByMillCardNo(CARDNO,CNO,TYPE){
   return url ="FDispatchChallan.html?ntab=NTAB&CRD="+encodeURI(CARDNO)+"&CNO="+encodeURI(CNO)+"&TYPE="+encodeURI(TYPE);
}  