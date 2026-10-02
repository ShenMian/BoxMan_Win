unit VclFileCtrl;
{ Compatibility shim: LCL dropped Delphi's TDirectoryListBox and TDriveComboBox
  (the current LCL filectrl unit only provides TFileListBox / TFilterComboBox).
  This unit re-implements the two missing controls on top of LCL list/combo
  boxes, with the members used by OpenFile.pas. }

{$mode delphi}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, FileCtrl, Windows;

type
  TDirectoryListBox = class(TListBox)
  private
    FDirectory: string;
    FFileList: TFileListBox;
    FOnChange: TNotifyEvent;
    FUpdating: Boolean;
    procedure SetFileList(const AValue: TFileListBox);
    procedure SetDirectory(const AValue: string);
    procedure Populate;
  protected
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure Update;
  published
    property Directory: string read FDirectory write SetDirectory;
    property FileList: TFileListBox read FFileList write SetFileList;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property Align;
    property ItemHeight;
    property TabOrder;
    property TabStop;
  end;

  TDriveComboBox = class(TComboBox)
  private
    FDrive: Char;
    FDirList: TDirectoryListBox;
    procedure SetDrive(const AValue: Char);
    procedure SetDirList(const AValue: TDirectoryListBox);
    procedure Populate;
  protected
    procedure Change; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Drive: Char read FDrive write SetDrive;
    property DirList: TDirectoryListBox read FDirList write SetDirList;
    property Align;
    property TabOrder;
    property TabStop;
  end;

implementation

{ TDirectoryListBox }

constructor TDirectoryListBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDirectory := '';
end;

procedure TDirectoryListBox.Populate;
var
  SR: TSearchRec;
  path: string;
begin
  Items.BeginUpdate;
  try
    Items.Clear;
    if FDirectory = '' then
      Exit;
    path := IncludeTrailingPathDelimiter(FDirectory);
    Items.Add('..');
    if SysUtils.FindFirst(path + '*', faDirectory, SR) = 0 then
    begin
      repeat
        if (SR.Attr and faDirectory <> 0) and (SR.Name <> '.') and
           (SR.Name <> '..') then
          Items.Add(SR.Name);
      until SysUtils.FindNext(SR) <> 0;
      SysUtils.FindClose(SR);
    end;
  finally
    Items.EndUpdate;
  end;
  ItemIndex := -1;
end;

procedure TDirectoryListBox.SetDirectory(const AValue: string);
begin
  if FDirectory = AValue then
    Exit;
  FDirectory := AValue;
  if Assigned(FFileList) then
    FFileList.Directory := FDirectory;
  Populate;
end;

procedure TDirectoryListBox.SetFileList(const AValue: TFileListBox);
begin
  FFileList := AValue;
  if Assigned(FFileList) and (FDirectory <> '') then
    FFileList.Directory := FDirectory;
end;

procedure TDirectoryListBox.Update;
begin
  Populate;
end;

procedure TDirectoryListBox.Click;
var
  sel: string;
begin
  inherited Click;
  if FUpdating then
    Exit;
  if (ItemIndex < 0) or (ItemIndex >= Items.Count) then
    Exit;
  sel := Items[ItemIndex];
  FUpdating := True;
  try
    if sel = '..' then
      SetDirectory(ExcludeTrailingPathDelimiter(FDirectory) + '\..')
    else
      SetDirectory(IncludeTrailingPathDelimiter(FDirectory) + sel);
  finally
    FUpdating := False;
  end;
  if Assigned(FOnChange) then
    FOnChange(Self);
end;

{ TDriveComboBox }

constructor TDriveComboBox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDrive := 'C';
  Populate;
end;

procedure TDriveComboBox.Populate;
var
  c: Char;
  root: string;
  dt: UINT;
begin
  Items.BeginUpdate;
  try
    Items.Clear;
    for c := 'A' to 'Z' do
    begin
      root := c + ':\';
      dt := GetDriveType(PChar(root));
      if (dt = DRIVE_REMOVABLE) or (dt = DRIVE_FIXED) or
         (dt = DRIVE_REMOTE) or (dt = DRIVE_CDROM) then
        Items.Add(root);
    end;
  finally
    Items.EndUpdate;
  end;
  if Items.Count > 0 then
    ItemIndex := 0;
end;

procedure TDriveComboBox.SetDirList(const AValue: TDirectoryListBox);
begin
  FDirList := AValue;
  if Assigned(FDirList) then
    FDirList.Directory := FDrive + ':\';
end;

procedure TDriveComboBox.SetDrive(const AValue: Char);
begin
  FDrive := UpCase(AValue);
  if Assigned(FDirList) then
    FDirList.Directory := FDrive + ':\';
end;

procedure TDriveComboBox.Change;
begin
  inherited Change;
  if ItemIndex >= 0 then
    SetDrive(Items[ItemIndex][1]);
end;

initialization
  Classes.RegisterClass(TDirectoryListBox);
  Classes.RegisterClass(TDriveComboBox);

end.
