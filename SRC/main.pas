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

{
uses LazFileUtils;
//...
AppendPathDelim(GetUserDir + 'Documents')
GetAppConfigDir()
}

unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls,
  Menus, ActnList, Buttons, StdCtrls,
  inifiles, windows, Grids, lazUTF8, shellapi, FileListGrid, copyform, IFileOp,
  diskmonitor, dialogform, setup;

const
   LngMainMenuFile:string = 'Файл';
   LngMainMenuFileExit:string = 'Выход';
   LngBtnRename:string = 'Переименовать (F2)';
   LngBtnView:string = 'Просмотр (F3)';
   LngBtnEdit:string = 'Правка (F4)';
   LngBtnCopy:string = 'Копировать (F5)';
   LngBtnMov:string = 'Переместить (F6)';
   LngBtnNewFold:string = 'Новый каталог (F7)';
   LngBtnDel:string = 'Удалить (F8)';
   LngByte:string = ' б';
   LngKiloByte:string = ' кб';
   LngMegaByte:string = ' мб';
   LngGigaByte:string = ' гб';
   LngTeraByte:string = ' тб';
   lngFree:string = 'свободно';
   lngOf:string = 'из';
   lngFileTab:string = 'Файлы';
   lngPictTab:string = 'Изображение';
   lngNewDir:string = 'Новая папка';
   lngNewDirPrompt:string = 'Введите название:';
   lngNewDirDefault:string = '';
   lngNewName = 'Переименовать: ';
   lngNewNamePrompt = 'Введите новое имя:';
   lngFopCaption = 'Оповещение';
   lngFopInfo = 'Список файлов пуст';
   LngCopyProgressCaption = 'Процесс копирования запущен';
   LngCopyProgressQ = 'Добавить файлы в очередь?';
   LngCopyProgressYes = 'Да';
   LngCopyProgressNo = 'Нет';
   lngBtnYes = 'Ок';
   lngBtnNo = 'Отмена';
   lngRenameItem  = 'Переименовать';
   lngRenameItemPrompt = 'Введите новое имя:';
   lngCopyFile  = 'Копировать';
   lngCopyFilePrompt = 'Имя файла:';

type

  { TmForm }

  TmForm = class(TForm)
    ActionShowSetup: TAction;
    ActionDel2: TAction;
    ActionDel: TAction;
    ActionNewFold: TAction;
    ActionMov: TAction;
    ActionCopy: TAction;
    ActionEdit: TAction;
    ActionView: TAction;
    ActionRename: TAction;
    ActionExit: TAction;
    EditLeftPath: TEdit;
    EditRightPath: TEdit;
    ldrivesMenu: TPopupMenu;
    ldrvbtn: TToolButton;
    leftDrvBtn: TToolBar;
    LeftFileTab: TTabSheet;
    leftFreeSpaceLabel: TLabel;
    LeftImgTab: TTabSheet;
    leftPanel: TPanel;
    lFList: TFileListGrid;
    llimg: TImage;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    mPanel: TPanel;
    PageControl1: TPageControl;
    PageControl2: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    leftPB: TProgressBar;
    Panel4: TPanel;
    rightPB: TProgressBar;
    rDrivesMenu: TPopupMenu;
    MenuItem4: TMenuItem;
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    rdrvbtn: TToolButton;
    rFList: TFileListGrid;
    rightDrvBtn: TToolBar;
    RightFileTab: TTabSheet;
    rightFreeSpaceLabel: TLabel;
    RightImgTab: TTabSheet;
    rightPanel: TPanel;
    rlimg: TImage;
    split50percent: TAction;
    ActionList1: TActionList;
    MainMenu1: TMainMenu;
    Splitter1: TSplitter;
    splitterMenu: TPopupMenu;
    btnToolBar: TToolBar;
    ToolBar1: TToolBar;
    ToolBar2: TToolBar;
    ToolBar3: TToolBar;
    ToolBar4: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton19: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    procedure ActionCopyExecute(Sender: TObject);
    procedure ActionDel2Execute(Sender: TObject);
    procedure ActionDelExecute(Sender: TObject);
    procedure ActionEditExecute(Sender: TObject);
    procedure ActionExitExecute(Sender: TObject);
    procedure ActionMovExecute(Sender: TObject);
    procedure ActionNewFoldExecute(Sender: TObject);
    procedure ActionRenameExecute(Sender: TObject);
    procedure ActionShowSetupExecute(Sender: TObject);
    procedure ActionViewExecute(Sender: TObject);
    procedure CoolBar1Change(Sender: TObject);
    procedure EditLeftPathClick(Sender: TObject);
    procedure EditRightPathClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of string);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormWindowStateChange(Sender: TObject);
    procedure lFListDirChange(Sender: TObject);
    procedure lFListDirectoryChange(Sender: TObject);
    procedure lFListEnter(Sender: TObject);
    procedure lFListFileSelect(Sender: TObject; fName: string);
    procedure lFListHeaderSized(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure lFListSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure rFListColRowInserted(Sender: TObject; IsColumn: Boolean; sIndex,
      tIndex: Integer);
    procedure rFListDirChange(Sender: TObject);
    procedure rFListDirectoryChange(Sender: TObject);
    procedure rFListEnter(Sender: TObject);
//    procedure rFListDirChange(Sender: TObject);
    procedure rFListFileSelect(Sender: TObject; fName: string);
    procedure rFListHeaderSized(Sender: TObject; IsColumn: Boolean;
      Index: Integer);
    procedure split50percentExecute(Sender: TObject);
    procedure ToolButton10Click(Sender: TObject);
    procedure ToolButton11Click(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ToolButton14Click(Sender: TObject);
    procedure ToolButton15Click(Sender: TObject);
    procedure ToolButton16Click(Sender: TObject);
    procedure ToolButton17Click(Sender: TObject);
    procedure ToolButton18Click(Sender: TObject);
    procedure ToolButton19Click(Sender: TObject);
  private


    //*********************** для файловых операций
    LeftPanelFocused:boolean;

    DiskMon:TDeviceMonitor;
    procedure diskChanged(EventType: Word; Drive: string);

    procedure getDrives(list:tstrings);
    procedure setdrives;
    procedure frmresize;
    procedure rightDrvBtnClick(Sender: TObject);
    procedure lDrvMenuClick(Sender: TObject);
    procedure rDrvMenuClick(Sender: TObject);
    procedure setfreespacelabel(drv:char; slabel:tlabel);
    function getVersion:string;
    procedure doCopy;
    procedure doDeleteToBin;
    procedure doMove;

    procedure init;
    procedure fin;

    function itbs(path:string):string;


  public
    inifile:tinifile;

    procedure SetColors;


  end;

var
  mForm: TmForm;

implementation


{$R *.lfm}

{ TmForm }


procedure TmForm.split50percentExecute(Sender: TObject);
begin
  leftPanel.Width:=mform.Width div 2 - 4;
  lflist.ColWidths[0]:=lflist.Width-lflist.ColWidths[1]-lflist.ColWidths[2]-20;
  rflist.ColWidths[0]:=rflist.Width-rflist.ColWidths[1]-rflist.ColWidths[2]-20;
end;

procedure TmForm.ToolButton10Click(Sender: TObject);
begin
  lflist.setDirectory(lflist.Directory[1]+lflist.Directory[2]);
end;

procedure TmForm.ToolButton11Click(Sender: TObject);
begin
  lflist.lvlUp;
end;

procedure TmForm.ToolButton12Click(Sender: TObject);
begin
  lflist.setDirectory(rflist.Directory);
end;

procedure TmForm.ToolButton13Click(Sender: TObject);
begin
   rflist.setDirectory(lflist.Directory);
end;

procedure TmForm.ToolButton14Click(Sender: TObject);
begin
   rflist.setDirectory(rflist.Directory[1]+rflist.Directory[2]);
end;

procedure TmForm.ToolButton15Click(Sender: TObject);
begin
  rflist.lvlUp;
end;

procedure TmForm.ToolButton16Click(Sender: TObject);
begin
   lflist.setDirectory(rflist.Directory);
end;

procedure TmForm.ToolButton17Click(Sender: TObject);
begin
  rflist.setDirectory(lflist.Directory);
end;

procedure TmForm.ToolButton18Click(Sender: TObject);
begin
  lflist.RefreshList;
end;

procedure TmForm.ToolButton19Click(Sender: TObject);
begin
  rflist.RefreshList;
end;

procedure TmForm.diskChanged(EventType: Word; Drive: string);
begin
   setdrives;
end;

procedure TmForm.getDrives(list: tstrings);
var
  drive:char;
  tmp:tstringlist;
begin
  //****************
  {
  DRIVE_UNKNOWN (0) Не удается определить тип диска.
  DRIVE_NO_ROOT_DIR (1) Недопустимый корневой путь; Например, том не подключен по указанному пути.
  DRIVE_REMOVABLE (2) Диск имеет съемный носитель; например, диск с флоппи-диском, большим диском или средством чтения флэш-карт.
  DRIVE_FIXED (3) Диск имеет фиксированный носитель; например, жесткий диск или флэш-диск.
  DRIVE_REMOTE (4) Диск является удаленным (сетевым) диском.
  DRIVE_CDROM (5) Диск — это диск CD-ROM.
  DRIVE_RAMDISK (6) Диск является диском ОЗУ.
  }
  //****************
  tmp:=tstringlist.Create;
  for Drive := 'A' to 'Z' do if GetDriveType(PChar(Drive + ':\')) <> DRIVE_NO_ROOT_DIR then tmp.Add(drive);
  list.Assign(tmp);
  tmp.Free;
  //GetDiskFreeSpaceEx(diskletter,FreeBytesAvailableToCaller,Totalsize,FreeSize:int64);
end;

procedure TmForm.setdrives;
var
  counter:integer;
  drv:tstringlist;
  tmp:ttoolbutton;
  mtmp:tmenuitem;
  getdrvinfo:boolean;
  //
  VolName, FSName: array [0..MAX_PATH-1] of Char;
  VolSN: DWord;
  MaxComponentLength,FileSystemFlags: Cardinal;
begin
  for counter:=1 to rightDrvBtn.ButtonCount do rightDrvBtn.Buttons[0].Free;
  for counter:=1 to leftDrvBtn.ButtonCount do leftDrvBtn.Buttons[0].Free;
  for counter:=1 to ldrivesMenu.Items.Count do ldrivesMenu.Items.Items[0].Free;
  for counter:=1 to rdrivesMenu.Items.Count do rdrivesMenu.Items.Items[0].Free;

  drv:=tstringlist.Create;
  getDrives(drv);
  getdrvinfo:=false;
  //showmessage(drv.Text);
  for counter:=0 to drv.Count-1 do
  begin
    getdrvinfo:=getvolumeinformation(pchar(drv[counter]+':\'),volname,MAX_PATH,@VolSN,MaxComponentLength,FileSystemFlags, FSname,MAX_PATH);
    tmp:=ttoolbutton.Create(leftDrvBtn);
    tmp.Caption:=(drv[counter]);
    if getdrvinfo then tmp.Hint:='('+drv[counter]+':)'+' '+volname;
    case GetDriveType(PChar(drv[counter] + ':\')) of
      DRIVE_REMOVABLE:tmp.ImageIndex:=8;
      DRIVE_CDROM:tmp.ImageIndex:=9;
      DRIVE_REMOTE:tmp.ImageIndex:=10;
      DRIVE_RAMDISK:tmp.ImageIndex:=11;
      else tmp.ImageIndex:=7;
    end;
    tmp.Parent:=leftDrvBtn;
    tmp.Left:=leftDrvBtn.Left+leftDrvBtn.Width;
    tmp.OnClick:=@lDrvMenuClick;//@leftDrvBtnClick;
    //****************************
    tmp:=ttoolbutton.Create(rightDrvBtn);
    tmp.Caption:=(drv[counter]);
    if getdrvinfo then tmp.Hint:='('+drv[counter]+':)'+' '+volname;
    case GetDriveType(PChar(drv[counter] + ':\')) of
      DRIVE_REMOVABLE:tmp.ImageIndex:=8;
      DRIVE_CDROM:tmp.ImageIndex:=9;
      DRIVE_REMOTE:tmp.ImageIndex:=10;
      DRIVE_RAMDISK:tmp.ImageIndex:=11;
      else tmp.ImageIndex:=7;
    end;
    tmp.Parent:=rightDrvBtn;
    tmp.Left:=rightDrvBtn.Left+rightDrvBtn.Width;
    tmp.OnClick:=@rDrvMenuClick;
    //**************************** drive menu
    {
    BOOL GetVolumeInformationA(
    [in, optional]  LPCSTR  lpRootPathName,
    [out, optional] LPSTR   lpVolumeNameBuffer,
    [in]            DWORD   nVolumeNameSize,
    [out, optional] LPDWORD lpVolumeSerialNumber,
    [out, optional] LPDWORD lpMaximumComponentLength,
    [out, optional] LPDWORD lpFileSystemFlags,
    [out, optional] LPSTR   lpFileSystemNameBuffer,
    [in]            DWORD   nFileSystemNameSize
    );
    }

    mtmp:=tmenuitem.Create(ldrivesMenu);
    mtmp.Caption:=('('+drv[counter]+':)');
    mtmp.Hint:=drv[counter]+':';
    case GetDriveType(PChar(drv[counter] + ':\')) of
      DRIVE_REMOVABLE:mtmp.ImageIndex:=8;
      DRIVE_CDROM:mtmp.ImageIndex:=9;
      DRIVE_REMOTE:mtmp.ImageIndex:=10;
      DRIVE_RAMDISK:mtmp.ImageIndex:=11;
      else mtmp.ImageIndex:=7;
    end;
    if getdrvinfo then mtmp.Caption:=mtmp.Caption+' '+volname;
    mtmp.OnClick:=@lDrvMenuClick;
    ldrivesMenu.Items.Add(mtmp);

    mtmp:=tmenuitem.Create(rdrivesMenu);
    mtmp.Caption:=('('+drv[counter]+':)');
    mtmp.Hint:=drv[counter]+':';
    case GetDriveType(PChar(drv[counter] + ':\')) of
      DRIVE_REMOVABLE:mtmp.ImageIndex:=8;
      DRIVE_CDROM:mtmp.ImageIndex:=9;
      DRIVE_REMOTE:mtmp.ImageIndex:=10;
      DRIVE_RAMDISK:mtmp.ImageIndex:=11;
      else mtmp.ImageIndex:=7;
    end;
    if getdrvinfo then mtmp.Caption:=mtmp.Caption+' '+volname;
    mtmp.OnClick:=@rDrvMenuClick;
    rdrivesMenu.Items.Add(mtmp);
  end;
  drv.Free;
end;

procedure TmForm.frmresize;
begin
   btnToolBar.ButtonWidth:=btnToolBar.Width div btnToolBar.ButtonCount-1;
   split50percentExecute(mForm);
end;

procedure TmForm.rightDrvBtnClick(Sender: TObject);
var ltr:char;
begin
  with sender as TToolButton do
  begin
     ltr:=caption[1];
     rflist.setDirectory(caption+':');
     setfreespacelabel(ltr,rightfreespacelabel);
   end;
end;

procedure TmForm.lDrvMenuClick(Sender: TObject);
begin
  if UTF8LowerCase(sender.ClassName) = 'tmenuitem' then
    with sender as tmenuitem do begin
      lflist.setDirectory(hint);
      ldrvbtn.Caption:=caption;
      ldrvbtn.ImageIndex:=ImageIndex;
      setfreespacelabel(hint[1],leftfreespacelabel);
    end
  else
   with sender as TToolButton do begin
      lflist.setDirectory(caption+':');
      ldrvbtn.Caption:=hint;
      ldrvbtn.ImageIndex:=ImageIndex;
      setfreespacelabel(caption[1],leftfreespacelabel);
    end
end;

procedure TmForm.rDrvMenuClick(Sender: TObject);
begin
  if UTF8LowerCase(sender.ClassName) = 'tmenuitem' then
    with sender as tmenuitem do begin
      rflist.setDirectory(hint);
      rdrvbtn.Caption:=caption;
      rdrvbtn.ImageIndex:=ImageIndex;
      setfreespacelabel(hint[1],rightfreespacelabel);
    end
  else
   with sender as TToolButton do begin
      rflist.setDirectory(caption+':');
      rdrvbtn.Caption:=hint;
      rdrvbtn.ImageIndex:=ImageIndex;
      setfreespacelabel(caption[1],rightfreespacelabel);
    end
end;

procedure TmForm.setfreespacelabel(drv: char; slabel: tlabel);
var
  sBytes:TLargeInteger;
  sTotal:TLargeInteger;
  sFree:TLargeInteger;
  lfree,ltotal:string;
begin
  if GetDiskFreeSpaceEx(pchar(drv+':\'),sBytes,sTotal,@sFree)
  then begin
    if sfree < 1000 then lfree:=floattostrf(sfree,fffixed,8,0)+lngByte
    else if sfree < 1000000 then lfree:=floattostrf(sfree/1024,fffixed,8,0)+lngKiloByte
    else if sfree < 1000000000 then lfree:=floattostrf(sfree/1000000,fffixed,8,0)+lngMegaByte
    else if sfree < 1000000000000 then lfree:=floattostrf(sfree/1000000000,fffixed,8,0)+lngGigaByte
    else lfree:=floattostrf(sfree/1000000000000,fffixed,8,0)+lngTeraByte;

    if stotal < 1000 then ltotal:=floattostrf(stotal,fffixed,8,0)+lngByte
    else if stotal < 1000000 then ltotal:=floattostrf(stotal/1000,fffixed,8,0)+lngKiloByte
    else if stotal < 1000000000 then ltotal:=floattostrf(stotal/1000000,fffixed,8,0)+lngMegaByte
    else if stotal < 1000000000000 then ltotal:=floattostrf(stotal/1000000000,fffixed,8,0)+lngGigaByte
    else ltotal:=floattostrf(stotal/1000000000000,fffixed,8,0)+lngTeraByte;

    slabel.Caption:=lfree+' '+lngFree+' '+lngOf+' '+ltotal + ' ( '+lngFree+' '+inttostr(trunc((sfree/stotal)*100))+'% )';
    //slabel.Caption:=inttostr(trunc((sfree/stotal)*100))+'%';
  end
  else slabel.Caption:='';
end;

function TmForm.getVersion: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
begin
  Result := '';
  VerInfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)), Dummy);
  if VerInfoSize = 0 then Exit;

  GetMem(VerInfo, VerInfoSize);
  try
    if GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo) then
    begin
      if VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize) then
      begin
        with VerValue^ do
        begin
          Result := Format(' ver.%d.%d.%d.%d', [
            HiWord(dwFileVersionMS), // Major
            LoWord(dwFileVersionMS), // Minor
            HiWord(dwFileVersionLS), // Release
            LoWord(dwFileVersionLS)  // Build
          ]);
        end;
      end;
    end;
  finally
    FreeMem(VerInfo, VerInfoSize);
  end;
end;

procedure TmForm.doCopy;
var
  tmpList:tstringlist;
  nName:string;
  lSrc,lDest:TFileListGrid;
begin

  tmpList:=tstringlist.Create;
  tmplist.Clear;

  if lflist.Focused then begin
    lSrc:=lfList;
    lDest:=rfList;
  end else begin
    lSrc:=rfList;
    lDest:=lfList;
  end;

  if copyf.getNowCopy then begin  //if being copied
     if QuestionDlg(LngCopyProgressCaption,LngCopyProgressQ, mtCustom, [mrYes,LngCopyProgressYes,'IsDefault',mrNo,LngCopyProgressNo], 0) = mrYes
     then begin
        if lSrc.getSelectedItems(tmpList,false)
        then
          if tmpList.Count<>1 then copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist)
          else begin
            //если файл только один и это файл
            if (
                (fileexists(itbs(lSrc.Directory)+tmpList.Strings[0]))
                 and
                (dlgform.getDlg(lngCopyFile,lngCopyFilePrompt,tmpList.Strings[0],lngBtnYes,lngBtnNo, nName))
                )
            then copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist,nName)
            else copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist);
          end;
     end;
  end else begin
    if lSrc.getSelectedItems(tmpList,false)
    then
      if tmpList.Count<>1 then copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist)
      else begin
        //если файл только один и это файл
        if (
            (fileexists(itbs(lSrc.Directory)+tmpList.Strings[0]))
             and
            (dlgform.getDlg(lngCopyFile,lngCopyFilePrompt,tmpList.Strings[0],lngBtnYes,lngBtnNo, nName))
            )
        then copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist,nName)
        else copyf.addToCopyQueue(lSrc.Directory,lDest.Directory,tmplist);
      end;
  end;

  tmpList.Free;
  copyf.startCopy;
end;

procedure TmForm.doDeleteToBin;
var
  tmp:tstringlist;
  counter:integer;
  pbar:tprogressbar;
begin
  tmp:=tstringlist.Create;

  if leftPanelFocused
  then begin
    lflist.getSelectedItems(tmp,true);
    pbar:=leftpb;
  end
  else begin
    rflist.getSelectedItems(tmp,true);
    pbar:=rightpb;
  end;

  if tmp.Count<>0 then begin
   pbar.Max:=tmp.Count;
   pbar.Show;
   pbar.Step:=1;
   for counter:=1 to tmp.Count do begin
     DeleteToRecycleBin(tmp.Strings[counter-1]);
     pbar.StepBy(1);
   end;
   pbar.Hide;
  end;

  tmp.Free;
end;

procedure TmForm.doMove;
var
  tmp:tstringlist;
  counter:integer;
  pbar:tprogressbar;
  dest:string;
begin
  if lowercase(lflist.Directory[1]+lflist.Directory[2]) = lowercase(rflist.Directory[1]+rflist.Directory[2])
  then begin //перемещение в пределах одного диска
    tmp:=tstringlist.Create;

    if leftPanelFocused
    then begin
      lflist.getSelectedItems(tmp,true);
      dest:=itbs(rflist.Directory);
      pbar:=leftpb;
    end
    else begin
      rflist.getSelectedItems(tmp,true);
      dest:=itbs(lflist.Directory);
      pbar:=rightpb;
    end;

    if tmp.Count<>0 then begin
     pbar.Max:=tmp.Count;
     pbar.Show;
     pbar.Step:=1;
     for counter:=1 to tmp.Count do begin
       MoveFileOrFolder(tmp.Strings[counter-1],dest,'');
       pbar.StepBy(1);
     end;
     pbar.Hide;
    end;

    tmp.Free;
  end else begin //разные диски
    tmp:=tstringlist.Create;

    if leftPanelFocused
    then begin
      lflist.getSelectedItems(tmp,true);
      dest:=itbs(rflist.Directory);
      pbar:=leftpb;
    end
    else begin
      rflist.getSelectedItems(tmp,true);
      dest:=itbs(lflist.Directory);
      pbar:=rightpb;
    end;

    if tmp.Count<>0 then begin
     pbar.Max:=tmp.Count;
     pbar.Show;
     pbar.Step:=1;
     for counter:=1 to tmp.Count do begin
       MoveFileOrFolder(tmp.Strings[counter-1],dest,'');
       pbar.StepBy(1);
     end;
     pbar.Hide;
    end;

    //mThread:=TThread.ExecuteInThread(@doMoveDiffDisks,nil);

    tmp.Free;
  end;
end;

procedure TmForm.init;
var
  counter:integer;
  tmp:tstringlist;
begin

   //************************ LANG
    MenuItem2.Caption:=LngMainMenuFile;
    ActionExit.Caption:=LngMainMenuFileExit;
    ActionRename.Caption:=LngBtnRename;
    ActionView.Caption:=LngBtnView;
    ActionEdit.Caption:=LngBtnEdit;
    ActionCopy.Caption:=LngBtnCopy;
    ActionMov.Caption:=LngBtnMov;
    ActionNewFold.Caption:=LngBtnNewFold;
    ActionDel.Caption:=LngBtnDel;
   //************************ LANG
   inifile:=tinifile.Create(GetAppConfigDir(false)+'lc.ini');

   //lflist.Directory:=inifile.ReadString('main','lfdir','c:');
   //rflist.Directory:=inifile.ReadString('main','rfdir','c:');

   setdrives;

   editLeftPath.Text:=inifile.ReadString('main','elft','');
   editRightPath.Text:=inifile.ReadString('main','erft','');

   ldrvbtn.Caption:=inifile.ReadString('main','ldrvcap','');
   rdrvbtn.Caption:=inifile.ReadString('main','rdrvcap','');

   leftFreeSpaceLabel.Caption:=inifile.ReadString('main','lfscap','');
   rightFreeSpaceLabel.Caption:=inifile.ReadString('main','rfscap','');

   leftPanel.Width:=inifile.ReadInteger('main','lpwidth',300);

   for counter:=0 to rflist.ColCount-1 do rflist.ColWidths[counter]:=inifile.ReadInteger('main','colwidth'+inttostr(counter),200);
   for counter:=0 to lflist.ColCount-1 do lflist.ColWidths[counter]:=inifile.ReadInteger('main','colwidth'+inttostr(counter),200);

   rdrvbtn.ImageIndex:=inifile.readInteger('main','rbtndrvimg',-1);
   ldrvbtn.ImageIndex:=inifile.readInteger('main','lbtndrvimg',-1);

   leftFileTab.Caption:=lngFileTab;
   rightFileTab.Caption:=lngFileTab;
   rightImgTab.Caption:=lngPictTab;
   leftImgTab.Caption:=lngPictTab;

   LeftPanelFocused:=true;
   lfList._startDirWatch;
   rflist._startDirWatch;

   mform.Caption:= mform.Caption+getVersion;


   DiskMon:=TDeviceMonitor.Create(self);
   DiskMon.OnChange:=@diskChanged;

   lflist.SortMode:=lflist.StrToSortMode(inifile.ReadString('main','lfsortmode','smNone'));
   rflist.SortMode:=rflist.StrToSortMode(inifile.ReadString('main','rfsortmode','smNone'));

   setColors;

   lflist.FilesShowHidden:=inifile.ReadBool('main','showhidden',false);
   lflist.FilesShowSys:=inifile.ReadBool('main','showsys',false);
   lflist.FilesColorUse:=inifile.ReadBool('main','usecolors',false);

   rflist.FilesShowHidden:=inifile.ReadBool('main','showhidden',false);
   rflist.FilesShowSys:=inifile.ReadBool('main','showsys',false);
   lflist.FilesColorUse:=inifile.ReadBool('main','usecolors',false);

   if not inifile.ValueExists('extcolor','bgcolor')
   then inifile.WriteString('extcolor','bgcolor','$00E6EEF0');
   if not inifile.ValueExists('extcolor','system')
   then mform.inifile.WriteString('extcolor','system','4734874');
   if not inifile.ValueExists('extcolor','hidden')
   then mform.inifile.WriteString('extcolor','hidden','10725807');


   tmp:=tstringlist.Create;
   inifile.ReadSection('extcolor',tmp);

   lflist.FilesColor.clear;
   for counter:=0 to tmp.Count-1 do
     with lflist.FilesColor.Add do begin
       key:=tmp.Strings[counter];
       value:=inifile.ReadString('extcolor',key,'0');
     end;

   rflist.FilesColor.clear;
   for counter:=0 to tmp.Count-1 do
     with rflist.FilesColor.Add do begin
       key:=tmp.Strings[counter];
       value:=inifile.ReadString('extcolor',key,'0');
     end;

   tmp.Free;

   lflist.Directory:=inifile.ReadString('main','lfdir','c:');
   rflist.Directory:=inifile.ReadString('main','rfdir','c:');
end;

procedure TmForm.fin;
var counter:integer;
begin
  //diskMon.free;
  freeandnil(diskMon);
  for counter:=1 to rightDrvBtn.ButtonCount do rightDrvBtn.Buttons[0].Free;
  for counter:=1 to leftDrvBtn.ButtonCount do leftDrvBtn.Buttons[0].Free;
  for counter:=1 to ldrivesMenu.Items.Count do ldrivesMenu.Items.Items[0].Free;
  inifile.WriteString('main','lfdir',lflist.Directory);
  inifile.WriteString('main','rfdir',rflist.Directory);
  if mform.WindowState = wsNormal
  then begin
    inifile.WriteInteger('main','ftop',mform.top);
    inifile.WriteInteger('main','fleft',mform.left);
    inifile.WriteInteger('main','fwidth',mform.width);
    inifile.WriteInteger('main','fheight',mform.height);
  end;
  inifile.WriteInteger('main','rbtndrvimg',rdrvbtn.ImageIndex);
  inifile.WriteInteger('main','lbtndrvimg',ldrvbtn.ImageIndex);

  inifile.WriteBool('main','lffocused',lflist.Focused);
  inifile.WriteBool('main','rffocused',rflist.Focused);

  lfList._stopDirWatch;
  rflist._stopDirWatch;

  if mform.WindowState = wsNormal then begin
    inifile.WriteInteger('main','ftop',mform.top);
    inifile.WriteInteger('main','fleft',mform.left);
    inifile.WriteInteger('main','fwidth',mform.width);
    inifile.WriteInteger('main','fheight',mform.height);
    inifile.WriteBool('main','fstate',true);
  end else inifile.WriteBool('main','fstate',false);

  inifile.WriteString('main','elft',editLeftPath.Text);
  inifile.WriteString('main','erft',editRightPath.Text);

  inifile.WriteString('main','ldrvcap',ldrvbtn.Caption);
  inifile.WriteString('main','rdrvcap',rdrvbtn.Caption);

  inifile.WriteString('main','lfscap',leftFreeSpaceLabel.Caption);
  inifile.WriteString('main','rfscap',rightFreeSpaceLabel.Caption);

  inifile.WriteInteger('main','lpwidth',leftPanel.Width);

  inifile.WriteString('main','lfsortmode',lflist.SortModeToStr(lflist.SortMode));
  inifile.WriteString('main','rfsortmode',rflist.SortModeToStr(rflist.SortMode));

  //inifile.WriteString('extcolor','bgcolor',inttostr(lflist.Color));

  freeandnil(inifile);
end;

function TmForm.itbs(path: string): string;
begin
  result:=includetrailingbackslash(path);
end;

procedure TmForm.SetColors;
begin
   lflist.Color:=strtoint(inifile.Readstring('extcolor','bgcolor','clWhite'));
   rflist.Color:=strtoint(inifile.Readstring('extcolor','bgcolor','clWhite'));
end;

procedure TmForm.FormCreate(Sender: TObject);
begin
  init;
end;

procedure TmForm.FormDropFiles(Sender: TObject; const FileNames: array of string
  );
begin
  showmessage ('***');
  if leftpanelfocused
  then showmessage ('l')
  else showmessage ('r');
end;

procedure TmForm.FormResize(Sender: TObject);
begin
  frmresize;
end;

procedure TmForm.FormShow(Sender: TObject);
begin
   if inifile.ReadBool('main','fstate',true) then begin
      mform.WindowState:=wsNormal;
      mform.top:=inifile.ReadInteger('main','ftop',100);
      mform.left:=inifile.ReadInteger('main','fleft',100);
      mform.width:=inifile.ReadInteger('main','fwidth',1024);
      mform.height:=inifile.ReadInteger('main','fheight',768);
   end else mform.WindowState:=wsMaximized;

   if ((lflist.CanFocus)and(inifile.ReadBool('main','lffocused',true))) then lflist.setFocus;
   if ((rflist.CanFocus)and(inifile.ReadBool('main','rffocused',false))) then rflist.setFocus;
   LeftPanelFocused:=lflist.Focused;
end;

procedure TmForm.FormWindowStateChange(Sender: TObject);
begin
  if mform.WindowState = wsNormal
  then begin
    mform.top:=inifile.ReadInteger('main','ftop',100);
    mform.left:=inifile.ReadInteger('main','fleft',100);
    mform.width:=inifile.ReadInteger('main','fwidth',1024);
    mform.height:=inifile.ReadInteger('main','fheight',768);
//    split50percentExecute(mForm);
  end;
end;


procedure TmForm.lFListDirChange(Sender: TObject);
begin
  editLeftPath.Text:=lflist.Directory;
end;

procedure TmForm.lFListDirectoryChange(Sender: TObject);
begin
  editLeftPath.Text:=lflist.Directory;
end;

procedure TmForm.lFListEnter(Sender: TObject);
begin
  LeftPanelFocused:=true;
end;

procedure TmForm.lFListFileSelect(Sender: TObject; fName: string);
begin
  if RightImgTab.Visible then
  try
    rlimg.Picture.LoadFromFile(fname);
  except
  end;
end;

procedure TmForm.lFListHeaderSized(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
var
  counter:integer;
begin
  if iscolumn then
  for counter:=0 to lflist.ColCount-1 do
  begin
    rflist.ColWidths[counter]:=lflist.ColWidths[counter];
    inifile.WriteInteger('main','colwidth'+inttostr(counter),lflist.ColWidths[counter]);
  end;
end;

procedure TmForm.lFListSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin

end;

procedure TmForm.rFListColRowInserted(Sender: TObject; IsColumn: Boolean;
  sIndex, tIndex: Integer);
begin

end;

procedure TmForm.rFListDirChange(Sender: TObject);
begin
  editRightPath.Text:=rflist.Directory;
end;

procedure TmForm.rFListDirectoryChange(Sender: TObject);
begin
  editRightPath.Text:=rflist.Directory;
end;

procedure TmForm.rFListEnter(Sender: TObject);
begin
  LeftPanelFocused:=false;
end;

procedure TmForm.rFListFileSelect(Sender: TObject; fName: string);
begin
  if LeftImgTab.Visible then
  try
    llimg.Picture.LoadFromFile(fname);
  except
  end;
end;

procedure TmForm.rFListHeaderSized(Sender: TObject; IsColumn: Boolean;
  Index: Integer);
var
  counter:integer;
begin
  if iscolumn then
  for counter:=0 to rflist.ColCount-1 do
  begin
    lflist.ColWidths[counter]:=rflist.ColWidths[counter];
    inifile.WriteInteger('main','colwidth'+inttostr(counter),rflist.ColWidths[counter]);
  end;
end;


procedure TmForm.ActionExitExecute(Sender: TObject);
begin
  close;
end;

procedure TmForm.ActionMovExecute(Sender: TObject);
begin
  doMove;
end;

procedure TmForm.ActionNewFoldExecute(Sender: TObject);
var tmp,newdir:string;
begin
  if lflist.Focused
  then tmp:=includetrailingpathdelimiter(lflist.Directory)
  else tmp:=includetrailingpathdelimiter(rflist.Directory);

  if dlgform.getDlg(lngNewDir,lngNewDirprompt,'',lngBtnYes,lngBtnNo, newdir)
  then if not directoryexists(tmp+newdir) then createdir(tmp+newdir);
end;

procedure TmForm.ActionEditExecute(Sender: TObject);
var tmp:tstringlist;
    path:string;
begin
  path:=extractfilepath(paramstr(0))+'tools\npp\notepad++.exe';
  tmp:=tstringlist.Create;
  if leftpanelfocused
  then lflist.getSelectedItems(tmp,true)
  else rflist.getSelectedItems(tmp,true);
  lflist.runApp(path,tmp);
  freeandnil(tmp);
end;

procedure TmForm.ActionCopyExecute(Sender: TObject);
begin
  //fileOperations(FO_COPY,LeftPanelFocused);
  doCopy;
end;

procedure TmForm.ActionDel2Execute(Sender: TObject);
begin
  doDeleteToBin;
end;

procedure TmForm.ActionDelExecute(Sender: TObject);
begin
  doDeleteToBin;
end;

procedure TmForm.ActionRenameExecute(Sender: TObject);
var
 tmp:string;
 pTmp:TFilelistGrid;
begin
  if lflist.Focused then ptmp:=lflist else ptmp:=rflist;

  if dlgform.getDlg(lngRenameItem,lngRenameItemPrompt,ptmp.SelectedItem,lngBtnYes,lngBtnNo, tmp)
  then
    if
     (
     ((directoryexists(itbs(ptmp.Directory)+ptmp.SelectedItem)) and not (directoryexists(itbs(ptmp.Directory)+tmp)))
     or
     ((fileexists(itbs(ptmp.Directory)+ptmp.SelectedItem)) and not (fileexists(itbs(ptmp.Directory)+tmp)))
     )
    then
      try
        renamefile(itbs(ptmp.Directory)+ptmp.SelectedItem,itbs(ptmp.Directory)+tmp);
      except
        on E: Exception do ShowMessage('Error: '+ E.Message );
      end;
end;

procedure TmForm.ActionShowSetupExecute(Sender: TObject);
begin
  setupform.Show;
end;

procedure TmForm.ActionViewExecute(Sender: TObject);
var tmp:tstringlist;
    path:string;
begin
  path:=extractfilepath(paramstr(0))+'tools\npp\notepad++.exe';
  tmp:=tstringlist.Create;
  if leftpanelfocused
  then lflist.getSelectedItems(tmp, true)
  else rflist.getSelectedItems(tmp, true);
  lflist.runApp(path,tmp);
  freeandnil(tmp);
end;

procedure TmForm.CoolBar1Change(Sender: TObject);
begin

end;

procedure TmForm.EditLeftPathClick(Sender: TObject);
var
  oldpos,counter:integer;
  tmp:string;
begin
  oldpos:=EditLeftPath.CaretPos.X;
  EditLeftPath.SelStart:=0;
  EditLeftPath.SelLength:=oldpos;
  tmp:=EditLeftPath.SelText;
  for counter:=oldpos+1 to length(EditLeftPath.Text) do
  if EditLeftPath.text[counter]<>'\' then tmp:=tmp+EditLeftPath.Text[counter] else break;
  EditLeftPath.SelLength:=0;
  if tmp<>EditLeftPath.text then lflist.setDirectory(tmp);
  if lflist.CanFocus then lflist.setFocus;
end;

procedure TmForm.EditRightPathClick(Sender: TObject);
var
  oldpos,counter:integer;
  tmp:string;
begin
  oldpos:=EditRightPath.CaretPos.X;
  EditRightPath.SelStart:=0;
  EditRightPath.SelLength:=oldpos;
  tmp:=EditRightPath.SelText;
  for counter:=oldpos+1 to length(EditRightPath.Text) do
  if EditRightPath.text[counter]<>'\' then tmp:=tmp+EditRightPath.Text[counter] else break;
  EditRightPath.SelLength:=0;
  if tmp<>EditRightPath.text then rflist.setDirectory(tmp);
  if rflist.CanFocus then rflist.setFocus;
end;

procedure TmForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  fin;
end;

end.

