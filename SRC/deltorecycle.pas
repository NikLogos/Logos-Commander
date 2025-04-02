unit DelToRecycle;

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

end.

