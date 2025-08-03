unit TestCase1;

interface

uses
  fpcunit, testregistry;

type

  { TTestCase1 }

  TTestCase1= class(TTestCase)
  published
    procedure Test1; // When_AccessTokenI_Is_Invalid_Then_Throw_ReplyError;
    procedure Test2; // When_Credentials_Invalid_Then_Throw_Bad_Request;
    procedure Test3;
  end;

implementation

uses
  SMTPOAuth2Client,
  OAuth2TokenProvider,
  IdReplySMTP, IdHTTP;

procedure TTestCase1.Test1;
begin
  ExpectException(EIdSMTPReplyError);
  SendSMTP('this_is_an_invalid_token');
end;

procedure TTestCase1.Test2;
begin
  ExpectException(EIdHTTPProtocolException);
  FetchToken;
end;

procedure TTestCase1.Test3;
var
   AccessToken: string;
begin
   AccessToken := FetchToken;
   SendSMTP(AccessToken);
end;

initialization

  RegisterTest(TTestCase1);
end.

