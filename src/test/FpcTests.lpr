program FpcTests;

uses
  Forms, Interfaces,
  GuiTestRunner,
  TestCase1;

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  TestRunner.Caption := 'SMTP OAuth2 Sender - FPCUnit';

  Application.Title := 'FPCUnit GUI test runner';
  Application.Run;
  Application.Free;
end.
