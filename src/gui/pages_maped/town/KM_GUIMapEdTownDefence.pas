unit KM_GUIMapEdTownDefence;
{$I KaM_Remake.inc}
interface
uses
   Classes, Controls, Math, StrUtils, SysUtils,
   KM_InterfaceDefaults,
   KM_Controls, KM_Defaults, KM_GUIMapEdTownFormationsPopUp;


type
  TKMMapEdTownDefence = class (TKMMapEdSubMenuPage)
  private
    procedure Town_DefenceFormations(Sender: TObject);
    procedure Town_DefenceAddClick(Sender: TObject);
    procedure Town_DefenceRefresh;
    procedure Town_DefenceChange(Sender: TObject);
  protected
    Panel_Defence: TKMPanel;
      Button_DefencePosAdd: TKMButtonFlat;
      CheckBox_AutoDefence: TKMCheckBox;
      CheckBox_DefendAllies: TKMCheckBox;
      TrackBar_AutoAttackRange: TKMTrackBar;
      TrackBar_RecruitCount: TKMTrackBar;
      NumEdit_RecruitDelay: TKMNumericEdit;
      CheckBox_MaxSoldiers: TKMCheckBox;
      NumEdit_MaxSoldiers: TKMNumericEdit;
      Button_EditFormations: TKMButton;
  public
    FormationsPopUp: TKMMapEdTownFormations;

    constructor Create(aParent: TKMPanel);

    procedure Show;
    procedure Hide;
    function Visible: Boolean; override;
    procedure UpdateState;
    procedure UpdatePlayer(aIndex: TKMHandID);
  end;


implementation
uses
  KM_Game, KM_HandsCollection, KM_ResTexts, KM_GameCursor, KM_RenderUI, KM_ResFonts, KM_InterfaceGame,
  KM_Hand, KM_Utils;


{ TKMMapEdTownDefence }
constructor TKMMapEdTownDefence.Create(aParent: TKMPanel);
begin
  inherited Create;

  Panel_Defence := TKMPanel.Create(aParent, 0, 28, aParent.Width, 400);
  with TKMLabel.Create(Panel_Defence, 0, PAGE_TITLE_Y, Panel_Defence.Width, 0, gResTexts[TX_MAPED_AI_DEFENSE], fntOutline, taCenter) do
    Anchors := [anLeft, anTop, anRight];
  Button_DefencePosAdd := TKMButtonFlat.Create(Panel_Defence, TB_PAD, 30, 33, 33, 338);
  Button_DefencePosAdd.OnClick := Town_DefenceAddClick;
  Button_DefencePosAdd.Hint := GetHintWHotKey(TX_MAPED_AI_DEFENSE_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[0]);

  with TKMLabel.Create(Panel_Defence, 0, 65, TB_MAP_ED_WIDTH, 0, gResTexts[TX_MAPED_AI_DEFENSE_OPTIONS], fntOutline, taCenter) do
    Anchors := [anLeft, anTop, anRight];
  CheckBox_AutoDefence := TKMCheckBox.Create(Panel_Defence, TB_PAD, 90, Panel_Defence.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_DEFENSE_AUTO], fntMetal);
  CheckBox_AutoDefence.Hint := GetHintWHotKey(TX_MAPED_AI_DEFENSE_AUTO_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[1]);
  CheckBox_AutoDefence.OnClick := Town_DefenceChange;

  CheckBox_DefendAllies := TKMCheckBox.Create(Panel_Defence, TB_PAD, 110, Panel_Defence.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_DEFEND_ALLIES], fntMetal);
  CheckBox_DefendAllies.Hint := GetHintWHotKey(TX_MAPED_AI_DEFEND_ALLIES_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[2]);
  CheckBox_DefendAllies.OnClick := Town_DefenceChange;

  TrackBar_AutoAttackRange := TKMTrackBar.Create(Panel_Defence, TB_PAD, 136, Panel_Defence.Width - TB_PAD, 1, 20);
  TrackBar_AutoAttackRange.Anchors := [anLeft, anTop, anRight];
  TrackBar_AutoAttackRange.Caption := gResTexts[TX_MAPED_AI_AUTO_ATTACK];
  TrackBar_AutoAttackRange.Hint := gResTexts[TX_MAPED_AI_AUTO_ATTACK_HINT];
  TrackBar_AutoAttackRange.OnChange := Town_DefenceChange;

  TrackBar_RecruitCount := TKMTrackBar.Create(Panel_Defence, TB_PAD, 186, Panel_Defence.Width - TB_PAD, 1, 20);
  TrackBar_RecruitCount.Anchors := [anLeft, anTop, anRight];
  TrackBar_RecruitCount.Caption := gResTexts[TX_MAPED_AI_RECRUITS];
  TrackBar_RecruitCount.Hint := gResTexts[TX_MAPED_AI_RECRUITS_HINT];
  TrackBar_RecruitCount.OnChange := Town_DefenceChange;

  with TKMLabel.Create(Panel_Defence, TB_PAD, 230, Panel_Defence.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_RECRUIT_DELAY], fntMetal, taLeft) do
    Hint := gResTexts[TX_MAPED_AI_RECRUIT_DELAY_HINT];

  NumEdit_RecruitDelay := TKMNumericEdit.Create(Panel_Defence, TB_PAD, 230 + 20, 0, 500);
  NumEdit_RecruitDelay.Hint := gResTexts[TX_MAPED_AI_RECRUIT_DELAY_HINT];
  NumEdit_RecruitDelay.MouseWheelStep := 20;
  NumEdit_RecruitDelay.AutoFocusable := False;
  NumEdit_RecruitDelay.OnChange := Town_DefenceChange;

  CheckBox_MaxSoldiers := TKMCheckBox.Create(Panel_Defence, TB_PAD, 274, Panel_Defence.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_MAX_SOLDIERS], fntMetal);
  CheckBox_MaxSoldiers.Hint := GetHintWHotKey(TX_MAPED_AI_MAX_SOLDIERS_ENABLE_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[3]);
  CheckBox_MaxSoldiers.OnClick := Town_DefenceChange;

  NumEdit_MaxSoldiers := TKMNumericEdit.Create(Panel_Defence, TB_PAD + 20, 292, 0, 500);
  NumEdit_MaxSoldiers.Hint := gResTexts[TX_MAPED_AI_MAX_SOLDIERS_HINT];
  NumEdit_MaxSoldiers.MouseWheelStep := 20;
  NumEdit_MaxSoldiers.AutoFocusable := False;
  NumEdit_MaxSoldiers.OnChange := Town_DefenceChange;

  Button_EditFormations := TKMButton.Create(Panel_Defence, TB_PAD, 322, Panel_Defence.Width - TB_PAD, 25, gResTexts[TX_MAPED_AI_FORMATIONS], bsGame);
  Button_EditFormations.Anchors := [anLeft, anTop, anRight];
  Button_EditFormations.OnClick := Town_DefenceFormations;
  Button_EditFormations.Hint := GetHintWHotKey(TX_MAPED_AI_FORMATIONS, MAPED_SUBMENU_ACTIONS_HOTKEYS[4]);

  fSubMenuActionsEvents[0] := Town_DefenceAddClick;
  fSubMenuActionsEvents[1] := Town_DefenceChange;
  fSubMenuActionsEvents[2] := Town_DefenceChange;
  fSubMenuActionsEvents[3] := Town_DefenceChange;
  fSubMenuActionsEvents[4] := Town_DefenceFormations;

  fSubMenuActionsCtrls[0,0] := Button_DefencePosAdd;
  fSubMenuActionsCtrls[1,0] := CheckBox_AutoDefence;
  fSubMenuActionsCtrls[2,0] := CheckBox_DefendAllies;
  fSubMenuActionsCtrls[3,0] := CheckBox_MaxSoldiers;
  fSubMenuActionsCtrls[4,0] := Button_EditFormations;
end;


procedure TKMMapEdTownDefence.Town_DefenceAddClick(Sender: TObject);
begin
  //Press the button
  Button_DefencePosAdd.Down := not Button_DefencePosAdd.Down and (Sender = Button_DefencePosAdd);

  if Button_DefencePosAdd.Down then
  begin
    gGameCursor.Mode := cmMarkers;
    gGameCursor.Tag1 := MARKER_DEFENCE;
  end
  else
    gGameCursor.Mode := cmNone;
end;


procedure TKMMapEdTownDefence.Town_DefenceChange(Sender: TObject);
begin
  gMySpectator.Hand.AI.Setup.AutoDefend := CheckBox_AutoDefence.Checked;
  gMySpectator.Hand.AI.Setup.DefendAllies := CheckBox_DefendAllies.Checked;
  gMySpectator.Hand.AI.Setup.AutoAttackRange := TrackBar_AutoAttackRange.Position;
  gMySpectator.Hand.AI.Setup.RecruitCount := TrackBar_RecruitCount.Position;
  gMySpectator.Hand.AI.Setup.RecruitDelay := NumEdit_RecruitDelay.Value * 600;

  if not CheckBox_MaxSoldiers.Checked then
    gMySpectator.Hand.AI.Setup.MaxSoldiers := -1
  else
    gMySpectator.Hand.AI.Setup.MaxSoldiers := NumEdit_MaxSoldiers.Value;

  Town_DefenceRefresh;
end;


procedure TKMMapEdTownDefence.Town_DefenceFormations(Sender: TObject);
begin
  FormationsPopUp.Show(gMySpectator.HandID);
end;


procedure TKMMapEdTownDefence.Town_DefenceRefresh;
var
  OnlyAdvancedAIHand: Boolean;
begin
  OnlyAdvancedAIHand := gGame.MapEditor.OnlyAdvancedAIHand(gMySpectator.HandID);

  CheckBox_AutoDefence.Checked := gMySpectator.Hand.AI.Setup.AutoDefend;
  CheckBox_DefendAllies.Checked := gMySpectator.Hand.AI.Setup.DefendAllies;
  TrackBar_AutoAttackRange.Position := gMySpectator.Hand.AI.Setup.AutoAttackRange;
  TrackBar_AutoAttackRange.Enabled := not OnlyAdvancedAIHand;
  TrackBar_RecruitCount.Position := gMySpectator.Hand.AI.Setup.RecruitCount;
  TrackBar_RecruitCount.Enabled := not OnlyAdvancedAIHand;
  NumEdit_RecruitDelay.Value := Round(gMySpectator.Hand.AI.Setup.RecruitDelay / 600);
  Button_EditFormations.Enabled := not OnlyAdvancedAIHand;

  CheckBox_MaxSoldiers.Checked := (gMySpectator.Hand.AI.Setup.MaxSoldiers >= 0);
  NumEdit_MaxSoldiers.Enabled := CheckBox_MaxSoldiers.Checked;
  NumEdit_MaxSoldiers.Value := Max(gMySpectator.Hand.AI.Setup.MaxSoldiers, 0);

  //Update Button_DefencePosAdd after CheckBox_AutoDefence has been set
  Button_DefencePosAdd.Enabled := not CheckBox_AutoDefence.Checked;

  if CheckBox_AutoDefence.Checked then
  begin
    Button_DefencePosAdd.Down := False;
    gGameCursor.Mode := cmNone;
  end;
end;


procedure TKMMapEdTownDefence.Hide;
begin
  Panel_Defence.Hide;
end;


procedure TKMMapEdTownDefence.Show;
begin
  Town_DefenceAddClick(nil);
  Town_DefenceRefresh;
  Panel_Defence.Show;
end;


function TKMMapEdTownDefence.Visible: Boolean;
begin
  Result := Panel_Defence.Visible;
end;


procedure TKMMapEdTownDefence.UpdateState;
begin
  Button_DefencePosAdd.Down := (gGameCursor.Mode = cmMarkers)
                                and (gGameCursor.Tag1 = MARKER_DEFENCE)
                                and not CheckBox_AutoDefence.Checked;
end;


procedure TKMMapEdTownDefence.UpdatePlayer(aIndex: TKMHandID);
begin
  if Panel_Defence.Visible then
    Show;
end;


end.
