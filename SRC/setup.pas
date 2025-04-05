{
The MIT License (MIT)

Copyright (c)  Ксенофонтов Николай aka Logos (nik.logos@gmail.com)

Данная лицензия разрешает лицам, получившим копию данного программного обеспечения и сопутствующей документации (далее — Программное обеспечение), безвозмездно использовать Программное обеспечение без ограничений, включая неограниченное право на использование, копирование, изменение, слияние, публикацию, распространение, сублицензирование и/или продажу копий Программного обеспечения, а также лицам, которым предоставляется данное Программное обеспечение, при соблюдении следующих условий:

Указанное выше уведомление об авторском праве и данные условия должны быть включены во все копии или значимые части данного Программного обеспечения.

ДАННОЕ ПРОГРАММНОЕ ОБЕСПЕЧЕНИЕ ПРЕДОСТАВЛЯЕТСЯ «КАК ЕСТЬ», БЕЗ КАКИХ-ЛИБО ГАРАНТИЙ, ЯВНО ВЫРАЖЕННЫХ ИЛИ ПОДРАЗУМЕВАЕМЫХ, ВКЛЮЧАЯ ГАРАНТИИ ТОВАРНОЙ ПРИГОДНОСТИ, СООТВЕТСТВИЯ ПО ЕГО КОНКРЕТНОМУ НАЗНАЧЕНИЮ И ОТСУТСТВИЯ НАРУШЕНИЙ, НО НЕ ОГРАНИЧИВАЯСЬ ИМИ. НИ В КАКОМ СЛУЧАЕ АВТОРЫ ИЛИ ПРАВООБЛАДАТЕЛИ НЕ НЕСУТ ОТВЕТСТВЕННОСТИ ПО КАКИМ-ЛИБО ИСКАМ, ЗА УЩЕРБ ИЛИ ПО ИНЫМ ТРЕБОВАНИЯМ, В ТОМ ЧИСЛЕ, ПРИ ДЕЙСТВИИ КОНТРАКТА, ДЕЛИКТЕ ИЛИ ИНОЙ СИТУАЦИИ, ВОЗНИКШИМ ИЗ-ЗА ИСПОЛЬЗОВАНИЯ ПРОГРАММНОГО ОБЕСПЕЧЕНИЯ ИЛИ ИНЫХ ДЕЙСТВИЙ С ПРОГРАММНЫМ ОБЕСПЕЧЕНИЕМ.


Copyright (c)  Ксенофрнтов Николай aka Logos (nik.logos@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
}

unit setup;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, StdCtrls,
  Grids, Buttons, inifiles;

type

  { TSetupForm }

  TSetupForm = class(TForm)
    BitAdd: TBitBtn;
    BitDel: TBitBtn;
    btnChg: TBitBtn;
    cListBox: TListBox;
    chgColorDlg: TColorDialog;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    SampleGrid: TStringGrid;
    TabSheet1: TTabSheet;
    procedure btnChgClick(Sender: TObject);
    procedure chgColorDlgClose(Sender: TObject);
    procedure cListBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    inifile:tinifile;
  public
     procedure init;
     procedure fin;
  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.lfm}

{ TSetupForm }

uses main;

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  init;
end;

procedure TSetupForm.cListBoxClick(Sender: TObject);
begin
  if cListBox.ItemIndex<>-1 then
  sampleGrid.Font.Color:=strtoint(inifile.ReadString('extcolor',cListBox.Items[cListBox.ItemIndex],intToStr(clBlack)));
end;

procedure TSetupForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  mform.SetColors;
end;

procedure TSetupForm.btnChgClick(Sender: TObject);
begin
  if cListBox.ItemIndex<>-1 then begin
    chgColorDlg.Color:=strtoint(inifile.ReadString('extcolor',cListBox.Items[cListBox.ItemIndex],intToStr(clBlack)));
    chgColorDlg.Execute;
    if cListBox.Items[cListBox.ItemIndex] = 'bgcolor'
    then sampleGrid.Color:=chgColorDlg.Color
    else sampleGrid.Font.Color:=chgColorDlg.Color;
    inifile.WriteString('extcolor',cListBox.Items[cListBox.ItemIndex],inttostr(chgColorDlg.Color));
  end;
end;

procedure TSetupForm.chgColorDlgClose(Sender: TObject);
begin

end;

procedure TSetupForm.FormDestroy(Sender: TObject);
begin
  fin;
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
  inifile.ReadSection('extcolor',clistbox.Items);
  sampleGrid.Color:=strtoint(inifile.ReadString('extcolor','bgcolor',inttostr(clWhite)));
end;

procedure TSetupForm.init;
begin
  Self.ShowInTaskBar := stAlways;
  sampleGrid.Cells[0,0]:='Lorem ipsum dolor sit amet';
  inifile:=tinifile.Create(GetAppConfigDir(false)+'lc.ini');
end;

procedure TSetupForm.fin;
begin
  inifile.Free;
end;

end.

