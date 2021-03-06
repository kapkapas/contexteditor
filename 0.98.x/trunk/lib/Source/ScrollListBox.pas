unit ScrollListBox;

interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, ComCtrls, StdCtrls;

type
  THScrollListBox = class(TListBox)
  private
    MaxExtent: integer;     { maximum length of the strings in the listbox (in pixel) }
    function GetStringExtent( s: string ): integer;
  protected
  public
    constructor Create( AOwner: TComponent ); override;
    function  InsertString(Index:integer; s:string; Data:TObject):integer;
    function  AddString(s:string; Data:TObject):integer;
    procedure DeleteString(i:integer);
    procedure ClearList;
    procedure AdjustWidth;
  published
  end;

procedure Register;

implementation

constructor THScrollListBox.Create( AOwner: TComponent );
begin
  inherited Create( AOwner );
  MaxExtent := 0;
end;


function THScrollListBox.GetStringExtent( s: string ): integer;
var
  dwExtent:	      DWORD;
  hDCListBox:	      HDC;
  hFontOld, hFontNew: HFONT;
  tm:		      TTextMetric;
  Size: 	      TSize;
begin
  hDCListBox := GetDC( Handle );
  hFontNew := SendMessage( Handle, WM_GETFONT, 0, 0 );
  hFontOld := SelectObject( hDCListBox, hFontNew );
  GetTextMetrics( hDCListBox, tm );

  { the following two lines should be modified for Delphi 1.0: call GetTextExtent }
  GetTextExtentPoint32( hDCListBox, PChar(s), Length(s), Size );
  dwExtent := Size.cx + tm.tmAveCharWidth;

  SelectObject( hDCListBox, hFontOld );
  ReleaseDC( Handle, hDCListBox );

  GetStringExtent := LOWORD( dwExtent );
end;

function THScrollListBox.InsertString(Index:integer; s:string; Data:TObject):integer;
var
  StrExtent: integer;
begin
  StrExtent := GetStringExtent( s );
  if StrExtent > MaxExtent then
  begin
    MaxExtent := StrExtent;
    SendMessage( Handle, LB_SETHORIZONTALEXTENT, MaxExtent, 0 );
  end;

  { adds the string to the listbox }
  Items.InsertObject(Index, s, Data);
  result:=Index;
end;

function THScrollListBox.AddString(s:string; Data:TObject):integer;
begin
  result:=InsertString(Items.Count, s, Data);
end;

procedure THScrollListBox.DeleteString(i:integer);
begin
  Items.Delete(i);
  AdjustWidth;
end;

procedure THScrollListBox.ClearList;
begin
  MaxExtent := 0;
	SendMessage( Handle, LB_SETHORIZONTALEXTENT, 0, 0 );

	{ scrolls the listbox to the left }
	SendMessage( Handle, WM_HSCROLL, SB_TOP, 0 );

  { clears the listbox }
  Items.Clear;
  AdjustWidth;
end;

procedure THScrollListBox.AdjustWidth;
var
  i		 :integer;
  StrExtent	 :integer;
begin
  SendMessage( Handle, WM_HSCROLL, SB_TOP, 0 );

  MaxExtent:=0;
  i:=0;
  while (i<Items.Count) do begin
    StrExtent:=GetStringExtent(Items[i]);
    if (StrExtent>MaxExtent) then
      MaxExtent := StrExtent;
    inc(i);
  end;

  SendMessage( Handle, LB_SETHORIZONTALEXTENT, MaxExtent, 0 );
end;

procedure Register;
begin
 RegisterComponents('Add-On''s', [THScrollListBox]);
end;

end.

