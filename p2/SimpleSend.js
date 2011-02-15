
var conn = WScript.CreateObject("P2ClientGate.P2Connection"); // ������� ������ Connection
conn.AppName = "JSOrdSend"; // ����� ������ ���������� � ������������� ���.
conn.Host	 = "127.0.0.1"; //����� 
conn.Port	 = 4001; // � ���� ���������� �������

var errorClass = conn.Connect(); // ������������� ���������� � ��������� ��������
var srvAddr = conn.ResolveService("FORTS_SRV"); // ���� ����� ������� ������ ������

WScript.Echo(srvAddr);

// ������� � �������������� ������� ��������-���������
var msgs = WScript.CreateObject("P2ClientGate.P2BLMessageFactory");
msgs.Init("p2fortsgate_messages.ini","");

WScript.Echo("Msg Factory inited"); 

// ������� � ��������� ���������
var msg = msgs.CreateMessageByName("FutAddOrder");

WScript.Echo("Msg created");

msg.DestAddr = srvAddr; // ����� �������

msg.Field("P2_Category")    = "FORTS_MSG"; // ��������� ����. 
msg.Field("P2_Type")        = 1; //��������� ����. 



msg.Field("isin")           = "LKOH-3.11"; 
msg.Field("price")     	    = "17000"; 
msg.Field("amount")         = "1"; 
msg.Field("client_code")    = "000";
msg.Field("type")    	    = 1;
msg.Field("dir")    	    = 1;

WScript.Echo("BeforeSend");


msg = msg.Send(conn, 5000); // �������� ��������� � ��������� ������ � ������� 5 000 �����������

var c = msg.Field("P2_Category");
var t = msg.Field("P2_Type");

WScript.Echo("category " + c + "; type " + t); 

if( ( c == "FORTS_MSG" ) && ( t == 101 ) )
{
    var code = msg.Field("code"); // ��������� �����
    if (code == 0)
	    WScript.Echo("Adding order Ok, Order_id="+msg.Field("order_id")); 
    else
	    WScript.Echo("Adding order fail, logic error="+msg.Field("message")); 
}
else if( ( c == "FORTS_MSG" ) && ( t == 100 ) )
{
    WScript.Echo("Adding order fail, system level error "+msg.Field("code")+" "+msg.Field("message")); 
}
else
{
    WScript.Echo("Unexpected MQ message recieved; category " + c + "; type " + t); 
}



