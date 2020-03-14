unit KM_DevPerfLog;
{$I KaM_Remake.inc}
interface
uses
  Classes, Math, StrUtils, SysUtils,
//  {$IFDEF DESKTOP}
  Vcl.Forms, Vcl.Controls,
//  {$ENDIF}
  {KM_Vertexes, }KM_CommonTypes,
  KM_DevPerfLogSingle, KM_DevPerfLogStack, KM_DevPerfLogTypes;


type
//  TPerfSectionDev = (
//    psNone,
//    psGameTick,
//      psHands,
//      psGameFOW,
//      psPathfinding,
//      psHungarian,
//      psAIFields,
//      psTerrain,
//      psTerrainFinder,
//    psFrameFullC,                 // Full render frame as seen by gMain
//    psFrameFullG,                 // Full render frame on GPU (doublecheck TKMPerfLogGFXStack)
//      psFrameGame,                // Frame of the Gameplay without GUI
//        psFrameFOW,
//        psFrameShadows,
//        psFrameWaterReflections,
//        psFrameRebuildGeoChunk,   // Rebuilding of GeoBlock happens within Render, so we count it here
//        psFrameRebuildWaterChunk,   // Rebuilding of GeoBlock happens within Render, so we count it here
//        psFrameNavDebug,          // Navigation debug display
//      psFrameGui                  // Frame of the Gameplay GUI
//  );
//  TPerfSectionSet = set of TPerfSectionDev;

  // Collection of PerfLoggers
  TKMPerfLogs = class
  private
    fItems: array [TPerfSectionDev] of TKMPerfLogSingle;
    fStackCPU: TKMPerfLogStackCPU;
    fStackGFX: TKMPerfLogStackGFX;
    function GetItem(aSection: TPerfSectionDev): TKMPerfLogSingle;
    function GetStackCPU: TKMPerfLogStackCPU;
    function GetStackGFX: TKMPerfLogStackGFX;
  public
    FrameBudget: Integer;
    Smoothing: Boolean;
    SaveOnExit: Boolean;

    constructor Create(aSections: TPerfSectionSet; aHighPrecision: Boolean);
    destructor Destroy; override;

    property Items[aSection: TPerfSectionDev]: TKMPerfLogSingle read GetItem; default;
    property StackCPU: TKMPerfLogStackCPU read GetStackCPU;
    property StackGFX: TKMPerfLogStackGFX read GetStackGFX;

    procedure SectionEnter(aSection: TPerfSectionDev; aTick: Integer = -1; aTag: Integer = 0);
    procedure SectionLeave(aSection: TPerfSectionDev);

    procedure Clear;

    procedure Render(aLeft, aWidth, aHeight: Integer);
    procedure SaveToFile(aFilename: string; aSaveThreshold: Integer = 10);
//    {$IFDEF DESKTOP}
    procedure ShowForm(aContainer: TWinControl);
//    {$ENDIF}

//    class function GetSectionName(aSection: TPerfSectionDev): string;
  end;


const
  // Tabs are for GUI structure
  // Can not use typed constants within another constants declaration :(
  // http://stackoverflow.com/questions/28699518/
  // Avoid Green, it blends with mostly green terrain
  SECTION_INFO: array [TPerfSectionDev] of record
    Name: string;
    ClassName: TKMPerfLogClass;
    Color: TKMColor3f;
  end = (
    (Name: 'None';                    ClassName: TKMPerfLogSingleCPU; Color: (R:0;G:0;B:0);),
    (Name: 'GameTick';                ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:1;B:0);),
    (Name: '   Hands';                ClassName: TKMPerfLogSingleCPU; Color: (R:1;G:0.25;B:0);),
    (Name: '   FOW';                  ClassName: TKMPerfLogSingleCPU; Color: (R:0;G:0.75;B:0);),
    (Name: '   Pathfinding';          ClassName: TKMPerfLogSingleCPU; Color: (R:0.0;G:1;B:0.75);),
    (Name: '   HungarianReorder';     ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:0;B:1);),
    (Name: '   AIFields';             ClassName: TKMPerfLogSingleCPU; Color: (R:0;G:0.5;B:1);),
    (Name: '   Terrain';              ClassName: TKMPerfLogSingleCPU; Color: (R:0.5;G:0.5;B:0.5);),
    (Name: '   TerrainFinder';        ClassName: TKMPerfLogSingleCPU; Color: (R:0;G:1;B:1);),
    (Name: 'Render.CPU';              ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:0;B:0);),
    (Name: 'Render.GFX';              ClassName: TKMPerfLogSingleGFX; Color: (R:1.0;G:1;B:0);),
//    (Name: 'Render.GFX';              ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:1;B:0);),
    (Name: '   Game';                 ClassName: TKMPerfLogSingleCPU; Color: (R:0.75;G:0.75;B:0);),
    (Name: '      FOW';               ClassName: TKMPerfLogSingleCPU; Color: (R:0;G:0.75;B:0);),
    (Name: '      Shadows';           ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:0;B:1.0);),
    (Name: '      WaterReflections';  ClassName: TKMPerfLogSingleCPU; Color: (R:0.0;G:0.25;B:1);),
    (Name: '      RebuildGeoChunk';   ClassName: TKMPerfLogSingleCPU; Color: (R:0.5;G:1;B:0.5);),
    (Name: '      RebuildWaterChunk'; ClassName: TKMPerfLogSingleCPU; Color: (R:0.0;G:1;B:0.5);),
    (Name: '      NavigationDebug';   ClassName: TKMPerfLogSingleCPU; Color: (R:0.0;G:1;B:0.75);),
    (Name: '   GUI';                  ClassName: TKMPerfLogSingleCPU; Color: (R:1.0;G:0.25;B:0);)
  );


var
  gPerfLogs: TKMPerfLogs;


implementation
uses
//  {$IFDEF DESKTOP}
  KM_DevPerfLogForm,
//  {$ENDIF}
  TypInfo, KM_Defaults, KM_RenderUI, KM_RenderAux, KM_ResFonts, KM_Points;


{ TKMPerfLogs }
constructor TKMPerfLogs.Create(aSections: TPerfSectionSet; aHighPrecision: Boolean);
var
  I: TPerfSectionDev;
begin
  inherited Create;

  FrameBudget := 5;

  for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
  begin
    fItems[I] := SECTION_INFO[I].ClassName.Create;
    fItems[I].Enabled := (I in aSections);
    fItems[I].Color := TKMColor4f.New(SECTION_INFO[I].Color);
    fItems[I].Display := (I in aSections);
    if fItems[I] is TKMPerfLogSingleCPU then
      TKMPerfLogSingleCPU(fItems[I]).HighPrecision := aHighPrecision;
  end;

  fStackCPU := TKMPerfLogStackCPU.Create;
  fStackGFX := TKMPerfLogStackGFX.Create;
end;


destructor TKMPerfLogs.Destroy;
var
  I: TPerfSectionDev;
  s: string;
begin
  if SaveOnExit then
  begin
    DateTimeToString(s, 'yyyy-mm-dd_hh-nn-ss', Now); //2007-12-23 15-24-33
    gPerfLogs.SaveToFile(ExeDir + 'logs' + PathDelim + 'performance_log_' + s + '.log');
  end;

  for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
    FreeAndNil(fItems[I]);

  FreeAndNil(fStackCPU);
  FreeAndNil(fStackGFX);

  inherited;
end;


function TKMPerfLogs.GetItem(aSection: TPerfSectionDev): TKMPerfLogSingle;
begin
  // This easy check allows us to exit if the Log was not initialized, e.g. in utils
  if Self <> nil then
    Result := fItems[aSection]
  else
    Result := nil;
end;


function TKMPerfLogs.GetStackGFX: TKMPerfLogStackGFX;
begin
  // This easy check allows us to exit if the Log was not initialized, e.g. in utils
  if Self <> nil then
    Result := fStackGFX
  else
    Result := nil;
end;


function TKMPerfLogs.GetStackCPU: TKMPerfLogStackCPU;
begin
  // This easy check allows us to exit if the Log was not initialized, e.g. in utils
  if Self <> nil then
    Result := fStackCPU
  else
    Result := nil;
end;


procedure TKMPerfLogs.SectionEnter(aSection: TPerfSectionDev; aTick: Integer = -1; aTag: Integer = 0);
begin
  if Self = nil then Exit;

  fItems[aSection].SectionEnter(aTick, aTag);
  fStackCPU.SectionEnter(aSection);
end;


procedure TKMPerfLogs.SectionLeave(aSection: TPerfSectionDev);
begin
  if Self = nil then Exit;

  fItems[aSection].SectionLeave;
  fStackCPU.SectionRollback;
end;


procedure TKMPerfLogs.Clear;
var
  PS: TPerfSectionDev;
begin
  for PS := LOW_PERF_SECTION to High(TPerfSectionDev) do
    fItems[PS].Clear;
end;


procedure TKMPerfLogs.Render(aLeft, aWidth, aHeight: Integer);
const
  PAD_SIDE = 40;
  PAD_Y = 10;
  SCALE_Y = 512; // Draw chart 500 px high
  EMA_ALPHA = 0.075; // Exponential Moving Average alpha, picked empirically
var
  I: TPerfSectionDev;
  K: Integer;
  needChart: Boolean;
  y: Single;
  ty: string;
begin
  for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
    fItems[I].Render(aLeft + PAD_SIDE, aLeft + aWidth - PAD_SIDE * 2, aHeight - PAD_Y, SCALE_Y, EMA_ALPHA, FrameBudget, Smoothing);

  // Stacked chart
  fStackCPU.Render(aLeft + PAD_SIDE, aLeft + aWidth - PAD_SIDE * 2, aHeight - PAD_Y, SCALE_Y, EMA_ALPHA, FrameBudget, Smoothing);
//  fStackGFX.Render(PAD_SIDE, aWidth - PAD_SIDE * 2, aHeight - PAD_Y, SCALE_Y, EMA_ALPHA, FrameBudget, Smoothing);
//
  needChart := fStackCPU.Display or fStackGFX.Display;
  for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
    needChart := needChart or fItems[I].Display;

  if needChart then
  begin
    // Baseline
    gRenderAux.Line(aLeft + PAD_SIDE + 0.5, aHeight - PAD_Y + 0.5, aLeft + PAD_SIDE + aWidth + 0.5, aHeight - PAD_Y + 0.5, icWhite);

    // Y-axis ticks
    for K := 0 to 10 do
    begin
      y := SCALE_Y / 10 * K;
      gRenderAux.Line(aLeft + PAD_SIDE + 0.5, aHeight - PAD_Y + 0.5 - y, aLeft + PAD_SIDE - 3.5, aHeight - PAD_Y + 0.5 - y, icWhite);

//      ty := IntToStr(FrameBudget div 10 * K) + 'ms'; FormatFloat('##0.##', aSpeed)
      ty := FormatFloat('##0.#', FrameBudget / 10 * K) + 'ms';
      TKMRenderUI.WriteText(aLeft + PAD_SIDE - 5, Trunc(aHeight - PAD_Y - y - 8), 0, ty, fntMini, taRight);
    end;
  end;
end;


procedure TKMPerfLogs.SaveToFile(aFilename: string; aSaveThreshold: Integer = 10);
var
  I: TPerfSectionDev;
  S: TStringList;
begin
  ForceDirectories(ExtractFilePath(aFilename));

  S := TStringList.Create;

  for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
  if fItems[I].Enabled then
  begin
    //Section name
    S.Append(SECTION_INFO[I].Name);
    S.Append(StringOfChar('-', 60));

    fItems[I].SaveToStringList(S, aSaveThreshold);

    // Gap
    S.Append('');
    S.Append('');
  end;

  S.SaveToFile(aFilename);
  S.Free;
end;


//{$IFDEF DESKTOP}
procedure TKMPerfLogs.ShowForm(aContainer: TWinControl);
var
  form: TFormPerfLogs;
begin
  form := TFormPerfLogs.Create(aContainer);

  form.Parent := aContainer;


  if aContainer = nil then
  begin
    form.Align := alNone;
    form.BorderStyle := bsDialog;
//    form.Left := 227;
//    form.Top := 108;
//    form.ShowModal;
  end;

  form.Show(Self);

//
end;
//{$ENDIF}


end.
