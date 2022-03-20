program lazBuildDslApp;

uses
  Classes,
  Sysutils,
  CustApp,
  XMLConf,
  libxml2,
  lazBuildDslApp.Model in 'main/lazBuildDslApp.Model.pas', Unit1;

const
  APPLICATION_BUILD_INFO_FILE_NAME = 'app/app-build-info-descriptor'#0;
  DESCRIPTOR_FILE_NAME_OPTION = 'f';
type
  { TLazBuildDSLApplication }

  TLazBuildDSLApplication = class(TCustomApplication)
  strict private
    FFileName: string;
    procedure HandleBuildScript();
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoRun; override;
    destructor Destroy; override;
  end;

  { TLazBuildDSLApplication }

  constructor TLazBuildDSLApplication.Create(AOwner: TComponent);
    begin
      inherited Create(AOwner);
      FFileName := ExtractFilePath(ExcludeTrailingPathDelimiter(Location)) + APPLICATION_BUILD_INFO_FILE_NAME;
    end;

  destructor TLazBuildDSLApplication.Destroy;
    begin
      FFileName := EmptyStr;
      inherited Destroy;
    end;

  procedure TLazBuildDSLApplication.HandleBuildScript();
    var
      doc: xmlDocPtr;
    begin
      doc := xmlReadFile(Pchar(@FFileName[1]),PChar('utf-8'#0),0);
      try
      finally
        xmlFreeDoc(doc);

      end;
    end;

  procedure TLazBuildDSLApplication.DoRun;
    var
      error: string;
    begin
      error := CheckOptions(DESCRIPTOR_FILE_NAME_OPTION, EmptyStr);
      if error <> EmptyStr then
      begin
        ShowException(Exception.Create(error));
        exitcode := -1;
        terminate;
        exit;
      end;
      if HasOption(DESCRIPTOR_FILE_NAME_OPTION) and (GetOptionValue(DESCRIPTOR_FILE_NAME_OPTION, EmptyStr).Trim() <> EmptyStr) then
        FFileName := GetOptionValue(DESCRIPTOR_FILE_NAME_OPTION, EmptyStr)+#0;
      writeln(format('try to build application from building descriptor at ''%s''', [FFileName]));
      try
        HandleBuildScript();
      except
        on e: Exception do
        begin
          writeln(format('During application building from descriptor at ''%s'' occurred error with message''%s''', [FFileName, e.Message]));
          exitcode := -1;
          Terminate;
          exit;
        end;
      end;
      writeln(format('application from building descriptor at ''%s'' built', [FFileName]));
      Terminate;
    end;

var
  Application: TLazBuildDSLApplication;

{$R *.res}

begin
  Application := TLazBuildDSLApplication.Create(nil);
  Application.Run;
  Application.Free;
end.
