function [ TaskData ] = Task
global S

try
    %% Tunning of the task
    
    [ EP, Parameters ] = REMINARY.Planning;
    TaskData.Parameters = Parameters;
    
    % End of preparations
    EP.BuildGraph;
    TaskData.EP = EP;
    
    
    %% Prepare event record and keybinf logger
    
    [ ER, RR, KL ] = Common.PrepareRecorders( EP );
    
    
    %% Prepare objects
    
    [ Text_mvt , Text_side , Text_rest ] = REMINARY.Prepare.Text;
    [ Cross ] = REMINARY.Prepare.Cross;
    
    
    %% Eyelink
    
    Common.StartRecordingEyelink;
    
    
    %% Go
    
    % Initialize some variables
    EXIT = 0;
    
    % Loop over the EventPlanning
    for evt = 1 : size( EP.Data , 1 )
        
        Common.CommandWindowDisplay( EP, evt );
        
        switch EP.Data{evt,1}
            
            case 'StartTime' % --------------------------------------------
                
                Text_rest.Draw
                
                Screen('DrawingFinished', S.PTB.wPtr);
                Screen('Flip', S.PTB.wPtr);
                
                StartTime = Common.StartTimeEvent;
                
            case 'StopTime' % ---------------------------------------------
                
                [ ER, RR, StopTime ] = Common.StopTimeEvent( EP, ER, RR, StartTime, evt );
                
                
            case 'Rest'
                
                Text_rest.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            case 'Instruction'
                
                % Mvt ?
                switch EP.Get('Real/Imaginary',evt)
                    case 'Real'
                        mvt = S.Parameters.REMINARY.Text_mvt.Conditions{1};
                    case 'Imaginary'
                        mvt = S.Parameters.REMINARY.Text_mvt.Conditions{2};
                end
                Text_mvt .content = [S.Parameters.REMINARY.Text_mvt.Content mvt];
                
                % Side ?
                switch EP.Get('Left/Right',evt)
                    case 'Left'
                        Text_side.content = S.Parameters.REMINARY.Text_side.Conditions{1};
                        Text_side.Xptb    = S.Parameters.REMINARY.Text_side.PositonXRatio(1) * S.PTB.wRect(3);
                        center = [...
                            S.Parameters.REMINARY.FixationCross.PositonXRatio(1)*S.PTB.wRect(3) ...
                            S.Parameters.REMINARY.FixationCross.PositonYRatio   *S.PTB.wRect(4) ...
                            ];
                    case 'Right'
                        Text_side.content = S.Parameters.REMINARY.Text_side.Conditions{2};
                        Text_side.Xptb    = S.Parameters.REMINARY.Text_side.PositonXRatio(2) * S.PTB.wRect(3);
                        center = [...
                            S.Parameters.REMINARY.FixationCross.PositonXRatio(2)*S.PTB.wRect(3) ...
                            S.Parameters.REMINARY.FixationCross.PositonYRatio   *S.PTB.wRect(4) ...
                            ];
                end
                Text_side.UpdatePosition
                Cross.center = center;
                Cross.GenerateCoords;
                
                Text_mvt. Draw
                Text_side.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                secs = lastFlipOnset;
                while secs < when
                    
                    % Fetch keys
                    [keyIsDown, secs, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            case {'Real_Left', 'Real_Right', 'Imaginary_Left', 'Imaginary_Right'}
                
                Text_mvt. Draw
                Text_side.Draw
                
                Cross.Draw
                
                when = StartTime + EP.Data{evt,2} - S.PTB.slack;
                Screen('DrawingFinished', S.PTB.wPtr);
                lastFlipOnset = Screen('Flip', S.PTB.wPtr, when);
                
                ER.AddEvent({EP.Data{evt,1} lastFlipOnset-StartTime [] EP.Data{evt,4:end}});
                
                % Make the metronom
                
                nrFramesCondition = ( Parameters.ActivityDuration ) * S.PTB.FPS ;
                nrFramesCycle     = round(1/Parameters.Metronome/2 * S.PTB.FPS) ;
                nrCycles          = round(nrFramesCondition/nrFramesCycle);
                nrCycles = nrCycles + 1; % add one cycle in the program in case of delay due to machine timing imperfections
                
                value = 0;
                program = [];
                for n = 1 : nrCycles
                    value = ~value;
                    program = [program ones(1,nrFramesCycle)*value]; %#ok<AGROW>
                end
                
                counter = 0;
                
                when = StartTime + EP.Data{evt+1,2} - S.PTB.slack*3;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                while lastFlipOnset < when
                    
                    counter = counter + 1;
                    
                    Text_mvt. Draw
                    Text_side.Draw
                    
                    if program(counter)
                        Cross.Draw
                    end
                    
                    Screen('DrawingFinished', S.PTB.wPtr);
                    lastFlipOnset = Screen('Flip', S.PTB.wPtr);
                    
                    % Fetch keys
                    [keyIsDown, ~, keyCode] = KbCheck;
                    
                    if keyIsDown
                        % ~~~ ESCAPE key ? ~~~
                        [ EXIT, StopTime ] = Common.Interrupt( keyCode, ER, RR, StartTime );
                        if EXIT
                            break
                        end
                    end
                    
                end % while
                if EXIT
                    break
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                
                
            otherwise % ---------------------------------------------------
                
                error('unknown envent')
                
        end % switch
        
        % This flag comes from Common.Interrupt, if ESCAPE is pressed
        if EXIT
            break
        end
        
    end % for
    
    
    %% End of stimulation
    
    % Close the audio device
    % PsychPortAudio('Close');
    
    TaskData = Common.EndOfStimulation( TaskData, EP, ER, RR, KL, StartTime, StopTime );
    
    % TaskData.BR = BR;
    % assignin('base','BR', BR)
    
    
catch err
    
    Common.Catch( err );
    
end

end % function
