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

unit copyThread;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, ComCtrls, Dialogs, stdCtrls;


type

  { TFileCopyThread }

  TFileCopyThread = class(TThread)
  private
    FSourceFile, FDestFile: string;
    FProgressBar: TProgressBar;
    FPercent: Integer;
    Flabel:tlabel;
    FErrorMessage: string;  // Поле для ошибки
    Stime, Ntime:ttime;
    //inProgress:boolean;
    FOnCopyDone: TNotifyEvent;
    procedure UpdateProgress;
    procedure ShowErrorMessage;  // Новый метод для вывода ошибки
    procedure CopyFileAttributes;  // Добавляем метод копирования атрибутов
    procedure copyDone;
  protected
    procedure Execute; override;
  public
    property OnCopyDone: TNotifyEvent read FOnCopyDone write FOnCopyDone;

    constructor Create(const SourceFile, DestFile: string; ProgressBar: TProgressBar; alabel:tlabel
     );
  end;

implementation

{Конструктор потока }
constructor TFileCopyThread.Create(const SourceFile, DestFile: string;
  ProgressBar: TProgressBar; alabel: tlabel);
begin
  inherited Create(False);  // Автоматически запускаем поток
  FreeOnTerminate := True;
  FSourceFile := SourceFile;
  FDestFile := DestFile;
  FProgressBar := ProgressBar;
  Flabel:=alabel;
  //inProgress:=false;
end;

{Обновление прогресса в основном потоке }
procedure TFileCopyThread.UpdateProgress;
begin
  if Assigned(FProgressBar) then FProgressBar.Position := FPercent;
  if Assigned(FLabel) then flabel.Caption:=(extractfilename(FSourceFile)+' : '+timetostr(ntime-stime));
end;

{Вывод ошибки в основном потоке }
procedure TFileCopyThread.ShowErrorMessage;
begin
  ShowMessage(FErrorMessage);  // Выводим сохраненное сообщение
end;

procedure TFileCopyThread.CopyFileAttributes;
var
  Attr: Integer;
  CreationTime, LastWriteTime: TDateTime;
begin
  if FileExists(FSourceFile) and FileExists(FDestFile) then
  begin
    // Копируем атрибуты (скрытый, системный, только чтение и т. д.)
    Attr := FileGetAttr(FSourceFile);
    FileSetAttr(FDestFile, Attr);

    // Копируем даты создания и изменения файла
    if FileAge(FSourceFile, CreationTime) then
      FileSetDate(FDestFile, DateTimeToFileDate(CreationTime));

    if FileAge(FSourceFile, LastWriteTime) then
      FileSetDate(FDestFile, DateTimeToFileDate(LastWriteTime));
  end;
end;

procedure TFileCopyThread.copyDone;
begin
  if Assigned(FOnCopyDone) then FOnCopyDone(Self);
end;

{Основной процесс копирования }
procedure TFileCopyThread.Execute;
const
  BufferSize = 4 * 1024 * 1024;
var
  SourceStream, DestStream: TFileStream;
  Buffer: Pointer;
  BytesRead, TotalBytes, BytesCopied: Int64;
  OldAttr: Integer;
begin
  stime:=now;
  //inProgress:=true;
  try
    SourceStream := TFileStream.Create(FSourceFile, fmOpenRead or fmShareDenyWrite);
    try
      // Если файл-приемник существует, убираем атрибут "только чтение"
      if FileExists(FDestFile) then
      begin
        OldAttr := FileGetAttr(FDestFile);  // Запоминаем старые атрибуты
        if (OldAttr and faReadOnly) <> 0 then
          FileSetAttr(FDestFile, OldAttr and not faReadOnly);  // Убираем ReadOnly
      end;

      // Открываем файл для записи
      if FileExists(FDestFile) then
        DestStream := TFileStream.Create(FDestFile, fmOpenReadWrite or fmShareDenyWrite)
      else
        DestStream := TFileStream.Create(FDestFile, fmCreate);

      try
        DestStream.Size := 0;  // Очищаем файл перед записью

        TotalBytes := SourceStream.Size;
        BytesCopied := 0;

        GetMem(Buffer, BufferSize);
        try
          repeat
            BytesRead := SourceStream.Read(Buffer^, BufferSize);
            if BytesRead > 0 then
            begin
              DestStream.Write(Buffer^, BytesRead);
              Inc(BytesCopied, BytesRead);

              FPercent := Round((BytesCopied / TotalBytes) * 100);
              ntime:=now;
              Synchronize(@UpdateProgress);
            end;
          until BytesRead = 0;
        finally
          FreeMem(Buffer);
        end;
      finally
        DestStream.Free;
      end;
    finally
      SourceStream.Free;
    end;

  // Копируем атрибуты файла в основном потоке (чтобы избежать ошибок)
  Synchronize(@CopyFileAttributes);
  except
    on E: Exception do
    begin
      FErrorMessage := 'Ошибка копирования: ' + E.Message;
      Synchronize(@ShowErrorMessage);  // Вызываем ShowMessage в основном потоке
    end;
  end;
  //inProgress:=false;
  Synchronize(@CopyDone);
end;

end.
