
DSN="MTEx"
Currentyear="2122"
FIRM="%20"
MCNO="1"
MTYPE="S51"
USER="prashant"
privateNetworkIp=""
LFolder="TRADING"
AccessUrl="jsonSyncToIndexeddb.html"


Const OneSecond = 1000 
Set browobj = CreateObject("Wscript.Shell")
strCurDir = browobj.CurrentDirectory



link ="DatabaseSource="+DSN+Currentyear+"&Currentyear="+Currentyear+"&MCNO="+MCNO+"&MTYPE="+MTYPE+"&privateNetworkIp="+privateNetworkIp+"&privateNetWorkSync=true&LFolder="+LFolder
siteA = "file:///"+strCurDir+"/"+AccessUrl+"?"+link
browobj.Run "chrome --start-fullscreen -url "&siteA
Set browobj = Nothing