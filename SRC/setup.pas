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

const
   LngSetupFormCaption:string = 'Настройки';
   LngSetupColorTabCaption:string = 'Файлы';
   LngSetupDlgAddCaption:string = 'Добавить';
   LngSetupDlgAddPrompt:string = 'Введите расширение файла:';
   LngSetupDlgBtnYes:string = 'Ок';
   LngSetupDlgBtnNo:string = 'Отмена';
   LngSetupCbColor:string = 'Подсветка файлов';
   LngSetupCbSys:string = 'Показывать системные файлы';
   LngSetupCbHidden:string = 'Показывать скрытые файлы';

type

  { TSetupForm }

  TSetupForm = class(TForm)
    BtAdd: TBitBtn;
    BtDel: TBitBtn;
    btnChg: TBitBtn;
    cbColor: TCheckBox;
    cbSys: TCheckBox;
    cbHidden: TCheckBox;
    cListBox: TListBox;
    chgColorDlg: TColorDialog;
    ImageList1: TImageList;
    PageControl1: TPageControl;
    SampleGrid: TStringGrid;
    TabSheet1: TTabSheet;
    procedure BtAddClick(Sender: TObject);
    procedure BtDelClick(Sender: TObject);
    procedure btnChgClick(Sender: TObject);
    procedure cbColorChange(Sender: TObject);
    procedure cbHiddenChange(Sender: TObject);
    procedure cbSysChange(Sender: TObject);
    procedure chgColorDlgClose(Sender: TObject);
    procedure cListBoxClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
     procedure init;
     procedure fin;
  end;

var
  SetupForm: TSetupForm;

implementation

{$R *.lfm}

{ TSetupForm }

uses main, dialogform;

procedure TSetupForm.FormCreate(Sender: TObject);
begin
  init;
end;

procedure TSetupForm.cListBoxClick(Sender: TObject);
begin
  if cListBox.ItemIndex<>-1 then
   if cListBox.Items.Strings[cListbox.ItemIndex]<>'bgcolor'
   then sampleGrid.Font.Color:=strtoint(mform.inifile.ReadString('extcolor',cListBox.Items[cListBox.ItemIndex],'0'))
   else begin
     sampleGrid.Color:=strtoint(mform.inifile.ReadString('extcolor',cListBox.Items[cListBox.ItemIndex],'0'));
     sampleGrid.Font.Color:=clBlack;
   end;
end;

procedure TSetupForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if cListBox.Count = 0 then begin
    mform.inifile.WriteString('extcolor','bgcolor','$00E6EEF0');
    mform.inifile.WriteString('extcolor','system','4734874');
    mform.inifile.WriteString('extcolor','hidden','10725807');
  end;
end;

procedure TSetupForm.btnChgClick(Sender: TObject);
begin
  if cListBox.ItemIndex<>-1 then begin
    chgColorDlg.Color:=strtoint(mform.inifile.ReadString('extcolor',cListBox.Items[cListBox.ItemIndex],'0'));
    chgColorDlg.Execute;
    if cListBox.Items[cListBox.ItemIndex] = 'bgcolor'
    then sampleGrid.Color:=chgColorDlg.Color
    else sampleGrid.Font.Color:=chgColorDlg.Color;
    mform.inifile.WriteString('extcolor',cListBox.Items[cListBox.ItemIndex],inttostr(chgColorDlg.Color));
  end;
end;

procedure TSetupForm.cbColorChange(Sender: TObject);
begin
  mform.inifile.WriteBool('main','usecolors',cbColor.Checked);
end;

procedure TSetupForm.cbHiddenChange(Sender: TObject);
begin
  mform.inifile.WriteBool('main','showhidden',cbHidden.Checked);
end;

procedure TSetupForm.cbSysChange(Sender: TObject);
begin
  mform.inifile.WriteBool('main','showsys',cbSys.Checked);
end;

procedure TSetupForm.chgColorDlgClose(Sender: TObject);
begin

end;

procedure TSetupForm.BtAddClick(Sender: TObject);
var
  tmp:string;
begin
   if dlgForm.getDlg(LngSetupDlgAddCaption,LngSetupDlgAddPrompt,'',LngSetupDlgBtnYes,LngSetupDlgBtnNo,tmp)
   then begin
     clistbox.Items.Add(tmp);
     mform.inifile.WriteString('extcolor',tmp,inttostr(chgColorDlg.Color));
   end;
   if cListBox.Items.IndexOf(tmp)<>-1 then cListBox.ItemIndex:=cListBox.Items.IndexOf(tmp);
end;

procedure TSetupForm.BtDelClick(Sender: TObject);
begin
  if cListBox.ItemIndex<>-1 then begin
    mform.inifile.DeleteKey('extcolor',clistbox.Items.Strings[clistbox.ItemIndex]);
    clistbox.Items.Delete(clistbox.ItemIndex);
  end;
end;

procedure TSetupForm.FormDestroy(Sender: TObject);
begin
  fin;
end;

procedure TSetupForm.FormShow(Sender: TObject);
begin
  mform.inifile.ReadSection('extcolor',clistbox.Items);
  clistbox.Sorted:=true;
  sampleGrid.Color:=strtoint(mform.inifile.ReadString('extcolor','bgcolor',inttostr(clWhite)));
  cbColor.Caption:=LngSetupCbColor;
  cbSys.Caption:=LngSetupCbSys;
  cbHidden.caption:=LngSetupCbHidden;
  cbColor.Checked:=mform.inifile.ReadBool('main','usecolors',true);
  cbSys.Checked:=mform.inifile.ReadBool('main','showsys',false);
  cbHidden.Checked:=mform.inifile.ReadBool('main','showhidden',false);
end;

procedure TSetupForm.init;
begin
  Self.ShowInTaskBar := stAlways;
  sampleGrid.Cells[0,0]:='Lorem ipsum dolor sit amet';
  setupForm.Caption:=LngSetupFormCaption;
  tabSheet1.Caption:=LngSetupColorTabCaption;
end;

procedure TSetupForm.fin;
begin

end;

end.

