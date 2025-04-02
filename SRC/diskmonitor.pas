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

unit DiskMonitor;

{$mode objfpc}{$H+}

interface

uses
  Classes, Windows, Messages, LCLIntf, sysutils;

type
  TDeviceChangeEvent = procedure(EventType: Word; Drive: string) of object;

  { TDeviceMonitor }

  TDeviceMonitor = class(TComponent)
  private
    FHandle: HWND;
    FOnChange: TDeviceChangeEvent;
    procedure WndProc(var Msg: TMessage);
    procedure AllocHandle(Method: TWndMethod);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property OnChange: TDeviceChangeEvent read FOnChange write FOnChange;
  end;

implementation

{ TDeviceMonitor }

procedure CallbackAllocateHWnd(Ahwnd: HWND; uMsg: UINT; wParam: WParam; lParam: LParam); stdcall;
var
  Msg: TMessage;
  PMethod: ^TWndMethod;
begin
  FillChar(Msg, SizeOf(Msg), #0);
  Msg.msg := uMsg;
  Msg.wParam := wParam;
  Msg.lParam := lParam;
  PMethod := Pointer(GetWindowLong(ahwnd, GWL_USERDATA));
  if Assigned(PMethod) then PMethod^(Msg);
  Windows.DefWindowProc(ahwnd, uMsg, wParam, lParam);
end;

procedure TDeviceMonitor.WndProc(var Msg: TMessage);
var
  DevBroadcastHdr: PDevBroadcastHdr;
  DevBroadcastVolume: PDevBroadcastVolume; // Добавлено
  Drive: string;
begin
  if Msg.Msg = WM_DEVICECHANGE then
  begin
    DevBroadcastHdr := PDevBroadcastHdr(Msg.LParam);
    if DevBroadcastHdr <> nil then
    begin
      if DevBroadcastHdr^.dbch_devicetype = $00000002 then
      begin
        DevBroadcastVolume := PDevBroadcastVolume(Msg.LParam); // Исправлено
        Drive := Chr(DevBroadcastVolume^.dbcv_unitmask + Ord('A') - 1) + ':\'; // Исправлено
        if Msg.WParam = $8000 then
        begin
          if Assigned(FOnChange) then
            FOnChange($8000, Drive);
        end
        else if Msg.WParam = $8004 then
        begin
          if Assigned(FOnChange) then
            FOnChange($8004, Drive);
        end;
      end;
    end;
  end;
end;

procedure TDeviceMonitor.AllocHandle(Method: TWndMethod);
var
  PMethod: ^TWndMethod;
begin
  FHandle := Windows.CreateWindow(PChar('STATIC'), '', WS_OVERLAPPED, 0, 0, 0, 0, 0, 0, MainInstance, nil);
  if Assigned(Method) then
  begin
    GetMem(PMethod, SizeOf(TMethod));
    PMethod^ := Method;
    SetWindowLong(FHandle, GWL_USERDATA, PtrInt(PMethod));
  end;
  Windows.SetWindowLongPtrW(FHandle, GWL_WNDPROC, PtrInt(@CallbackAllocateHWnd));
end;

constructor TDeviceMonitor.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  AllocHandle(@WndProc);
end;

destructor TDeviceMonitor.Destroy;
var
  PMethod: ^TWndMethod;
begin
  if FHandle <> 0 then
  begin
    // Получаем указатель на сохранённый метод
    PMethod := Pointer(GetWindowLong(FHandle, GWL_USERDATA));

    // Уничтожаем окно
    Windows.DestroyWindow(FHandle);
    FHandle := 0;

    // Освобождаем память, если она была выделена
    if Assigned(PMethod) then
      FreeMem(PMethod);
  end;
  inherited Destroy;
end;

end.
