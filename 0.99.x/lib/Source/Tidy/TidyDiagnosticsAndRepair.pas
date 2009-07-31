{-----------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at 
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either expressed or implied. See the License for
the specific language governing rights and limitations under the License.

The Initial Developer of the Original Code is Michael Elsd�rfer.
All Rights Reserved.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: TidyDiagnosticsAndRepair.pas,v 1.1 2004/06/25 14:38:39 miracle2k Exp $

You may retrieve the latest version of this file at the LibTidy Hompage,
located at http://www.elsdoerfer.net/delphi/

Known Issues:
-----------------------------------------------------------------------------}

unit TidyDiagnosticsAndRepair;

interface

uses
  Windows,
  TidyOpaqueTypes, TidyGlobal;

type
  TtidyRunDiagnostics = function(doc: TidyDoc): LongInt; cdecl;
  TtidyCleanAndRepair = function(doc: TidyDoc): LongInt; cdecl;

var
  tidyRunDiagnostics: TtidyRunDiagnostics;
  tidyCleanAndRepair: TtidyCleanAndRepair;

procedure InitTidyLibrary(LibHandle: THandle);

implementation

procedure InitTidyLibrary;
Begin
  tidyRunDiagnostics := GetProcAddress(LibHandle, 'tidyRunDiagnostics');
  tidyCleanAndRepair := GetProcAddress(LibHandle, 'tidyCleanAndRepair');
end;

end.
