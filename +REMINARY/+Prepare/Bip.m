function bip = Bip
global S

%% Parameters

fs  = S.Parameters.Audio.SamplingRate;
f0  = S.Parameters.REMINARY.Bip.Freq;
dur = S.Parameters.REMINARY.Bip.BipDuration;
iof = S.Parameters.REMINARY.Bip.InOutFadeRation;


%% Create objects

bip = Bip( fs , f0 , dur , iof );
bip. LinkToPAhandle( S.PTB.Playback_pahandle );
bip.AssertReadyForPlayback; % just to check


end % function
