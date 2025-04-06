unit dialogform;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, LCLType;

type

  { TdlgForm }

  TdlgForm = class(TForm)
    btn1: TButton;
    btn2: TButton;
    dlgEdit: TEdit;
    promptLbl: TLabel;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: char);
  private
  public
    function getDlg(fcaption,prompt,default,btn1text,btn2text:string; var val:string):boolean;
  end;

var
  dlgForm: TdlgForm;

implementation

{$R *.lfm}

{ TdlgForm }

procedure TdlgForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_RETURN:btn1.Click;
    VK_ESCAPE:btn2.Click;
  end;
end;


procedure TdlgForm.FormKeyPress(Sender: TObject; var Key: char);
begin

end;

function TdlgForm.getDlg(fcaption, prompt, default, btn1text, btn2text: string;
  var val: string): boolean;
begin
  result:=false;
  dlgForm.Caption:=fcaption;
  promptlbl.Caption:=prompt;
  dlgEdit.Text:=default;
  btn1.Caption:=btn1text;
  btn2.Caption:=btn2text;
  dlgform.ShowModal;
  dlgedit.SelectAll;
  if modalresult = mrOk then begin
    val:=dlgEdit.Text;
    if val<>'' then result:=true else result:=false;
  end else begin
    result:=false;
    val:='';
  end;
end;

end.

