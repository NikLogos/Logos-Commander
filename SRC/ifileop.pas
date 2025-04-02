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

unit IFileOp;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,Windows, ActiveX, ComObj;

type
  // Объявляем интерфейс IShellItem
  IShellItem = interface(IUnknown)
    ['{43826D1E-E718-42EE-BC55-A1E261C37BFE}']
    function BindToHandler(const pbc: IBindCtx; const bhid: TGUID; const riid: TIID;
                          out ppvOut): HRESULT; stdcall;
    function GetParent(out ppsi: IShellItem): HRESULT; stdcall;
    function GetDisplayName(sigdnName: DWORD; out ppszName: LPWSTR): HRESULT; stdcall;
    function GetAttributes(sfgaoMask: DWORD; out psfgaoAttribs: DWORD): HRESULT; stdcall;
    function Compare(const psi: IShellItem; hint: DWORD; out piOrder: Integer): HRESULT; stdcall;
  end;

  // Объявляем интерфейс IFileOperation
  IFileOperation = interface(IUnknown)
    ['{947AAB5F-0A5C-4C13-B4D6-4BF7836FC9F8}']
    function Advise(const pfops: IUnknown; out pdwCookie: DWORD): HRESULT; stdcall;
    function Unadvise(dwCookie: DWORD): HRESULT; stdcall;
    function SetOperationFlags(dwOperationFlags: DWORD): HRESULT; stdcall;
    function SetProgressMessage(pszMessage: LPCWSTR): HRESULT; stdcall;
    function SetProgressDialog(const popd: IUnknown): HRESULT; stdcall;
    function SetProperties(const pproparray: IUnknown): HRESULT; stdcall;
    function SetOwnerWindow(hwndOwner: HWND): HRESULT; stdcall;
    function ApplyPropertiesToItem(const psiItem: IShellItem): HRESULT; stdcall;
    function ApplyPropertiesToItems(const punkItems: IUnknown): HRESULT; stdcall;
    function RenameItem(const psiItem: IShellItem; pszNewName: LPCWSTR;
                       const pfopsItem: IUnknown): HRESULT; stdcall;
    function RenameItems(const pUnkItems: IUnknown; pszNewName: LPCWSTR): HRESULT; stdcall;
    function MoveItem(const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
                     pszNewName: LPCWSTR; const pfopsItem: IUnknown): HRESULT; stdcall;
    function MoveItems(const punkItems: IUnknown; const psiDestinationFolder: IShellItem): HRESULT; stdcall;
    function CopyItem(const psiItem: IShellItem; const psiDestinationFolder: IShellItem;
                     pszNewName: LPCWSTR; const pfopsItem: IUnknown): HRESULT; stdcall;
    function CopyItems(const punkItems: IUnknown; const psiDestinationFolder: IShellItem): HRESULT; stdcall;
    function DeleteItem(const psiItem: IShellItem; const pfopsItem: IUnknown): HRESULT; stdcall;
    function DeleteItems(const punkItems: IUnknown): HRESULT; stdcall;
    function NewItem(const psiDestinationFolder: IShellItem; dwFileAttributes: DWORD;
                    pszName: LPCWSTR; pszTemplateName: LPCWSTR;
                    const pfopsItem: IUnknown): HRESULT; stdcall;
    function PerformOperations: HRESULT; stdcall;
    function GetAnyOperationsAborted(out pfAnyOperationsAborted: BOOL): HRESULT; stdcall;
  end;

const
  // Идентификаторы интерфейсов и классов
  IID_IShellItem: TGUID = '{43826D1E-E718-42EE-BC55-A1E261C37BFE}';
  CLSID_FileOperation: TGUID = '{3AD05575-8857-4850-9277-11B85BDB8E09}';
  IID_IFileOperation: TGUID = '{947AAB5F-0A5C-4C13-B4D6-4BF7836FC9F8}';

  // Флаги для операций с файлами
  FOF_ALLOWUNDO = $40;
  FOF_NOCONFIRMATION = $10;
  FOF_NOERRORUI = $400;
  FOF_SILENT = $4;


  function DeleteToRecycleBin(const FilePath: string): Boolean;
  function MoveFileOrFolder(const SourcePath, DestPath: string; NewName: string = ''): Boolean;

implementation


type
  TSHCreateItemFromParsingName = function(pszPath: LPCWSTR; pbc: IBindCtx;
                                        const riid: TIID; out ppv: Pointer): HRESULT; stdcall;

var
  _SHCreateItemFromParsingName: TSHCreateItemFromParsingName = nil;

function SHCreateItemFromParsingName(pszPath: LPCWSTR; pbc: IBindCtx;
                                   const riid: TIID; out ppv: Pointer): HRESULT;
var
  Shell32Handle: THandle;
begin
  if not Assigned(_SHCreateItemFromParsingName) then
  begin
    Shell32Handle := LoadLibrary('shell32.dll');
    if Shell32Handle <> 0 then
      Pointer(_SHCreateItemFromParsingName) :=
        GetProcAddress(Shell32Handle, 'SHCreateItemFromParsingName');
  end;

  if Assigned(_SHCreateItemFromParsingName) then
    Result := _SHCreateItemFromParsingName(pszPath, pbc, riid, ppv)
  else
    Result := E_NOTIMPL;
end;

function DeleteToRecycleBin(const FilePath: string): Boolean;
var
  FileOp: IFileOperation;
  ShellItem: IShellItem;
  pShellItem: Pointer;
  FilePathW: WideString;
begin
  Result := False;
  FilePathW := UTF8Decode(FilePath);

  // Инициализация COM
  OleInitialize(nil);
  try
    // Создаем объект FileOperation
    if SUCCEEDED(CoCreateInstance(CLSID_FileOperation, nil, CLSCTX_ALL,
                  IID_IFileOperation, FileOp)) then
    begin
      // Устанавливаем параметры операции
      FileOp.SetOperationFlags(FOF_ALLOWUNDO or FOF_NOCONFIRMATION or
                              FOF_NOERRORUI or FOF_SILENT);

      // Создаем ShellItem для файла через указатель
      if SUCCEEDED(SHCreateItemFromParsingName(PWideChar(FilePathW),
                                              nil, IID_IShellItem, pShellItem)) then
      begin
        ShellItem := IShellItem(pShellItem);
        // Добавляем файл в очередь на удаление
        if SUCCEEDED(FileOp.DeleteItem(ShellItem, nil)) then
        begin
          // Выполняем операцию
          Result := SUCCEEDED(FileOp.PerformOperations);
        end;
      end;
    end;
  finally
    OleUninitialize;
  end;
end;

function MoveFileOrFolder(const SourcePath, DestPath: string; NewName: string
  ): Boolean;
var
  FileOp: IFileOperation;
  SourceItem, DestFolder: IShellItem;
  pSourceItem, pDestFolder: Pointer;
  SourcePathW, DestPathW, NewNameW: WideString;
begin
  Result := False;
  SourcePathW := UTF8Decode(SourcePath);
  DestPathW := UTF8Decode(DestPath);
  if NewName <> '' then
    NewNameW := UTF8Decode(NewName)
  else
    NewNameW := '';

  OleInitialize(nil);
  try
    if SUCCEEDED(CoCreateInstance(CLSID_FileOperation, nil, CLSCTX_ALL,
                  IID_IFileOperation, FileOp)) then
    begin
      // Устанавливаем флаги операции
      FileOp.SetOperationFlags(FOF_ALLOWUNDO or FOF_NOCONFIRMATION or
                              FOF_NOERRORUI or FOF_SILENT);

      // Создаем ShellItem для исходного файла/папки
      if SUCCEEDED(SHCreateItemFromParsingName(PWideChar(SourcePathW),
                                              nil, IID_IShellItem, pSourceItem)) then
      begin
        SourceItem := IShellItem(pSourceItem);

        // Создаем ShellItem для папки назначения
        if SUCCEEDED(SHCreateItemFromParsingName(PWideChar(DestPathW),
                                                nil, IID_IShellItem, pDestFolder)) then
        begin
          DestFolder := IShellItem(pDestFolder);

          // Выполняем перемещение
          if NewNameW = '' then
            Result := SUCCEEDED(FileOp.MoveItem(SourceItem, DestFolder, nil, nil))
          else
            Result := SUCCEEDED(FileOp.MoveItem(SourceItem, DestFolder, PWideChar(NewNameW), nil));

          if Result then
            Result := SUCCEEDED(FileOp.PerformOperations);
        end;
      end;
    end;
  finally
    OleUninitialize;
  end;
end;

end.

