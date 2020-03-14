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

    CheckBoxes: array [TPerfSectionDev, 0..2] of TCheckBox;
  public
    procedure Show(aPerfLogs: TKMPerfLogs); reintroduce;
  end;


implementation
{$R *.dfm}


{ TFormPerfLogs }
procedure TFormPerfLogs.Show(aPerfLogs: TKMPerfLogs);
const
  TY = 4;
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
    lbl.Left := 32;
    lbl.Top := TY;
    lbl.Caption := 'Show';

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 60;
    lbl.Top := TY;
    lbl.Caption := 'ShowStacked';

    lbl := TLabel.Create(Self);
    lbl.Parent := Self;
    lbl.Left := 110;
    lbl.Top := TY;
    lbl.Caption := 'Section';

    for I := LOW_PERF_SECTION to High(TPerfSectionDev) do
    begin
      CheckBoxes[I, 0] := TCheckBox.Create(Self);
      CheckBoxes[I, 0].Parent := Self;
      CheckBoxes[I, 0].Left := 8;
      CheckBoxes[I, 0].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 0].Tag := Ord(I);
      CheckBoxes[I, 0].Checked := fPerfLogs[I].Enabled;
      CheckBoxes[I, 0].OnClick := DoChange;

      CheckBoxes[I, 1] := TCheckBox.Create(Self);
      CheckBoxes[I, 1].Parent := Self;
      CheckBoxes[I, 1].Left := 32;
      CheckBoxes[I, 1].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 1].Tag := Ord(I);
      CheckBoxes[I, 1].Checked := fPerfLogs[I].Display;
      CheckBoxes[I, 1].OnClick := DoChange;

      CheckBoxes[I, 2] := TCheckBox.Create(Self);
      CheckBoxes[I, 2].Parent := Self;
      CheckBoxes[I, 2].Left := 56;
      CheckBoxes[I, 2].Top := TY + DY + Ord(I) * DY;
      CheckBoxes[I, 2].Tag := Ord(I);
      CheckBoxes[I, 2].Checked := True; //fPerfLogs.StackCPU.SectionData[I].Show;
      CheckBoxes[I, 2].OnClick := DoChange;

      shp := TShape.Create(Self);
      shp.Parent := Self;
      shp.SetBounds(80, TY + DY + Ord(I) * DY + 1, DY, DY);
      shp.Pen.Style := psClear;
      shp.Brush.Color := SECTION_INFO[I].Color.ToCardinal;

      lbl := TLabel.Create(Self);
      lbl.Parent := Self;
      lbl.Left := 104;
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
var
  section: TPerfSectionDev;
begin
  if fUpdating then Exit;

  section := TPerfSectionDev(TCheckBox(Sender).Tag);

  if Sender = CheckBoxes[section, 0] then
    fPerfLogs[section].Enabled := TCheckBox(Sender).Checked
  else
  if Sender = CheckBoxes[section, 1] then
  begin
    fPerfLogs[section].Display := TCheckBox(Sender).Checked;
    fPerfLogs[section].Enabled := fPerfLogs[section].Enabled or fPerfLogs[section].Display;
    CheckBoxes[section, 0].Checked := fPerfLogs[section].Enabled;
  end
  else
  if Sender = CheckBoxes[section, 2] then
    fPerfLogs.StackCPU.SectionData[section].Show := TCheckBox(Sender).Checked;

  fPerfLogs.StackCPU.Enabled := cbStackedCPU.Checked;
  fPerfLogs.StackCPU.Display := cbStackedCPU.Checked;

  fPerfLogs.StackGFX.Enabled := cbStackedGFX.Checked;
  fPerfLogs.StackGFX.Display := cbStackedGFX.Checked;

  fPerfLogs.FrameBudget := seFrameBudget.Value;

  fPerfLogs.Smoothing := cbSmoothLines.Checked;
end;


end.
