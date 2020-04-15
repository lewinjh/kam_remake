unit KM_ScriptingUtils;
{$I KaM_Remake.inc}

interface
uses
  Math,
  KM_ScriptingEvents, KM_CommonTypes, KM_Points;

type
  TKMScriptUtils = class(TKMScriptEntity)
  public
    function AbsI(aValue: Integer): Integer;
    function AbsS(aValue: Single): Single;

    function ArrayElementCount(const aElement: AnsiString; aArray: array of String): Integer;
    function ArrayElementCountB(aElement: Boolean; aArray: array of Boolean): Integer;
    function ArrayElementCountI(aElement: Integer; aArray: array of Integer): Integer;
    function ArrayElementCountS(aElement: Single; aArray: array of Single): Integer;

    function ArrayHasElement(const aElement: AnsiString; aArray: array of String): Boolean;
    function ArrayHasElementB(aElement: Boolean; aArray: array of Boolean): Boolean;
    function ArrayHasElementI(aElement: Integer; aArray: array of Integer): Boolean;
    function ArrayHasElementS(aElement: Single; aArray: array of Single): Boolean;

    function ArrayRemoveIndexI(aIndex: Integer; aArray: TIntegerArray): TIntegerArray;
    function ArrayRemoveIndexS(aIndex: Integer; aArray: TAnsiStringArray): TAnsiStringArray;

    function BoolToStr(aBool: Boolean): AnsiString;

    function EnsureRangeI(aValue, aMin, aMax: Integer): Integer;
    function EnsureRangeS(aValue, aMin, aMax: Single): Single;

    function Format(const aFormatting: string; aData: array of const): string;
    function FormatFloat(const aFormat: string; aValue: Single): string;

    function IfThen(aBool: Boolean; const aTrue, aFalse: AnsiString): AnsiString;
    function IfThenI(aBool: Boolean; aTrue, aFalse: Integer): Integer;
    function IfThenS(aBool: Boolean; aTrue, aFalse: Single): Single;

    function InAreaI(aX, aY, aXMin, aYMin, aXMax, aYMax: Integer): Boolean;
    function InAreaS(aX, aY, aXMin, aYMin, aXMax, aYMax: Single): Boolean;

    function InRangeI(aValue, aMin, aMax: Integer): Boolean;
    function InRangeS(aValue, aMin, aMax: Single): Boolean;

    function KMPoint(X,Y: Integer): TKMPoint;

    function MaxI(A, B: Integer): Integer;
    function MaxS(A, B: Single): Single;

    function MaxInArrayI(aArray: array of Integer): Integer;
    function MaxInArrayS(aArray: array of Single): Single;

    function MinI(A, B: Integer): Integer;
    function MinS(A, B: Single): Single;

    function MinInArrayI(aArray: array of Integer): Integer;
    function MinInArrayS(aArray: array of Single): Single;

    function Power(aBase, aExp: Extended): Extended;

    function RandomRangeI(aFrom, aTo: Integer): Integer;

    function RGBDecToBGRHex(aR, aG, aB: Byte): AnsiString;
    function RGBToBGRHex(aHexColor: string): AnsiString;

    function RoundToDown(aValue: Single; aBase: Integer): Integer;
    function RoundToUp(aValue: Single; aBase: Integer): Integer;

    function Sqr(A: Extended): Extended;

    function SumI(aArray: array of Integer): Integer;
    function SumS(aArray: array of Single): Single;

    function TimeToString(aTicks: Integer): AnsiString;
    function TimeToTick(aHours, aMinutes, aSeconds: Integer): Cardinal;

    function ColorBrightness(aHexColor: string): Single;

  end;


implementation

uses
  SysUtils, KM_CommonUtils;


function TryParseHexColor(aHexColor: string; out aResult: string): Boolean;
begin
  aHexColor := UpperCase(aHexColor);
  if aHexColor[1] <> '$' then
  begin
    if Length(aHexColor) = 6 then
      aResult := '$' + aHexColor
    else if Length(aHexColor) = 7 then
      aResult := '$' + Copy(aHexColor, 2, Length(aHexColor))
    else
      aResult := '';

    Result := Length(aResult) > 0;
  end else begin
    aResult := aHexColor;
    Result := Length(aHexColor) = 7;
  end;
end;


{ TKMScriptingUtils }


//* Version: 7000+
//* Returns absolute value of specified integer
function TKMScriptUtils.AbsI(aValue: Integer): Integer;
begin
  try
    Result := System.Abs(aValue);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns absolute value of specified single number
function TKMScriptUtils.AbsS(aValue: Single): Single;
begin
  try
    Result := System.Abs(aValue);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks how many times specified string comes in requested array
function TKMScriptUtils.ArrayElementCount(const aElement: AnsiString; aArray: array of String): Integer;
var
  I: Integer;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = String(aElement) then
          Inc(Result);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks how many times specified boolean comes in requested array
function TKMScriptUtils.ArrayElementCountB(aElement: Boolean; aArray: array of Boolean): Integer;
var
  I: Integer;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Inc(Result);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks how many times specified integer comes in requested array
function TKMScriptUtils.ArrayElementCountI(aElement: Integer; aArray: array of Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Inc(Result);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks how many times specified single comes in requested array
function TKMScriptUtils.ArrayElementCountS(aElement: Single; aArray: array of Single): Integer;
var
  I: Integer;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Inc(Result);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether requested array has specified string
function TKMScriptUtils.ArrayHasElement(const aElement: AnsiString; aArray: array of String): Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = String(aElement) then
          Exit(True);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether requested array has specified boolean
function TKMScriptUtils.ArrayHasElementB(aElement: Boolean; aArray: array of Boolean): Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Exit(True);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether requested array has specified integer
function TKMScriptUtils.ArrayHasElementI(aElement: Integer; aArray: array of Integer): Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Exit(True);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether requested array has specified single number
function TKMScriptUtils.ArrayHasElementS(aElement: Single; aArray: array of Single): Boolean;
var
  I: Integer;
begin
  Result := False;
  try
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] = aElement then
          Exit(True);
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Removes element on specified index in specified array of integer.
//* Integer array should be declared as TIntegerArray instead of array of integer.
function TKMScriptUtils.ArrayRemoveIndexI(aIndex: Integer; aArray: TIntegerArray): TIntegerArray;
begin
  Result := aArray;
  try
    if (Length(aArray) > 0) and (aIndex in [Low(aArray)..High(aArray)]) then
    begin
      DeleteFromArray(aArray, aIndex);
      Result := aArray;
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Removes element on specified index in specified array of string.
//* String array should be declared as TAnsiStringArray instead of array of AnsiString.
function TKMScriptUtils.ArrayRemoveIndexS(aIndex: Integer; aArray: TAnsiStringArray): TAnsiStringArray;
begin
  Result := aArray;
  try
    if (Length(aArray) > 0) and (aIndex in [Low(aArray)..High(aArray)]) then
    begin
      DeleteFromArray(aArray, aIndex);
      Result := aArray;
    end;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Return string representation of Boolean value: 'True' or 'False'
function TKMScriptUtils.BoolToStr(aBool: Boolean): AnsiString;
begin
  try
    Result := AnsiString(SysUtils.BoolToStr(aBool, True));
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 10940
//* Get Color Brightness from HEX BGR color
//* Result: Color Brightness OR -1 if aHexColor not equal to HEX BGR
function TKMScriptUtils.ColorBrightness(aHexColor: string): Single;
var
  hexclr: String;
  Val: Integer;
begin
  try
    if TryParseHexColor(aHexColor, hexclr) and (TryStrToInt(hexclr, Val)) then
      Result := GetColorBrightness(Val)
    else
      Result := -1;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns the closest to aValue integer that is in interval [aMin..aMax]
function TKMScriptUtils.EnsureRangeI(aValue, aMin, aMax: Integer): Integer;
begin
  try
    Result := Math.EnsureRange(aValue, aMin, aMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns the closest to aValue single number that is in interval [aMin..aMax]
function TKMScriptUtils.EnsureRangeS(aValue, aMin, aMax: Single): Single;
begin
  try
    Result := Math.EnsureRange(aValue, aMin, aMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Wrapper for pascal Format function
//* Formats aFormatting string with specified aData array of parameters
function TKMScriptUtils.Format(const aFormatting: string; aData: array of const): string;
begin
  try
    Result := SysUtils.Format(aFormatting, aData);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 11000
//* Wrapper for pascal FormatFloat function
//* Formats aValue with specified aFormat
function TKMScriptUtils.FormatFloat(const aFormat: string; aValue: Single): string;
begin
  try
    Result := SysUtils.FormatFloat(aFormat, aValue);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks condition aBool and returns aTrue/aFalse string depending on check result
function TKMScriptUtils.IfThen(aBool: Boolean; const aTrue, aFalse: AnsiString): AnsiString;
begin
  try
    if aBool then
      Result := aTrue
    else
      Result := aFalse;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks condition aBool and returns aTrue/aFalse integer depending on check result
function TKMScriptUtils.IfThenI(aBool: Boolean; aTrue, aFalse: Integer): Integer;
begin
  try
    Result := Math.IfThen(aBool, aTrue, aFalse);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks condition aBool and returns aTrue/aFalse single number depending on check result
function TKMScriptUtils.IfThenS(aBool: Boolean; aTrue, aFalse: Single): Single;
begin
  try
    Result := Math.IfThen(aBool, aTrue, aFalse);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* 2D variant of InRange, can be used for unit locs checks
function TKMScriptUtils.InAreaI(aX, aY, aXMin, aYMin, aXMax, aYMax: Integer): Boolean;
begin
  try
    Result := (Math.InRange(aX, aXMin, aXMax)) and Math.InRange(aY, aYMin, aYMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* 2D variant of InRange
function TKMScriptUtils.InAreaS(aX, aY, aXMin, aYMin, aXMax, aYMax: Single): Boolean;
begin
  try
    Result := (Math.InRange(aX, aXMin, aXMax)) and Math.InRange(aY, aYMin, aYMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether specified aValue is in interval [aMin..aMax]
function TKMScriptUtils.InRangeI(aValue, aMin, aMax: Integer): Boolean;
begin
  try
    Result := Math.InRange(aValue, aMin, aMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Checks whether specified aValue is in interval [aMin..aMax]
function TKMScriptUtils.InRangeS(aValue, aMin, aMax: Single): Boolean;
begin
  try
    Result := Math.InRange(aValue, aMin, aMax);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns point record with specified coordinates
function TKMScriptUtils.KMPoint(X,Y: Integer): TKMPoint;
begin
  Result := KM_Points.KMPoint(X,Y);
end;


//* Version: 7000+
//* Returns max number of two specified
function TKMScriptUtils.MaxI(A, B: Integer): Integer;
begin
  try
    Result := Math.Max(A, B);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns max number of two specified
function TKMScriptUtils.MaxS(A, B: Single): Single;
begin
  try
    Result := Math.Max(A, B);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns max number of array elements
function TKMScriptUtils.MaxInArrayI(aArray: array of Integer): Integer;
var
  I: Integer;
begin
  try
    Result := -MaxInt;
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] > Result then
          Result := aArray[I];
    end
    else
      LogParamWarning('Utils.MaxInArrayI: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns max number of array elements
function TKMScriptUtils.MaxInArrayS(aArray: array of Single): Single;
var
  I: Integer;
begin
  try
    Result := MinSingle;
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] > Result then
          Result := aArray[I];
    end
    else
      LogParamWarning('Utils.MaxInArrayS: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns min number of two specified
function TKMScriptUtils.MinI(A, B: Integer): Integer;
begin
  try
    Result := Math.Min(A, B);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns min number of two specified
function TKMScriptUtils.MinS(A, B: Single): Single;
begin
  try
    Result := Math.Min(A, B);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns min number of array elements
function TKMScriptUtils.MinInArrayI(aArray: array of Integer): Integer;
var
  I: Integer;
begin
  try
    Result := MaxInt;
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] < Result then
          Result := aArray[I];
    end
    else
      LogParamWarning('Utils.MinInArrayI: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns min number of array elements
function TKMScriptUtils.MinInArrayS(aArray: array of Single): Single;
var
  I: Integer;
begin
  try
    Result := MaxSingle;
    if Length(aArray) > 0 then
    begin
      for I := 0 to High(aArray) do
        if aArray[I] < Result then
          Result := aArray[I];
    end
    else
      LogParamWarning('Utils.MinInArrayS: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Exponentation, base 'Base' raised to power 'Exp'.
//* F.e. Power(3, 2) = 3^2 = 9
//* Returns base "Base" raised to power "Exp"
function TKMScriptUtils.Power(aBase, aExp: Extended): Extended;
begin
  try
    Result := Math.Power(aBase, aExp);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 11000
//* Generates a random number in requested range aFrom..aTo (inclusive)
function TKMScriptUtils.RandomRangeI(aFrom, aTo: Integer): Integer;
begin
  try
    Result := KaMRandom(aTo - aFrom + 1, 'TKMScriptUtils.RandomRangeI') + aFrom;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 10940
//* Converts RGB to HEX BGR color
//* Result: HEX BGR Color
//* Example
//* VAR := RGBDecToBGRHex(255, 255, 0);
//* The result of the VAR will be 00FFFF
function TKMScriptUtils.RGBDecToBGRHex(aR, aG, aB: Byte): AnsiString;
begin
  try
    Result := AnsiString(Format('%.6x', [RGB2BGR(StrToInt('$' + IntToHex(aR, 2) + IntToHex(aG, 2) + IntToHex(aB, 2)))]));
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 10940
//* Converts HEX RGB to HEX BGR color
//* Result: HEX BGR Color or '' if aHexColor not equal to HEX RGB
//* Example
//* VAR := RGBToBGRHex('#FFFF00');
//* The result of the VAR will be 00FFFF
function TKMScriptUtils.RGBToBGRHex(aHexColor: string): AnsiString;
var
  hexclr: String;
  Val: Integer;
begin
  try
    if TryParseHexColor(aHexColor, hexclr) and TryStrToInt(hexclr, Val) then
      Result := AnsiString(Format('%.6x', [RGB2BGR(Val)]))
    else
      Result := '';
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding down. F.e. RoundToDown(11.7, 5) = 10
function TKMScriptUtils.RoundToDown(aValue: Single; aBase: Integer): Integer;
begin
  try
    Result := Trunc(aValue / aBase) * aBase
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Rounds specified single number aValue to nearest multiple of specified base aBase. Rounding up. F.e. RoundToUp(11.7, 5) = 15
function TKMScriptUtils.RoundToUp(aValue: Single; aBase: Integer): Integer;
begin
  try
    Result := Ceil(aValue / aBase) * aBase
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns A^2 = A*A
function TKMScriptUtils.Sqr(A: Extended): Extended;
begin
  try
    Result := System.Sqr(A);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns sum of the elements of requested array
function TKMScriptUtils.SumI(aArray: array of Integer): Integer;
var
  I: Integer;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
      for I := 0 to High(aArray) do
        Result := Result + aArray[I]
    else
      LogParamWarning('Utils.SumI: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Returns sum of the elements of requested array
function TKMScriptUtils.SumS(aArray: array of Single): Single;
begin
  Result := 0;
  try
    if Length(aArray) > 0 then
      Result := Math.Sum(aArray)
    else
      LogParamWarning('Utils.SumS: Requested array is empty',[]);
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 7000+
//* Converts game ticks count into string: HH:MM:SS
//* Can be used for scripted timers
function TKMScriptUtils.TimeToString(aTicks: Integer): AnsiString;
var
  H, M, S: Integer;
begin
  try
    if aTicks >= 0 then
    begin
      H := aTicks div 36000;
      M := (aTicks div 600) mod 60;
      S := (aTicks div 10) mod 60;
      Result := AnsiString(Format('%.2d:%.2d:%.2d', [H, M, S]));
    end
    else
      Result := '';
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


//* Version: 10940
//* Converts Time in game ticks
//* Result: game ticks
function TKMScriptUtils.TimeToTick(aHours, aMinutes, aSeconds: Integer): Cardinal;
begin
  try
    Result := ((aHours * 60 * 60) + (aMinutes * 60) + aSeconds) * 10;
  except
    gScriptEvents.ExceptionOutsideScript := True;
    raise;
  end;
end;


end.
