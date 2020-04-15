unit KM_GUIMapEdMarkerDefence;
{$I KaM_Remake.inc}
interface
uses
   Classes, Controls, Math, StrUtils, SysUtils,
   KM_Controls, KM_Defaults, KM_Pics, KM_Points, KM_InterfaceGame;


type
  TKMMapEdMarkerDefence = class
  private
    fOwner: TKMHandID;
    fIndex: Integer;
    fOnDone: TNotifyEvent;
    procedure Marker_Change(Sender: TObject);
    procedure Marker_UpdateOrder(Sender: TObject; Shift: TShiftState);
  protected
    Panel_MarkerDefence: TKMPanel;
    Label_MarkerType: TKMLabel;
    Image_MarkerPic: TKMImage;
    DropList_DefenceGroup: TKMDropList;
    DropList_DefenceType: TKMDropList;
    TrackBar_DefenceRad: TKMTrackBar;
    Label_Priority: TKMLabel;
    Button_Priority_Inc, Button_Priority_Dec: TKMButton;
    Button_DefenceCW, Button_DefenceCCW: TKMButton;
    Button_DefenceDelete: TKMButton;
    Button_DefenceClose: TKMButton;
  public
    constructor Create(aParent: TKMPanel; aOnDone: TNotifyEvent);

    property Index: Integer read fIndex;
    property Owner: TKMHandID read fOwner;

    procedure Show(aPlayer: TKMHandID; aIndex: Integer);
    procedure Hide;
    function Visible: Boolean;
  end;


implementation
uses
  KM_HandsCollection, KM_ResTexts, KM_Game,
  KM_RenderUI, KM_ResFonts, KM_AIDefensePos, KM_Hand;


{ TKMMapEdMarkerDefence }
constructor TKMMapEdMarkerDefence.Create(aParent: TKMPanel; aOnDone: TNotifyEvent);
begin
  inherited Create;

  fOnDone := aOnDone;

  Panel_MarkerDefence := TKMPanel.Create(aParent, TB_PAD, 50, TB_MAP_ED_WIDTH - TB_PAD, 400);

  Label_MarkerType := TKMLabel.Create(Panel_MarkerDefence, 0, 10, Panel_MarkerDefence.Width, 0, '', fntOutline, taCenter);
  Image_MarkerPic := TKMImage.Create(Panel_MarkerDefence, 0, 10, 32, 32, 338);

  DropList_DefenceGroup := TKMDropList.Create(Panel_MarkerDefence, 0, 55, Panel_MarkerDefence.Width, 20, fntGame, '', bsGame);
  DropList_DefenceGroup.Add(gResTexts[TX_MAPED_AI_ATTACK_TYPE_MELEE]);
  DropList_DefenceGroup.Add(gResTexts[TX_MAPED_AI_ATTACK_TYPE_ANTIHORSE]);
  DropList_DefenceGroup.Add(gResTexts[TX_MAPED_AI_ATTACK_TYPE_RANGED]);
  DropList_DefenceGroup.Add(gResTexts[TX_MAPED_AI_ATTACK_TYPE_MOUNTED]);
  DropList_DefenceGroup.OnChange := Marker_Change;
  DropList_DefenceType := TKMDropList.Create(Panel_MarkerDefence, 0, 85, Panel_MarkerDefence.Width, 20, fntGame, '', bsGame);
  DropList_DefenceType.Add(gResTexts[TX_MAPED_AI_DEFENCE_DEFENDERS]);
  DropList_DefenceType.Add(gResTexts[TX_MAPED_AI_DEFENCE_ATTACKERS]);
  DropList_DefenceType.OnChange := Marker_Change;
  TrackBar_DefenceRad := TKMTrackBar.Create(Panel_MarkerDefence, 0, 115, Panel_MarkerDefence.Width, 1, 128);
  TrackBar_DefenceRad.Caption := gResTexts[TX_MAPED_AI_DEFENCE_RADIUS];
  TrackBar_DefenceRad.OnChange := Marker_Change;

  TKMLabel.Create(Panel_MarkerDefence, 0, 165, gResTexts[TX_MAPED_AI_DEFENCE_PRIORITY_ORDER], fntMetal, taLeft);
  Label_Priority := TKMLabel.Create(Panel_MarkerDefence, 20, 185+2, 20, 0, '', fntGrey, taCenter);
  Button_Priority_Dec := TKMButton.Create(Panel_MarkerDefence, 0, 185, 20, 20, '-', bsGame);
  Button_Priority_Inc := TKMButton.Create(Panel_MarkerDefence, 40, 185, 20, 20, '+', bsGame);
  Button_Priority_Dec.OnClickShift := Marker_UpdateOrder;
  Button_Priority_Inc.OnClickShift := Marker_UpdateOrder;

  Button_DefenceCCW  := TKMButton.Create(Panel_MarkerDefence, 0, 235, 50, 35, 23, rxGui, bsGame);
  Button_DefenceCCW.OnClick := Marker_Change;
  Button_DefenceCW := TKMButton.Create(Panel_MarkerDefence, 130, 235, 50, 35, 24, rxGui, bsGame);
  Button_DefenceCW.OnClick := Marker_Change;
  Button_DefenceDelete := TKMButton.Create(Panel_MarkerDefence, 0, 280, 25, 25, 340, rxGui, bsGame);
  Button_DefenceDelete.Hint := gResTexts[TX_MAPED_AI_DEFENCE_DELETE_HINT];
  Button_DefenceDelete.OnClick := Marker_Change;
  Button_DefenceClose := TKMButton.Create(Panel_MarkerDefence, Panel_MarkerDefence.Width-100, 280, 100, 25, gResTexts[TX_MAPED_CLOSE], bsGame);
  Button_DefenceClose.Hint := gResTexts[TX_MAPED_AI_DEFENCE_CLOSE_HINT];
  Button_DefenceClose.OnClick := Marker_Change;
end;


procedure TKMMapEdMarkerDefence.Marker_Change(Sender: TObject);
var
  DP: TAIDefencePosition;
begin
  DP := gHands[fOwner].AI.General.DefencePositions[fIndex];
  DP.Radius := TrackBar_DefenceRad.Position;
  DP.DefenceType := TAIDefencePosType(DropList_DefenceType.ItemIndex);
  DP.GroupType := TKMGroupType(DropList_DefenceGroup.ItemIndex);

  if Sender = Button_DefenceCW then
    DP.Position := KMPointDir(DP.Position.Loc, KMNextDirection(DP.Position.Dir));
  if Sender = Button_DefenceCCW then
    DP.Position := KMPointDir(DP.Position.Loc, KMPrevDirection(DP.Position.Dir));

  if Sender = Button_DefenceDelete then
  begin
    gHands[fOwner].AI.General.DefencePositions.Delete(fIndex);
    Hide;
    fOnDone(Self);
  end;

  if Sender = Button_DefenceClose then
  begin
    Hide;
    fOnDone(Self);
  end;
end;


procedure TKMMapEdMarkerDefence.Marker_UpdateOrder(Sender: TObject; Shift: TShiftState);
var I: Integer;
begin
  if Sender = Button_Priority_Inc then
    for I := 1 to 1 + 9*Byte(ssRight in Shift) do
      if fIndex < gHands[fOwner].AI.General.DefencePositions.Count-1 then
      begin
        gHands[fOwner].AI.General.DefencePositions.MoveUp(fIndex);
        Inc(fIndex);
        Label_Priority.Caption := IntToStr(fIndex + 1);
      end;

  if Sender = Button_Priority_Dec then
    for I := 1 to 1 + 9*Byte(ssRight in Shift) do
      if fIndex > 0 then
      begin
        gHands[fOwner].AI.General.DefencePositions.MoveDown(fIndex);
        Dec(fIndex);
      end;

  Label_Priority.Caption := IntToStr(fIndex + 1);
  Button_Priority_Inc.Enabled := fIndex < gHands[fOwner].AI.General.DefencePositions.Count-1;
  Button_Priority_Dec.Enabled := fIndex > 0;
  gGame.MapEditor.ActiveMarker.Index := fIndex;
end;


procedure TKMMapEdMarkerDefence.Show(aPlayer: TKMHandID; aIndex: Integer);
begin
  fOwner := aPlayer;
  fIndex := aIndex;

  Label_MarkerType.Caption := gResTexts[TX_MAPED_AI_DEFENCE_POSITION];
  Image_MarkerPic.TexID := 338;
  DropList_DefenceGroup.ItemIndex := Byte(gHands[fOwner].AI.General.DefencePositions[fIndex].GroupType);
  DropList_DefenceType.ItemIndex := Byte(gHands[fOwner].AI.General.DefencePositions[fIndex].DefenceType);
  TrackBar_DefenceRad.Position := gHands[fOwner].AI.General.DefencePositions[fIndex].Radius;
  Marker_UpdateOrder(nil, []);

  Panel_MarkerDefence.Show;
end;


procedure TKMMapEdMarkerDefence.Hide;
begin
  Panel_MarkerDefence.Hide;
end;


function TKMMapEdMarkerDefence.Visible: Boolean;
begin
  Result := Panel_MarkerDefence.Visible;
end;


end.
