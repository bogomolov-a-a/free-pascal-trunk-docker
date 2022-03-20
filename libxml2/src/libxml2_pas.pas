{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit libxml2_pas;

{$warn 5023 off : no warning about unused units}
interface

uses
  iconv, libexslt, libxml2, libxmlsec, libxslt, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('libxml2_pas', @Register);
end.
