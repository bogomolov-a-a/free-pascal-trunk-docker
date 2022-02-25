program lazBuildDslApp;

uses
  common.Data.Mapper,
  Classes,
  Sysutils,
  CustApp,
  lazBuildDslApp.Model;

const
  APPLICATION_BUILD_INFO_FILE_NAME = 'app/app-build-info-descriptor';
  DESCRIPTOR_FILE_NAME_OPTION = 'f';
type
  { TLazBuildDSLApplication }

  TLazBuildDSLApplication = class(TCustomApplication)
  strict private
    FFileName: string;
    FBuildFileStream: TStringStream;
    FDescriptorMapper: IDataMapper;
    procedure HandleBuildScript(Data: string);
  public
    constructor Create(AOwner: TComponent); override;
    procedure DoRun; override;
    destructor Destroy; override;
  end;

{$R *.res}

  { TLazBuildDSLApplication }

  constructor TLazBuildDSLApplication.Create(AOwner: TComponent);
    begin
      inherited Create(AOwner);
      FDescriptorMapper := TDataMapperFactory.CreateDataMapper(mtJSON);
      FBuildFileStream := TStringStream.Create;
      FFileName := ExtractFilePath(ExcludeTrailingPathDelimiter(Location)) + APPLICATION_BUILD_INFO_FILE_NAME;
    end;

  destructor TLazBuildDSLApplication.Destroy;
    begin
      FDescriptorMapper := nil;
      FreeAndNil(FBuildFileStream);
      FFileName := EmptyStr;
      inherited Destroy;
    end;

  procedure TLazBuildDSLApplication.HandleBuildScript(Data: string);
    var
      ApplicationBuildInfo: TApplicationBuildInfoCollection;
    begin
      ApplicationBuildInfo := FDescriptorMapper.DeSerializeFrom(Data, TApplicationBuildInfoCollection) as TApplicationBuildInfoCollection;
      ApplicationBuildInfo.GenerateBuildScript();
      FreeAndNil(ApplicationBuildInfo);
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
        FFileName := GetOptionValue(DESCRIPTOR_FILE_NAME_OPTION, EmptyStr);
      writeln(format('try to build application from building descriptor at ''%s''', [FFileName]));
      try
        FBuildFileStream.LoadFromFile(FFileName);
        HandleBuildScript(FBuildFileStream.DataString);

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
begin
  Application := TLazBuildDSLApplication.Create(nil);
  Application.Run;
  Application.Free;
end.
