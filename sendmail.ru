function Send_SMTP(host:string; port:Integer; Username,Password,CharSet,Body,Subject,Name,EMailAddresses,MessageParts:string):Boolean;
var
SMTP : TIdSMTP;
msg : TIdMessage;
SSLOpen : TIdSSLIOHandlerSocketOpenSSL;
begin
SMTP := TIdSMTP.Create(Application);
SMTP.Host := host;
SMTP.Port := port;
SMTP.AuthType := satDefault;
SMTP.Username := Username;
SMTP.Password := Password;

SSLOpen := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
SSLOpen.Destination := SMTP.Host+':'+IntToStr(SMTP.Port);
SSLOpen.Host := SMTP.Host;
SSLOpen.Port := SMTP.Port;
SSLOpen.DefaultPort := 0;
SSLOpen.SSLOptions.Method := sslvSSLv23;
SSLOpen.SSLOptions.Mode := sslmUnassigned;

SMTP.IOHandler := SSLOpen;
SMTP.UseTLS := utUseImplicitTLS;

msg := TIdMessage.Create(Application);
msg.CharSet := CharSet;
msg.Body.Text:=Body;
msg.Subject := Subject;
msg.From.Address := SMTP.Username;
msg.From.Name := Name;
msg.Recipients.EMailAddresses :=EMailAddresses;
msg.IsEncoded:=True;
TIdAttachmentFile.Create(msg.MessageParts, MessageParts);

SMTP.Connect;
if SMTP.Connected then
begin
SMTP.Send(msg);
Result := True;
end else
Result := False;

SMTP.Disconnect();
SMTP.Free;
SSLOpen.Free;
msg.Free;
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
if Send_SMTP('smtp.yandex.ru',465,'mikew2013@yandex.ru','mik12345','Windows-1251','тело письма','заголовок письма','Anonymous','art3m.galiullin@yandex.ru','C:\Manifest.txt') = True then
begin
ShowMessage('Сообщение отправлено');

end
else
ShowMessage('Ошибка отправки');
end;
end.
