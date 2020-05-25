unit KM_WorkerThread;
{$I KaM_Remake.inc}
interface
uses
  Classes, SysUtils, Generics.Collections;

type
  TKMWorkerThreadTask = class
    WorkName: string;
    Proc: TProc;
  end;

  TKMWorkerThread = class(TThread)
  private
    fWorkerThreadName: string;
    fWorkCompleted: Boolean;
    fTaskQueue: TQueue<TKMWorkerThreadTask>;

    procedure NameThread; overload;
    procedure NameThread(aThreadName: string); overload;
  public
    //Special mode for exception handling. Runs work synchronously inside QueueWork
    fSynchronousExceptionMode: Boolean;

    constructor Create(const aThreadName: string = '');
    destructor Destroy; override;
    procedure Execute; override;

    procedure QueueWork(aProc: TProc; aWorkName: string = '');
    procedure WaitForAllWorkToComplete;
  end;

implementation


{ TKMWorkerThread }
constructor TKMWorkerThread.Create(const aThreadName: string = '');
begin
  //Thread isn't started until all constructors have run to completion
  //so Create(False) may be put in front as well
  inherited Create(False);

  fWorkerThreadName := aThreadName;

  {$IFDEF DEBUG}
  if fWorkerThreadName <> '' then
    TThread.NameThreadForDebugging(fWorkerThreadName, ThreadID);
  {$ENDIF}

  fWorkCompleted := False;
  fSynchronousExceptionMode := False;
  fTaskQueue := TQueue<TKMWorkerThreadTask>.Create;
end;

destructor TKMWorkerThread.Destroy;
begin
  Terminate;
  //Wake the thread if it's waiting
  TMonitor.Enter(fTaskQueue);
  try
    TMonitor.Pulse(fTaskQueue);
  finally
    TMonitor.Exit(fTaskQueue);
  end;

  inherited Destroy;

  fTaskQueue.Free; // Free task queue after Worker thread is destroyed so we don't wait for it
end;

procedure TKMWorkerThread.NameThread;
begin
  NameThread(fWorkerThreadName);
end;

procedure TKMWorkerThread.NameThread(aThreadName: string);
begin
  {$IFDEF DEBUG}
  if fWorkerThreadName <> '' then
    TThread.NameThreadForDebugging(fWorkerThreadName);
  {$ENDIF}
end;

procedure TKMWorkerThread.Execute;
var
  Job: TKMWorkerThreadTask;
  LoopRunning: Boolean;
begin
  Job := nil;
  LoopRunning := True;

  while LoopRunning do
  begin
    TMonitor.Enter(fTaskQueue);
    try
      if fTaskQueue.Count > 0 then
      begin
        Job := fTaskQueue.Dequeue;
      end
      else
      begin
        //We may only terminate once we have finished all our work
        if Terminated then
        begin
          LoopRunning := False;
        end
        else
        begin
          //Notify main thread that worker is idle if it's blocked in WaitForAllWorkToComplete
          fWorkCompleted := True;
          TMonitor.Pulse(fTaskQueue);

          TMonitor.Wait(fTaskQueue, 10000);
          if fTaskQueue.Count > 0 then
            Job := fTaskQueue.Dequeue;
        end;
      end;
    finally
      TMonitor.Exit(fTaskQueue);
    end;

    if Job <> nil then
    begin
      NameThread(Job.WorkName);
      Job.Proc();
      FreeAndNil(Job);
    end;

    NameThread;
  end;
end;

procedure TKMWorkerThread.QueueWork(aProc: TProc; aWorkName: string = '');
var
  Job: TKMWorkerThreadTask;
begin
  if fSynchronousExceptionMode then
  begin
    aProc();
  end
  else
  begin
    if Finished then
      raise Exception.Create('Worker thread not running in TKMWorkerThread.QueueWork');

    Job := TKMWorkerThreadTask.Create;
    Job.Proc := aProc;
    Job.WorkName := aWorkName;

    TMonitor.Enter(fTaskQueue);
    try
      fWorkCompleted := False;
      fTaskQueue.Enqueue(Job);

      TMonitor.Pulse(fTaskQueue);
    finally
      TMonitor.Exit(fTaskQueue);
    end;
  end;
end;

procedure TKMWorkerThread.WaitForAllWorkToComplete;
begin
  if fSynchronousExceptionMode then
    Exit;

  TMonitor.Enter(fTaskQueue);
  try
    if not fWorkCompleted and not Finished then
    begin
      //Wait infinite until worker thread finish his job
      while not TMonitor.Wait(fTaskQueue, 1000) do ;
    end;
  finally
    TMonitor.Exit(fTaskQueue);
  end;
end;

end.
