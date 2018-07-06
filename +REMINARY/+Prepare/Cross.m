function [ cross ] = Cross
global S

dim    = round(S.PTB.wRect(4)*S.Parameters.REMINARY.FixationCross.ScreenRatio);
width  = round(dim * S.Parameters.REMINARY.FixationCross.lineWidthRatio);
color  = S.Parameters.REMINARY.FixationCross.Color;
center = [...
    S.Parameters.REMINARY.FixationCross.PositonYRatio*S.PTB.wRect(3) ... % arbitrary, will be updated in the script
    S.Parameters.REMINARY.FixationCross.PositonYRatio*S.PTB.wRect(4) ... 
    ];

cross = FixationCross(...
    dim   ,... % dimension in pixels
    width ,... % width     in pixels
    color ,... % color     [R G B] 0-255
    center );  % center    in pixels

cross.LinkToWindowPtr( S.PTB.wPtr )

cross.AssertReady % just to check

end % function
