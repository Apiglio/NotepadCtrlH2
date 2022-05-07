program NotepadCtrlH_2;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, NCH2_main, nch2_definition
  { you can add units after this };

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Initialize;
  Application.CreateForm(TForm_Main, Form_Main);
  Application.Run;
end.

