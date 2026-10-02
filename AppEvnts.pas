unit AppEvnts;
{ Compatibility shim: maps Delphi's AppEvnts/TApplicationEvents onto the
  LCL's TApplicationProperties (which lives in the Forms unit).
  Keeps the original MainForm.pas and MainForm.dfm unchanged. }

{$mode delphi}{$H+}

interface

uses
  Classes, Forms;

type
  TApplicationEvents = class(TApplicationProperties)
  end;

implementation

initialization
  RegisterClass(TApplicationEvents);

end.
