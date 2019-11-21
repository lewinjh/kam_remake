unit GeneticAlgorithmParameters;

interface
uses
  Classes, SysUtils, Math,
  GeneticAlgorithm,
  KM_Log, KM_AIParameters;

type
  TGAParameterization = class
  private
    fLogPar: TKMLog;
    fClass: String;
    function Incr(var Idx: Integer): Integer;
    // Get count of parameters
    function GetParCnt_HandLogistics(): Word;
    function GetParCnt_CityBuilder(): Word;
    function GetParCnt_Farm(): Word;
    function GetParCnt_Quarry(): Word;
    function GetParCnt_RoadPlanner(): Word;
    function GetParCnt_Forest(): Word;
    function GetParCnt_CityPlanner(): Word;
    // Set global parameters
    procedure SetPar_HandLogistics(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_CityBuilder(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_Farm(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_Quarry(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_RoadPlanner(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_Forest(aIdv: TGAIndividual; aLogIt: Boolean = False);
    procedure SetPar_CityPlanner(aIdv: TGAIndividual; aLogIt: Boolean = False);
  public
    constructor Create();
    destructor Destroy(); override;

    property SetLogPar: TKMLog write fLogPar;
    property CurrentClass: String read fClass write fClass;

    function GetParCnt(aNewClass: String = ''): Word;
    procedure SetPar(aIdv: TGAIndividual; aLogIt: Boolean = False);
  end;

implementation


{ TGAParameterization }
constructor TGAParameterization.Create();
begin
  inherited;

  fLogPar := nil;
  fClass := '';
end;


destructor TGAParameterization.Destroy();
begin
  fLogPar := nil;
  fClass := '';

  inherited;
end;



// Small helping function
function TGAParameterization.Incr(var Idx: Integer): Integer;
begin
  Result := Idx;
  Inc(Idx);
end;


function TGAParameterization.GetParCnt(aNewClass: String = ''): Word;
begin
  if not (CompareStr(aNewClass, '') = 0) then
    fClass := aNewClass;
  if      (CompareStr(fClass, 'TKMRunnerGA_CityBuilder'  ) = 0) then Result := GetParCnt_CityBuilder
  else if (CompareStr(fClass, 'TKMRunnerGA_CityPlanner'  ) = 0) then Result := GetParCnt_CityPlanner
  else if (CompareStr(fClass, 'TKMRunnerGA_Farm'         ) = 0) then Result := GetParCnt_Farm
  else if (CompareStr(fClass, 'TKMRunnerGA_Forest'       ) = 0) then Result := GetParCnt_Forest
  else if (CompareStr(fClass, 'TKMRunnerGA_HandLogistics') = 0) then Result := GetParCnt_HandLogistics
  else if (CompareStr(fClass, 'TKMRunnerGA_Quarry'       ) = 0) then Result := GetParCnt_Quarry
  else if (CompareStr(fClass, 'TKMRunnerGA_RoadPlanner'  ) = 0) then Result := GetParCnt_RoadPlanner
  else Result := 0;
end;

procedure TGAParameterization.SetPar(aIdv: TGAIndividual; aLogIt: Boolean = False);
begin
  if      (CompareStr(fClass, 'TKMRunnerGA_CityBuilder'  ) = 0) then SetPar_CityBuilder(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_CityPlanner'  ) = 0) then SetPar_CityPlanner(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_Farm'         ) = 0) then SetPar_Farm(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_Forest'       ) = 0) then SetPar_Forest(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_HandLogistics') = 0) then SetPar_HandLogistics(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_Quarry'       ) = 0) then SetPar_Quarry(aIdv, aLogIt)
  else if (CompareStr(fClass, 'TKMRunnerGA_RoadPlanner'  ) = 0) then SetPar_RoadPlanner(aIdv, aLogIt);
end;


function TGAParameterization.GetParCnt_HandLogistics(): Word;
begin
  Result := 0;
end;

procedure TGAParameterization.SetPar_HandLogistics(aIdv: TGAIndividual; aLogIt: Boolean = False);
//var
//  I: Integer;
begin
  //I := 0;

  //GA_TCBB_BasicInit   := Max(1, Round(aIdv.Gene[Incr(K)] * 20));
  //GA_TCBB_BasicRnd    := Max(1, Round(aIdv.Gene[Incr(K)] * 60)+40);
  //GA_TCBB_NormRnd     := Max(1, Round(aIdv.Gene[Incr(K)] * 32));
  //GA_TCBB_Rnd         := Max(1, Round(aIdv.Gene[Incr(K)] * 50));
  //GA_TCBB_BasicPwr    := Max(1, Round(GA_TCBB_BasicRnd / 5)); // GA has discovered that this is best strategy
  //GA_TCBB_NormPwr     := Max(1, Round(GA_TCBB_NormRnd / 5));
  //
  //if aLogIt then
  //begin
  //  fLogPar.AddTime('GA_TCBB_BasicInit   : Integer = ' + IntToStr( GA_TCBB_BasicInit ) + ';');
  //  fLogPar.AddTime('GA_TCBB_BasicRnd    : Integer = ' + IntToStr( GA_TCBB_BasicRnd  ) + ';');
  //  fLogPar.AddTime('GA_TCBB_BasicPwr    : Integer = ' + IntToStr( GA_TCBB_BasicPwr  ) + ';');
  //  fLogPar.AddTime('GA_TCBB_NormRnd     : Integer = ' + IntToStr( GA_TCBB_NormRnd   ) + ';');
  //  fLogPar.AddTime('GA_TCBB_NormPwr     : Integer = ' + IntToStr( GA_TCBB_NormPwr   ) + ';');
  //  fLogPar.AddTime('GA_TCBB_Rnd         : Integer = ' + IntToStr( GA_TCBB_Rnd       ) + ';');
  //end;
end;


function TGAParameterization.GetParCnt_CityBuilder(): Word;
begin
  Result := 4+5+5+2;
end;

procedure TGAParameterization.SetPar_CityBuilder(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_BUILDER_BuildHouse_FieldMaxWork    := Max(1, aIdv.Gene[Incr(K)] * 3);
  GA_BUILDER_BuildHouse_RTPMaxWork      := Max(1, aIdv.Gene[Incr(K)] * 10);
  GA_BUILDER_BuildHouse_RoadMaxWork     := Max(1, aIdv.Gene[Incr(K)] * 30);
  GA_BUILDER_CreateShortcuts_MaxWork    := Max(1, aIdv.Gene[Incr(K)] * 20);

  GA_BUILDER_ChHTB_FractionCoef         := Max(1, aIdv.Gene[Incr(K)] * 30);
  GA_BUILDER_ChHTB_TrunkFactor          := Max(1, aIdv.Gene[Incr(K)] * 20);
  GA_BUILDER_ChHTB_TrunkBalance         := Max(1, aIdv.Gene[Incr(K)] * 10);
  GA_BUILDER_ChHTB_AllWorkerCoef        := Max(1, aIdv.Gene[Incr(K)] * 15);
  GA_BUILDER_ChHTB_FreeWorkerCoef       := Max(1, aIdv.Gene[Incr(K)] * 10);

  GA_BUILDER_Shortage_Stone             := Max(1, aIdv.Gene[Incr(K)] * 20);
  GA_BUILDER_Shortage_StoneNoQuarry     := Max(1, aIdv.Gene[Incr(K)] * 20 + 20);
  GA_BUILDER_Shortage_Gold              := Max(1, aIdv.Gene[Incr(K)] * 20 + 20);
  GA_BUILDER_Shortage_Trunk             := Max(0.1, aIdv.Gene[Incr(K)] * 10);
  GA_BUILDER_Shortage_Wood              := Max(1, aIdv.Gene[Incr(K)] * 20);

  GA_PREDICTOR_WareNeedPerAWorker_Stone := aIdv.Gene[Incr(K)] * 1;
  GA_PREDICTOR_WareNeedPerAWorker_Wood  := aIdv.Gene[Incr(K)] * 1;

  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_BUILDER_BuildHouse_FieldMaxWork              : Single = %16.10f;',[ GA_BUILDER_BuildHouse_FieldMaxWork    ]));
    fLogPar.AddTime(Format('GA_BUILDER_BuildHouse_RTPMaxWork                : Single = %16.10f;',[ GA_BUILDER_BuildHouse_RTPMaxWork      ]));
    fLogPar.AddTime(Format('GA_BUILDER_BuildHouse_RoadMaxWork               : Single = %16.10f;',[ GA_BUILDER_BuildHouse_RoadMaxWork     ]));
    fLogPar.AddTime(Format('GA_BUILDER_CreateShortcuts_MaxWork              : Single = %16.10f;',[ GA_BUILDER_CreateShortcuts_MaxWork    ]));
    fLogPar.AddTime(Format('GA_BUILDER_ChHTB_FractionCoef                   : Single = %16.10f;',[ GA_BUILDER_ChHTB_FractionCoef         ]));
    fLogPar.AddTime(Format('GA_BUILDER_ChHTB_TrunkFactor                    : Single = %16.10f;',[ GA_BUILDER_ChHTB_TrunkFactor          ]));
    fLogPar.AddTime(Format('GA_BUILDER_ChHTB_TrunkBalance                   : Single = %16.10f;',[ GA_BUILDER_ChHTB_TrunkBalance         ]));
    fLogPar.AddTime(Format('GA_BUILDER_ChHTB_AllWorkerCoef                  : Single = %16.10f;',[ GA_BUILDER_ChHTB_AllWorkerCoef        ]));
    fLogPar.AddTime(Format('GA_BUILDER_ChHTB_FreeWorkerCoef                 : Single = %16.10f;',[ GA_BUILDER_ChHTB_FreeWorkerCoef       ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Stone                       : Single = %16.10f;',[ GA_BUILDER_Shortage_Stone             ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_StoneNoQuarry               : Single = %16.10f;',[ GA_BUILDER_Shortage_StoneNoQuarry     ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Gold                        : Single = %16.10f;',[ GA_BUILDER_Shortage_Gold              ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Trunk                       : Single = %16.10f;',[ GA_BUILDER_Shortage_Trunk             ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Wood                        : Single = %16.10f;',[ GA_BUILDER_Shortage_Wood              ]));
    fLogPar.AddTime(Format('GA_PREDICTOR_WareNeedPerAWorker_Stone           : Single = %16.10f;',[ GA_PREDICTOR_WareNeedPerAWorker_Stone ]));
    fLogPar.AddTime(Format('GA_PREDICTOR_WareNeedPerAWorker_Wood            : Single = %16.10f;',[ GA_PREDICTOR_WareNeedPerAWorker_Wood  ]));
  end;
end;


function TGAParameterization.GetParCnt_Farm(): Word;
begin
  Result := 4+4;
end;

procedure TGAParameterization.SetPar_Farm(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_PLANNER_PlanFields_CanBuild   :=  0 + Round(aIdv.Gene[Incr(K)] * 75);
  GA_PLANNER_PlanFields_Dist       :=  0 + Round(aIdv.Gene[Incr(K)] * 75);
  GA_PLANNER_PlanFields_ExistField :=  0 + Round(aIdv.Gene[Incr(K)] * 75);
  GA_PLANNER_PlanFields_MaxFields  := 12 + Round(aIdv.Gene[Incr(K)] *  8);

  GA_PLANNER_FindPlaceForHouse_RouteFarm      := -2 + aIdv.Gene[Incr(K)] *   1 * 4; // 0-255
  GA_PLANNER_FindPlaceForHouse_FlatAreaFarm   := -5 + aIdv.Gene[Incr(K)] *   3 * 4; // 0-82
  GA_PLANNER_FindPlaceForHouse_HouseDistFarm  :=  0 + aIdv.Gene[Incr(K)] *  10 * 1; // 3-100+
  GA_PLANNER_FindPlaceForHouse_CityCenterFarm :=  0 + aIdv.Gene[Incr(K)] *  10 * 5; // 3-100+;

  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_PLANNER_PlanFields_CanBuild                  : Word = %4d;',[ GA_PLANNER_PlanFields_CanBuild   ]));
    fLogPar.AddTime(Format('GA_PLANNER_PlanFields_Dist                      : Word = %4d;',[ GA_PLANNER_PlanFields_Dist       ]));
    fLogPar.AddTime(Format('GA_PLANNER_PlanFields_ExistField                : Word = %4d;',[ GA_PLANNER_PlanFields_ExistField ]));
    fLogPar.AddTime(Format('GA_PLANNER_PlanFields_MaxFields                 : Word = %4d;',[ GA_PLANNER_PlanFields_MaxFields  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_RouteFarm          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_RouteFarm      ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_FlatAreaFarm       : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_FlatAreaFarm   ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_HouseDistFarm      : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_HouseDistFarm  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_CityCenterFarm     : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_CityCenterFarm ]));
  end;
end;


function TGAParameterization.GetParCnt_Quarry(): Word;
begin
  Result := 5;
end;

procedure TGAParameterization.SetPar_Quarry(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_PLANNER_FindPlaceForQuary_Obstacle	 := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_DistCity	 := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_DistTimer := aIdv.Gene[Incr(K)] * 30000;
  GA_PLANNER_FindPlaceForQuary_DistStone := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_SnapCrit	 := aIdv.Gene[Incr(K)] * 50;

  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_Obstacle           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_Obstacle  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistCity           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistCity  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistTimer          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistTimer ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistStone          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistStone ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_SnapCrit           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_SnapCrit  ]));
  end;
end;


function TGAParameterization.GetParCnt_RoadPlanner(): Word;
begin
  Result := 7+7+2+5;
end;

procedure TGAParameterization.SetPar_RoadPlanner(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_PATHFINDING_BasePrice    := 30 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_PATHFINDING_Road         :=  0 + Min(GA_PATHFINDING_BasePrice,Round( aIdv.Gene[Incr(K)] * 50 ));
  GA_PATHFINDING_noBuildArea  := 10 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_PATHFINDING_Field        :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_PATHFINDING_Coal         :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_PATHFINDING_Forest       := 30 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_PATHFINDING_OtherCase    :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );

  GA_SHORTCUTS_BasePrice      := 35 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_SHORTCUTS_Road           :=  0 + Min(GA_SHORTCUTS_BasePrice,Round( aIdv.Gene[Incr(K)] * 50 ));
  GA_SHORTCUTS_noBuildArea    :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_SHORTCUTS_Field          :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_SHORTCUTS_Coal           :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_SHORTCUTS_Forest         :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );
  GA_SHORTCUTS_OtherCase      :=  0 + Round( aIdv.Gene[Incr(K)] * 50 );

  GA_MANAGEMENT_CheckUnitCount_SerfCoef  := Max(0.01, aIdv.Gene[Incr(K)] * 2);
  GA_MANAGEMENT_CheckUnitCount_SerfLimit := Max(0.01, aIdv.Gene[Incr(K)] * 2);

  GA_PLANNER_FindPlaceForQuary_Obstacle	 := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_DistCity	 := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_DistTimer := aIdv.Gene[Incr(K)] * 30000;
  GA_PLANNER_FindPlaceForQuary_DistStone := aIdv.Gene[Incr(K)] * 50;
  GA_PLANNER_FindPlaceForQuary_SnapCrit	 := aIdv.Gene[Incr(K)] * 50;

  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_PATHFINDING_BasePrice                        : Word = %4d;',[ GA_PATHFINDING_BasePrice   ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_Road                             : Word = %4d;',[ GA_PATHFINDING_Road        ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_noBuildArea                      : Word = %4d;',[ GA_PATHFINDING_noBuildArea ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_Field                            : Word = %4d;',[ GA_PATHFINDING_Field       ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_Coal                             : Word = %4d;',[ GA_PATHFINDING_Coal        ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_Forest                           : Word = %4d;',[ GA_PATHFINDING_Forest      ]));
    fLogPar.AddTime(Format('GA_PATHFINDING_OtherCase                        : Word = %4d;',[ GA_PATHFINDING_OtherCase   ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_BasePrice                          : Word = %4d;',[ GA_SHORTCUTS_BasePrice     ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_Road                               : Word = %4d;',[ GA_SHORTCUTS_Road          ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_noBuildArea                        : Word = %4d;',[ GA_SHORTCUTS_noBuildArea   ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_Field                              : Word = %4d;',[ GA_SHORTCUTS_Field         ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_Coal                               : Word = %4d;',[ GA_SHORTCUTS_Coal          ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_Forest                             : Word = %4d;',[ GA_SHORTCUTS_Forest        ]));
    fLogPar.AddTime(Format('GA_SHORTCUTS_OtherCase                          : Word = %4d;',[ GA_SHORTCUTS_OtherCase     ]));
    fLogPar.AddTime(Format('GA_MANAGEMENT_CheckUnitCount_SerfCoef           : Single = %16.10f;',[ GA_MANAGEMENT_CheckUnitCount_SerfCoef  ]));
    fLogPar.AddTime(Format('GA_MANAGEMENT_CheckUnitCount_SerfLimit          : Single = %16.10f;',[ GA_MANAGEMENT_CheckUnitCount_SerfLimit ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_Obstacle           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_Obstacle  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistCity           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistCity  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistTimer          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistTimer ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_DistStone          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_DistStone ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForQuary_SnapCrit           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForQuary_SnapCrit  ]));
  end;
end;


function TGAParameterization.GetParCnt_Forest(): Word;
begin
  Result := 6+12+2;
end;

procedure TGAParameterization.SetPar_Forest(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_EYE_GetForests_MaxAB            :=   1 + aIdv.Gene[Incr(K)] * 200; // <0,201> Ignore trees in existing forest <0,255-AVOID_BUILDING_FOREST_MINIMUM)
  GA_EYE_GetForests_Radius           :=   6 + aIdv.Gene[Incr(K)] *   4; // Forest radius
  GA_EYE_GetForests_MinTrees         :=   3 + aIdv.Gene[Incr(K)] *   3; // Min trees in forest
  GA_EYE_GetForests_SPRndOwnLimMin   :=  55 + aIdv.Gene[Incr(K)] * 100; // Minimum influence of potential forest
  GA_EYE_GetForests_SPRndOwnLimMax   := 255 - aIdv.Gene[Incr(K)] * 100; // Maximum influence of potential forest
  GA_EYE_GetForests_MinRndSoil       :=  50 + aIdv.Gene[Incr(K)] *  32; // 0-82

  GA_PLANNER_FindPlaceForWoodcutter_TreeCnt       := 0 + aIdv.Gene[Incr(K)] *  21 * 2 ; // 0-~12
  GA_PLANNER_FindPlaceForWoodcutter_TreeCntTimer  := 6000 + aIdv.Gene[Incr(K)] * 12000; // 6000-18000 10-30 min
  GA_PLANNER_FindPlaceForWoodcutter_ExistForest   := 0 + aIdv.Gene[Incr(K)] * 255 * 2 ; // 0-1
  GA_PLANNER_FindPlaceForWoodcutter_Routes        :=-1 + aIdv.Gene[Incr(K)] *   2 * 1 ; // -255<->255
  GA_PLANNER_FindPlaceForWoodcutter_FlatArea      := 0 + aIdv.Gene[Incr(K)] *   3 * 2 ; // 0-81
  GA_PLANNER_FindPlaceForWoodcutter_Soil          := 0 + aIdv.Gene[Incr(K)] *   3 * 1 ; // 0-81
  GA_PLANNER_FindPlaceForWoodcutter_DistCrit      := 0 + aIdv.Gene[Incr(K)] *  10 * 1 ; // 0-20
  GA_PLANNER_FindPlaceForWoodcutter_DistTimer     := 6000 + aIdv.Gene[Incr(K)] * 12000; // 6000-18000 10-30 min
  GA_PLANNER_FindPlaceForWoodcutter_FreeTiles     := 0 + aIdv.Gene[Incr(K)] *   3 * 2 ; // 0-81
  GA_PLANNER_FindPlaceForWoodcutter_ABRange       := 0 + aIdv.Gene[Incr(K)] * 200; // 0-200
  GA_PLANNER_FindPlaceForWoodcutter_Radius        := 3 + aIdv.Gene[Incr(K)] *   4;
  GA_PLANNER_FindForestAround_MaxDist             := 5 + aIdv.Gene[Incr(K)] *   5; // 4-10

  GA_BUILDER_Shortage_Trunk                       := 2 + aIdv.Gene[Incr(K)] * 3;
  GA_BUILDER_Shortage_Wood                        := 10 + aIdv.Gene[Incr(K)] * 10;

  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_EYE_GetForests_MaxAB                         : Single = %16.10f;',[ GA_EYE_GetForests_MaxAB                        ]));
    fLogPar.AddTime(Format('GA_EYE_GetForests_Radius                        : Single = %16.10f;',[ GA_EYE_GetForests_Radius                       ]));
    fLogPar.AddTime(Format('GA_EYE_GetForests_MinTrees                      : Single = %16.10f;',[ GA_EYE_GetForests_MinTrees                     ]));
    fLogPar.AddTime(Format('GA_EYE_GetForests_SPRndOwnLimMin                : Single = %16.10f;',[ GA_EYE_GetForests_SPRndOwnLimMin               ]));
    fLogPar.AddTime(Format('GA_EYE_GetForests_SPRndOwnLimMax                : Single = %16.10f;',[ GA_EYE_GetForests_SPRndOwnLimMax               ]));
    fLogPar.AddTime(Format('GA_EYE_GetForests_MinRndSoil                    : Single = %16.10f;',[ GA_EYE_GetForests_MinRndSoil                   ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_TreeCnt       : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_TreeCnt      ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_TreeCntTimer  : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_TreeCntTimer ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_ExistForest   : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_ExistForest  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_Routes        : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_Routes       ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_FlatArea      : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_FlatArea     ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_Soil          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_Soil         ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_DistCrit      : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_DistCrit     ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_DistTimer     : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_DistTimer    ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_FreeTiles     : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_FreeTiles    ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_ABRange       : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_ABRange      ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForWoodcutter_Radius        : Single = %16.10f;',[ GA_PLANNER_FindPlaceForWoodcutter_Radius       ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindForestAround_MaxDist             : Single = %16.10f;',[ GA_PLANNER_FindForestAround_MaxDist            ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Trunk                       : Single = %16.10f;',[ GA_BUILDER_Shortage_Trunk                      ]));
    fLogPar.AddTime(Format('GA_BUILDER_Shortage_Wood                        : Single = %16.10f;',[ GA_BUILDER_Shortage_Wood                       ]));
  end;
end;


function TGAParameterization.GetParCnt_CityPlanner(): Word;
begin
  Result := 2+3+4+11;
end;

procedure TGAParameterization.SetPar_CityPlanner(aIdv: TGAIndividual; aLogIt: Boolean = False);
var
  K: Integer;
begin
  K := 0;

  GA_PLANNER_ObstaclesInHousePlan_Tree       := aIdv.Gene[Incr(K)] * 100 * 10; // 0-3+
  GA_PLANNER_ObstaclesInHousePlan_Road       := aIdv.Gene[Incr(K)] *  50 * 10; // 0-5+

  GA_PLANNER_FieldCrit_PolyRoute             := aIdv.Gene[Incr(K)] *   1 * 5; // 0-255
  GA_PLANNER_FieldCrit_FlatArea              := aIdv.Gene[Incr(K)] *   3 * 4; // 0-82
  GA_PLANNER_FieldCrit_Soil                  := aIdv.Gene[Incr(K)] *   3 * 1; // 0-82

  GA_PLANNER_SnapCrit_SnapToHouse            := aIdv.Gene[Incr(K)] *  10 * 5; // 0-5+
  GA_PLANNER_SnapCrit_SnapToFields           := aIdv.Gene[Incr(K)] *  10 * 5; // 0-5+
  GA_PLANNER_SnapCrit_SnapToRoads            := aIdv.Gene[Incr(K)] *  10 * 5; // 0-5+
  GA_PLANNER_SnapCrit_ClearEntrance          := aIdv.Gene[Incr(K)] *  10 * 8; // 0-6

  GA_PLANNER_FindPlaceForHouse_SnapCrit      := aIdv.Gene[Incr(K)] *   2 * 1; // var
  GA_PLANNER_FindPlaceForHouse_HouseDist     := aIdv.Gene[Incr(K)] *  10 * 2; // 3-100+
  GA_PLANNER_FindPlaceForHouse_SeedDist      := aIdv.Gene[Incr(K)] *  10 * 5; // 3-30
  GA_PLANNER_FindPlaceForHouse_CityCenter    := aIdv.Gene[Incr(K)] *  10 * 5; // 3-100+
  GA_PLANNER_FindPlaceForHouse_Route         := aIdv.Gene[Incr(K)] *   1 * 4; // 0-255
  GA_PLANNER_FindPlaceForHouse_FlatArea      := aIdv.Gene[Incr(K)] *   3 * 4; // 0-82
  GA_PLANNER_FindPlaceForHouse_RouteFarm     := -2+aIdv.Gene[Incr(K)] *   1 * 4; // 0-255
  GA_PLANNER_FindPlaceForHouse_FlatAreaFarm  := -5+aIdv.Gene[Incr(K)] *   3 * 4; // 0-82
  GA_PLANNER_FindPlaceForHouse_HouseDistFarm := aIdv.Gene[Incr(K)] *  10 * 1; // 3-100+
  GA_PLANNER_FindPlaceForHouse_CityCenterFarm:= aIdv.Gene[Incr(K)] *  10 * 5; // 3-100+;
  GA_PLANNER_PlaceWoodcutter_DistFromForest  := aIdv.Gene[Incr(K)] *  10 * 1; // 0-X


  if aLogIt AND (fLogPar <> nil) then
  begin
    fLogPar.AddTime(Format('GA_PLANNER_ObstaclesInHousePlan_Tree            : Single = %16.10f;',[ GA_PLANNER_ObstaclesInHousePlan_Tree        ]));
    fLogPar.AddTime(Format('GA_PLANNER_ObstaclesInHousePlan_Road            : Single = %16.10f;',[ GA_PLANNER_ObstaclesInHousePlan_Road        ]));
    fLogPar.AddTime(Format('GA_PLANNER_FieldCrit_PolyRoute                  : Single = %16.10f;',[ GA_PLANNER_FieldCrit_PolyRoute              ]));
    fLogPar.AddTime(Format('GA_PLANNER_FieldCrit_FlatArea                   : Single = %16.10f;',[ GA_PLANNER_FieldCrit_FlatArea               ]));
    fLogPar.AddTime(Format('GA_PLANNER_FieldCrit_Soil                       : Single = %16.10f;',[ GA_PLANNER_FieldCrit_Soil                   ]));
    fLogPar.AddTime(Format('GA_PLANNER_SnapCrit_SnapToHouse                 : Single = %16.10f;',[ GA_PLANNER_SnapCrit_SnapToHouse             ]));
    fLogPar.AddTime(Format('GA_PLANNER_SnapCrit_SnapToFields                : Single = %16.10f;',[ GA_PLANNER_SnapCrit_SnapToFields            ]));
    fLogPar.AddTime(Format('GA_PLANNER_SnapCrit_SnapToRoads                 : Single = %16.10f;',[ GA_PLANNER_SnapCrit_SnapToRoads             ]));
    fLogPar.AddTime(Format('GA_PLANNER_SnapCrit_ClearEntrance               : Single = %16.10f;',[ GA_PLANNER_SnapCrit_ClearEntrance           ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_SnapCrit           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_SnapCrit       ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_HouseDist          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_HouseDist      ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_SeedDist           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_SeedDist       ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_CityCenter         : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_CityCenter     ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_Route              : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_Route          ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_FlatArea           : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_FlatArea       ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_RouteFarm          : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_RouteFarm      ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_FlatAreaFarm       : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_FlatAreaFarm   ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_HouseDistFarm      : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_HouseDistFarm  ]));
    fLogPar.AddTime(Format('GA_PLANNER_FindPlaceForHouse_CityCenterFarm     : Single = %16.10f;',[ GA_PLANNER_FindPlaceForHouse_CityCenterFarm ]));
    fLogPar.AddTime(Format('GA_PLANNER_PlaceWoodcutter_DistFromForest       : Single = %16.10f;',[ GA_PLANNER_PlaceWoodcutter_DistFromForest   ]));
  end;
end;


end.