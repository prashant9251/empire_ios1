
DSN="MTAw"
Currentyear="2223"
FIRM="%20"
MCNO="1"
MTYPE="S51"
USER="prashant"
privateNetworkIp=""
LFolder="AGENCY"
AccessUrl="jsonSyncToIndexeddb.html"
http="https://"
Serverlocation="aashaimpex.com"


Const OneSecond = 1000 
Set browobj = CreateObject("Wscript.Shell")
strCurDir = browobj.CurrentDirectory



link ="DatabaseSource="+DSN+Currentyear+"&Currentyear="+Currentyear+"&MCNO="+MCNO+"&MTYPE="+MTYPE+"&privateNetworkIp="+privateNetworkIp+"&privateNetWorkSync=true&LFolder="+LFolder+"&http="+http+"&ServerLocation="+ServerLocation
siteA = "file:///"+strCurDir+"/"+AccessUrl+"?"+link
browobj.Run "chrome --start-fullscreen -url "&siteA
Set browobj = Nothing