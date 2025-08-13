unit OAuth2TokenProvider;

interface

function FetchToken: string;

implementation

uses
  IdHTTP, IdSSLOpenSSL, IdSSLOpenSSLHeaders, IdGlobal,
  fpjson, jsonparser,
  SysUtils, Classes;

function CreateIdHTTPwithSSL12: TIdHTTP;
var
  IOHandler: TIdSSLIOHandlerSocketOpenSSL;
begin
  Result := TIdHTTP.Create;
  IOHandler := TIdSSLIOHandlerSocketOpenSSL.Create(Result);
  IOHandler.SSLOptions.SSLVersions := [sslvTLSv1_2];
  IOHandler.SSLOptions.Mode := sslmClient;
  Result.IOHandler := IOHandler;
end;

function SendPost: string;
var
  HTTP: TIdHTTP;
  RequestBody: TStrings;
const
  TokenEndpoint = 'https://login.microsoftonline.com/{tenant}/oauth2/v2.0/token';
  ClientID = '{client-id}';
  ClientSecret = '{client-secret}';
begin
  HTTP := CreateIdHTTPwithSSL12;
  try
    RequestBody := TStringList.Create;
    try
      HTTP.Request.ContentType := 'application/x-www-form-urlencoded';

      RequestBody.Add('client_id=' + ClientID);
      RequestBody.Add('client_secret=' + ClientSecret);
      RequestBody.Add('scope=https://outlook.office365.com/.default');
      RequestBody.Add('grant_type=client_credentials');

      Result := HTTP.Post(TokenEndpoint, RequestBody);
    finally
      RequestBody.Free;
    end;
  finally
    HTTP.Free;
  end;
end;

function FetchToken: string;
var
  JsonString: string;
  JsonData: TJSONData;
  JsonObject: TJSONObject;
begin
  JsonString := SendPost;
  JsonData := GetJSON(JsonString);
  if JsonData.JSONType = jtObject then
  begin
    JsonObject := TJSONObject(JsonData);
    Result := JsonObject.Get('access_token', '');
  end
  else
    Assert(False, 'Invalid JSON object');
end;

end.

