function [ Text_mvt , Text_side , Text_rest ] = Text
global S

color = S.Parameters.Text.Color;
content = ' '; % temporary

Xptb_1 = S.Parameters.REMINARY.Text_mvt .PositonXRatio * S.PTB.wRect(3);
Yptb_1 = S.Parameters.REMINARY.Text_mvt .PositonYRatio * S.PTB.wRect(4);
Text_mvt  = Text( color, content, Xptb_1, Yptb_1 );
Text_mvt. LinkToWindowPtr( S.PTB.wPtr )
Text_mvt. AssertReady % just to check

Xptb_2 = 0.5 * S.PTB.wRect(3); % temporary
Yptb_2 = S.Parameters.REMINARY.Text_side.PositonYRatio * S.PTB.wRect(4);
Text_side = Text( color, content, Xptb_2, Yptb_2 );
Text_side.LinkToWindowPtr( S.PTB.wPtr )
Text_side.AssertReady % just to check

Xptb_3 = S.Parameters.REMINARY.Text_rest.PositonXRatio * S.PTB.wRect(3);
Yptb_3 = S.Parameters.REMINARY.Text_rest.PositonYRatio * S.PTB.wRect(4);
content= S.Parameters.REMINARY.Text_rest.Content;
Text_rest = Text( color, content, Xptb_3, Yptb_3 );
Text_rest.LinkToWindowPtr( S.PTB.wPtr )
Text_rest.AssertReady % just to check

end % function
