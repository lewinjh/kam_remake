unit KM_DevPerfLogSingle;
{$I KM_CompilerDirectives.inc}
interface
uses
  Classes, Math, StrUtils, SysUtils,
  KM_Vertexes;


type
  // Log how much time each section takes and write results to a file or HUD
  // It is simpler to keep CPU/GPU separate, so we can enable/show them individually
  TKMPerfLogClass = class of TKMPerfLogSingle;
  TKMPerfLogSingle = class
  private
    fCount: Integer;
    fTimes: array of record
      Time: Int64;
      Tag: Integer;
    end;
  protected
    fEnterTick: Integer;
    fEnterTag: Integer;
    procedure DoSectionEnter; virtual; abstract;
    procedure DoSectionLeave; virtual; abstract;
  public
    Enabled: Boolean;
    Display: Boolean;
    Color: TKMColor4f;
    constructor Create; virtual; // Needs to be virtual (see more info inside)
    procedure SectionEnter(aTick: Integer = -1; aTag: Integer = 0);
    procedure SectionLeave;
    procedure Render(aLeft, aWidth, aHeight, aScaleY: Integer; aEmaAlpha: Single; aFrameBudget: Integer; aSmoothing: Boolean);
    procedure SaveToFile(aFilename: string; aSaveThreshold: Integer);
    procedure SaveToStringList(aStringList: TStringList; aSaveThreshold: Integer);
  end;

  // CPU logging
  TKMPerfLogSingleCPU = class(TKMPerfLogSingle)
  private
    fEnterTime: Int64;
  protected
    procedure DoSectionEnter; override;
    procedure DoSectionLeave; override;
  public
    HighPrecision: Boolean;
  end;

  // GPU logging
  // Async through gRenderLow.Queries
  // Largely replaced with TKMPerfLogGFXStack
  // Do not delete it, we might need it for non-frame dependant things (e.g. measure GPU cost of Buffers updates)
  TKMPerfLogSingleGFX = class(TKMPerfLogSingle)
  private
    fGPUQueryId: Integer;
  protected
    procedure DoSectionEnter; override;
    procedure DoSectionLeave; override;
  public
    constructor Create; override; // Needs to be overriden (see TKMPerfLogSingle.Create for info)
    destructor Destroy; override;
  end;


implementation
uses
  KM_RenderLow, KM_RenderTypes, KM_Utils;


{ TKMPerfLogSingle }
constructor TKMPerfLogSingle.Create;
begin
  inherited;

  // Need a virtual constructor, so child classes could override it, so their constructors get called
  // when referenced as ClassName: TKMPerfLogClass; ClassName.Create
  // Otherwise, only base TObject class constructor gets called, yet objects are instances of ClassName
end;


// aTick - Tick to which the result gets appended (for example multiple FOW calls can be stacked within the same tick)
// aTag - mark the Tick (e.g. render frame can be marked with a game tick it displayed)
procedure TKMPerfLogSingle.SectionEnter(aTick: Integer = -1; aTag: Integer = 0);
begin
  // This easy check allows us to exit if the Log was not initialized, e.g. in untils
  if Self = nil then Exit;
  if not Enabled then Exit;

  fEnterTick := aTick;
  fEnterTag := aTag;

  DoSectionEnter;
end;


procedure TKMPerfLogSingle.SectionLeave;
begin
  // This easy check allows us to exit if the Log was not initialized, e.g. in untils
  if Self = nil then Exit;
  if not Enabled then Exit;

  DoSectionLeave;
end;


procedure TKMPerfLogSingle.Render(aLeft, aWidth, aHeight, aScaleY: Integer; aEmaAlpha: Single; aFrameBudget: Integer; aSmoothing: Boolean);
var
  I, K: Integer;
  vaChart: TKMVertex2Array;
  cCount: Integer;
  accum: Single;
begin
  if not Display then Exit;

  cCount := Min(fCount, aWidth);
  SetLength(vaChart, cCount);

  accum := aHeight;

  for I := cCount - 1 downto 0 do
  begin
    // Instant reading
    K := fCount - 1 - I;
    vaChart[I] := TKMVertex2.New(aLeft + I + 0.5, aHeight + 0.5 - fTimes[K].Time / 1000 / aFrameBudget * aScaleY);

    if aSmoothing then
    begin
      // Exponential Moving Average
      accum := aEmaAlpha * vaChart[I].Y + (1 - aEmaAlpha) * accum;
      vaChart[I].Y := accum;
    end;
  end;

  // Chart
  gRenderLow.Draw.RenderLine2(vaChart, Color, 1, lmStrip)
end;


// Save to file for standalone version running without TKMPerfLogs
procedure TKMPerfLogSingle.SaveToFile(aFilename: string; aSaveThreshold: Integer);
var
  sl: TStringList;
begin
  sl := TStringList.Create;
  SaveToStringList(sl, aSaveThreshold);
  sl.SaveToFile(aFilename);
  sl.Free;
end;


procedure TKMPerfLogSingle.SaveToStringList(aStringList: TStringList; aSaveThreshold: Integer);
var
  I: Integer;
  total: Int64;
begin
  total := 0;

  // Times (when Disabled Count is 0)
  for I := 0 to fCount - 1 do
  begin
    Inc(total, fTimes[I].Time);

    if fTimes[I].Time >= aSaveThreshold then
      aStringList.Append(Format('%d'#9'%d'#9'%d', [I, fTimes[I].Tag, fTimes[I].Time]));
  end;

  aStringList.Append('Total ' + FloatToStr(total/1000) + 'msec');
end;


{ TKMPerfLogSingleCPU }
procedure TKMPerfLogSingleCPU.DoSectionEnter;
begin
  if HighPrecision then
    fEnterTime := TimeGetUsec
  else
    fEnterTime := TimeGet;
end;


procedure TKMPerfLogSingleCPU.DoSectionLeave;
var
  tgt: Integer;
  T: Int64;
begin
  if HighPrecision then
    T := TimeGetUsecSince(fEnterTime)
  else
    T := TimeGetSince(fEnterTime) * 1000;

  if fEnterTick = -1 then
    tgt := fCount + 1
  else
    tgt := fEnterTick;

  if tgt >= Length(fTimes) then
    SetLength(fTimes, tgt + 1024);

  fTimes[tgt].Tag := fEnterTag;
  if fEnterTick = -1 then
    fTimes[tgt].Time := T
  else
    fTimes[tgt].Time := fTimes[tgt].Time + T;

  fCount := Max(fCount, tgt);
end;


{ TKMPerfLogSingleGFX }
constructor TKMPerfLogSingleGFX.Create;
begin
  inherited;

  fGPUQueryId := -1;
end;


destructor TKMPerfLogSingleGFX.Destroy;
begin
  if fGPUQueryId <> -1 then
    gRenderLow.Query.QueriesDelete(fGPUQueryId);

  inherited;
end;


procedure TKMPerfLogSingleGFX.DoSectionEnter;
begin
  if fGPUQueryId = -1 then
    fGPUQueryId := gRenderLow.Query.QueriesGen;

  gRenderLow.Query.QueriesBegin(fGPUQueryId);
end;


procedure TKMPerfLogSingleGFX.DoSectionLeave;
var
  T: Int64;
begin
  gRenderLow.Query.QueriesEnd(fGPUQueryId);

  // Get us time from previous frame
  T := gRenderLow.Query.QueriesTime(fGPUQueryId);
  T := Round(T / 1000);

  if fEnterTick = -1 then
    Inc(fCount)
  else
    fCount := fEnterTick;

  if fCount-1 >= Length(fTimes) then
    SetLength(fTimes, fCount + 1024);

  fTimes[fCount-1].Tag := fEnterTag;
  if fEnterTick = -1 then
    fTimes[fCount-1].Time := T
  else
    fTimes[fCount-1].Time := fTimes[fCount-1].Time + T;
end;


end.
