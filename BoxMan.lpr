program BoxMan;

{ Lazarus/Free Pascal port of the original Delphi 7 project.
  Converted from BoxMan.dpr. }

{$mode delphi}{$H+}

uses
  Interfaces,
  Forms,
  Dialogs,
  SysUtils,
  Registry,
  Windows,
  LoadSkin in 'LoadSkin.pas' {LoadSkinForm},
  MainForm in 'MainForm.pas' {main},
  PathFinder in 'PathFinder.pas',
  LoadMapUnit in 'LoadMapUnit.pas',
  LogFile in 'LogFile.pas',
  LurdAction in 'LurdAction.pas',
  Actions in 'Actions.pas' {ActionForm},
  BrowseLevels in 'BrowseLevels.pas' {BrowseForm},
  inf in 'inf.pas' {InfForm},
  Submit in 'Submit.pas' {MySubmit},
  ShowSolutionList in 'ShowSolutionList.pas' {ShowSolutuionList},
  OpenFile in 'OpenFile.pas' {MyOpenFile},
  Board in 'Board.pas',
  MyMessage in 'MyMessage.pas' {Msg};

{$R *.res}

// 避免关闭程序出现“runtime error 216 at xxxxxxx"的错误提示
procedure Halt0;
begin
  Halt;
end;

begin
  if not AppHasRun(Application.Handle) then
  begin
    Application.Initialize;
    Application.CreateForm(Tmain, main);
    Application.CreateForm(TActionForm, ActionForm);
    Application.CreateForm(TInfForm, InfForm);
    Application.CreateForm(TMySubmit, MySubmit);
    Application.CreateForm(TShowSolutuionList, ShowSolutuionList);
    Application.CreateForm(TMyOpenFile, MyOpenFile);
    Application.CreateForm(TMsg, Msg);
  end;

  Application.Run;

  { The original Delphi .dpr installed a Win32 SEH handler here to suppress
    "runtime error 216". That hack is Delphi-specific and unnecessary under
    FPC, so it is intentionally omitted. }
  Halt0;
end.
