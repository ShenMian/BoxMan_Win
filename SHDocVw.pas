unit SHDocVw;
{ TWebBrowser —— 基于 IE ActiveX 控件的浏览器封装。

  实现方式：以 importtl 从 IE 类型库（ieframe.dll / SHDocVw）生成的
  SHDocVw_1_1_TLB 中的 TAxcWebBrowser（TActiveXContainer 派生类）为基类，
  在其上补齐本工程所用到的成员：Navigate / GoBack / GoForward / Refresh /
  LocationURL。事件（OnStatusTextChange、OnNewWindow2 等）由基类提供。 }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Controls, ActiveX, Variants,
  SHDocVw_1_1_TLB;

type
  TWebBrowser = class(TAxcWebBrowser)
  private
    function GetLocationURL: string;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Loaded; override;
    procedure Navigate(const URL: string);
    procedure GoBack;
    procedure GoForward;
    // 覆盖 TControl.Refresh（非虚方法），改为刷新网页
    procedure Refresh; reintroduce;
    property LocationURL: string read GetLocationURL;
  end;

implementation

constructor TWebBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TWebBrowser.Loaded;
begin
  inherited Loaded;
  // TActiveXContainer 需要通过 Active := True 触发 Attach（嵌入并就地激活 IE 控件），
  // 之后 Navigate 等方法才能正常工作。
  if not Active then
    Active := True;
  // 屏蔽 IE 弹出的对话框（脚本错误、混合内容安全警告等）。
  if Assigned(OleServer) then
    OleServer.Silent := True;
end;

procedure TWebBrowser.Navigate(const URL: string);
var
  Flags, TargetFrameName, PostData, Headers: OleVariant;
begin
  if not Assigned(OleServer) then
    Exit;
  Flags := EmptyParam;
  TargetFrameName := EmptyParam;
  PostData := EmptyParam;
  Headers := EmptyParam;
  OleServer.Navigate(WideString(URL), Flags, TargetFrameName, PostData, Headers);
end;

procedure TWebBrowser.GoBack;
begin
  if Assigned(OleServer) then
    OleServer.GoBack;
end;

procedure TWebBrowser.GoForward;
begin
  if Assigned(OleServer) then
    OleServer.GoForward;
end;

procedure TWebBrowser.Refresh;
begin
  if Assigned(OleServer) then
    OleServer.Refresh;
end;

function TWebBrowser.GetLocationURL: string;
begin
  if Assigned(OleServer) then
    Result := string(OleServer.LocationURL)
  else
    Result := '';
end;

initialization
  Classes.RegisterClass(TWebBrowser);

end.
