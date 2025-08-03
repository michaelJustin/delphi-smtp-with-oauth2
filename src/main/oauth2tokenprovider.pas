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
  jsonData: TJSONData;
  jsonObject: TJSONObject;
  jsonString: string;
  PostResponse: string;
  AccessToken: string;
begin
  jsonString := SendPost;
  jsonData := GetJSON(jsonString);

  if jsonData.JSONType = jtObject then
  begin
    jsonObject := TJSONObject(jsonData);
    AccessToken := jsonObject.Get('access_token', '');
  end
  else
    assert(False, 'Invalid JSON object');

  Result := AccessToken;
end;

end.

