unit KM_GUIMapEdPlayerView;
{$I KaM_Remake.inc}
interface
uses
   Classes,
   KM_Controls, KM_Defaults,
   KM_Points;

type
  TKMMapEdPlayerView = class
  private
    procedure Player_ViewClick(Sender: TObject);
  protected
    Panel_PlayerView: TKMPanel;
    Button_Reveal: TKMButtonFlat;
    TrackBar_RevealNewSize: TKMTrackBar;
    CheckBox_RevealAll: TKMCheckBox;
    Button_CenterScreen: TKMButtonFlat;
    Button_PlayerCenterScreen: TKMButton;
  public
    constructor Create(aParent: TKMPanel);

    procedure Show;
    function Visible: Boolean;
    procedure Hide;
    procedure UpdateState;
    procedure UpdatePlayerColor;
  end;


implementation
uses
  KM_HandsCollection, KM_ResTexts, KM_Game, KM_GameCursor, KM_RenderUI, KM_ResFonts,
  KM_InterfaceGame;


{ TKMMapEdPlayerView }
constructor TKMMapEdPlayerView.Create(aParent: TKMPanel);
begin
  inherited Create;

  Panel_PlayerView := TKMPanel.Create(aParent, 0, 28, aParent.Width, 400);
  with TKMLabel.Create(Panel_PlayerView, 0, PAGE_TITLE_Y, Panel_PlayerView.Width, 0, gResTexts[TX_MAPED_FOG], fntOutline, taCenter) do
    Anchors := [anLeft, anTop, anRight];
  Button_Reveal         := TKMButtonFlat.Create(Panel_PlayerView, 9, 30, 33, 33, 394);
  Button_Reveal.Hint    := gResTexts[TX_MAPED_FOG_HINT];
  Button_Reveal.OnClick := Player_ViewClick;
  TrackBar_RevealNewSize  := TKMTrackBar.Create(Panel_PlayerView, 46, 35, Panel_PlayerView.Width - 46, 1, 64);
  TrackBar_RevealNewSize.Anchors := [anLeft, anTop, anRight];
  TrackBar_RevealNewSize.OnChange := Player_ViewClick;
  TrackBar_RevealNewSize.Position := 8;
  CheckBox_RevealAll          := TKMCheckBox.Create(Panel_PlayerView, 9, 75, 140, 20, gResTexts[TX_MAPED_FOG_ALL], fntMetal);
  CheckBox_RevealAll.OnClick  := Player_ViewClick;
  with TKMLabel.Create(Panel_PlayerView, 0, 100, Panel_PlayerView.Width, 0, gResTexts[TX_MAPED_FOG_CENTER], fntOutline, taCenter) do
    Anchors := [anLeft, anTop, anRight];
  Button_CenterScreen         := TKMButtonFlat.Create(Panel_PlayerView, 9, 120, 33, 33, 391);
  Button_CenterScreen.Hint    := gResTexts[TX_MAPED_FOG_CENTER_HINT];
  Button_CenterScreen.OnClick := Player_ViewClick;
  Button_PlayerCenterScreen    := TKMButton.Create(Panel_PlayerView, 49, 120, 80, 33, '[X,Y]', bsGame);
  Button_PlayerCenterScreen.OnClick := Player_ViewClick;
  Button_PlayerCenterScreen.Hint := gResTexts[TX_MAPED_FOG_CENTER_JUMP];
end;


procedure TKMMapEdPlayerView.Player_ViewClick(Sender: TObject);
begin
  //Press the button
  if Sender = Button_Reveal then
  begin
    Button_Reveal.Down := not Button_Reveal.Down;
    Button_CenterScreen.Down := False;
  end;
  if Sender = Button_CenterScreen then
  begin
    Button_CenterScreen.Down := not Button_CenterScreen.Down;
    Button_Reveal.Down := False;
  end;

  if (Sender = nil) and (gGameCursor.Mode = cmNone) then
  begin
    Button_Reveal.Down := False;
    Button_CenterScreen.Down := False;
  end;

  if Button_Reveal.Down then
  begin
    gGameCursor.Mode := cmMarkers;
    gGameCursor.Tag1 := MARKER_REVEAL;
    gGameCursor.MapEdSize := TrackBar_RevealNewSize.Position;
  end
  else
  if Button_CenterScreen.Down then
  begin
    gGameCursor.Mode := cmMarkers;
    gGameCursor.Tag1 := MARKER_CENTERSCREEN;
  end
  else
    gGameCursor.Mode := cmNone;

  if Sender = CheckBox_RevealAll then
    gGame.MapEditor.RevealAll[gMySpectator.HandID] := CheckBox_RevealAll.Checked
  else
    CheckBox_RevealAll.Checked := gGame.MapEditor.RevealAll[gMySpectator.HandID];

  if Sender = Button_PlayerCenterScreen then
    gGame.ActiveInterface.Viewport.Position := KMPointF(gMySpectator.Hand.CenterScreen); //Jump to location

  Button_PlayerCenterScreen.Caption := TypeToString(gMySpectator.Hand.CenterScreen);
end;


procedure TKMMapEdPlayerView.UpdateState;
begin
  Button_CenterScreen.Down := (gGameCursor.Mode = cmMarkers) and (gGameCursor.Tag1 = MARKER_CENTERSCREEN);
  Button_Reveal.Down := (gGameCursor.Mode = cmMarkers) and (gGameCursor.Tag1 = MARKER_REVEAL);
end;


procedure TKMMapEdPlayerView.Hide;
begin
  Panel_PlayerView.Hide;
end;


procedure TKMMapEdPlayerView.Show;
begin
  Panel_PlayerView.Show;
  Button_PlayerCenterScreen.Caption := TypeToString(gMySpectator.Hand.CenterScreen);
  CheckBox_RevealAll.Checked := gGame.MapEditor.RevealAll[gMySpectator.HandID];
end;


function TKMMapEdPlayerView.Visible: Boolean;
begin
  Result := Panel_PlayerView.Visible;
end;


procedure TKMMapEdPlayerView.UpdatePlayerColor;
begin
  Button_Reveal.FlagColor := gMySpectator.Hand.FlagColor;
end;


end.
