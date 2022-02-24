unit lazBuildDslApp.Model;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils;

type
  TCSVType = (git, svn, hg, unknown);

  { TCVSInfo }

  TCVSInfo = class(TPersistent)
  strict private
    FCVSType: TCSVType;
    FUrl: string;
    FLocalDirectory: string;
    FBranch: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property CVSType: TCSVType read FCVSType write FCVSType;
    property Url: string read FUrl write FUrl;
    property LocalDirectory: string read FLocalDirectory write FLocalDirectory;
    property Branch: string read FBranch write FBranch;
  end;

  TOptions = record

  end;

  { TBuildSystemInfo }

  TBuildSystemInfo = class(TPersistent)
  strict private
    FCompilerPath: string;
    FLazbuildPath: string;
  public
    constructor Create;
    destructor Destroy; override;
  published
    property CompilerPath: string read FCompilerPath write FCompilerPath;
    property LazbuildPath: string read FLazBuildPath write FLazbuildPath;
  end;

  { TDependency }

  TDependency = class(TCollectionItem)
  strict private
    FLocalPath: string;
    FNeedLoadFromCSV: boolean;
    FCVSInfo: TCVSInfo;
  public
    constructor Create(ACollection: TCollection); override;
    constructor Create;
    destructor Destroy; override;
  published
    property LocalPath: string read FLocalPath write FLocalPath;
    property NeedLoadFromCSV: boolean read FNeedLoadFromCSV write FNeedLoadFromCSV;
    property CVSInfo: TCVSInfo read FCVSInfo;
  end;

  { TDependencyCollection }

  TDependencyCollection = class(TCollection)
  public
    constructor Create;
  end;

  TAbstractApplicationBuildInfo = class(TCollectionItem)

  end;

  { TTestSuiteInfo }

  TTestSuiteInfo = class(TAbstractApplicationBuildInfo)
  strict private
    FProjectFileName: string;
    FBuildSystemInfo: TBuildSystemInfo;
    FDependenies: TDependencyCollection;
  public
    constructor Create(ACollection: TCollection);
    constructor Create;
    destructor Destroy; override;
  published
    property ProjectFileName: string read FProjectFileName write FProjectFileName;
    property BuildSystemInfo: TBuildSystemInfo read FBuildSystemInfo;
    property Dependenies: TDependencyCollection read FDependenies;
  end;

  { TTestSuiteInfoCollection }

  TTestSuiteInfoCollection = class(TCollection)
    constructor Create(AItemClass: TCollectionItem);
  end;

  TApplicationBuildInfoCollection = class;
  { TApplicationBuildInfo }

  TApplicationBuildInfo = class(TAbstractApplicationBuildInfo)
  strict private
    FBuildOrder: integer;
    FTestSuits: TTestSuiteInfoCollection;
  public
    constructor Create(ACollection: TCollection);
    destructor Destroy; override;
  published
    property BuildOrder: integer read FBuildOrder write FBuildOrder;
    property TestSuits: TTestSuiteInfoCollection read FTestSuits;
  end;

  { TApplicationBuildInfoCollection }

  TApplicationBuildInfoCollection = class(TCollection)
  public
    constructor Create(AItemClass: TCollectionItemClass);
    procedure GenerateBuildScript();
    class function SortItem(Item1, Item2: TApplicationBuildInfo): integer; static;
  end;

implementation

{ TTestSuiteInfo }

constructor TTestSuiteInfo.Create(ACollection: TCollection);
  begin

  end;

constructor TTestSuiteInfo.Create;
  begin

  end;

destructor TTestSuiteInfo.Destroy;
  begin
    inherited Destroy;
  end;

{ TTestSuiteInfoCollection }

constructor TTestSuiteInfoCollection.Create(AItemClass: TCollectionItem);
  begin
    inherited Create(TTestSuiteInfo);
  end;

{ TCVSInfo }

constructor TCVSInfo.Create;
  begin
    inherited Create;
    FCVSType := unknown;
    FUrl := EmptyStr;
    FBranch := EmptyStr;
    FLocalDirectory := EmptyStr;
  end;

destructor TCVSInfo.Destroy;
  begin
    FLocalDirectory := EmptyStr;
    FBranch := EmptyStr;
    FUrl := EmptyStr;
    FCVSType := unknown;
    inherited Destroy;
  end;

{ TDependency }

constructor TDependency.Create(ACollection: TCollection);
  begin
    inherited Create(ACollection);
    Create;
  end;

constructor TDependency.Create;
  begin
    FLocalPath := EmptyStr;
    FNeedLoadFromCSV := False;
    FCVSInfo := TCVSInfo.Create;
  end;

destructor TDependency.Destroy;
  begin
    FreeAndNil(FCVSInfo);
    FNeedLoadFromCSV := False;
    FLocalPath := EmptyStr;
    inherited Destroy;
  end;

{ TDependencyCollection }

constructor TDependencyCollection.Create;
  begin
    inherited Create(TDependency);
  end;

{ TBuildSystemInfo }

constructor TBuildSystemInfo.Create;
  begin
    FCompilerPath := EmptyStr;
    FLazbuildPath := EmptyStr;
  end;

destructor TBuildSystemInfo.Destroy;
  begin
    FLazbuildPath := EmptyStr;
    FCompilerPath := EmptyStr;
    inherited Destroy;
  end;

{ TApplicationBuildInfo }

constructor TApplicationBuildInfo.Create(ACollection: TCollection);
  begin
    inherited Create(ACollection);
    FBuildOrder := -1;
    FTestSuits := TTestSuiteInfoCollection.Create(nil);
  end;

destructor TApplicationBuildInfo.Destroy;
  begin
    FreeAndNil(FTestSuits);
    FBuildOrder := -1;
    inherited Destroy;
  end;

{ TApplicationBuildInfoCollection }

constructor TApplicationBuildInfoCollection.Create(AItemClass: TCollectionItemClass);
  begin
    inherited Create(TApplicationBuildInfo);
  end;

procedure TApplicationBuildInfoCollection.GenerateBuildScript;
  begin

  end;

class function TApplicationBuildInfoCollection.SortItem(Item1, Item2: TApplicationBuildInfo): integer;
  begin
    Result := 0;
    if Item1.BuildOrder > Item2.BuildOrder then
    begin
      Result := 1;
      exit;
    end;
    if Item1.BuildOrder < Item2.BuildOrder then
      Result := -1;
  end;

end.
