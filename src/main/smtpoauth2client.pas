unit SMTPOAuth2Client;

interface

procedure SendSMTP(const OAuth2Token: string);

implementation

uses
  IdSMTP, IdSSLOpenSSL, IdMessage, IdGlobal, IdEMailAddress, IdSASLOAuth,
  IdUserPassProvider, IdSASLCollection, IdExplicitTLSClientServerBase,
  Classes, SysUtils;

procedure SendSMTP(const OAuth2Token: string);
var
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  AddressItem: TIdEMailAddressItem;
  Auth: TIdSASLListEntry;
  IOHandler: TidSSLIOHandlerSocketOpenSSL;
  UserPass: TIdUserPassProvider;
begin
  IdSMTP := TIdSMTP.Create;
  try
    IdSMTP.Host := 'smtp.office365.com';
    IdSMTP.Port := 587;

    IdMessage := TIdMessage.Create(IdSMTP);
    try
      IdMessage.From.Address := 'user@example.com';

      AddressItem := IdMessage.Recipients.Add;
      AddressItem.Address := 'recipient@example.com';
      AddressItem.Name := 'Recipient';

      IdMessage.Subject := 'My first Delphi SMTP OAuth2 mail';
      IdMessage.Body.Text := 'Test';

      IOHandler := TidSSLIOHandlerSocketOpenSSL.Create(IdSMTP);
      IOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
      IdSMTP.IOHandler := IOHandler;

      UserPass := TIdUserPassProvider.Create(IdSMTP);
      UserPass.Username := 'user@example.com';
      UserPass.Password := OAuth2Token;

      Auth := IdSMTP.SASLMechanisms.Add;
      Auth.SASL := TIdSASLXOAuth2.Create(IdSMTP);
      TIdSASLXOAuth2(Auth.SASL).UserPassProvider := UserPass;

      IdSMTP.UseTLS := utUseExplicitTLS;
      IdSMTP.AuthType := satSASL;
      IdSMTP.Connect;

      IdSMTP.Authenticate;
      IdSMTP.Send(IdMessage);
    finally
      IdMessage.Free;
    end;

    IdSMTP.Disconnect;
  finally
    IdSMTP.Free;
  end;
end;

end.
