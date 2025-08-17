![GitHub license](https://img.shields.io/github/license/michaelJustin/delphi-smtp-with-oauth2)
![GitHub issues](https://img.shields.io/github/issues/michaelJustin/delphi-smtp-with-oauth2)
![GitHub forks](https://img.shields.io/github/forks/michaelJustin/delphi-smtp-with-oauth2?style=social)
![GitHub top language](https://img.shields.io/github/languages/top/michaelJustin/delphi-smtp-with-oauth2)
![GitHub stars](https://img.shields.io/github/stars/michaelJustin/delphi-smtp-with-oauth2?style=social)

# Secure Delphi SMTP With OAuth2

# Requirements for FPCUnit test project
* Lazarus IDE
* Add required package for FPCUnit to the project
* 64 Bit OpenSSL DLLs from Indy
* Indy Sockets

# Configuration

* Add tenant id, client id and client secret in unit oauth2tokenprovider 

https://github.com/michaelJustin/delphi-smtp-with-oauth2/blob/dfa633624479bd1587e303aa33ed224aa352957c/src/main/oauth2tokenprovider.pas#L29-L32

* Set recipient address and name in unit smtpoauth2client

https://github.com/michaelJustin/delphi-smtp-with-oauth2/blob/dfa633624479bd1587e303aa33ed224aa352957c/src/main/smtpoauth2client.pas#L46-L48

* Set authorized user and password (the auth token) in smtpoauth2client
 
https://github.com/michaelJustin/delphi-smtp-with-oauth2/blob/dfa633624479bd1587e303aa33ed224aa352957c/src/main/smtpoauth2client.pas#L57-L59
