unit NCH2_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Apiglio_Useful, auf_ram_var, aufscript_frame, nch2_definition;

type

  { TForm_Main }

  TForm_Main = class(TForm)
    Frame_AufScript1: TFrame_AufScript;
    Memo_File: TMemo;
    Splitter_Horizon: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private

  public

  end;

var
  Form_Main: TForm_Main;
  mem,cvt:TMemoryStream;
  updating:boolean;

implementation

{$R *.lfm}

{ TForm_Main }

procedure TForm_Main.FormResize(Sender: TObject);
begin
  Frame_AufScript1.FrameResize(Frame_AufScript1);
end;

procedure TForm_Main.FormCreate(Sender: TObject);
begin
  Frame_AufScript1.AufGenerator;
  Func_NCH2_Generator(Frame_AufScript1.Auf.Script);
end;

initialization

  mem:=TMemoryStream.Create;
  cvt:=TMemoryStream.Create;

finalization
  mem.Free;
  cvt.Free;

end.

