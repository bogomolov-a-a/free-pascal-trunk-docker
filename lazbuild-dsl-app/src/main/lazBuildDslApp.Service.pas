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
  strict private
    {$IF DEFINED(LCLcarbon) }
    {$ENDIF}

  public
    class function CreateBuildScriptBuilder(): IBuildScriptBuilder;

  end;

implementation

{ TBuildScriptBuilderFactory }
type
TWindowsBuildScriptBuilder=class(TInterfacedObject,IBuildScriptBuilder)
end

class function TBuildScriptBuilderFactory.CreateBuildScriptBuilder: IBuildScriptBuilder;
begin
  {$IF DEFINED(LCLcarbon)} Result:=
  TMacOSBuildScriptBuilder.Create
  {$ENDIF}
         {$IF DEFINED(Linux)}
          Result:=TLinuxBuildScriptBuilder.Create
         {$ELSE}
                {$IF DEFINED(UNIX)}
                 Result:=TUnixBuildScriptBuilder.Create
                {$ELSE}
                       {$IF DEFINED(WINDOWS)}
                        Result:=TWindowsBuildScriptBuilder.Create;
                       {$ENDIF}
                {$ENDIF}
         {$ENDIF}

end;

end.
