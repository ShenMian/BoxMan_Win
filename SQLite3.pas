unit SQLite3;

{
  Simplified interface for SQLite.
  Updated for Sqlite 3 by Tim Anderson (tim@itwriting.com)
  Note: NOT COMPLETE for version 3, just minimal functionality
  Adapted from file created by Pablo Pissanetzky (pablo@myhtpc.net)
  which was based on SQLite.pas by Ben Hochstrasser (bhoc@surfeu.ch)
}

{$IFDEF FPC}
  {$MODE DELPHI}
  {$H+}            (* use AnsiString *)
  {$PACKENUM 4}    (* use 4-byte enums *)
  {$PACKRECORDS C} (* C/C++-compatible record packing *)
{$ELSE}
  {$MINENUMSIZE 4} (* use 4-byte enums *)
{$ENDIF}

interface

const
{$IF Defined(MSWINDOWS)}
  {$IFDEF WIN64}
  SQLiteDLL = 'sqlite3_x64.dll';
  {$ELSE}
  SQLiteDLL = 'sqlite3.dll';
  {$ENDIF}
{$ELSEIF Defined(DARWIN)}
  SQLiteDLL = 'libsqlite3.dylib';
  {$linklib libsqlite3}
{$ELSEIF Defined(UNIX)}
  SQLiteDLL = 'sqlite3.so';
{$IFEND}

// Return values for sqlite3_exec() and sqlite3_step()

const
  SQLITE_OK          =  0; // Successful result
  (* beginning-of-error-codes *)
  SQLITE_ERROR       =  1; // SQL error or missing database
  SQLITE_INTERNAL    =  2; // An internal logic error in SQLite
  SQLITE_PERM        =  3; // Access permission denied
  SQLITE_ABORT       =  4; // Callback routine requested an abort
  SQLITE_BUSY        =  5; // The database file is locked
  SQLITE_LOCKED      =  6; // A table in the database is locked
  SQLITE_NOMEM       =  7; // A malloc() failed
  SQLITE_READONLY    =  8; // Attempt to write a readonly database
  SQLITE_INTERRUPT   =  9; // Operation terminated by sqlite3_interrupt()
  SQLITE_IOERR       = 10; // Some kind of disk I/O error occurred
  SQLITE_CORRUPT     = 11; // The database disk image is malformed
  SQLITE_NOTFOUND    = 12; // (Internal Only) Table or record not found
  SQLITE_FULL        = 13; // Insertion failed because database is full
  SQLITE_CANTOPEN    = 14; // Unable to open the database file
  SQLITE_PROTOCOL    = 15; // Database lock protocol error
  SQLITE_EMPTY       = 16; // Database is empty
  SQLITE_SCHEMA      = 17; // The database schema changed
  SQLITE_TOOBIG      = 18; // Too much data for one row of a table
  SQLITE_CONSTRAINT  = 19; // Abort due to contraint violation
  SQLITE_MISMATCH    = 20; // Data type mismatch
  SQLITE_MISUSE      = 21; // Library used incorrectly
  SQLITE_NOLFS       = 22; // Uses OS features not supported on host
  SQLITE_AUTH        = 23; // Authorization denied
  SQLITE_FORMAT      = 24; // Auxiliary database format error
  SQLITE_RANGE       = 25; // 2nd parameter to sqlite3_bind out of range
  SQLITE_NOTADB      = 26; // File opened that is not a database file
  SQLITE_ROW         = 100; // sqlite3_step() has another row ready
  SQLITE_DONE        = 101; // sqlite3_step() has finished executing

  SQLITE_INTEGER = 1;
  SQLITE_FLOAT   = 2;
  SQLITE_TEXT    = 3;
  SQLITE_BLOB    = 4;
  SQLITE_NULL    = 5;

  SQLITE_UTF8     = 1;
  SQLITE_UTF16    = 2;
  SQLITE_UTF16BE  = 3;
  SQLITE_UTF16LE  = 4;
  SQLITE_ANY      = 5;

  SQLITE_STATIC    {: TSQLite3Destructor} = Pointer(0);
  SQLITE_TRANSIENT {: TSQLite3Destructor} = Pointer(-1);

type
  TSQLiteDB = Pointer;
  TSQLiteResult = ^PAnsiChar;
  TSQLiteStmt = Pointer;
  TSQLiteBackup = pointer;

type
  PPAnsiCharArray = ^TPAnsiCharArray; 
  TPAnsiCharArray = array[0 .. (MaxInt div SizeOf(PAnsiChar))-1] of PAnsiChar;

type
  TSQLiteExecCallback = function(UserData: Pointer; NumCols: integer; ColValues:
    PPAnsiCharArray; ColNames: PPAnsiCharArray): integer; cdecl;
  TSQLiteBusyHandlerCallback = function(UserData: Pointer; P2: integer): integer; cdecl;

  //function prototype for define own collate
  TCollateXCompare = function(UserData: pointer; Buf1Len: integer; Buf1: pointer;
    Buf2Len: integer; Buf2: pointer): integer; cdecl;
    




// 
// In the SQL strings input to sqlite3_prepare() and sqlite3_prepare16(),
// one or more literals can be replace by a wildcard "?" or ":N:" where
// N is an integer.  These value of these wildcard literals can be set
// using the routines listed below.
// 
// In every case, the first parameter is a pointer to the sqlite3_stmt
// structure returned from sqlite3_prepare().  The second parameter is the
// index of the wildcard.  The first "?" has an index of 1.  ":N:" wildcards
// use the index N.
// 
// The fifth parameter to sqlite3_bind_blob(), sqlite3_bind_text(), and
//sqlite3_bind_text16() is a destructor used to dispose of the BLOB or
//text after SQLite has finished with it.  If the fifth argument is the
// special value SQLITE_STATIC, then the library assumes that the information
// is in static, unmanaged space and does not need to be freed.  If the
// fifth argument has the value SQLITE_TRANSIENT, then SQLite makes its
// own private copy of the data.
// 
// The sqlite3_bind_* routine must be called before sqlite3_step() after
// an sqlite3_prepare() or sqlite3_reset().  Unbound wildcards are interpreted
// as NULL.
// 

type
  TSQLite3Destructor = procedure(Ptr: Pointer); cdecl;




//user collate definiton

type
  TSQLite3_OpenFn = function(filename: PAnsiChar; var db: TSQLiteDB):integer; cdecl;
  TSQLite3_CloseFn = function(db: TSQLiteDB):integer; cdecl;
  TSQLite3_ExecFn = function(db: TSQLiteDB; SQLStatement: PAnsiChar; CallbackPtr: TSQLiteExecCallback; UserData: Pointer; var ErrMsg: PAnsiChar):integer; cdecl;
  TSQLite3_VersionFn = function():PAnsiChar; cdecl;
  TSQLite3_ErrMsgFn = function(db: TSQLiteDB):PAnsiChar; cdecl;
  TSQLite3_ErrCodeFn = function(db: TSQLiteDB):integer; cdecl;
  TSQlite3_FreeFn = procedure(P: PAnsiChar); cdecl;
  TSQLite3_GetTableFn = function(db: TSQLiteDB; SQLStatement: PAnsiChar; var ResultPtr: TSQLiteResult; var RowCount: Cardinal; var ColCount: Cardinal; var ErrMsg: PAnsiChar):integer; cdecl;
  TSQLite3_FreeTableFn = procedure(Table: TSQLiteResult); cdecl;
  TSQLite3_CompleteFn = function(P: PAnsiChar):boolean; cdecl;
  TSQLite3_LastInsertRowIDFn = function(db: TSQLiteDB):int64; cdecl;
  TSQLite3_InterruptFn = procedure(db: TSQLiteDB); cdecl;
  TSQLite3_BusyHandlerFn = procedure(db: TSQLiteDB; CallbackPtr: TSQLiteBusyHandlerCallback; UserData: Pointer); cdecl;
  TSQLite3_BusyTimeoutFn = procedure(db: TSQLiteDB; TimeOut: integer); cdecl;
  TSQLite3_ChangesFn = function(db: TSQLiteDB):integer; cdecl;
  TSQLite3_TotalChangesFn = function(db: TSQLiteDB):integer; cdecl;
  TSQLite3_PrepareFn = function(db: TSQLiteDB; SQLStatement: PAnsiChar; nBytes: integer; var hStmt: TSqliteStmt; var pzTail: PAnsiChar):integer; cdecl;
  TSQLite3_Prepare_v2Fn = function(db: TSQLiteDB; SQLStatement: PAnsiChar; nBytes: integer; var hStmt: TSqliteStmt; var pzTail: PAnsiChar):integer; cdecl;
  TSQLite3_ColumnCountFn = function(hStmt: TSqliteStmt):integer; cdecl;
  TSQLite3_ColumnNameFn = function(hStmt: TSqliteStmt; ColNum: integer):PAnsiChar; cdecl;
  TSQLite3_ColumnDeclTypeFn = function(hStmt: TSqliteStmt; ColNum: integer):PAnsiChar; cdecl;
  TSQLite3_StepFn = function(hStmt: TSqliteStmt):integer; cdecl;
  TSQLite3_DataCountFn = function(hStmt: TSqliteStmt):integer; cdecl;
  TSQLite3_ColumnBlobFn = function(hStmt: TSqliteStmt; ColNum: integer):pointer; cdecl;
  TSQLite3_ColumnBytesFn = function(hStmt: TSqliteStmt; ColNum: integer):integer; cdecl;
  TSQLite3_ColumnDoubleFn = function(hStmt: TSqliteStmt; ColNum: integer):double; cdecl;
  TSQLite3_ColumnIntFn = function(hStmt: TSqliteStmt; ColNum: integer):integer; cdecl;
  TSQLite3_ColumnTextFn = function(hStmt: TSqliteStmt; ColNum: integer):PAnsiChar; cdecl;
  TSQLite3_ColumnTypeFn = function(hStmt: TSqliteStmt; ColNum: integer):integer; cdecl;
  TSQLite3_ColumnInt64Fn = function(hStmt: TSqliteStmt; ColNum: integer):Int64; cdecl;
  TSQLite3_FinalizeFn = function(hStmt: TSqliteStmt):integer; cdecl;
  TSQLite3_ResetFn = function(hStmt: TSqliteStmt):integer; cdecl;
  TSQLite3_Backup_InitFn = function(DestDb: TSQLiteDB; DestDbName: PAnsiChar; SourceDb: TSQLiteDB; SourceDbName: PAnsiChar):TSqliteBackup; cdecl;
  TSQLite3_Backup_StepFn = function(hBackup: TSQLiteBackup; nPage: integer):integer; cdecl;
  TSQLite3_Backup_FinishFn = function(hBackup: TSQLiteBackup):integer; cdecl;
  TSQLite3_Backup_RemainingFn = function(hBackup: TSQLiteBackup):integer; cdecl;
  TSQLite3_Backup_PagecountFn = function(hBackup: TSQLiteBackup):integer; cdecl;
  Tsqlite3_bind_blobFn = function(hStmt: TSqliteStmt; ParamNum: integer; ptrData: pointer; numBytes: integer; ptrDestructor: TSQLite3Destructor):integer; cdecl;
  Tsqlite3_bind_textFn = function(hStmt: TSqliteStmt; ParamNum: integer; Text: PAnsiChar; numBytes: integer; ptrDestructor: TSQLite3Destructor):integer; cdecl;
  Tsqlite3_bind_doubleFn = function(hStmt: TSqliteStmt; ParamNum: integer; Data: Double):integer; cdecl;
  Tsqlite3_bind_intFn = function(hStmt: TSqLiteStmt; ParamNum: integer; Data: integer):integer; cdecl;
  Tsqlite3_bind_int64Fn = function(hStmt: TSqliteStmt; ParamNum: integer; Data: int64):integer; cdecl;
  Tsqlite3_bind_nullFn = function(hStmt: TSqliteStmt; ParamNum: integer):integer; cdecl;
  Tsqlite3_bind_parameter_indexFn = function(hStmt: TSqliteStmt; zName: PAnsiChar):integer; cdecl;
  Tsqlite3_enable_shared_cacheFn = function(Value: integer):integer; cdecl;
  TSQLite3_create_collationFn = function(db: TSQLiteDB; Name: PAnsiChar; eTextRep: integer; UserData: pointer; xCompare: TCollateXCompare):integer; cdecl;

var
  SQLite3_Open: TSQLite3_OpenFn;
  SQLite3_Close: TSQLite3_CloseFn;
  SQLite3_Exec: TSQLite3_ExecFn;
  SQLite3_Version: TSQLite3_VersionFn;
  SQLite3_ErrMsg: TSQLite3_ErrMsgFn;
  SQLite3_ErrCode: TSQLite3_ErrCodeFn;
  SQlite3_Free: TSQlite3_FreeFn;
  SQLite3_GetTable: TSQLite3_GetTableFn;
  SQLite3_FreeTable: TSQLite3_FreeTableFn;
  SQLite3_Complete: TSQLite3_CompleteFn;
  SQLite3_LastInsertRowID: TSQLite3_LastInsertRowIDFn;
  SQLite3_Interrupt: TSQLite3_InterruptFn;
  SQLite3_BusyHandler: TSQLite3_BusyHandlerFn;
  SQLite3_BusyTimeout: TSQLite3_BusyTimeoutFn;
  SQLite3_Changes: TSQLite3_ChangesFn;
  SQLite3_TotalChanges: TSQLite3_TotalChangesFn;
  SQLite3_Prepare: TSQLite3_PrepareFn;
  SQLite3_Prepare_v2: TSQLite3_Prepare_v2Fn;
  SQLite3_ColumnCount: TSQLite3_ColumnCountFn;
  SQLite3_ColumnName: TSQLite3_ColumnNameFn;
  SQLite3_ColumnDeclType: TSQLite3_ColumnDeclTypeFn;
  SQLite3_Step: TSQLite3_StepFn;
  SQLite3_DataCount: TSQLite3_DataCountFn;
  SQLite3_ColumnBlob: TSQLite3_ColumnBlobFn;
  SQLite3_ColumnBytes: TSQLite3_ColumnBytesFn;
  SQLite3_ColumnDouble: TSQLite3_ColumnDoubleFn;
  SQLite3_ColumnInt: TSQLite3_ColumnIntFn;
  SQLite3_ColumnText: TSQLite3_ColumnTextFn;
  SQLite3_ColumnType: TSQLite3_ColumnTypeFn;
  SQLite3_ColumnInt64: TSQLite3_ColumnInt64Fn;
  SQLite3_Finalize: TSQLite3_FinalizeFn;
  SQLite3_Reset: TSQLite3_ResetFn;
  SQLite3_Backup_Init: TSQLite3_Backup_InitFn;
  SQLite3_Backup_Step: TSQLite3_Backup_StepFn;
  SQLite3_Backup_Finish: TSQLite3_Backup_FinishFn;
  SQLite3_Backup_Remaining: TSQLite3_Backup_RemainingFn;
  SQLite3_Backup_Pagecount: TSQLite3_Backup_PagecountFn;
  sqlite3_bind_blob: Tsqlite3_bind_blobFn;
  sqlite3_bind_text: Tsqlite3_bind_textFn;
  sqlite3_bind_double: Tsqlite3_bind_doubleFn;
  sqlite3_bind_int: Tsqlite3_bind_intFn;
  sqlite3_bind_int64: Tsqlite3_bind_int64Fn;
  sqlite3_bind_null: Tsqlite3_bind_nullFn;
  sqlite3_bind_parameter_index: Tsqlite3_bind_parameter_indexFn;
  sqlite3_enable_shared_cache: Tsqlite3_enable_shared_cacheFn;
  SQLite3_create_collation: TSQLite3_create_collationFn;

function SQLiteFieldType(SQLiteFieldTypeCode: Integer): AnsiString;
function SQLiteErrorStr(SQLiteErrorCode: Integer): AnsiString;

implementation

uses
  SysUtils, Windows;


var
  hSQLiteLib: HMODULE;

procedure LoadSQLiteLib;
begin
  hSQLiteLib := LoadLibrary(SQLiteDLL);
  if hSQLiteLib = 0 then
    raise Exception.Create('Cannot load ' + SQLiteDLL);
  SQLite3_Open := TSQLite3_OpenFn(GetProcAddress(hSQLiteLib, 'sqlite3_open'));
  SQLite3_Close := TSQLite3_CloseFn(GetProcAddress(hSQLiteLib, 'sqlite3_close'));
  SQLite3_Exec := TSQLite3_ExecFn(GetProcAddress(hSQLiteLib, 'sqlite3_exec'));
  SQLite3_Version := TSQLite3_VersionFn(GetProcAddress(hSQLiteLib, 'sqlite3_libversion'));
  SQLite3_ErrMsg := TSQLite3_ErrMsgFn(GetProcAddress(hSQLiteLib, 'sqlite3_errmsg'));
  SQLite3_ErrCode := TSQLite3_ErrCodeFn(GetProcAddress(hSQLiteLib, 'sqlite3_errcode'));
  SQlite3_Free := TSQlite3_FreeFn(GetProcAddress(hSQLiteLib, 'sqlite3_free'));
  SQLite3_GetTable := TSQLite3_GetTableFn(GetProcAddress(hSQLiteLib, 'sqlite3_get_table'));
  SQLite3_FreeTable := TSQLite3_FreeTableFn(GetProcAddress(hSQLiteLib, 'sqlite3_free_table'));
  SQLite3_Complete := TSQLite3_CompleteFn(GetProcAddress(hSQLiteLib, 'sqlite3_complete'));
  SQLite3_LastInsertRowID := TSQLite3_LastInsertRowIDFn(GetProcAddress(hSQLiteLib, 'sqlite3_last_insert_rowid'));
  SQLite3_Interrupt := TSQLite3_InterruptFn(GetProcAddress(hSQLiteLib, 'sqlite3_interrupt'));
  SQLite3_BusyHandler := TSQLite3_BusyHandlerFn(GetProcAddress(hSQLiteLib, 'sqlite3_busy_handler'));
  SQLite3_BusyTimeout := TSQLite3_BusyTimeoutFn(GetProcAddress(hSQLiteLib, 'sqlite3_busy_timeout'));
  SQLite3_Changes := TSQLite3_ChangesFn(GetProcAddress(hSQLiteLib, 'sqlite3_changes'));
  SQLite3_TotalChanges := TSQLite3_TotalChangesFn(GetProcAddress(hSQLiteLib, 'sqlite3_total_changes'));
  SQLite3_Prepare := TSQLite3_PrepareFn(GetProcAddress(hSQLiteLib, 'sqlite3_prepare'));
  SQLite3_Prepare_v2 := TSQLite3_Prepare_v2Fn(GetProcAddress(hSQLiteLib, 'sqlite3_prepare_v2'));
  SQLite3_ColumnCount := TSQLite3_ColumnCountFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_count'));
  SQLite3_ColumnName := TSQLite3_ColumnNameFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_name'));
  SQLite3_ColumnDeclType := TSQLite3_ColumnDeclTypeFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_decltype'));
  SQLite3_Step := TSQLite3_StepFn(GetProcAddress(hSQLiteLib, 'sqlite3_step'));
  SQLite3_DataCount := TSQLite3_DataCountFn(GetProcAddress(hSQLiteLib, 'sqlite3_data_count'));
  SQLite3_ColumnBlob := TSQLite3_ColumnBlobFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_blob'));
  SQLite3_ColumnBytes := TSQLite3_ColumnBytesFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_bytes'));
  SQLite3_ColumnDouble := TSQLite3_ColumnDoubleFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_double'));
  SQLite3_ColumnInt := TSQLite3_ColumnIntFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_int'));
  SQLite3_ColumnText := TSQLite3_ColumnTextFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_text'));
  SQLite3_ColumnType := TSQLite3_ColumnTypeFn(GetProcAddress(hSQLiteLib, 'sqlite3_column_type'));
  SQLite3_ColumnInt64 := TSQLite3_ColumnInt64Fn(GetProcAddress(hSQLiteLib, 'sqlite3_column_int64'));
  SQLite3_Finalize := TSQLite3_FinalizeFn(GetProcAddress(hSQLiteLib, 'sqlite3_finalize'));
  SQLite3_Reset := TSQLite3_ResetFn(GetProcAddress(hSQLiteLib, 'sqlite3_reset'));
  SQLite3_Backup_Init := TSQLite3_Backup_InitFn(GetProcAddress(hSQLiteLib, 'sqlite3_backup_init'));
  SQLite3_Backup_Step := TSQLite3_Backup_StepFn(GetProcAddress(hSQLiteLib, 'sqlite3_backup_step'));
  SQLite3_Backup_Finish := TSQLite3_Backup_FinishFn(GetProcAddress(hSQLiteLib, 'sqlite3_backup_finish'));
  SQLite3_Backup_Remaining := TSQLite3_Backup_RemainingFn(GetProcAddress(hSQLiteLib, 'sqlite3_backup_remaining'));
  SQLite3_Backup_Pagecount := TSQLite3_Backup_PagecountFn(GetProcAddress(hSQLiteLib, 'sqlite3_backup_pagecount'));
  sqlite3_bind_blob := Tsqlite3_bind_blobFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_blob'));
  sqlite3_bind_text := Tsqlite3_bind_textFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_text'));
  sqlite3_bind_double := Tsqlite3_bind_doubleFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_double'));
  sqlite3_bind_int := Tsqlite3_bind_intFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_int'));
  sqlite3_bind_int64 := Tsqlite3_bind_int64Fn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_int64'));
  sqlite3_bind_null := Tsqlite3_bind_nullFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_null'));
  sqlite3_bind_parameter_index := Tsqlite3_bind_parameter_indexFn(GetProcAddress(hSQLiteLib, 'sqlite3_bind_parameter_index'));
  sqlite3_enable_shared_cache := Tsqlite3_enable_shared_cacheFn(GetProcAddress(hSQLiteLib, 'sqlite3_enable_shared_cache'));
  SQLite3_create_collation := TSQLite3_create_collationFn(GetProcAddress(hSQLiteLib, 'sqlite3_create_collation'));
end;

function SQLiteFieldType(SQLiteFieldTypeCode: Integer): AnsiString;
begin
  case SQLiteFieldTypeCode of
    SQLITE_INTEGER: Result := 'Integer';
    SQLITE_FLOAT: Result := 'Float';
    SQLITE_TEXT: Result := 'Text';
    SQLITE_BLOB: Result := 'Blob';
    SQLITE_NULL: Result := 'Null';
  else
    Result := 'Unknown SQLite Field Type Code "' + IntToStr(SQLiteFieldTypeCode) + '"';
  end;
end;

function SQLiteErrorStr(SQLiteErrorCode: Integer): AnsiString;
begin
  case SQLiteErrorCode of
    SQLITE_OK: Result := 'Successful result';
    SQLITE_ERROR: Result := 'SQL error or missing database';
    SQLITE_INTERNAL: Result := 'An internal logic error in SQLite';
    SQLITE_PERM: Result := 'Access permission denied';
    SQLITE_ABORT: Result := 'Callback routine requested an abort';
    SQLITE_BUSY: Result := 'The database file is locked';
    SQLITE_LOCKED: Result := 'A table in the database is locked';
    SQLITE_NOMEM: Result := 'A malloc() failed';
    SQLITE_READONLY: Result := 'Attempt to write a readonly database';
    SQLITE_INTERRUPT: Result := 'Operation terminated by sqlite3_interrupt()';
    SQLITE_IOERR: Result := 'Some kind of disk I/O error occurred';
    SQLITE_CORRUPT: Result := 'The database disk image is malformed';
    SQLITE_NOTFOUND: Result := '(Internal Only) Table or record not found';
    SQLITE_FULL: Result := 'Insertion failed because database is full';
    SQLITE_CANTOPEN: Result := 'Unable to open the database file';
    SQLITE_PROTOCOL: Result := 'Database lock protocol error';
    SQLITE_EMPTY: Result := 'Database is empty';
    SQLITE_SCHEMA: Result := 'The database schema changed';
    SQLITE_TOOBIG: Result := 'Too much data for one row of a table';
    SQLITE_CONSTRAINT: Result := 'Abort due to contraint violation';
    SQLITE_MISMATCH: Result := 'Data type mismatch';
    SQLITE_MISUSE: Result := 'Library used incorrectly';
    SQLITE_NOLFS: Result := 'Uses OS features not supported on host';
    SQLITE_AUTH: Result := 'Authorization denied';
    SQLITE_FORMAT: Result := 'Auxiliary database format error';
    SQLITE_RANGE: Result := '2nd parameter to sqlite3_bind out of range';
    SQLITE_NOTADB: Result := 'File opened that is not a database file';
    SQLITE_ROW: Result := 'sqlite3_step() has another row ready';
    SQLITE_DONE: Result := 'sqlite3_step() has finished executing';
  else
    Result := 'Unknown SQLite Error Code "' + IntToStr(SQLiteErrorCode) + '"';
  end;
end;

function ColValueToStr(Value: PAnsiChar): AnsiString;
begin
  if (Value = nil) then
    Result := 'NULL'
  else
    Result := Value;
end;


initialization
  LoadSQLiteLib;

finalization
  if hSQLiteLib <> 0 then FreeLibrary(hSQLiteLib);

end.
