unit KM_ResCursors;
{$I KaM_Remake.inc}
interface
uses
  Classes, Forms,
  {$IFDEF MSWindows} Windows, {$ENDIF}
  {$IFDEF Unix} LCLIntf, LCLType, {$ENDIF}
  Graphics, Math, SysUtils,
  KM_Points, KM_ResSprites;

type
  TKMCursor = (
    kmcDefault, kmcInfo, kmcAttack, kmcJoinYes, kmcJoinNo, kmcEdit, kmcDragUp,
    kmcDir0, kmcDir1, kmcDir2, kmcDir3, kmcDir4, kmcDir5, kmcDir6, kmcDir7, kmcDirNA,
    kmcScroll0, kmcScroll1, kmcScroll2, kmcScroll3, kmcScroll4, kmcScroll5, kmcScroll6, kmcScroll7,
    kmcBeacon, kmcDrag,
    kmcInvisible, //for some reason kmcInvisible should be at its current position in enum. Otherwise 1px dot will appear while TroopSelection is on
    kmcPaintBucket);


  TKMResCursors = class
  private
    fRXData: PRXData; //Store pointer to record instead of duplicating it
    function GetCursor: TKMCursor;
    procedure SetCursor(Value: TKMCursor);
  public
    procedure MakeCursors(aSprites: TKMSpritePack);
    property Cursor: TKMCursor read GetCursor write SetCursor;
    function CursorOffset(aDir: TKMDirection): TKMPoint;
    function CursorTexID(aDir: TKMDirection): Integer;
  end;


implementation
uses
  KM_Defaults;

const
  //Screen.Cursors[0] is used by System default cursor
  COUNT_OFFSET = 1;

  //Indexes of cursor images in GUI.RX
  CURSORS: array [TKMCursor] of Word = (
    1, 452, 457, 460, 450, 453, 449,
    511,  512, 513, 514, 515, 516, 517, 518, 519,
    4, 7, 3, 9, 5, 8, 2, 6,
    456, 451, 999, 661);

  //Which cursor is used for which direction
  TKMCursorDirections: array [TKMDirection] of TKMCursor = (
    kmcDirNA, kmcDir0, kmcDir1, kmcDir2, kmcDir3, kmcDir4, kmcDir5, kmcDir6, kmcDir7);


{ TKMResCursors }
function TKMResCursors.GetCursor: TKMCursor;
begin
  if InRange(Screen.Cursor - COUNT_OFFSET, Byte(Low(TKMCursor)), Byte(High(TKMCursor))) then
    Result := TKMCursor(Screen.Cursor - COUNT_OFFSET)
  else
    Result := kmcDefault;
end;


procedure TKMResCursors.SetCursor(Value: TKMCursor);
begin
  if SKIP_LOADING_CURSOR then Exit;
  Screen.Cursor := Byte(Value) + COUNT_OFFSET;
end;


procedure TKMResCursors.MakeCursors(aSprites: TKMSpritePack);
const
  SF = 17; //Full width/height of a scroll cursor
  SH = 8; //Half width/height of a scroll cursor
  //Measured manually
  CursorOffsetsX: array [TKMCursor] of Integer = (0,0,20, 0, 0,-8, 9,0, 1,1,1,0,-1,-1,-1,0, SH,SF,SF,SF,SH, 0, 0,0, 0,0,0,27);
  CursorOffsetsY: array [TKMCursor] of Integer = (0,9,10,18,20,44,13,0,-1,0,1,1, 1, 0,-1,0, 0 ,0 ,SH,SF,SF,SF,SH,0,28,0,0,28);
var
  KMC: TKMCursor;
  sx,sy,x,y: Integer;
  bm,bm2: TBitmap;
  IconInfo: TIconInfo;
  Px: PRGBQuad;
begin
  if SKIP_RENDER then Exit;

  fRXData := @aSprites.RXData;

  bm  := TBitmap.Create; bm.HandleType  := bmDIB; bm.PixelFormat  := pf32bit;
  bm2 := TBitmap.Create; bm2.HandleType := bmDIB; bm2.PixelFormat := pf32bit;

  for KMC := Low(TKMCursor) to High(TKMCursor) do
  begin

    //Special case for invisible cursor
    if KMC = kmcInvisible then
    begin
      bm.Width  := 1; bm.Height  := 1;
      bm2.Width := 1; bm2.Height := 1;
      bm2.Canvas.Pixels[0,0] := clWhite; //Invisible mask, we don't care for Image color
      IconInfo.xHotspot := 0;
      IconInfo.yHotspot := 0;
    end
    else
    begin
      sx := fRXData.Size[CURSORS[KMC]].X;
      sy := fRXData.Size[CURSORS[KMC]].Y;
      bm.Width  := sx; bm.Height  := sy;
      bm2.Width := sx; bm2.Height := sy;

      for y:=0 to sy-1 do
      begin
        Px := bm.ScanLine[y];
        for x:=0 to sx-1 do
        begin
          if fRXData.RGBA[CURSORS[KMC],y*sx+x] and $FF000000 = 0 then
            Px.rgbReserved := $00
          else
            Px.rgbReserved := $FF;
          // Here we have BGR, not RGB
          Px.rgbBlue := (fRXData.RGBA[CURSORS[KMC],y*sx+x] and $FF0000) shr 16;
          Px.rgbGreen := (fRXData.RGBA[CURSORS[KMC],y*sx+x] and $FF00) shr 8;
          Px.rgbRed := fRXData.RGBA[CURSORS[KMC],y*sx+x] and $FF;
          inc(Px);
        end;
      end;
      //Load hotspot offsets from RX file, adding the manual offsets (normally 0)
      IconInfo.xHotspot := Math.max(-fRXData.Pivot[CURSORS[KMC]].x+CursorOffsetsX[KMC],0);
      IconInfo.yHotspot := Math.max(-fRXData.Pivot[CURSORS[KMC]].y+CursorOffsetsY[KMC],0);
    end;

    //Release the Mask, otherwise there is black rect in Lazarus
    //it works only from within the loop, means mask is recreated when we access canvas or something like that
    bm2.ReleaseMaskHandle;

    IconInfo.fIcon := false; //true=Icon, false=Cursor
    IconInfo.hbmColor := bm.Handle;

    //I have a suspicion that maybe Windows could create icon delayed, at a time when bitmap data is
    //no longer valid (replaced by other bitmap or freed). Hence issues with transparency.
    {$IFDEF MSWindows}
      IconInfo.hbmMask  := bm2.Handle;
      Screen.Cursors[Byte(KMC) + COUNT_OFFSET] := CreateIconIndirect(IconInfo);
    {$ENDIF}
    {$IFDEF Unix}
      bm2.Mask(clWhite);
      IconInfo.hbmMask  := bm2.MaskHandle;
      Screen.Cursors[Byte(KMC) + COUNT_OFFSET] :=  CreateIconIndirect(@IconInfo);
    {$ENDIF}
  end;

  bm.Free;
  bm2.Free;
end;


// Return cursor offset for given direction, which is a signed(!) value
function TKMResCursors.CursorOffset(aDir: TKMDirection): TKMPoint;
begin
  Result.X := fRXData.Pivot[CURSORS[TKMCursorDirections[aDir]]].X;
  Result.Y := fRXData.Pivot[CURSORS[TKMCursorDirections[aDir]]].Y;
end;


// Sprite index of the cursor
function TKMResCursors.CursorTexID(aDir: TKMDirection): Integer;
begin
  Result := CURSORS[TKMCursorDirections[aDir]];
end;


end.
