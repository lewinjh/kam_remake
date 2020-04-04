unit KM_MapEdTypes;
{$I KaM_Remake.inc}
interface
uses
  KM_Defaults, KM_CommonTypes, KM_ResTileset, KM_Terrain;

type
  // same as TKMTerrainLayer, but packed
  TKMTerrainLayerPacked = packed record
    Terrain: Word;
    Rotation: Byte;
    Corners: TKMTileCorners; //Corners, that this layer 'owns' (corners are distributed between all layers, so any layer can own 1-4 corners)
    procedure SetCorners(aCorners: TKMByteSet);
    procedure ClearCorners;
  end;

  //Tile data that we store in undo checkpoints
  //TODO: pack UndoTile (f.e. blendingLvl + IsCustom could be packed into 1 byte etc)
  TKMUndoTile = packed record
    BaseLayer: TKMTerrainLayerPacked;
    LayersCnt: Byte;
    Layer: array [0..2] of TKMTerrainLayerPacked;
    Height: Byte;
    Obj: Word;
    IsCustom: Boolean;
    BlendingLvl: Byte;
    TerKind: TKMTerrainKind;
    Tiles: SmallInt;
    HeightAdd: Byte;
    TileOverlay: TKMTileOverlay;
    TileOwner: TKMHandID;
  end;

  TKMPainterTile = packed record
    TerKind: TKMTerrainKind; //Stores terrain type per node
    Tiles: SmallInt;  //Stores kind of transition tile used, no need to save into MAP footer
    HeightAdd: Byte; //Fraction part of height, for smooth height editing
  end;
  
implementation


{ TKMTerrainLayerPacked }
procedure TKMTerrainLayerPacked.SetCorners(aCorners: TKMByteSet);
var
  I: Integer;
begin
  for I := 0 to 3 do
    Corners[I] := I in aCorners;
end;


procedure TKMTerrainLayerPacked.ClearCorners;
var
  I: Integer;
begin
  for I := 0 to 3 do
    Corners[I] := False;
end;
 
 
end.
 