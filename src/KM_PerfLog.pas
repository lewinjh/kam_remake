unit KM_PerfLog;
{$I KaM_Remake.inc}
interface
uses
  Generics.Collections;


type
  TPerfSection = (psTick, psHungarian, psAIFields, psFOW,
                  psFOWCheck, psFOWCheck3, psFOWCheck5,
                  psRender,
                  psRenderTer,
                  psRenderTerBase, psUpdateVBO, psDoTiles, psDoWater, psDoTilesLayers, psDoOverlays, psDoLighting, psDoShadows,
                  psRenderFences, psRenderPlans,
                  psRenderOther, psRenderList, psRenderHands, psRenderFOW,
                  psHands, psPathfinding, psTerrain, psGIP, psScripting);

const
  SKIP_SECTION: set of TPerfSection = [psHungarian, psAIFields, psFOW, psFOWCheck, psFOWCheck3, psFOWCheck5,
                                       psRenderOther, psRenderList, psRenderHands, psRenderFOW,
                                       psHands, psPathfinding, psTerrain, psGIP, psScripting];

type
  //Log how much time each section takes and write results to a log file

  TKMPerfSectionData = record
    Section: TPerfSection;
    Time: Int64;
  end;

  TKMPerfLog = class
  private
    fTick: Cardinal;
    fCount: array [TPerfSection] of Integer;
    fTimeEnter: array [TPerfSection] of Int64;
//    fTimes: array [TPerfSection] of array of Int64;
    fTickTimes: TDictionary<Cardinal, TDictionary<TPerfSection, Int64>>;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Clear;
    procedure StartTick(aTick: Cardinal);
    procedure EndTick;
    procedure EnterSection(aSection: TPerfSection);
    procedure LeaveSection(aSection: TPerfSection);
    procedure SaveToFile(const aFilename: UnicodeString);
  end;


implementation
uses
  Classes, SysUtils, KM_CommonUtils;


const
  SECT_W = 12;
  //Unicode for TStringList population
  SectionName: array [TPerfSection] of UnicodeString = ('Tick', 'Hungur', 'AIFields', 'FOW',
    'FOWChecks', 'FOWCheck3', 'FOWCheck5',
    'Render',
    'RenderTer', 'RenTerBase',
    'UpdateVBO', 'DoTiles', 'DoWater', 'DoLayers', 'DoOverlays', 'DoLight', 'DoShadows',
    'RenFences', 'RenPlans',
    'RenderOth', 'RendList', 'RendHands', 'RenderFOW',
    'Hands', 'PFinding', 'Terrain', 'GIP', 'Script');

//  LIMITS: array[TPerfSection] of Integer = (30000, 5000, 5000, 5000, 5000, 5000, 5000, 5000);


{ TKMPerfLog }
constructor TKMPerfLog.Create;
var
  K: TPerfSection;
begin
  inherited;

  for K := Low(TPerfSection) to High(TPerfSection) do
    fTimeEnter[K] := 0;

  fTickTimes := TDictionary<Cardinal, TDictionary<TPerfSection, Int64>>.Create;
end;


destructor TKMPerfLog.Destroy;
var
  SectDict: TDictionary<TPerfSection, Int64>;
begin
  for SectDict in fTickTimes.Values do
    SectDict.Free;

  fTickTimes.Clear;
  fTickTimes.Free;

  inherited;
end;


procedure TKMPerfLog.Clear;
var
  I: TPerfSection;
begin
  for I := Low(TPerfSection) to High(TPerfSection) do
    fCount[I] := 0;
end;


procedure TKMPerfLog.StartTick(aTick: Cardinal);
var
  K: TPerfSection;
  SectDict: TDictionary<TPerfSection, Int64>;
begin
  Assert(not fTickTimes.ContainsKey(aTick), 'Tick is already started');

  fTick := aTick;

  SectDict := TDictionary<TPerfSection, Int64>.Create;
  fTickTimes.Add(fTick, SectDict);

  EnterSection(psTick);

  //Init all sections
  for K := Low(TPerfSection) to High(TPerfSection) do
  begin
    if K = psTick then
      Continue;

    EnterSection(K);
    LeaveSection(K);
  end;
end;


procedure TKMPerfLog.EndTick;
begin
  LeaveSection(psTick);
end;


procedure TKMPerfLog.EnterSection(aSection: TPerfSection);
begin
  Assert(fTimeEnter[aSection] = 0, 'Entering not left section');
  fTimeEnter[aSection] := TimeGetUsec;
end;


procedure TKMPerfLog.LeaveSection(aSection: TPerfSection);
var
  T, OldT: Int64;
  SectDict: TDictionary<TPerfSection, Int64>;
//  SectData: TKMPerfSectionData;
begin
  T := TimeGetUsec - fTimeEnter[aSection]; //Measure it ASAP
//  if fCount[aSection] >= Length(fTimes[aSection]) then
//    SetLength(fTimes[aSection], fCount[aSection] + 1024);
//
//  fTimes[aSection, fCount[aSection]] := T;
//  Assert(fTickTimes.ContainsKey(fTick), 'Leave unopened section at tick' + IntToStr(fTick));

  if fTickTimes.TryGetValue(fTick, SectDict) then
//    raise Exception.CreateFmt('Leave unopened section at tick %d', [fTick])
//  else
  begin
//    SectData.Section := aSection;
//    SectData.Time := T;
    if SectDict.TryGetValue(aSection, OldT) then
      SectDict.Items[aSection] := OldT + T
    else
      SectDict.Add(aSection, T);
  end;

//  Inc(fCount[aSection]);

  fTimeEnter[aSection] := 0;
end;


procedure TKMPerfLog.SaveToFile(const aFilename: UnicodeString);
var
  K: TPerfSection;
  S: TStringList;
  TickKey: Cardinal;
  SectKey: TPerfSection;
  Str: String;
  SectDict: TDictionary<TPerfSection, Int64>;

  FastTick: Boolean;

  SectsArray: TArray<TPerfSection>;
  TicksArray: TArray<Cardinal>;
begin
  ForceDirectories(ExtractFilePath(aFilename));

  S := TStringList.Create;

  TicksArray := fTickTimes.Keys.ToArray;
  TArray.Sort<Cardinal>(TicksArray);

//  Str := 'Tick   '; //7
  Str := '       ';
  for K := Low(TPerfSection) to High(TPerfSection) do
  begin
    if K in SKIP_SECTION then
      Continue;

    Str := Str + Format('%' + IntToStr(SECT_W) + 's', [SectionName[K]]);
  end;
  S.Append(Str);


  for TickKey in TicksArray do
  begin
    SectDict := fTickTimes.Items[TickKey];

    SectsArray := SectDict.Keys.ToArray;
    TArray.Sort<TPerfSection>(SectsArray);

    FastTick := False;
    Str := Format('%6d:', [TickKey]);
    for SectKey in SectsArray do
    begin
      if SectKey in SKIP_SECTION then
        Continue;
//      if (SectKey = psTick) and (SectDict.Items[SectKey] < 5000) then //Skip ticks with low execution time
//      begin
//        FastTick := True;
//        Break;
//      end;

      Str := Str + Format('%' + IntToStr(SECT_W) + 'd', [SectDict.Items[SectKey]]);
    end;

    if not FastTick then
      S.Append(Str);
  end;


//  for K := Low(TPerfSection) to High(TPerfSection) do
//  begin
//    //Section name
//    S.Append(SectionName[K]);
//    S.Append(StringOfChar('-', 60));
//
//    //Times
//    for I := 0 to fCount[K] - 1 do
//    if fTimes[K,I] > LIMITS[K] then //Dont bother saving 95% of data
//      S.Append(Format('%d'#9'%d', [I, fTimes[K,I]]));
//
//    //Footer
//    S.Append('');
//    S.Append('');
//  end;

  S.SaveToFile(aFilename);
  S.Free;
end;


end.
