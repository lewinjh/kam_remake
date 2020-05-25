unit KM_UnitActionStormAttack;
{$I KaM_Remake.inc}
interface
uses
  Classes, Math,
  KM_CommonClasses, KM_Defaults, KM_Points, KM_CommonUtils,
  KM_Units;


{Charge forwards until we are tired or hit an obstacle}
type
  TKMUnitActionStormAttack = class(TKMUnitAction)
  private
    fDelay: Integer; //Delay before action starts
    fTileSteps: Integer; //The number of tiles we have walked onto so far
    fStamina: Integer; //How much stamina to run do we have
    fNextPos: TKMPoint; //The tile we are currently walking to
    fVertexOccupied: TKMPoint; //The diagonal vertex we are currently occupying
    procedure IncVertex(const aFrom, aTo: TKMPoint);
    procedure DecVertex;
  public
    constructor Create(aUnit: TKMUnit; aActionType: TKMUnitActionType; aRow: Integer);
    constructor Load(LoadStream: TKMemoryStream); override;
    destructor Destroy; override;
    function ActName: TKMUnitActionName; override;
    function CanBeInterrupted(aForced: Boolean = True): Boolean; override;
    function GetExplanation: UnicodeString; override;
    function GetSpeed: Single;
    function Execute: TKMActionResult; override;
    procedure Save(SaveStream: TKMemoryStream); override;
  end;

implementation
uses
  KM_Resource, KM_ResUnits, KM_UnitWarrior;


const
  STORM_SPEEDUP = 1.5;


{ TUnitActionStormAttack }
constructor TKMUnitActionStormAttack.Create(aUnit: TKMUnit; aActionType: TKMUnitActionType; aRow: Integer);
const
  //Tiles traveled measured in KaM TPR: Min 8, maximum 13
  //We reduced the variation in order to make storm attack more useful
  MIN_STAMINA = 12;
  MAX_STAMINA = 13;
begin
  inherited Create(aUnit, aActionType, True);
  fTileSteps      := -1; //-1 so the first initializing step makes it 0
  fDelay          := aRow * 5; //No delay for the first row
  fStamina        := MIN_STAMINA + KaMRandom(MAX_STAMINA-MIN_STAMINA+1, 'TKMUnitActionStormAttack.Create');
  fNextPos        := KMPOINT_ZERO;
  fVertexOccupied := KMPOINT_ZERO;
end;


destructor TKMUnitActionStormAttack.Destroy;
begin
  if not KMSamePoint(fVertexOccupied, KMPOINT_ZERO) then
    DecVertex;
  inherited;
end;


constructor TKMUnitActionStormAttack.Load(LoadStream: TKMemoryStream);
begin
  inherited;
  LoadStream.CheckMarker('UnitActionStormAttack');
  LoadStream.Read(fDelay);
  LoadStream.Read(fTileSteps);
  LoadStream.Read(fStamina);
  LoadStream.Read(fNextPos);
  LoadStream.Read(fVertexOccupied);
end;


function TKMUnitActionStormAttack.ActName: TKMUnitActionName;
begin
  Result := uanStormAttack;
end;


function TKMUnitActionStormAttack.GetExplanation: UnicodeString;
begin
  Result := 'Storming';
end;


procedure TKMUnitActionStormAttack.IncVertex(const aFrom, aTo: TKMPoint);
begin
  //Tell gTerrain that this vertex is being used so no other unit walks over the top of us
  Assert(KMSamePoint(fVertexOccupied, KMPOINT_ZERO), 'Storm vertex in use');
  //Assert(not gTerrain.HasVertexUnit(KMGetDiagVertex(aFrom,aTo)), 'Storm vertex blocked');

  fUnit.VertexAdd(aFrom,aTo); //Running counts as walking
  fVertexOccupied := KMGetDiagVertex(aFrom,aTo);
end;


procedure TKMUnitActionStormAttack.DecVertex;
begin
  //Tell gTerrain that this vertex is not being used anymore
  Assert(not KMSamePoint(fVertexOccupied, KMPOINT_ZERO), 'DecVertex 0:0 Storm');

  fUnit.VertexRem(fVertexOccupied);
  fVertexOccupied := KMPOINT_ZERO;
end;


function TKMUnitActionStormAttack.GetSpeed: Single;
begin
  if (fTileSteps <= 0) or (fTileSteps >= fStamina-1) then
    Result := gRes.Units[fUnit.UnitType].Speed
  else
    Result := gRes.Units[fUnit.UnitType].Speed * STORM_SPEEDUP;
end;


function TKMUnitActionStormAttack.Execute: TKMActionResult;
var
  DX, DY: ShortInt;
  WalkX, WalkY, Distance: Single;
begin
  if KMSamePoint(fNextPos, KMPOINT_ZERO) then
    fNextPos := fUnit.CurrPosition; //Set fNextPos to current pos so it initializes on the first run

  //Walk for the first step before running
  if fDelay > 0 then
  begin
    Dec(fDelay);
    fUnit.AnimStep := UNIT_STILL_FRAMES[fUnit.Direction];
    Result := arActContinues;
    Exit;
  end;

  //Last step is walking, others are running (unit gets tired and slows at the end)
  //In KaM the first step was also walking, but this makes it less useful/surprising
  if (fTileSteps >= fStamina - 1) then
  begin
    Distance := gRes.Units[fUnit.UnitType].Speed;
    fType := uaWalk;
  end else begin
    Distance := gRes.Units[fUnit.UnitType].Speed * STORM_SPEEDUP;
    fType := uaSpec;
  end;

  if KMSamePointF(fUnit.PositionF, KMPointF(fNextPos), Distance/2) then
  begin
    inc(fTileSteps); //We have stepped on a new tile
    //Set precise position to avoid rounding errors
    fUnit.PositionF := KMPointF(fNextPos);

    //No longer using previous vertex
    if KMStepIsDiag(fUnit.PrevPosition, fUnit.NextPosition) and (fTileSteps > 0) then
      DecVertex;

    //Check for units nearby to fight
    Locked := False; //Unlock during this check only so CheckForEnemy can abandon our action
    if (fUnit is TKMUnitWarrior) then
      if TKMUnitWarrior(fUnit).CheckForEnemy then
      begin
        //If we've picked a fight it means this action no longer exists,
        //so we must exit out (don't set ActDone as that will now apply to fight action)
        Result := arActContinues;
        Exit;
      end;
    Locked := True; //Finished CheckForEnemy, so lock again

    //Begin the next step
    fNextPos := KMGetPointInDir(fUnit.CurrPosition, fUnit.Direction);

    //Action ends if: 1: Used up stamina. 2: There is an enemy to fight. 3: NextPos is an obsticle
    if (fTileSteps >= fStamina) or not fUnit.CanStepTo(fNextPos.X, fNextPos.Y, fUnit.DesiredPassability) then
    begin
      Result := arActDone; //Finished run
      Exit; //Must exit right away as we might have changed this action to fight
    end;

    //Do some house keeping because we have now stepped on a new tile
    fUnit.NextPosition := fNextPos;
    fUnit.Walk(fUnit.PrevPosition, fUnit.NextPosition); //Pre-occupy next tile
    if KMStepIsDiag(fUnit.PrevPosition,fUnit.NextPosition) then
      IncVertex(fUnit.PrevPosition,fUnit.NextPosition);
  end;

  WalkX := fNextPos.X - fUnit.PositionF.X;
  WalkY := fNextPos.Y - fUnit.PositionF.Y;
  DX := Sign(WalkX); //-1,0,1
  DY := Sign(WalkY); //-1,0,1

  if (DX <> 0) and (DY <> 0) then
    Distance := Distance / 1.41; {sqrt (2) = 1.41421 }

  fUnit.PositionF := KMPointF(fUnit.PositionF.X + DX*Math.min(Distance, Abs(WalkX)),
                              fUnit.PositionF.Y + DY*Math.min(Distance, Abs(WalkY)));

  inc(fUnit.AnimStep);
  StepDone := false; //We are not actually done because now we have just taken another step
  Result := arActContinues;
end;


procedure TKMUnitActionStormAttack.Save(SaveStream: TKMemoryStream);
begin
  inherited;
  SaveStream.PlaceMarker('UnitActionStormAttack');
  SaveStream.Write(fDelay);
  SaveStream.Write(fTileSteps);
  SaveStream.Write(fStamina);
  SaveStream.Write(fNextPos);
  SaveStream.Write(fVertexOccupied);
end;


function TKMUnitActionStormAttack.CanBeInterrupted(aForced: Boolean = True): Boolean;
begin
  Result := not Locked; //Never interupt storm attack
end;


end.
