unit IdHTTP;
{ Minimal Indy-compatible TIdHTTP shim for Free Pascal / Lazarus.
  Provides only the members used by this project (Get/Post), implemented
  on top of FPC's built-in fphttpclient (fcl-web). }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, fphttpclient;

type
  TIdHTTP = class
  private
    FClient: TFPHTTPClient;
    FAllowRedirect: Boolean;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Get(const AURL: string; AResponseContent: TStream);
    procedure Post(const AURL: string; const ASource: TStrings;
      AResponseContent: TStream);
    property AllowRedirect: Boolean read FAllowRedirect write FAllowRedirect;
  end;

implementation

constructor TIdHTTP.Create(AOwner: TComponent);
begin
  inherited Create;
  FClient := TFPHTTPClient.Create(nil);
  FClient.AllowRedirect := True;
  FAllowRedirect := True;
end;

destructor TIdHTTP.Destroy;
begin
  FClient.Free;
  inherited Destroy;
end;

procedure TIdHTTP.Get(const AURL: string; AResponseContent: TStream);
begin
  FClient.AllowRedirect := FAllowRedirect;
  FClient.Get(AURL, AResponseContent);
end;

procedure TIdHTTP.Post(const AURL: string; const ASource: TStrings;
  AResponseContent: TStream);
begin
  FClient.AllowRedirect := FAllowRedirect;
  { fphttpclient.FormPost sends ASource as application/x-www-form-urlencoded,
    exactly matching Indy's TIdHTTP.Post(URL, TStrings, Stream) behaviour. }
  FClient.FormPost(AURL, ASource, AResponseContent);
end;

end.
