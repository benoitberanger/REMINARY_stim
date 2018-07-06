function [ Parameters ] = GetParameters
% GETPARAMETERS Prepare common parameters
global S

if isempty(S)
    %     S.Environement = 'MRI';
    %     S.Side         = 'Left';
    %     S.Task         = 'MRI';
end


%% Echo in command window

EchoStart(mfilename)


%% Paths

% Parameters.Path.wav = ['wav' filesep];


%% Set parameters

%%%%%%%%%%%
%  Audio  %
%%%%%%%%%%%

% Parameters.Audio.SamplingRate            = 44100; % Hz

% Parameters.Audio.Playback_Mode           = 1; % 1 = playback, 2 = record
% Parameters.Audio.Playback_LowLatencyMode = 1; % {0,1,2,3,4}
% Parameters.Audio.Playback_freq           = Parameters.Audio.SamplingRate ;
% Parameters.Audio.Playback_Channels       = 2; % 1 = mono, 2 = stereo

% Parameters.Audio.Record_Mode             = 2; % 1 = playback, 2 = record
% Parameters.Audio.Record_LowLatencyMode   = 0; % {0,1,2,3,4}
% Parameters.Audio.Record_freq             = Parameters.Audio.SamplingRate;
% Parameters.Audio.Record_Channels         = 1; % 1 = mono, 2 = stereo


%%%%%%%%%%%%%%
%   Screen   %
%%%%%%%%%%%%%%
% Prisma scanner @ CENIR
Parameters.Video.ScreenWidthPx   = 1024;  % Number of horizontal pixel in MRI video system @ CENIR
Parameters.Video.ScreenHeightPx  = 768;   % Number of vertical pixel in MRI video system @ CENIR
Parameters.Video.ScreenFrequency = 60;    % Refresh rate (in Hertz)
Parameters.Video.SubjectDistance = 0.120; % m
Parameters.Video.ScreenWidthM    = 0.040; % m
Parameters.Video.ScreenHeightM   = 0.030; % m

Parameters.Video.ScreenBackgroundColor = [128 128 128]; % [R G B] ( from 0 to 255 )

%%%%%%%%%%%%
%   Text   %
%%%%%%%%%%%%
Parameters.Text.SizeRatio   = 0.10; % Size = ScreenWide *ratio
Parameters.Text.Font        = 'Arial';
Parameters.Text.Color       = [255 255 255]; % [R G B] ( from 0 to 255 )
Parameters.Text.ClickCorlor = [0   255 0  ]; % [R G B] ( from 0 to 255 )

%%%%%%%%%%%%%%%%
%   REMINARY   %
%%%%%%%%%%%%%%%%

% Bip
% Parameters.REMINARY.Bip.Freq            = 440;   % Hz
% Parameters.REMINARY.Bip.BipDuration     = 0.500; % second
% Parameters.REMINARY.Bip.InOutFadeRation = 0.10;  % ration : [0-1]

% Fixation cross
Parameters.REMINARY.FixationCross.ScreenRatio    = 0.20;          % ratio : dim   = ScreenWide *ratio_screen
Parameters.REMINARY.FixationCross.lineWidthRatio = 0.05;          % ratio : width = dim        *ratio_width
Parameters.REMINARY.FixationCross.Color          = [255 255 255]; % [R G B] ( from 0 to 255 )
Parameters.REMINARY.FixationCross.PositonXRatio  = [1/3 2/3];     % Xpos = PositonXRatio * ScreenWidth
Parameters.REMINARY.FixationCross.PositonYRatio  = 0.60;           % Ypos = PositonYRatio * ScreenHight

% Text 1 : movement
Parameters.REMINARY.Text_mvt.Content        = '';
Parameters.REMINARY.Text_mvt.Conditions     = {'REEL' , 'IMAGINAIRE'};
Parameters.REMINARY.Text_mvt.PositonXRatio  = 0.50;       % Xpos = PositonXRatio * ScreenWidth
Parameters.REMINARY.Text_mvt.PositonYRatio  = 0.15;       % Ypos = PositonYRatio * ScreenHight

% Text 2 : side
Parameters.REMINARY.Text_side.Content       = '';
Parameters.REMINARY.Text_side.Conditions    = {'Gauche' , 'Droite'};
Parameters.REMINARY.Text_side.PositonXRatio = [1/3 2/3];  % Xpos = PositonXRatio * ScreenWidth
Parameters.REMINARY.Text_side.PositonYRatio = 0.30;       % Ypos = PositonYRatio * ScreenHight

% Text 3 : rest
Parameters.REMINARY.Text_rest.Content       = 'Repos';
Parameters.REMINARY.Text_rest.PositonXRatio = 1/2;  % Xpos = PositonXRatio * ScreenWidth
Parameters.REMINARY.Text_rest.PositonYRatio = 1/2;        % Ypos = PositonYRatio * ScreenHight

%%%%%%%%%%%%%%
%  Keybinds  %
%%%%%%%%%%%%%%

KbName('UnifyKeyNames');

Parameters.Keybinds.TTL_t_ASCII          = KbName('t'); % MRI trigger has to be the first defined key
% Parameters.Keybinds.emulTTL_s_ASCII      = KbName('s');
Parameters.Keybinds.Stop_Escape_ASCII    = KbName('ESCAPE');


% switch S.Task
%     
%     case 'REMINARY'
%         
%         switch S.Environement
%             
%             case 'MRI'
%                 
%                 Parameters.Fingers.Left  = KbName('e'); % Index finger
%                 Parameters.Fingers.Right = KbName('b'); % Index finger
% 
%             case 'Practice'
%                 
%                 Parameters.Fingers.Left     = KbName('LeftArrow' );
%                 Parameters.Fingers.Right    = KbName('RightArrow');
%                 
%         end
%         
%         Parameters.Fingers.Names = {'Left' 'Right'};
%         
%     case {'REMINARY' 'TryLikertScale' }
%         
%         switch S.Environement
%             
%             case 'MRI'
%                 
%                 switch S.Side
%                     case 'Left'
%                         Parameters.Fingers.Right    = KbName('e'); % Index finger
%                         Parameters.Fingers.Validate = KbName('z'); % Middle finger
%                         Parameters.Fingers.Left     = KbName('n'); % Ring finger
%                     case 'Right'
%                         Parameters.Fingers.Left     = KbName('b'); % Index finger
%                         Parameters.Fingers.Validate = KbName('y'); % Middle finger
%                         Parameters.Fingers.Right    = KbName('g'); % Ring finger
%                 end
% 
%             case 'Practice'
%                 
%                 Parameters.Fingers.Left     = KbName('LeftArrow' );
%                 Parameters.Fingers.Validate = KbName('DownArrow' );
%                 Parameters.Fingers.Right    = KbName('RightArrow');
%                 
%         end
%         
%         Parameters.Fingers.Names = {'Left' 'Validate' 'Right'};
% 
% end


%% Echo in command window

EchoStop(mfilename)


end