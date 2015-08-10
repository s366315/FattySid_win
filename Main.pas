unit Main;

interface

uses
  Winapi.Windows, Vcl.Forms, System.Win.ScktComp, Vcl.StdCtrls, WinSock,
  Vcl.ExtCtrls, System.Classes, Vcl.Controls, Registry;

type
  TForm1 = class(TForm)
    ServerSocket1: TServerSocket;
    lbInetAddress: TLabel;
    Label1: TLabel;
    CheckBox1: TCheckBox;

    procedure FormCreate(sender: TObject);
    function GetLocalIP: String;
    procedure FormCloseQuery(sender: TObject; var CanClose: Boolean);
    procedure ServerSocket1ClientRead(sender: TObject;
      Socket: TCustomWinSocket);
    procedure TrayIcon1Click(sender: TObject);
    procedure Button1Click(sender: TObject);
    function CheckSubStr(SubStr, MainStr: string): Boolean;
    procedure Autorun(Flag: Boolean; NameParam, Path: String);
    procedure CheckBox1Click(sender: TObject);

  private

  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  APPCOMMAND_VOLUME_MUTE: Integer = Integer(DWORD($80000));
  APPCOMMAND_VOLUME_UP: Integer = Integer(DWORD($A0000));
  APPCOMMAND_VOLUME_DOWN: Integer = Integer(DWORD($90000));
  WM_APPCOMMAND: Integer = Integer(DWORD($319));
  hW: HWND;
  Reg: TRegistry;

implementation

procedure SendMessageW(HWND: Integer; Msg: Integer; wParm: Integer;
  lParam: Integer); stdcall; external 'User32.dll';

{$R *.dfm}

procedure TForm1.CheckBox1Click(sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Autorun(true, 'FattySid', Application.ExeName);
  end
  else
  begin
    Autorun(false, 'FattySid', Application.ExeName);
  end;
end;

function TForm1.CheckSubStr(SubStr, MainStr: string): Boolean;
begin
  Result := false;
  if (Pos(SubStr, MainStr) = 0) = false then
    Result := true;
end;

procedure TForm1.Autorun(Flag: Boolean; NameParam, Path: String);
begin
  if Flag then
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.WriteString(NameParam, Path);
    Reg.Free;
  end
  else
  begin
    Reg := TRegistry.Create;
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
    Reg.DeleteValue(NameParam);
    Reg.Free;
  end;
end;

procedure TForm1.Button1Click(sender: TObject);
begin
  SendMessageW(Form1.ActiveControl.Handle, WM_APPCOMMAND,
    Form1.ActiveControl.Handle, APPCOMMAND_VOLUME_MUTE);
end;

procedure TForm1.FormCloseQuery(sender: TObject; var CanClose: Boolean);
begin
  ServerSocket1.Active := false;
end;

procedure TForm1.FormCreate(sender: TObject);
begin
  hW := Form1.Handle;
  ServerSocket1.Active := true;
  lbInetAddress.Caption := 'IP: ' + GetLocalIP;

  Reg := TRegistry.Create;
  Reg.RootKey := HKEY_CURRENT_USER;
  Reg.OpenKey('\SOFTWARE\Microsoft\Windows\CurrentVersion\Run', false);
  if Reg.ValueExists('FattySid') then
  begin
    CheckBox1.Checked := true;
  end;
end;

function TForm1.GetLocalIP: String;
const
  WSVer = $101;
var
  wsaData: TWSAData;
  P: PHostEnt;
  Buf: array [0 .. 127] of Char;
begin
  Result := '';
  if WSAStartup(WSVer, wsaData) = 0 then
  begin
    if GetHostName(@Buf, 128) = 0 then
    begin
      P := GetHostByName(@Buf);
      if P <> nil then
        Result := iNet_ntoa(PInAddr(P^.h_addr_list^)^);
    end;
    WSACleanup;
  end;
end;

procedure TForm1.ServerSocket1ClientRead(sender: TObject;
  Socket: TCustomWinSocket);
var
  s: String;
  i: Integer;
begin
  i := 0;
  s := ServerSocket1.Socket.Connections[0].ReceiveText;
  if (s = 'pause') then
  begin
    keybd_event(VK_SPACE, 0, KEYEVENTF_EXTENDEDKEY, 0);
    keybd_event(VK_SPACE, 0, KEYEVENTF_KEYUP, 0);
  end
  else if (CheckSubStr(s, 'mute')) then
  begin
    SendMessageW(hW, WM_APPCOMMAND, hW, APPCOMMAND_VOLUME_MUTE);
  end
  else if (CheckSubStr(s, 'up')) then
  begin
    while i < 5 do
    begin
      SendMessageW(hW, WM_APPCOMMAND, hW, APPCOMMAND_VOLUME_UP);
      i := i + 1;
    end;
  end
  else if (CheckSubStr(s, 'down')) then
  begin
    while i < 5 do
    begin
      SendMessageW(hW, WM_APPCOMMAND, hW, APPCOMMAND_VOLUME_DOWN);
      i := i + 1;
    end;
  end;
  Label1.Caption := s;
end;

end.
