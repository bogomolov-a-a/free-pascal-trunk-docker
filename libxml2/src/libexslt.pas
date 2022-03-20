{This file generated automatically from libexslt-api.xml}
{For libexslt version: 0.8.13}
unit libexslt;

interface

{$ALIGN 8}
{$MINENUMSIZE 4}

uses libxml2, libxslt;

const
{$IF DEFINED(WIN32) or DEFINED(WIN64)}
  LIBEXSLT_SO = 'libexslt.dll';
{$ELSE}
  LIBEXSLT_SO = 'libexslt.so';

{$ENDIF}

//type


procedure exsltCommonRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltCryptoRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltDateRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltDynRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltFuncRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltMathRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltRegisterAll(); cdecl; external LIBEXSLT_SO;
procedure exsltSaxonRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltSetsRegister(); cdecl; external LIBEXSLT_SO;
procedure exsltStrRegister(); cdecl; external LIBEXSLT_SO;
function exsltLibexsltVersion(): longint; cdecl;
function exsltLibraryVersion(): PChar; cdecl;
function exsltLibxmlVersion(): longint; cdecl;
function exsltLibxsltVersion(): longint; cdecl;

implementation

uses
{$IF DEFINED(WIN32) or DEFINED(WIN64)}
  Windows,
{$ENDIF}
  SysUtils;

var
  libHandle: THandle;

// Utility function to make sure procedure entry points are not null

procedure CheckForNil(ptr: Pointer; Name: string);
  begin
    if not Assigned(ptr) then
      raise Exception.Create('"' + Name + '" could not be loaded from the dynamic library ' + LIBEXSLT_SO);
  end;

var
  pexsltLibexsltVersion: PInteger;

function exsltLibexsltVersion: longint; cdecl;
  begin
    CheckForNil(pexsltLibexsltVersion, 'exsltLibexsltVersion');
    Result := pexsltLibexsltVersion^;
  end;

var
  pexsltLibraryVersion: PPChar;

function exsltLibraryVersion: PChar; cdecl;
  begin
    CheckForNil(pexsltLibraryVersion, 'exsltLibraryVersion');
    Result := pexsltLibraryVersion^;
  end;

var
  pexsltLibxmlVersion: PInteger;

function exsltLibxmlVersion: longint; cdecl;
  begin
    CheckForNil(pexsltLibxmlVersion, 'exsltLibxmlVersion');
    Result := pexsltLibxmlVersion^;
  end;

var
  pexsltLibxsltVersion: PInteger;

function exsltLibxsltVersion: longint; cdecl;
  begin
    CheckForNil(pexsltLibxsltVersion, 'exsltLibxsltVersion');
    Result := pexsltLibxsltVersion^;
  end;



initialization
  // The Delphi 'external' directive can be used for functions and procedures,
  // but here we need to obtain the addresses of POINTERS to functions. We can
  // get to these addresses (and also those of other data values exported from
  // the DLL) by using GetProcAddress.
  libHandle := LoadLibrary(LIBEXSLT_SO);
  if libHandle <> 0 then
  begin
    pexsltLibexsltVersion := PInteger(GetProcAddress(libHandle, 'exsltLibexsltVersion'));
    pexsltLibraryVersion := PPChar(GetProcAddress(libHandle, 'exsltLibraryVersion'));
    pexsltLibxmlVersion := PInteger(GetProcAddress(libHandle, 'exsltLibxmlVersion'));
    pexsltLibxsltVersion := PInteger(GetProcAddress(libHandle, 'exsltLibxsltVersion'));

    FreeLibrary(libHandle);
  end;

end.
