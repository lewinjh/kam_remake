unit KM_DevPerfLogForm;
{$I KaM_Remake.inc}
interface
uses
  SysUtils, Classes, Vcl.Graphics, Vcl.Forms, Vcl.CheckLst, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls, Types,
  {KM_ResTypes, }KM_DevPerfLog, KM_DevPerfLogTypes, KM_DevPerfLogSingle, Vcl.Samples.Spin;

type
  TFormPerfLogs = class(TForm)
    Label1: TLabel;
    cbStackedGFX: TCheckBox;
    seFrameBudget: TSpinEdit;
    Label2: TLabel;
    cbStackedCPU: TCheckBox;
    cbSmoothLines: TCheckBox;
    procedure DoChange(Sender: TObject);
  private
    fPerfLogs: TKMPerfLogs;
    fControlsCreated: Boolean;
    fUpdating: Boolean;
    fAllClicked: Boolean;

    CheckBoxes: array [TPerfSectionDev, 0..2] of TCheckBox;
  public
    procedure Show(aPerfLogs: TKMPerfLogs); reintroduce;
  end;

  TCheckBoxHelper = class helper for TCheckBox
    procedure SetStateWithoutClick(aState: TCheckBoxState);
    procedure SetCheckedWithoutClick(aChecked: Boolean);
  end;


implementation
{$R *.dfm}


{ TFormPerfLogs }
procedure TFormPerfLogs.Show(aPerfLogs: TKMPerfLogs);
const
  TY = 56;
  DY = 16;
var
  I: TPerfSectionDev;
  lbl: TLabel;
  shp: TShape;
begin
  fPerfLogs := aPerfLogs;

  if not fControlsCreated then
  begin
    fUpdating := True;

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 8;
    lbl.Top := TY;
    lbl.Caption := 'Enable';

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 45;
    lbl.Top := TY;
    lbl.Caption := 'Show';

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 82;
    lbl.Top := TY;
    lbl.Caption := 'Stacked';

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 130;
    lbl.Top := TY;
    lbl.Caption := 'Section';

    for I := Low(TPerfSectionDev) to High(TPerfSectionDev) do
    begin
      CheckBoxes[I, 0] := TCheckBox.Create(Self);
      CheckBoxes[I, 0].Parent := Self;
      CheckBoxes[I, 0].Left := 8;
      CheckBoxes[I, 0].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 0].Tag := Ord(I);
      CheckBoxes[I, 0].OnClick := DoChange;

      CheckBoxes[I, 1] := TCheckBox.Create(Self);
      CheckBoxes[I, 1].Parent := Self;
      CheckBoxes[I, 1].Left := 45;
      CheckBoxes[I, 1].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 1].Tag := Ord(I);
      CheckBoxes[I, 1].OnClick := DoChange;

      CheckBoxes[I, 2] := TCheckBox.Create(Self);
      CheckBoxes[I, 2].Parent := Self;
      CheckBoxes[I, 2].Left := 82;
      CheckBoxes[I, 2].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 2].Tag := Ord(I);
      CheckBoxes[I, 2].OnClick := DoChange;

      if I <> psNone then
      begin
        CheckBoxes[I, 0].Checked := fPerfLogs[I].Enabled;
        CheckBoxes[I, 1].Checked := fPerfLogs[I].Display;
        CheckBoxes[I, 2].Checked := True;

        shp := TShape.Create(Self);
        shp.Parent := Self;
        shp.SetBounds(110, TY + DY + Ord(I) * DY + 1, DY, DY);
        shp.Pen.Style := psClear;
        shp.Brush.Color := SECTION_INFO[I].Color.ToCardinal;
      end
      else
      begin
        CheckBoxes[I, 0].AllowGrayed := True;
        CheckBoxes[I, 1].AllowGrayed := True;
        CheckBoxes[I, 2].Checked := True;
        CheckBoxes[I, 2].AllowGrayed := True;
      end;

      lbl := TLabel.Create(Self);
      lbl.Parent := Self;
      lbl.Left := 130;
      lbl.Top := TY + DY + Ord(I) * DY + 1;
      lbl.Caption := SECTION_INFO[I].Name;
    end;
    fUpdating := False;

    seFrameBudget.Value := fPerfLogs.FrameBudget;

    fControlsCreated := True;
  end;

  inherited Show;
end;


procedure TFormPerfLogs.DoChange(Sender: TObject);

  procedure ChangeCheckboxes;
  var
    I: Integer;
    PS: TPerfSectionDev;
  begin
    for I := 0 to 2 do
    begin
      if Sender <> CheckBoxes[psNone, I] then
        Continue;

      case CheckBoxes[psNone, I].State of
        cbChecked:    CheckBoxes[psNone, I].SetStateWithoutClick(cbUnchecked);
        cbGrayed:     CheckBoxes[psNone, I].SetStateWithoutClick(cbChecked);
      end;

      fAllClicked := True; //Prevent UpdateAllChkboxState

      for PS := LOW_PERF_SECTION to High(TPerfSectionDev) do
        CheckBoxes[PS, I].Checked := CheckBoxes[psNone, I].Checked;

      fAllClicked := False;

      if I = 1 then
        // No need to trigger OnChange event here, since all section events were already triggered above
        CheckBoxes[psNone, 0].SetCheckedWithoutClick(CheckBoxes[psNone, 0].Checked
                                                     or CheckBoxes[psNone, 1].Checked
                                                     or CheckBoxes[psNone, 2].Checked);
    end;

  end;

  procedure UpdateAllChkboxState;
  var
    I: Integer;
    PS: TPerfSectionDev;
    AllEnabled, AllDisabled: Boolean;
  begin
    for I := 0 to 2 do
    begin
      AllEnabled := True;
      AllDisabled := True;
      for PS := LOW_PERF_SECTION to High(TPerfSectionDev) do
      begin
        if not CheckBoxes[PS, I].Checked then
          AllEnabled := False;

        if CheckBoxes[PS, I].Checked then
          AllDisabled := False;
      end;

      if AllEnabled then
        CheckBoxes[psNone, I].SetStateWithoutClick(cbChecked)
      else
      if AllDisabled then
        CheckBoxes[psNone, I].SetStateWithoutClick(cbUnchecked)
      else
        CheckBoxes[psNone, I].SetStateWithoutClick(cbGrayed);
    end;
  end;

var
  section: TPerfSectionDev;
begin
  if fUpdating then Exit;

  section := TPerfSectionDev(TCheckBox(Sender).Tag);

  if section = psNone then
    ChangeCheckboxes
  else
  begin
    if Sender = CheckBoxes[section, 0] then
    begin
      fPerfLogs[section].Enabled := TCheckBox(Sender).Checked;
      fPerfLogs.StackCPU.SectionData[section].Enabled := TCheckBox(Sender).Checked;
    end
    else
    begin
      if Sender = CheckBoxes[section, 1] then
      begin
        fPerfLogs[section].Display := TCheckBox(Sender).Checked;
        fPerfLogs[section].Enabled := fPerfLogs[section].Enabled or fPerfLogs[section].Display;
      end
      else
      if Sender = CheckBoxes[section, 2] then
      begin
        fPerfLogs.StackCPU.SectionData[section].Show := TCheckBox(Sender).Checked;
        fPerfLogs.StackCPU.SectionData[section].Enabled := fPerfLogs.StackCPU.SectionData[section].Enabled
                                                           or TCheckBox(Sender).Checked;
      end;

      CheckBoxes[section, 0].Checked := fPerfLogs[section].Enabled or fPerfLogs.StackCPU.SectionData[section].Enabled;
    end;

    if not fAllClicked then
      UpdateAllChkboxState;
  end;

  fPerfLogs.StackCPU.Enabled := cbStackedCPU.Checked;
  fPerfLogs.StackCPU.Display := cbStackedCPU.Checked;

  fPerfLogs.StackGFX.Enabled := cbStackedGFX.Checked;
  fPerfLogs.StackGFX.Display := cbStackedGFX.Checked;

  fPerfLogs.FrameBudget := seFrameBudget.Value;

  fPerfLogs.Smoothing := cbSmoothLines.Checked;
end;


{ TCheckBoxHelper }
procedure TCheckBoxHelper.SetStateWithoutClick(aState: TCheckBoxState);
var
    BckEvent: TNotifyEvent;
begin
    BckEvent := OnClick;
    OnClick := nil;
    try
      State := aState;
    finally
      OnClick := BckEvent;
    end;
end;


procedure TCheckBoxHelper.SetCheckedWithoutClick(aChecked: Boolean);
var
    BckEvent: TNotifyEvent;
begin
    BckEvent := OnClick;
    OnClick := nil;
    try
      Checked := aChecked;
    finally
      OnClick := BckEvent;
    end;
end;


end.
