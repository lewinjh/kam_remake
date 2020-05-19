unit KM_UnitVisual;
{$I KaM_Remake.inc}
interface
uses
  KM_Points, KM_Defaults;

type
  TKMUnitVisualState = record
    PosF: TKMPointF;
    Dir: TKMDirection;
    SlideX, SlideY: Single;
    Action: TKMUnitActionType;
    AnimStep: Integer;
    AnimFraction: Single;

    procedure SetFromUnit(aUnit: TObject);
  end;

  // Purely visual thing. Split from TKMUnit to aviod mixup of game-logic and render Positions
  TKMUnitVisual = class
  private
    fUnit: TObject;
    Curr: TKMUnitVisualState;
    Prev: TKMUnitVisualState;
  public
    constructor Create(aUnit: TObject);

    function GetLerp(aLag: Single): TKMUnitVisualState;
    procedure UpdateState;
  end;


implementation
uses
  KromUtils, Math, SysUtils,
  KM_Units;


{ TKMUnitVisualState }
procedure TKMUnitVisualState.SetFromUnit(aUnit: TObject);
var
  U: TKMUnit;
begin
  U := TKMUnit(aUnit);
  PosF := U.PositionF;
  Dir := U.Direction;
  SlideX := U.GetSlide(axX);
  SlideY := U.GetSlide(axY);
  AnimStep := U.AnimStep;
  AnimFraction := 0.0;

  if U.Action <> nil then
    Action := U.Action.ActionType
  else
    Action := uaUnknown;
end;


{ TKMUnitVisual }
constructor TKMUnitVisual.Create(aUnit: TObject);
begin
  inherited Create;
  fUnit := TKMUnit(aUnit);
  Prev.SetFromUnit(fUnit);
  Curr.SetFromUnit(fUnit);
end;


function TKMUnitVisual.GetLerp(aLag: Single): TKMUnitVisualState;
begin
  Result.PosF := KMLerp(Curr.PosF, Prev.PosF, aLag);
  Result.SlideX := KromUtils.Lerp(Curr.SlideX, Prev.SlideX, aLag);
  Result.SlideY := KromUtils.Lerp(Curr.SlideY, Prev.SlideY, aLag);
  //If there's no lag, use the current state
  if aLag = 0.0 then
  begin
    Result.Dir := Curr.Dir;
    Result.Action := Curr.Action;
    Result.AnimStep := Curr.AnimStep;
    Result.AnimFraction := 0.0;
  end
  else
  begin
    //Don't start a new action or change direction until the last one is 100% finished
    Result.Dir := Prev.Dir;
    Result.Action := Prev.Action;
    Result.AnimStep := Prev.AnimStep;
    Result.AnimFraction := 0.0;
    //If action/dir/step is consistent we can interpolate the animation
    if (Curr.Action = Prev.Action) and (Curr.Dir = Prev.Dir) and (Curr.AnimStep - Prev.AnimStep = 1) then
      Result.AnimFraction := 1.0 - aLag;
  end;
end;


procedure TKMUnitVisual.UpdateState;
begin
  Prev := Curr;
  Curr.SetFromUnit(fUnit);
end;

end.
