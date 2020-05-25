unit KM_GUIMapEdTownScript;
{$I KaM_Remake.inc}
interface
uses
   Classes, Controls, Math, StrUtils, SysUtils,
   KM_InterfaceDefaults,
   KM_Controls;

type
  TKMMapEdTownScript = class (TKMMapEdSubMenuPage)
  private
    procedure Town_ScriptRefresh;
    procedure Town_ScriptChange(Sender: TObject);
    procedure ClassicAIParams_Click(Sender: TObject);
  protected
    Panel_Script: TKMPanel;
      CheckBox_AutoBuild: TKMCheckBox;
      CheckBox_AutoRepair: TKMCheckBox;
      Button_ClassicAIParams: TKMButton;

      PopUp_ClassicAIParams: TKMPopUpPanel;
        TrackBar_SerfsPer10Houses: TKMTrackBar;
        TrackBar_WorkerCount: TKMTrackBar;
        DropBox_ArmyType: TKMDropList;
        Button_CloseClassicAIParams: TKMButton;

      CheckBox_UnlimitedEquip: TKMCheckBox;
      NumEd_EquipRateLeather: TKMNumericEdit;
      NumEd_EquipRateIron: TKMNumericEdit;
      Button_AIStart: TKMButtonFlat;
  public
    constructor Create(aParent: TKMPanel);

    procedure Show;
    procedure Hide;
    function Visible: Boolean; override;
    procedure KeyDown(Key: Word; Shift: TShiftState; var aHandled: Boolean);
    procedure UpdateState;
  end;


implementation
uses
  {$IFDEF MSWindows} Windows, {$ENDIF}
  {$IFDEF Unix} LCLType, {$ENDIF}
  KM_Game, KM_HandsCollection, KM_ResTexts, KM_RenderUI, KM_ResFonts, KM_InterfaceGame, KM_GameCursor,
  KM_Defaults, KM_Pics, KM_Hand, KM_ResHouses, KM_Utils;


{ TKMMapEdTownScript }
constructor TKMMapEdTownScript.Create(aParent: TKMPanel);
begin
  inherited Create;

  Panel_Script := TKMPanel.Create(aParent, 0, 28, aParent.Width, 400);
  with TKMLabel.Create(Panel_Script, 0, PAGE_TITLE_Y, Panel_Script.Width, 0, gResTexts[TX_MAPED_AI_TITLE], fntOutline, taCenter) do
    Anchors := [anLeft, anTop, anRight];
  CheckBox_AutoBuild := TKMCheckBox.Create(Panel_Script, 9, 30, Panel_Script.Width - 9, 20, gResTexts[TX_MAPED_AI_AUTOBUILD], fntMetal);
  CheckBox_AutoBuild.OnClick := Town_ScriptChange;
  CheckBox_AutoBuild.Hint := GetHintWHotKey(TX_MAPED_AI_AUTOBUILD, MAPED_SUBMENU_ACTIONS_HOTKEYS[0]);
  CheckBox_AutoRepair := TKMCheckBox.Create(Panel_Script, 9, 50, Panel_Script.Width - 9, 20, gResTexts[TX_MAPED_AI_AUTOREPAIR], fntMetal);
  CheckBox_AutoRepair.OnClick := Town_ScriptChange;
  CheckBox_AutoRepair.Hint := GetHintWHotKey(TX_MAPED_AI_AUTOREPAIR, MAPED_SUBMENU_ACTIONS_HOTKEYS[1]);

  Button_ClassicAIParams := TKMButton.Create(Panel_Script, 9, 75, Panel_Script.Width - 9, 40, gResTexts[TX_MAPED_AI_CLASSIC_AI_PARAMS], bsGame);
  Button_ClassicAIParams.Anchors := [anLeft, anTop, anRight];
  Button_ClassicAIParams.Hint := GetHintWHotkey(TX_MAPED_AI_CLASSIC_AI_PARAMS_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[2]);
  Button_ClassicAIParams.OnClick := ClassicAIParams_Click;

  PopUp_ClassicAIParams := TKMPopUpPanel.Create(aParent.MasterParent, 300, 220, gResTexts[TX_MAPED_AI_CLASSIC_AI_PARAMS_TITLE], pubgitGray);

    TrackBar_SerfsPer10Houses := TKMTrackBar.Create(PopUp_ClassicAIParams, 10, 10, 280, 1, 50);
    TrackBar_SerfsPer10Houses.Caption := gResTexts[TX_MAPED_AI_SERFS_PER_10_HOUSES];
    TrackBar_SerfsPer10Houses.OnChange := Town_ScriptChange;
    TrackBar_WorkerCount := TKMTrackBar.Create(PopUp_ClassicAIParams, 10, 55, 280, 0, 50);
    TrackBar_WorkerCount.Caption := gResTexts[TX_MAPED_AI_WORKERS];
    TrackBar_WorkerCount.Hint := gResTexts[TX_MAPED_AI_WORKERS_COUNT_HINT];
    TrackBar_WorkerCount.OnChange := Town_ScriptChange;

    TKMLabel.Create(PopUp_ClassicAIParams, 10, 110, TB_WIDTH, 0, gResTexts[TX_MAPED_AI_ARMY_TYPE], fntMetal, taLeft);
    DropBox_ArmyType := TKMDropList.Create(PopUp_ClassicAIParams, 10, 130, 280, 20, fntMetal, '', bsGame);
    DropBox_ArmyType.OnChange := Town_ScriptChange;
    DropBox_ArmyType.Add(gResTexts[TX_MAPED_AI_ARMY_TYPE_IRON_THEN_LEATHER], Byte(atIronThenLeather));
    DropBox_ArmyType.Add(gResTexts[TX_MAPED_AI_ARMY_TYPE_IRON],              Byte(atIron));
    DropBox_ArmyType.Add(gResTexts[TX_MAPED_AI_ARMY_TYPE_LEATHER],           Byte(atLeather));
    DropBox_ArmyType.Add(gResTexts[TX_MAPED_AI_ARMY_TYPE_MIXED],             Byte(atIronAndLeather));

    Button_CloseClassicAIParams := TKMButton.Create(PopUp_ClassicAIParams,
                                                    (PopUp_ClassicAIParams.Width div 2) - 60,
                                                    PopUp_ClassicAIParams.Height - 40,
                                                    120, 30, gResTexts[TX_WORD_CLOSE], bsGame);
    Button_CloseClassicAIParams.OnClick := ClassicAIParams_Click;

  CheckBox_UnlimitedEquip := TKMCheckBox.Create(Panel_Script, TB_PAD, 130, Panel_Script.Width - 9, 20, gResTexts[TX_MAPED_AI_FASTEQUIP], fntMetal);
  CheckBox_UnlimitedEquip.OnClick := Town_ScriptChange;
  CheckBox_UnlimitedEquip.Hint := GetHintWHotKey(TX_MAPED_AI_FASTEQUIP_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[3]);

  with TKMLabel.Create(Panel_Script, TB_PAD, 155, Panel_Script.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_LEATHER], fntMetal, taLeft) do
    Hint := gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_LEATHER_HINT];

  NumEd_EquipRateLeather := TKMNumericEdit.Create(Panel_Script, TB_PAD, 155 + 20, 100, 3000);
  NumEd_EquipRateLeather.Hint := gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_LEATHER_HINT];
  NumEd_EquipRateLeather.MouseWheelStep := 100;
  NumEd_EquipRateLeather.AutoFocusable := False;
  NumEd_EquipRateLeather.OnChange := Town_ScriptChange;

  with TKMLabel.Create(Panel_Script, TB_PAD, 200, Panel_Script.Width - TB_PAD, 20, gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_IRON], fntMetal, taLeft) do
    Hint := gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_IRON_HINT];

  NumEd_EquipRateIron := TKMNumericEdit.Create(Panel_Script, TB_PAD, 200 + 20, 100, 3000);
  NumEd_EquipRateIron.Hint := gResTexts[TX_MAPED_AI_DEFENSE_EQUIP_IRON_HINT];
  NumEd_EquipRateIron.MouseWheelStep := 100;
  NumEd_EquipRateIron.AutoFocusable := False;
  NumEd_EquipRateIron.OnChange := Town_ScriptChange;

  TKMLabel.Create(Panel_Script, TB_PAD, 255, gResTexts[TX_MAPED_AI_START], fntMetal, taLeft);
  Button_AIStart         := TKMButtonFlat.Create(Panel_Script, TB_PAD, 275, 33, 33, 62, rxGuiMain);
  Button_AIStart.Hint    := GetHintWHotKey(TX_MAPED_AI_START_HINT, MAPED_SUBMENU_ACTIONS_HOTKEYS[4]);
  Button_AIStart.OnClick := Town_ScriptChange;

  fSubMenuActionsEvents[0] := Town_ScriptChange;
  fSubMenuActionsEvents[1] := Town_ScriptChange;
  fSubMenuActionsEvents[2] := ClassicAIParams_Click;
  fSubMenuActionsEvents[3] := Town_ScriptChange;
  fSubMenuActionsEvents[4] := Town_ScriptChange;

  fSubMenuActionsCtrls[0,0] := CheckBox_AutoBuild;
  fSubMenuActionsCtrls[1,0] := CheckBox_AutoRepair;
  fSubMenuActionsCtrls[2,0] := Button_ClassicAIParams;
  fSubMenuActionsCtrls[3,0] := CheckBox_UnlimitedEquip;
  fSubMenuActionsCtrls[4,0] := Button_AIStart;
end;


procedure TKMMapEdTownScript.Town_ScriptRefresh;
begin
  CheckBox_AutoBuild.Checked := gMySpectator.Hand.AI.Setup.AutoBuild;
  CheckBox_AutoRepair.Checked := gMySpectator.Hand.AI.Setup.AutoRepair;
  TrackBar_SerfsPer10Houses.Position := Round(10*gMySpectator.Hand.AI.Setup.SerfsPerHouse);
  if gMySpectator.HandID <> -1 then
    TrackBar_SerfsPer10Houses.Hint := Format(gResTexts[TX_MAPED_AI_SERFS_PER_10_HOUSES_HINT], [gMySpectator.Hand.Stats.GetHouseQty(htAny)]);
  TrackBar_WorkerCount.Position := gMySpectator.Hand.AI.Setup.WorkerCount;
  CheckBox_UnlimitedEquip.Checked := gMySpectator.Hand.AI.Setup.UnlimitedEquip;
  NumEd_EquipRateLeather.Value := gMySpectator.Hand.AI.Setup.EquipRateLeather;
  NumEd_EquipRateIron.Value    := gMySpectator.Hand.AI.Setup.EquipRateIron;
  DropBox_ArmyType.SelectByTag(Byte(gMySpectator.Hand.AI.Setup.ArmyType));

  NumEd_EquipRateLeather.Enable;
  NumEd_EquipRateIron.Enable;
  case gMySpectator.Hand.AI.Setup.ArmyType of
    atLeather: NumEd_EquipRateIron.Disable;
    atIron:    NumEd_EquipRateLeather.Disable;
  end;

  Button_ClassicAIParams.Enabled := not gGame.MapEditor.OnlyAdvancedAIHand(gMySpectator.HandID);
end;


procedure TKMMapEdTownScript.ClassicAIParams_Click(Sender: TObject);
begin
  PopUp_ClassicAIParams.Visible := not PopUp_ClassicAIParams.Visible;
end;


procedure TKMMapEdTownScript.Town_ScriptChange(Sender: TObject);
begin
  gMySpectator.Hand.AI.Setup.AutoBuild := CheckBox_AutoBuild.Checked;
  gMySpectator.Hand.AI.Setup.AutoRepair := CheckBox_AutoRepair.Checked;
  gMySpectator.Hand.AI.Setup.SerfsPerHouse := TrackBar_SerfsPer10Houses.Position / 10;
  gMySpectator.Hand.AI.Setup.WorkerCount := TrackBar_WorkerCount.Position;
  gMySpectator.Hand.AI.Setup.UnlimitedEquip := CheckBox_UnlimitedEquip.Checked;
  gMySpectator.Hand.AI.Setup.EquipRateLeather := NumEd_EquipRateLeather.Value;
  gMySpectator.Hand.AI.Setup.EquipRateIron := NumEd_EquipRateIron.Value;
  gMySpectator.Hand.AI.Setup.ArmyType := TKMArmyType(DropBox_ArmyType.GetSelectedTag);

  if CheckBox_UnlimitedEquip.Checked and gGame.MapEditor.OnlyAdvancedAIHand(gMySpectator.HandID) then
  begin
    //Only for Advanced AI locks
    //No equip rates when equip is unlimited
    NumEd_EquipRateIron.Disable;
    NumEd_EquipRateLeather.Disable;
  end else begin
    NumEd_EquipRateLeather.Enable;
    NumEd_EquipRateIron.Enable;
    case gMySpectator.Hand.AI.Setup.ArmyType of
      atLeather: NumEd_EquipRateIron.Disable;
      atIron:    NumEd_EquipRateLeather.Disable;
    end;
  end;

  if Sender = Button_AIStart then
    Button_AIStart.Down := not Button_AIStart.Down;

  if Button_AIStart.Down then
  begin
    gGameCursor.Mode := cmMarkers;
    gGameCursor.Tag1 := MARKER_AISTART;
  end
  else
    gGameCursor.Mode := cmNone;
end;


procedure TKMMapEdTownScript.KeyDown(Key: Word; Shift: TShiftState; var aHandled: Boolean);
begin
  if aHandled then Exit;

  if (Key = VK_ESCAPE) and PopUp_ClassicAIParams.Visible then
  begin
    PopUp_ClassicAIParams.Hide;
    aHandled := True;
  end;
end;


procedure TKMMapEdTownScript.UpdateState;
begin
  Button_AIStart.Down := (gGameCursor.Mode = cmMarkers) and (gGameCursor.Tag1 = MARKER_AISTART);
end;


procedure TKMMapEdTownScript.Hide;
begin
  Panel_Script.Hide;
end;


procedure TKMMapEdTownScript.Show;
begin
  Button_AIStart.Down := False;
  Town_ScriptRefresh;
  Panel_Script.Show;
end;


function TKMMapEdTownScript.Visible: Boolean;
begin
  Result := Panel_Script.Visible;
end;


end.
