unit KM_MapEditorHistory;
{$I KaM_Remake.inc}
interface
uses
  Classes, Generics.Collections, SysUtils,
  KM_Defaults, KM_Points,
  KM_ResWares, KM_ResHouses, KM_ResTileset, KM_MapEdTypes, KM_Terrain, KM_UnitGroup;


type
  TKMCheckpointArea = (
    caAll,        // Required for initial map state, when we need to Undo everything at once, not "by-area"
    caTerrain,
//    caEmitters,
//    caStockpiles,
//    caTriggers,
//    caWaterLevel,
    caUnits
//    caHouses
//    caFences,
//    caFields
    //todo -cPractical: Other areas
    // Dispositions
    // CenterScreen
    // FOW Revealers
    // Hand Flag Color
    //
  );

  TKMCheckpoint = class
  private
    fArea: TKMCheckpointArea;
    fCaption: string;
  public
    constructor Create(const aCaption: string); overload;
    class function FactoryCreate(aArea: TKMCheckpointArea; const aCaption: string): TKMCheckpoint;
    procedure Apply(aArea: TKMCheckpointArea = caAll); virtual; abstract;
    property Caption: string read fCaption;
    property Area: TKMCheckpointArea read fArea;
    function CanAdjoin(aArea: TKMCheckpointArea): Boolean; virtual;
    procedure Adjoin; virtual;
  end;

  TKMCheckpointTerrain = class(TKMCheckpoint)
  private
    // Each Undo step stores whole terrain for simplicity
    fData: array of array of TKMUndoTile;
    function MakeUndoTile(aTile: TKMTerrainTile; aPaintedTile: TKMPainterTile): TKMUndoTile;
    procedure RestoreTileFromUndo(var aTile: TKMTerrainTile; var aPaintedTile: TKMPainterTile; aUndoTile: TKMUndoTile);
  public
    constructor Create(const aCaption: string);
    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
  end;

//  TKMCheckpointFences = class(TKMCheckpoint)
//  type
//    TKMTerrainFieldRec = record
//      EdgeHFence: Byte;
//      EdgeHOwner: TKMHandID;
//      EdgeVFence: Byte;
//      EdgeVOwner: TKMHandID;
//    end;
//  private
//    // Each Undo step stores whole terrain for simplicity
//    fData: array of array of TKMTerrainFieldRec;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;

//  TKMCheckpointFields = class(TKMCheckpoint)
//  type
//    TKMTerrainFieldRec = record
//      Field: TKMFieldType;
//      Owner: TKMHandID;
//      Age: Byte;
//    end;
//  private
//    // Each Undo step stores whole terrain for simplicity
//    fData: array of array of TKMTerrainFieldRec;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;

//  TKMCheckpointEmitters = class(TKMCheckpoint)
//  private
//    // Each Undo step stores all emitters for simplicity
//    fEmitters: array of record
//      EmitterType: TKMEmitterType;
//      Loc: TKMPoint;
//    end;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;
//
//  TKMCheckpointStockpiles = class(TKMCheckpoint)
//  private
//    // Each Undo step stores all stockpiles for simplicity
//    fStockpiles: array of record
//      Ware: TKMWareType;
//      Loc: TKMPoint;
//      Count: Byte;
//    end;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;
//
//  TKMCheckpointTriggers = class(TKMCheckpoint)
//  private
//    // Each Undo step stores all emitters for simplicity
//    fTriggers: array of record
//      Area: TKMRect;
//      Id: Integer;
//    end;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;

  TKMCheckpointUnits = class(TKMCheckpoint)
  private
    // Each Undo step stores all units for simplicity
    fUnits: array of record
      UnitType: TKMUnitType;
      Position: TKMPoint;
      Dir: TKMDirection;
      Owner: TKMHandID;
      Condition: Integer;
      GroupMemberCount: Integer;
      GroupColumns: Integer;
      GroupOrder: TKMMapEdOrder;
//      CarryWare: TKMWareType;
//      CarryCount: Integer;
    end;
  public
    constructor Create(const aCaption: string);
    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
  end;

//  TKMCheckpointHouses = class(TKMCheckpoint)
//  private
//    // Each Undo step stores all houses for simplicity
//    fHouses: array of record
//      HouseType: TKMHouseType;
//      Position: TKMPoint;
//      Owner: TKMHandID;
//      Health: Integer;
//      WaresIn: array [0..Ord(High(TKMWareType))] of Integer;
//      WaresOut: array [0..Ord(High(TKMWareType))] of Integer;
//    end;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//  end;

//  TKMCheckpointWaterLevel = class(TKMCheckpoint)
//  private
//    // Each Undo step stores all emitters for simplicity
//    fWaterLevel: Single;
//  public
//    constructor Create(const aCaption: string);
//    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
//    function CanAdjoin(aArea: TKMCheckpointArea): Boolean; override;
//    procedure Adjoin; override;
//  end;

  // Checkpoint for everything (used for initial state)
  TKMCheckpointAll = class(TKMCheckpoint)
  private
    fAreas: array [TKMCheckpointArea] of TKMCheckpoint;
  public
    constructor Create(const aCaption: string);
    procedure Apply(aArea: TKMCheckpointArea = caAll); override;
  end;

  // Terrain helper that is used to undo/redo terrain changes in Map Editor
  TKMMapEditorHistory = class
  private
    // State change counter (to update UI)
    fCounter: Cardinal;

    fCheckpointPos: Integer;
    fCheckpoints: TList<TKMCheckpoint>;

    procedure IncCounter;
  public
    constructor Create;
    destructor Destroy; override;

    function CanUndo: Boolean;
    function CanRedo: Boolean;
    property Position: Integer read fCheckpointPos;
    property Counter: Cardinal read fCounter;
    procedure GetCheckpoints(aList: TStringList);

    procedure MakeCheckpoint(aArea: TKMCheckpointArea; const aCaption: string);
    procedure Undo;
    procedure Redo;
  end;


implementation
uses
  KM_HandsCollection, KM_Houses, KM_Hand, KM_Units, KM_UnitsCollection, KM_CommonClasses, KM_UnitWarrior, KM_Utils, KM_Game, KM_CommonUtils;


{ TKMCheckpoint }
constructor TKMCheckpoint.Create(const aCaption: string);
begin
  inherited Create;

  fCaption := aCaption;
end;


class function TKMCheckpoint.FactoryCreate(aArea: TKMCheckpointArea; const aCaption: string): TKMCheckpoint;
begin
  case aArea of
    caAll:        Result := TKMCheckpointAll.Create(aCaption);
    caTerrain:    Result := TKMCheckpointTerrain.Create(aCaption);
//    caFences:     Result := TKMCheckpointFences.Create(aCaption);
//    caFields:     Result := TKMCheckpointFields.Create(aCaption);
//    caEmitters:   Result := TKMCheckpointEmitters.Create(aCaption);
//    caStockpiles: Result := TKMCheckpointStockpiles.Create(aCaption);
//    caTriggers:   Result := TKMCheckpointTriggers.Create(aCaption);
    caUnits:      Result := TKMCheckpointUnits.Create(aCaption);
//    caHouses:     Result := TKMCheckpointHouses.Create(aCaption);
//    caWaterLevel: Result := TKMCheckpointWaterLevel.Create(aCaption);
  else
    raise Exception.Create('Error Message');
  end;
end;


function TKMCheckpoint.CanAdjoin(aArea: TKMCheckpointArea): Boolean;
begin
  Result := False; // Typically not available
end;


procedure TKMCheckpoint.Adjoin;
begin
  // Do nothing as it is typically not available
end;


{ TKMCheckpointTerrain }
constructor TKMCheckpointTerrain.Create(const aCaption: string);
var
  I, K: Integer;
begin
  inherited Create(aCaption);

  fArea := caTerrain;

  SetLength(fData, gTerrain.MapY, gTerrain.MapX);

  for I := 0 to gTerrain.MapY-1 do
  for K := 0 to gTerrain.MapX-1 do
    fData[I,K] := MakeUndoTile(gTerrain.Land[I,K], gGame.TerrainPainter.LandTerKind[I,K]);
end;


function TKMCheckpointTerrain.MakeUndoTile(aTile: TKMTerrainTile; aPaintedTile: TKMPainterTile): TKMUndoTile;
var
  L: Integer;
begin
  Result.BaseLayer.Terrain   := aTile.BaseLayer.Terrain;
  Result.BaseLayer.Rotation  := aTile.BaseLayer.Rotation;
  Result.BaseLayer.Corners   := aTile.BaseLayer.Corners;

  Result.LayersCnt   := aTile.LayersCnt;
  Result.Height      := aTile.Height;
  Result.Obj         := aTile.Obj;
  Result.IsCustom    := aTile.IsCustom;
  Result.BlendingLvl := aTile.BlendingLvl;
  Result.TerKind     := aPaintedTile.TerKind;
  Result.Tiles       := aPaintedTile.Tiles;
  Result.HeightAdd   := aPaintedTile.HeightAdd;
  Result.TileOverlay := aTile.TileOverlay;
  for L := 0 to 2 do
  begin
    Result.Layer[L].Terrain   := aTile.Layer[L].Terrain;
    Result.Layer[L].Rotation  := aTile.Layer[L].Rotation;
    Result.Layer[L].Corners   := aTile.Layer[L].Corners;
  end;
end;


procedure TKMCheckpointTerrain.RestoreTileFromUndo(var aTile: TKMTerrainTile; var aPaintedTile: TKMPainterTile; aUndoTile: TKMUndoTile);
var
  L: Integer;
begin
  aTile.BaseLayer.Terrain   := aUndoTile.BaseLayer.Terrain;
  aTile.BaseLayer.Rotation  := aUndoTile.BaseLayer.Rotation;
  aTile.BaseLayer.Corners   := aUndoTile.BaseLayer.Corners;

  aTile.LayersCnt           := aUndoTile.LayersCnt;
  aTile.Height              := aUndoTile.Height;
  aTile.Obj                 := aUndoTile.Obj;
  aTile.IsCustom            := aUndoTile.IsCustom;
  aTile.BlendingLvl         := aUndoTile.BlendingLvl;
  aPaintedTile.TerKind      := aUndoTile.TerKind;
  aPaintedTile.Tiles        := aUndoTile.Tiles;
  aPaintedTile.HeightAdd    := aUndoTile.HeightAdd;
  aTile.TileOverlay         := aUndoTile.TileOverlay;
  for L := 0 to 2 do
  begin
    aTile.Layer[L].Terrain  := aUndoTile.Layer[L].Terrain;
    aTile.Layer[L].Rotation := aUndoTile.Layer[L].Rotation;
    aTile.Layer[L].Corners  := aUndoTile.Layer[L].Corners;
  end;
end;


procedure TKMCheckpointTerrain.Apply(aArea: TKMCheckpointArea = caAll);
var
  I, K: Integer;
begin
  for I := 0 to gTerrain.MapY-1 do
  for K := 0 to gTerrain.MapX-1 do
    RestoreTileFromUndo(gTerrain.Land[I,K], gGame.TerrainPainter.LandTerKind[I,K], fData[I,K]);

  gTerrain.UpdatePassability(gTerrain.MapRect);
  gTerrain.UpdateLighting(gTerrain.MapRect);
//  gTerrain.ChangeAll;
end;


{ TKMCheckpointFences }
//constructor TKMCheckpointFences.Create(const aCaption: string);
//var
//  I, K: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caFences;
//
//  SetLength(fData, gTerrain.MapY, gTerrain.MapX);
//
//  for I := 0 to gTerrain.MapY-1 do
//  for K := 0 to gTerrain.MapX-1 do
//  begin
//    fData[I,K].EdgeHFence := gTerrain.Land[I,K].EdgeHFence;
//    fData[I,K].EdgeHOwner := gTerrain.Land[I,K].EdgeHOwner;
//    fData[I,K].EdgeVFence := gTerrain.Land[I,K].EdgeVFence;
//    fData[I,K].EdgeVOwner := gTerrain.Land[I,K].EdgeVOwner;
//  end;
//end;
//
//
//procedure TKMCheckpointFences.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I, K: Integer;
//begin
//  for I := 0 to gTerrain.MapY-1 do
//  for K := 0 to gTerrain.MapX-1 do
//  begin
//    gTerrain.Land[I,K].EdgeHFence := fData[I,K].EdgeHFence;
//    gTerrain.Land[I,K].EdgeHOwner := fData[I,K].EdgeHOwner;
//    gTerrain.Land[I,K].EdgeVFence := fData[I,K].EdgeVFence;
//    gTerrain.Land[I,K].EdgeVOwner := fData[I,K].EdgeVOwner;
//  end;
//
//  gTerrain.UpdatePassability(gTerrain.MapRect);
//  gTerrain.ChangeAll;
//end;


{ TKMCheckpointFields }
//constructor TKMCheckpointFields.Create(const aCaption: string);
//var
//  I, K: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caFields;
//
//  SetLength(fData, gTerrain.MapY, gTerrain.MapX);
//
//  for I := 0 to gTerrain.MapY-1 do
//  for K := 0 to gTerrain.MapX-1 do
//  begin
//    fData[I,K].Field := gTerrain.Land[I,K].TileField;
//    fData[I,K].Owner := gTerrain.Land[I,K].TileOwner;
//    fData[I,K].Age := gTerrain.Land[I,K].FieldAge;
//  end;
//end;
//
//
//procedure TKMCheckpointFields.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I, K: Integer;
//begin
//  for I := 0 to gTerrain.MapY-1 do
//  for K := 0 to gTerrain.MapX-1 do
//  begin
//    gTerrain.Land[I,K].TileField := fData[I,K].Field;
//    gTerrain.Land[I,K].TileOwner := fData[I,K].Owner;
//    gTerrain.Land[I,K].FieldAge := fData[I,K].Age;
//  end;
//
//  gTerrain.UpdatePassability(gTerrain.MapRect);
//  gTerrain.ChangeAll;
//end;


//{ TKMCheckpointEmitters }
//constructor TKMCheckpointEmitters.Create(const aCaption: string);
//var
//  I: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caEmitters;
//
//  SetLength(fEmitters, gTerrain.Emitters.Count);
//  for I := 0 to gTerrain.Emitters.Count - 1 do
//  begin
//    fEmitters[I].EmitterType := gTerrain.Emitters[I].EmitterType;
//    fEmitters[I].Loc := gTerrain.Emitters[I].Loc;
//  end;
//end;
//
//
//procedure TKMCheckpointEmitters.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I: Integer;
//begin
//  gTerrain.Emitters.Clear;
//
//  for I := 0 to High(fEmitters) do
//    gTerrain.Emitters.Add(fEmitters[I].EmitterType, fEmitters[I].Loc);
//end;
//
//
//{ TKMCheckpointStockpiles }
//constructor TKMCheckpointStockpiles.Create(const aCaption: string);
//var
//  I: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caStockpiles;
//
//  SetLength(fStockpiles, gTerrain.Stockpiles.Count);
//  for I := 0 to gTerrain.Stockpiles.Count - 1 do
//  begin
//    fStockpiles[I].Ware := gTerrain.Stockpiles[I].Ware;
//    fStockpiles[I].Loc := gTerrain.Stockpiles[I].Loc;
//    fStockpiles[I].Count := gTerrain.Stockpiles[I].Count;
//  end;
//end;
//
//
//procedure TKMCheckpointStockpiles.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I: Integer;
//begin
//  gTerrain.Stockpiles.Clear;
//
//  for I := 0 to High(fStockpiles) do
//    gTerrain.Stockpiles.AddStockpile(fStockpiles[I].Ware, fStockpiles[I].Loc, fStockpiles[I].Count);
//end;
//
//
//{ TKMCheckpointTriggers }
//constructor TKMCheckpointTriggers.Create(const aCaption: string);
//var
//  I: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caTriggers;
//
//  SetLength(fTriggers, gTerrain.Triggers.Count);
//  for I := 0 to gTerrain.Triggers.Count - 1 do
//  begin
//    fTriggers[I].Area := gTerrain.Triggers[I].Area;
//    fTriggers[I].Id := gTerrain.Triggers[I].Id;
//  end;
//end;
//
//
//procedure TKMCheckpointTriggers.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I: Integer;
//begin
//  gTerrain.Triggers.Clear;
//
//  for I := 0 to High(fTriggers) do
//    gTerrain.Triggers.Add(fTriggers[I].Area, fTriggers[I].Id);
//end;


{ TKMCheckpointUnits }
constructor TKMCheckpointUnits.Create(const aCaption: string);
var
  I, K, L: Integer;
  unitCount: Integer;
  U: TKMUnit;
  G: TKMUnitGroup;
begin
  inherited Create(aCaption);

  fArea := caUnits;

  unitCount := gHands.PlayerAnimals.Units.Count;
  for I := 0 to gHands.Count - 1 do
    Inc(unitCount, gHands[I].Units.Count);

  L := 0;
  SetLength(fUnits, unitCount);

  // Animals
  for K := 0 to gHands.PlayerAnimals.Units.Count - 1 do
  begin
    U := gHands.PlayerAnimals.Units[K];
    if (U.UnitType in [ANIMAL_MIN..ANIMAL_MAX])
      and not gHands.PlayerAnimals.Units[K].IsDeadOrDying then
    begin
      fUnits[L].UnitType := U.UnitType;
      fUnits[L].Position := U.CurrPosition;
      fUnits[L].Owner := I;

      fUnits[L].Condition := U.Condition;

      Inc(L);
    end;
  end;

  for I := 0 to gHands.Count - 1 do
  begin
    // Units
    for K := 0 to gHands[I].Units.Count - 1 do
    if not gHands[I].Units[K].IsDeadOrDying then
    begin
      U := gHands[I].Units[K];
      if U.UnitType in [CITIZEN_MIN..CITIZEN_MAX] then
//      if U is TKMCivilUnit then
      begin
        fUnits[L].UnitType := U.UnitType;
        fUnits[L].Position := U.CurrPosition;
        fUnits[L].Owner := I;

        fUnits[L].Condition := U.Condition;

        Inc(L);
      end;
    end;

    // Groups
    for K := 0 to gHands[I].UnitGroups.Count - 1 do
    if not gHands[I].UnitGroups[K].IsDead then
    begin
      G := gHands[I].UnitGroups[K];
      fUnits[L].UnitType := G.UnitType;
      fUnits[L].Position := G.Position;
      fUnits[L].Dir := G.Direction;
      fUnits[L].Owner := I;
      fUnits[L].Condition := G.Condition;

      fUnits[L].GroupMemberCount := G.MapEdCount;
      fUnits[L].GroupColumns := G.UnitsPerRow;
      fUnits[L].GroupOrder := G.MapEdOrder;

      Inc(L);
    end;
  end;

  // Trim to actual length (which is always smaller due to erased(dead) units)
  SetLength(fUnits, L);
end;


procedure TKMCheckpointUnits.Apply(aArea: TKMCheckpointArea = caAll);
var
  I: Integer;
  U: TKMUnit;
  G: TKMUnitGroup;
begin
  for I := 0 to gHands.Count - 1 do
  begin
    gHands[I].UnitGroups.Clear;
    gHands[I].Units.Clear;
  end;

  for I := 0 to High(fUnits) do
  begin
    if fUnits[I].UnitType in [CITIZEN_MIN..CITIZEN_MAX] then
      U := gHands[fUnits[I].Owner].AddUnit(fUnits[I].UnitType, fUnits[I].Position, False)
    else
    if fUnits[I].UnitType in [WARRIOR_MIN..WARRIOR_MAX] then
      U := gHands[fUnits[I].Owner].AddUnitGroup(fUnits[I].UnitType, fUnits[I].Position, dirS, 1, 1).FlagBearer
    else
      U := gHands.PlayerAnimals.AddUnit(fUnits[I].UnitType, fUnits[I].Position);

    U.Condition := fUnits[I].Condition;

    // Warriors
    if fUnits[I].UnitType in [WARRIOR_MIN..WARRIOR_MAX] then
    begin
      Assert(U is TKMUnitWarrior);

      U.Direction := fUnits[I].Dir;
      G := gHands[fUnits[I].Owner].UnitGroups.AddGroup(TKMUnitWarrior(U));
      G.MapEdCount := fUnits[I].GroupMemberCount;
      G.UnitsPerRow := fUnits[I].GroupColumns;
      G.MapEdOrder := fUnits[I].GroupOrder;
    end;
  end;
end;


{ TKMCheckpointHouses }
//constructor TKMCheckpointHouses.Create(const aCaption: string);
//  procedure AddHouse(aHouse: TKMHouse; var aCount: Integer);
//  var
//    I: Integer;
//    spec: TKMHouseSpec;
//  begin
//    fHouses[aCount].HouseType := aHouse.HouseType;
//    fHouses[aCount].Position := aHouse.Position;
//    fHouses[aCount].Owner := aHouse.Owner;
//    fHouses[aCount].Health := aHouse.GetHealth;
//
//    spec := gRes.Houses[aHouse.HouseType];
//
//    for I := 0 to spec.WareInCount - 1 do
//      fHouses[aCount].WaresIn[I] := aHouse.WareInPeek(I);
//
//    for I := 0 to spec.WareOutCount - 1 do
//      fHouses[aCount].WaresOut[I] := aHouse.WareOutPeek(I);
//
//    Inc(aCount);
//  end;
//var
//  I, K, houseCount: Integer;
//begin
//  inherited Create(aCaption);
//
//  fArea := caHouses;
//
//  houseCount := 0;
//  for I := 0 to gHands.Count - 1 do
//    Inc(houseCount, gHands[I].Houses.Count);
//  SetLength(fHouses, houseCount);
//  houseCount := 0;
//
//  for I := 0 to gHands.Count - 1 do
//  for K := 0 to gHands[I].Houses.Count - 1 do
//  if not gHands[I].Houses[K].IsDestroyed then
//    AddHouse(gHands[I].Houses[K], houseCount);
//
//  // Trim to actual length (which is always smaller due to erased(dead) Houses)
//  SetLength(fHouses, houseCount);
//end;
//
//
//procedure TKMCheckpointHouses.Apply(aArea: TKMCheckpointArea = caAll);
//var
//  I, K: Integer;
//  H: TKMHouse;
//  spec: TKMHouseSpec;
//begin
//  // Remove all houses and apply them anew
//  for I := 0 to gHands.Count - 1 do
//    gHands[I].Houses.Clear;
//
//  for I := 0 to High(fHouses) do
//  begin
//    H := gHands[fHouses[I].Owner].HouseAdd(fHouses[I].HouseType, fHouses[I].Position, fHouses[I].Face, tpHouseScript);
//    H.AddDamage(H.HealthMax - fHouses[I].Health, nil, True);
//
//    spec := gRes.Houses[fHouses[I].HouseType];
//
//    for K := 0 to spec.WareInCount - 1 do
//    if fHouses[I].WaresIn[K] > 0 then
//      H.WareInAdd(K, fHouses[I].WaresIn[K], wstNoChange);
//
//    for K := 0 to spec.WareOutCount - 1 do
//    if fHouses[I].WaresOut[K] > 0 then
//      H.WareOutAdd(K, fHouses[I].WaresOut[K], wstNoChange);
//  end;
//end;


{ TKMCheckpointWaterLevel }
//constructor TKMCheckpointWaterLevel.Create(const aCaption: string);
//begin
//  inherited Create(aCaption);
//
//  fArea := caWaterLevel;
//
//  fWaterLevel := gTerrain.Waterbody.WaterLevel;
//end;
//
//
//procedure TKMCheckpointWaterLevel.Apply(aArea: TKMCheckpointArea);
//begin
//  gTerrain.Waterbody.WaterLevel := fWaterLevel;
//end;
//
//
//function TKMCheckpointWaterLevel.CanAdjoin(aArea: TKMCheckpointArea): Boolean;
//begin
//  Result := aArea = fArea;
//end;
//
//
//procedure TKMCheckpointWaterLevel.Adjoin;
//begin
//  fWaterLevel := gTerrain.Waterbody.WaterLevel;
//end;


{ TKMCheckpointAll }
constructor TKMCheckpointAll.Create(const aCaption: string);
var
  I: TKMCheckpointArea;
begin
  inherited Create(aCaption);

  fArea := caAll;

  for I := Low(TKMCheckpointArea) to High(TKMCheckpointArea) do
  if I <> caAll then
    fAreas[I] := TKMCheckpoint.FactoryCreate(I, aCaption);
end;


procedure TKMCheckpointAll.Apply(aArea: TKMCheckpointArea = caAll);
var
  I: TKMCheckpointArea;
begin
  for I := Low(TKMCheckpointArea) to High(TKMCheckpointArea) do
  if (I <> caAll) and ((aArea = caAll) or (I = aArea)) then
    fAreas[I].Apply;
end;


{ TKMMapEditorHistory }
constructor TKMMapEditorHistory.Create;
begin
  inherited;

  fCheckpoints := TList<TKMCheckpoint>.Create;
end;


destructor TKMMapEditorHistory.Destroy;
begin
  fCheckpoints.Free;

  inherited;
end;


procedure TKMMapEditorHistory.MakeCheckpoint(aArea: TKMCheckpointArea; const aCaption: string);
var
  cp: TKMCheckpoint;
begin
  // Delete all Redo checkpoints, as they've become invalid with this new change
  while fCheckpointPos < fCheckpoints.Count - 1 do
    fCheckpoints.Delete(fCheckpoints.Count - 1);

  // Register change
  if (fCheckpoints.Count > 0) and fCheckpoints.Last.CanAdjoin(aArea) then
  begin
    // Sometimes we can adjoin checkpoints
    fCheckpoints.Last.Adjoin;
  end else
  begin
    // Otherwise create new one
    cp := TKMCheckpoint.FactoryCreate(aArea, aCaption);
    fCheckpoints.Add(cp);
    fCheckpointPos := fCheckpoints.Count - 1;
    IncCounter;
  end;
end;


function TKMMapEditorHistory.CanUndo: Boolean;
begin
  Result := fCheckpointPos > 0;
end;


function TKMMapEditorHistory.CanRedo: Boolean;
begin
  Result := fCheckpointPos < fCheckpoints.Count - 1;
end;


// Get list of available checkpoints (tag current/prev/next with a color)
procedure TKMMapEditorHistory.GetCheckpoints(aList: TStringList);
var
  I: Integer;
  s: string;
begin
  aList.Clear;

  for I := 0 to fCheckpoints.Count - 1 do
  begin
    s := fCheckpoints[I].Caption;

    // Undo checkpoints are white (no color-wrap)
    // Current checkpoint highlighted in yellow
    // Redo checkpoints highlighted in light-grey
    if I = fCheckpointPos then
      s := WrapColor(s, $88FFFF)
    else
    if I > fCheckpointPos then
      s := WrapColor(s, $AAAAAA);

    aList.Append(s);
  end;
end;


procedure TKMMapEditorHistory.IncCounter;
begin
  Inc(fCounter);
end;


procedure TKMMapEditorHistory.Undo;
var
  prev: Integer;
begin
  // Find previous state of area we are undoing ("Initial" state at 0 being our last chance)
  prev := fCheckpointPos - 1;
  while prev > 0 do
  begin
    if fCheckpoints[prev].Area = fCheckpoints[fCheckpointPos].Area then
      Break;
    Dec(prev);
  end;

  Assert(prev >= 0);

  // Apply only requested area (e.g. if we are undoing single change made to Houses at step 87 since editing start)
  fCheckpoints[prev].Apply(fCheckpoints[fCheckpointPos].Area);

  Dec(fCheckpointPos);

  IncCounter;
end;


procedure TKMMapEditorHistory.Redo;
var
  next: Integer;
begin
  next := fCheckpointPos + 1;

  Assert(next <= fCheckpoints.Count - 1);

  fCheckpoints[next].Apply;
  fCheckpointPos := next;

  IncCounter;
end;


end.
