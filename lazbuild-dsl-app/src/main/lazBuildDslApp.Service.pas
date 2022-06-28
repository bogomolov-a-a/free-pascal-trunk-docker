unit lazBuildDslApp.Service;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, lazBuildDslApp.Model, SysUtils;

type
  IBuildScriptBuilder = interface
    function Build(AAplicationInfoCollection: TApplicationBuildInfoCollection): string;
  end;

  { TBuildScriptBuilderFactory }

  TBuildScriptBuilderFactory = class
    class function CreateBuildScriptBuilder(): IBuildScriptBuilder;
  end;

implementation

{ TBuildScriptBuilderFactory }

class function TBuildScriptBuilderFactory.CreateBuildScriptBuilder: IBuildScriptBuilder;
begin
  Result:={$IF DEFINED(LCLcarbon)}
  TMacOSBuildScriptBuilder.Create
  {$ELSE}
         {$IF DEFINED(Linux)}
         TLinuxBuildScriptBuilder.Create
         {$ELSE}
                {$IF DEFINED(UNIX)}
                TUnixBuildScriptBuilder.Create
                {$ELSE}
                       {$IF DEFINED(WINDOWS)}
                       TWindowsBuildScriptBuilder.Create;
                       {$ENDIF}
                {$ENDIF}
         {$ENDIF}
  {$ENDIF}
end;

end.
