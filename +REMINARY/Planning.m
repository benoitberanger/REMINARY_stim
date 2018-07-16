function [ EP , Parameters ] = Planning
global S

if nargout < 1 % only to plot the paradigme when we execute the function outside of the main script
    S.OperationMode = 'Acquisition';
end


%% Paradigme

switch S.OperationMode
    case 'Acquisition'
        Parameters.NrRepetitions       = 8;
        Parameters.InstructionDuration = 1;   % second
        Parameters.ActivityDuration    = 20;  % second
        Parameters.RestDuration        = 10;  % second
        Parameters.Metronome           = 0.35;% Hz
    case 'FastDebug'
        Parameters.NrRepetitions       = 1;
        Parameters.InstructionDuration = 1;   % second
        Parameters.ActivityDuration    = 5;   % second
        Parameters.RestDuration        = 2;   % second
        Parameters.Metronome           = 0.35;% Hz
    case 'RealisticDebug'
        Parameters.NrRepetitions       = 1;
        Parameters.InstructionDuration = 1;   % second
        Parameters.ActivityDuration    = 20;  % second
        Parameters.RestDuration        = 2;   % second
        Parameters.Metronome           = 0.35;% Hz
end


%% Randomization the trials

Parameters.ListOfConditions_str = {'Real_Left', 'Real_Right', 'Imaginary_Left', 'Imaginary_Right'};
Parameters.ListOfConditions_num = [ 1         ,  2          ,  3              ,  4               ];

Parameters.ConditionOrder_num = Common.ShuffleN(Parameters.ListOfConditions_num, Parameters.NrRepetitions);
Parameters.ConditionOrder_str = Parameters.ListOfConditions_str(Parameters.ConditionOrder_num);

NrTrials = length(Parameters.ConditionOrder_num);


%% Define a planning <--- paradigme


% Create and prepare
header = { 'event_name', 'onset(s)', 'duration(s)', 'Real/Imaginary', 'Left/Right' '#Condition'};
EP     = EventPlanning(header);

% NextOnset = PreviousOnset + PreviousDuration
NextOnset = @(EP) EP.Data{end,2} + EP.Data{end,3};


% --- Start ---------------------------------------------------------------

EP.AddStartTime('StartTime',0);

% --- Stim ----------------------------------------------------------------

EP.AddPlanning({ 'Rest' NextOnset(EP) Parameters.RestDuration [] [] [] })

for evt = 1 : NrTrials
    
    name = Parameters.ConditionOrder_str{evt};
    res  = regexp(name,'_','split');
    mvt  = res{1};
    side = res{2};
    idx  = Parameters.ConditionOrder_num(evt);
    
    EP.AddPlanning({ 'Instruction' NextOnset(EP) Parameters.InstructionDuration  mvt side idx })
    
    EP.AddPlanning({ name NextOnset(EP) Parameters.ActivityDuration  mvt side idx })
    
    EP.AddPlanning({ 'Rest' NextOnset(EP) Parameters.RestDuration  [] [] [] })
    
end

% --- Stop ----------------------------------------------------------------

EP.AddStopTime('StopTime',NextOnset(EP));


%% Display

% To prepare the planning and visualize it, we can execute the function
% without output argument

if nargout < 1
    
    fprintf( '\n' )
    fprintf(' \n Total stim duration : %g seconds \n' , NextOnset(EP) )
    fprintf( '\n' )
    
    EP.Plot
    
end


end % function
