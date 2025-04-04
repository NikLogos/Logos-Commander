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

unit copyForm;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, copyThread;

const
   LngCopyFin:string = 'Копирование завершено';
   LngErrorCreateDirCaption = 'Ошибка';
   LngErrorCreateDir = 'Не удалось создать папку';
   LngFileExistCaption = 'Файл уже существует';
   LngFileExistQuestion = 'Перезаписать?';
   LngFileExistY = 'Да';
   LngFileExistN = 'Нет';
   LngFileExistYALL = 'Да для всех';
   LngFileExistNALL = 'Нет для всех';
   LngFormCaption = 'Копирование >>';
   LngCopyLeftOf = 'В очереди файлов:';

type

  { TcopyF }

  TcopyF = class(TForm)
    Label1: TLabel;
    LogList: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    copyProgressBar: TProgressBar;
    CpyTimer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure CpyTimerTimer(Sender: TObject);
  private
     srclist,destlist:tstringlist;
     qsrc:tstringlist; //for scan subdirs
     nowCopy, YesToAll, NoToAll, No, Yes:boolean;
     copyThread:TFileCopyThread;

     procedure ScanDir(const Dir: string; FileList: TStringList);
     procedure copyDone(sender:tobject);

  public
     procedure addToCopyQueue(srcPath,destPath:string; addList:TstringList);
     procedure addToCopyQueue(srcPath,destPath:string; addList:TstringList; DestFile:string);
     procedure startCopy;
     function getNowCopy:boolean;
  end;

var
  copyF: TcopyF;

implementation

{$R *.lfm}

{ TcopyF }

procedure TcopyF.FormCreate(Sender: TObject);
begin
  Self.ShowInTaskBar := stAlways;
  srclist:=tstringlist.create;
  destlist:=tstringlist.create;
  qsrc:=tstringlist.create;
  nowCopy:=false;
  YesToAll:=false;
  NoToAll:=false;
  No:=false;
  Yes:=false;
end;

procedure TcopyF.FormDestroy(Sender: TObject);
begin
  qsrc.Free;
  destlist.free;
  srclist.free;
end;

procedure TcopyF.CpyTimerTimer(Sender: TObject);
var
  tmp:string;
  Attr: Integer;
  CreationTime, LastWriteTime: TDateTime;
begin
   tmp:='';
   if ((srcList.Count = 0)and(not nowCopy)) then begin
     logList.Items.Add(LngCopyFin);
     CpyTimer.Enabled:=false;
     YesToAll:=false;
     NoToAll:=false;
     No:=false;
     Yes:=false;
     copyf.Caption:=LngFormCaption;
     close;
   end else begin
     while srcList.Count<>0 do begin

       //папки
       if not nowCopy then begin
         copyf.Caption:=LngFormCaption+' '+LngCopyLeftOf+' '+inttostr(srclist.Count);
         if (FileGetAttr(srcList.Strings[0]) and faDirectory)<>0
         then begin
            if not forcedirectories(destList.Strings[0])
            then MessageDlg(LngErrorCreateDirCaption, LngErrorCreateDir, mtError, [mbOk], 0)
            else begin
              // Копируем атрибуты (скрытый, системный, только чтение и т. д.)
              Attr := FileGetAttr(srcList.Strings[0]);
              FileSetAttr(destList.Strings[0], Attr);

              // Копируем даты создания и изменения
              if FileAge(srcList.Strings[0], CreationTime) then FileSetDate(srcList.Strings[0], DateTimeToFileDate(CreationTime));
              if FileAge(srcList.Strings[0], LastWriteTime) then FileSetDate(srcList.Strings[0], DateTimeToFileDate(LastWriteTime));

            end;
            nowCopy:=false;

            srcList.Delete(0);
            destList.Delete(0);

         end else begin
            //файлы
            if ForceDirectories(extractfilepath(destList.Strings[0]))
            then begin
              if fileexists(destList.Strings[0]) then begin
                cpyTimer.Enabled:=false;
                if ((not yestoall) and (not notoall)) then
                case QuestionDlg(LngFileExistCaption,extractfilename(destList.Strings[0])+' - '+LngFileExistQuestion, mtWarning, [mrYes,LngFileExistY,mrNo,'IsDefault',LngFileExistN, mrYesToAll, LngFileExistYALL, mrNoToAll, LngFileExistNALL],0)  of
                  mrYes:Yes:=true;
                  mrYesToAll:yestoall:=true;
                  mrNo:no:=true;
                  mrNoToAll:notoall:=true;
                end;
                cpyTimer.Enabled:=true;
                if yes or yestoall then begin
                  nowCopy:=true;
                  copyThread:=TFileCopyThread.create(srcList.Strings[0],destList.Strings[0],copyProgressBar,label1);
                  copyThread.OnCopyDone:=@copyDone;
                end;
                Yes:=false;
                No:=false;
              end else begin
                nowCopy:=true;
                copyThread:=TFileCopyThread.create(srcList.Strings[0],destList.Strings[0],copyProgressBar,label1);
                copyThread.OnCopyDone:=@copyDone;
              end;

              srcList.Delete(0);
              destList.Delete(0);
            end
            else MessageDlg(LngErrorCreateDirCaption, LngErrorCreateDir, mtError, [mbOk], 0);
         end;

         if srcList.Count<>0
         then
           begin
              tmp:=srcList.Strings[0];
              if tmp.IndexOf(logList.Items.Strings[0]) = -1 then logList.Items.Delete(0)
           end else logList.Items.clear;

       end;
       //while
       application.ProcessMessages;

     end;
   end;
end;

procedure TcopyF.ScanDir(const Dir: string; FileList: TStringList);
var
  SR: TSearchRec;
  Path: string;
begin
  Path := IncludeTrailingPathDelimiter(Dir);

  // Ищем файлы и папки
  if FindFirst(Path + '*', faAnyFile, SR) = 0 then
  begin
    repeat
      if (SR.Name <> '.') and (SR.Name <> '..') then
      begin
        FileList.Add(Path + SR.Name); // Добавляем в список

        if (SR.Attr and faDirectory) <> 0 then
          ScanDir(Path + SR.Name, FileList);
      end;
    until FindNext(SR) <> 0;
    FindClose(SR);
  end;
end;

procedure TcopyF.copyDone(sender: tobject);
begin
  nowCopy:=false;
end;

procedure TcopyF.addToCopyQueue(srcPath, destPath: string; addList: TstringList
  );
var
  counter:integer;
  tmp:string;
  tmplist:tstringlist;
begin
   if ((logList.Count<>0) and (loglist.Items.Strings[0]=LngCopyFin)) then LogList.Clear;
   qsrc.Clear;
   tmpList:=tstringlist.Create;
   tmp:='';

   for counter:=0 to addList.Count-1 do begin
      tmp:=IncludeTrailingPathDelimiter(srcPath)+addList.Strings[counter];
      if(FileGetAttr(tmp) and faDirectory)<>0
      then
         begin
           tmpList.Clear;
           qsrc.Add(tmp);
           scanDir(IncludeTrailingPathDelimiter(tmp),tmplist);
           qsrc.AddStrings(tmplist);
         end
      else qsrc.Add(tmp);
      logList.Items.Add(tmp);
   end;

   for counter:=0 to qsrc.Count-1 do begin
      tmp:=qsrc.Strings[counter];
      srcList.Add(tmp);
      destList.Add(tmp.Replace(srcPath,destPath));
   end;

   tmpList.Free;
end;

procedure TcopyF.addToCopyQueue(srcPath, destPath: string;
  addList: TstringList; DestFile: string);
begin
  if ((logList.Count<>0) and (loglist.Items.Strings[0]=LngCopyFin)) then LogList.Clear;
  srcList.Add(IncludeTrailingPathDelimiter(srcPath)+addList.Strings[0]);
  destList.Add(IncludeTrailingPathDelimiter(destPath)+destFile);
  logList.Items.Add(IncludeTrailingPathDelimiter(srcPath)+addList.Strings[0]);
end;

procedure TcopyF.startCopy;
begin
  //logList.Clear;
  CpyTimer.Enabled:=true;
  show;
end;

function TcopyF.getNowCopy: boolean;
begin
  result:=((nowcopy) or (srcList.Count<>0));
end;

end.

