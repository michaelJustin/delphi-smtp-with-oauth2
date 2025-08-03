unit SMTPOAuth2Client;

interface

procedure SendSMTP(const OAuth2Token: string);

implementation

uses
  IdSMTP, IdSSLOpenSSL, IdMessage, IdGlobal, IdEMailAddress,
  IdUserPassProvider, IdSASLCollection, IdSASLOAuth,
  IdExplicitTLSClientServerBase, IdCoder, IdCoderMIME,
  Classes, SysUtils;

function EncodeBase64(const Input: string): string;
var
  Encoder: TIdEncoderMIME;
begin
  Encoder := TIdEncoderMIME.Create(nil);
  try
    Result := Encoder.EncodeString(Input);
  finally
    Encoder.Free;
  end;
end;

procedure SendSMTP(const OAuth2Token: string);
var
  Base64EncodedToken: string;
  IdSMTP: TIdSMTP;
  IdMessage: TIdMessage;
  AddressItem: TIdEMailAddressItem;
  Auth: TIdSASLListEntry;
  IOHandler: TidSSLIOHandlerSocketOpenSSL;
  UserPass: TIdUserPassProvider;
begin
  Base64EncodedToken := EncodeBase64(OAuth2Token);

  IdSMTP := TIdSMTP.Create;
  try
    IdSMTP.Host := 'smtp.office365.com';
    IdSMTP.Port := 587;

    IdMessage := TIdMessage.Create(IdSMTP);
    try
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
      UserPass.Password := Base64EncodedToken;

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
