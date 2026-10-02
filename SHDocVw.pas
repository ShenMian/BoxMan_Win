unit SHDocVw;
{ Compatibility shim for Delphi's SHDocVw/TWebBrowser (IE ActiveX control).

  NOTE: This is a compile-time stub. It provides the members the project uses
  (Navigate/GoBack/GoForward/Refresh/LocationURL + events) and renders a plain
  placeholder surface. It does NOT embed Internet Explorer, so the "solution
  list" web page will not be displayed. Replacing this with a real IE host
  (e.g. via the LazActiveX package's TActiveXContainer) is a follow-up task. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, Controls, Graphics, Windows, ActiveX;

type
  TWebBrowserStatusTextChange = procedure(Sender: TObject;
    const Text: WideString) of object;
  TWebBrowserNewWindow2 = procedure(Sender: TObject; var ppDisp: IDispatch;
    var Cancel: WordBool) of object;

  TWebBrowser = class(TCustomControl)
  private
    FLocationURL: string;
    FOnStatusTextChange: TWebBrowserStatusTextChange;
    FOnNewWindow2: TWebBrowserNewWindow2;
    procedure SetLocationURL(const AValue: string);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Navigate(const URL: string);
    procedure GoBack;
    procedure GoForward;
    property LocationURL: string read FLocationURL write SetLocationURL;
  published
    property OnStatusTextChange: TWebBrowserStatusTextChange
      read FOnStatusTextChange write FOnStatusTextChange;
    property OnNewWindow2: TWebBrowserNewWindow2
      read FOnNewWindow2 write FOnNewWindow2;
    property Align;
    property TabOrder;
    property TabStop;
    property Visible;
  end;

implementation

constructor TWebBrowser.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FLocationURL := '';
end;

procedure TWebBrowser.SetLocationURL(const AValue: string);
begin
  FLocationURL := AValue;
end;

procedure TWebBrowser.Paint;
begin
  Canvas.Brush.Color := clWhite;
  Canvas.FillRect(ClientRect);
  Canvas.Brush.Style := bsClear;
  Canvas.Font.Color := clGray;
  Canvas.TextOut(8, 8, 'WebBrowser (Lazarus stub) - no IE control embedded');
end;

procedure TWebBrowser.Navigate(const URL: string);
begin
  FLocationURL := URL;
  if Assigned(FOnStatusTextChange) then
    FOnStatusTextChange(Self, WideString(URL));
  Invalidate;
end;

procedure TWebBrowser.GoBack;
begin
  { no history in the stub }
end;

procedure TWebBrowser.GoForward;
begin
  { no history in the stub }
end;

initialization
  Classes.RegisterClass(TWebBrowser);

end.
