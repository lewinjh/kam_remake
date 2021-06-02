unit ConsoleMain;
{$I KaM_Remake.inc}
interface
uses
  KM_MinimapMission,
  KM_Defaults, MapUtilTypes;

type
  TConsoleMain = class(TObject)
  private
    fMinimap: TKMMinimapMission;
    procedure GenerateAndSaveMapMinimapImage(const aMapDatPath: string; aFowType: TFOWType);
    procedure SaveToFile(const aFileName: string);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Start(const aParameterRecord: TCLIParamRecord);
    procedure ShowHelp;
  end;

const
  MAPUTIL_VERSION_MAJOR = '2';
  MAPUTIL_VERSION_MINOR = '03';
var
  MAPUTIL_VERSION: String;
const
  MAPUTIL_START_TEXT    = '' + sLineBreak +
    '++=====================================================================================++' + sLineBreak +
    '++=====================================================================================++' + sLineBreak +
    '||                             KaM Remake Map Utility                                  ||' + sLineBreak +
    '++=====================================================================================++' + sLineBreak +
    '++=====================================================================================++' + sLineBreak;
  MAPUTIL_HELP_TEXT     = '' +
    '++=====================================================================================++' + sLineBreak +
    '||                                                                                     ||' + sLineBreak +
    '||  Map Utility has a few options.                                                     ||' + sLineBreak +
    '||  Main function of this tool is to generate a minimap from map files                 ||' + sLineBreak +
    '||  Below we will show these options and give a brief explanation what they do.        ||' + sLineBreak +
    '||                                                                                     ||' + sLineBreak +
    '||=====================================================================================||' + sLineBreak +
    '||                                                                                     ||' + sLineBreak +
    '||  Usage:                                                                             ||' + sLineBreak +
    '||    MapUtil [OPTIONS] /PathToMap/PathToMap.dat                                       ||' + sLineBreak +
    '||                                                                                     ||' + sLineBreak +
    '||  Options:                                                                           ||' + sLineBreak +
    '||    -h / -help               - Will show this menu                                   ||' + sLineBreak +
    '||    -a / -revealAll          - Reveal all map on the generated png (default option)  ||' + sLineBreak +
    '||    -p / -revealPlayers      - Reveal what will players view on the generated png    ||' + sLineBreak +
    '||    -m / -revealByMapSetting - Reveal according to the map setting `BlockMapPreview` ||' + sLineBreak +
    '||                                                                                     ||' + sLineBreak +
    '||=====================================================================================||' + sLineBreak;


implementation
uses
  {$IFDEF MSWindows} Windows, {$ENDIF}
  SysUtils, Classes,
  {$IFDEF WDC}
  IOUtils,
  {$ENDIF}
  {$IFDEF FPC}
  LazFileUtils,
  {$ENDIF}
  KM_Maps, KM_Resource, KM_IoPNG,
  KM_CommonUtils, KM_Log;

{ TMain }
constructor TConsoleMain.Create;
begin
  inherited;

  gLog := TKMLog.Create(ExtractFilePath(ParamStr(0)) + 'MapUtil.log');
  fMinimap := TKMMinimapMission.Create(True);

  gRes := TKMResource.Create(nil, nil);
  gRes.LoadMainResources;
end;


destructor TConsoleMain.Destroy;
begin
  FreeAndNil(fMinimap);

  inherited;
end;


procedure TConsoleMain.GenerateAndSaveMapMinimapImage(const aMapDatPath: string; aFowType: TFOWType);
var
  mapName, dir, pngName: string;
  map: TKMMapInfo;
  doRevealAll: Boolean;
begin
  {$IFDEF WDC}
  mapName := TPath.GetFileNameWithoutExtension(aMapDatPath);
  {$ENDIF}
  {$IFDEF FPC}
  mapName := ExtractFileNameOnly(aMapDatPath);
  {$ENDIF}

  dir := ExtractFileDir(aMapDatPath) + PathDelim;

  gLog.AddTime('generating png for a map ' + aMapDatPath);

  map := TKMMapInfo.Create(dir, mapName, False);
  map.TxtInfo.LoadTXTInfo(ChangeFileExt(aMapDatPath, '.txt'));


  fMinimap.LoadFromMission(aMapDatPath, map.HumanUsableLocs);

  doRevealAll := True;
  case aFowType of
    ftRevealAll:      doRevealAll := True;
    ftRevealPlayers:  doRevealAll := False;
    ftMapSetting:     doRevealAll := not map.TxtInfo.BlockFullMapPreview;
  end;

  fMinimap.Update(doRevealAll);

//  fMinimap.ConvertToBGR;
  pngName := ChangeFileExt(aMapDatPath, '.png');
  SaveToFile(pngName);
  gLog.AddTime('generated file: ' + pngName);

  map.Free;
end;


procedure TConsoleMain.SaveToFile(const aFileName: string);
begin
  SaveToPng(fMinimap.MapX, fMinimap.MapY, fMinimap.Base, aFileName);
end;


procedure TConsoleMain.Start(const aParameterRecord: TCLIParamRecord);
begin
  GenerateAndSaveMapMinimapImage(aParameterRecord.MapDatPath, aParameterRecord.FOWType);
end;


procedure TConsoleMain.ShowHelp;
begin
  Writeln(MAPUTIL_HELP_TEXT);
end;


end.

