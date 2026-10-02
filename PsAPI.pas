unit PsAPI;
{ Compatibility shim: provides the small slice of the Delphi PsAPI unit that
  this project uses (GetProcessMemoryInfo). FPC does not ship a PsAPI unit. }

{$mode delphi}{$H+}

interface

uses
  Windows;

type
  _PROCESS_MEMORY_COUNTERS = record
    cb: DWORD;
    PageFaultCount: DWORD;
    PeakWorkingSetSize: NativeUInt;
    WorkingSetSize: NativeUInt;
    QuotaPeakPagedPoolUsage: NativeUInt;
    QuotaPagedPoolUsage: NativeUInt;
    QuotaPeakNonPagedPoolUsage: NativeUInt;
    QuotaNonPagedPoolUsage: NativeUInt;
    PagefileUsage: NativeUInt;
    PeakPagefileUsage: NativeUInt;
  end;
  PROCESS_MEMORY_COUNTERS = _PROCESS_MEMORY_COUNTERS;
  PPROCESS_MEMORY_COUNTERS = ^_PROCESS_MEMORY_COUNTERS;

function GetProcessMemoryInfo(Process: THandle;
  ppsmemCounters: PPROCESS_MEMORY_COUNTERS; cb: DWORD): BOOL; stdcall;
  external 'psapi.dll' name 'GetProcessMemoryInfo';

implementation

end.
