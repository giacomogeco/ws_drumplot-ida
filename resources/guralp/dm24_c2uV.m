function chconv=dm24_c2uV(streamID)

%   c = dm24_c2uV (streamID);
%
% Fattori di conversione digitalizzatori canale per canale secondo quanto
% dichiarato nei fogli di calibrazione dell'unit�.

digit=char(streamID);
digit=streamID(1:4);
%% ELENCO UNITA'

switch digit
    case 'A754'                         % A754
        CH.A754Z2=3.218*1e-6;
        CH.A754N2=3.208*1e-6;
        CH.A754E2=3.223*1e-6;
        CH.A754X2=3.212*1e-6;
        
        CH.A754M8=292.91*1e-6;
        CH.A754M9=291.70*1e-6;
        CH.A754MA=293.67*1e-6;
        CH.A754MB=290.88*1e-6;
        CH.A754MC=293.78*1e-6;
        CH.A754MD=292.54*1e-6;
        CH.A754ME=293.51*1e-6;
        CH.A754MF=292.47*1e-6;
    
    case 'A755'                         % A755
        CH.A755Z2=3.194*1e-6;
        CH.A755N2=3.207*1e-6;
        CH.A755E2=3.216*1e-6;
        CH.A755X2=3.222*1e-6;
        
        CH.A755M8=291.46*1e-6;
        CH.A755M9=291.98*1e-6;
        CH.A755MA=291.37*1e-6;
        CH.A755MB=291.78*1e-6;
        CH.A755MC=290.63*1e-6;
        CH.A755MD=294.39*1e-6;
        CH.A755ME=291.37*1e-6;
        CH.A755MF=292.18*1e-6;

    case 'A756'                         % A756
        CH.A756Z2=3.203*1e-6;
        CH.A756N2=3.205*1e-6;
        CH.A756E2=3.190*1e-6;
        CH.A756X2=3.212*1e-6;
        
        CH.A756M8=291.57*1e-6;
        CH.A756M9=291.15*1e-6;
        CH.A756MA=292.36*1e-6;
        CH.A756MB=293.02*1e-6;
        CH.A756MC=293.08*1e-6;
        CH.A756MD=292.93*1e-6;
        CH.A756ME=291.72*1e-6;
        CH.A756MF=292.27*1e-6;

    case 'A758'                         % A758
        CH.A758Z2=3.211*1e-6;
        CH.A758N2=3.212*1e-6;
        CH.A758E2=3.207*1e-6;
        CH.A758X2=3.214*1e-6;

        CH.A758M8=294.34*1e-6;
        CH.A758M9=292.21*1e-6;
        CH.A758MA=292.26*1e-6;
        CH.A758MB=292.54*1e-6;
        CH.A758MC=292.30*1e-6;
        CH.A758MD=292.30*1e-6;
        CH.A758ME=292.15*1e-6;
        CH.A758MF=292.98*1e-6;

    case 'A818'                         % A818
        CH.A818Z2=3.194*1e-6;
        CH.A818N2=3.203*1e-6;
        CH.A818E2=3.198*1e-6;
        CH.A818Z3=3.206*1e-6;
        CH.A818N3=3.189*1e-6;
        CH.A818E3=3.203*1e-6;
        CH.A818X2=3.204*1e-6;
        
        CH.A818M8=291.74*1e-6;
        CH.A818M9=291.90*1e-6;
        CH.A818MA=293.15*1e-6;
        CH.A818MB=292.03*1e-6;
        CH.A818MC=290.82*1e-6;
        CH.A818MD=290.31*1e-6;
        CH.A818ME=293.48*1e-6;
        CH.A818MF=292.48*1e-6;

    case 'A819'                         % A819
        CH.A819Z2=3.233*1e-6;
        CH.A819N2=3.199*1e-6;
        CH.A819E2=3.206*1e-6;
        CH.A819Z3=3.210*1e-6;
        CH.A819N3=3.171*1e-6;
        CH.A819E3=3.177*1e-6;
        CH.A819X2=3.218*1e-6;
        
        CH.A819M8=295.02*1e-6;
        CH.A819M9=292.35*1e-6;
        CH.A819MA=291.86*1e-6;
        CH.A819MB=292.72*1e-6;
        CH.A819MC=293.82*1e-6;
        CH.A819MD=292.23*1e-6;
        CH.A819ME=293.80*1e-6;
        CH.A819MF=293.98*1e-6;

    case 'C653'                         % C653
        CH.C653Z2=3.213*1e-6;
        CH.C653N2=3.206*1e-6;
        CH.C653E2=3.201*1e-6;
        CH.C653Z3=3.187*1e-6;
        CH.C653N3=3.189*1e-6;
        CH.C653E3=3.186*1e-6;
        CH.C653X2=3.187*1e-6;
        
        CH.C653M8=289.68*1e-6;
        CH.C653M9=290.58*1e-6;
        CH.C653MA=290.65*1e-6;
        CH.C653MB=290.41*1e-6;
        CH.C653MC=291.24*1e-6;
        CH.C653MD=291.73*1e-6;
        CH.C653ME=290.25*1e-6;
        CH.C653MF=290.41*1e-6;

    case 'C654'                         % C654
        CH.C654Z2=3.197*1e-6;
        CH.C654N2=3.204*1e-6;
        CH.C654E2=3.200*1e-6;
        CH.C654Z3=3.196*1e-6;
        CH.C654N3=3.213*1e-6;
        CH.C654E3=3.216*1e-6;
        CH.C654X2=3.188*1e-6;

        CH.C654M8=290.37*1e-6;
        CH.C654M9=289.45*1e-6;
        CH.C654MA=290.64*1e-6;
        CH.C654MB=290.88*1e-6;
        CH.C654MC=290.33*1e-6;
        CH.C654MD=290.48*1e-6;
        CH.C654ME=288.45*1e-6;
        CH.C654MF=290.66*1e-6;

    case 'C655'                         % C655
        CH.C655Z2=3.186*1e-6;
        CH.C655N2=3.199*1e-6;
        CH.C655E2=3.198*1e-6;
        CH.C655X2=3.194*1e-6;
        
        CH.C655M8=292.69*1e-6;
        CH.C655M9=292.31*1e-6;
        CH.C655MA=291.11*1e-6;
        CH.C655MB=291.88*1e-6;
        CH.C655MC=290.44*1e-6;
        CH.C655MD=291.88*1e-6;
        CH.C655ME=292.09*1e-6;
        CH.C655MF=290.33*1e-6;
        
    case 'A376'                         % A2376
        CH.A376Z2=3.209*1e-6;
        CH.A376N2=3.213*1e-6;
        CH.A376E2=3.205*1e-6;
        CH.A376X2=3.198*1e-6;

        CH.A376M8=289.197*1e-6;
        CH.A376M9=289.627*1e-6;
        CH.A376MA=290.038*1e-6;
        CH.A376MB=289.714*1e-6;
        CH.A376MC=290.319*1e-6;
        CH.A376MD=288.832*1e-6;
        CH.A376ME=290.493*1e-6;
        CH.A376MF=289.930*1e-6;

    case 'A372'                         % A2372
        CH.A372Z2=3.198*1e-6;
        CH.A372N2=3.196*1e-6;
        CH.A372E2=3.189*1e-6;
        CH.A372X2=3.191*1e-6;
        
        CH.A372M8=290.983*1e-6;
        CH.A372M9=289.985*1e-6;
        CH.A372MA=289.187*1e-6;
        CH.A372MB=291.135*1e-6;
        CH.A372MC=290.353*1e-6;
        CH.A372MD=290.179*1e-6;
        CH.A372ME=289.531*1e-6;
        CH.A372MF=292.163*1e-6;

    case 'A377'                        % A2377
        CH.A377Z2=3.221*1e-6;
        CH.A377N2=3.204*1e-6;
        CH.A377E2=3.211*1e-6;
        CH.A377X2=3.194*1e-6;

        CH.A377M8=290.195*1e-6;
        CH.A377M9=290.846*1e-6;
        CH.A377MA=291.872*1e-6;
        CH.A377MB=292.157*1e-6;
        CH.A377MC=291.391*1e-6;
        CH.A377MD=291.828*1e-6;
        CH.A377ME=289.957*1e-6;
        CH.A377MF=290.152*1e-6;
        
    otherwise
        CH=struct;
end
%% Selezione canale
if isfield(CH,streamID)==1
    chconv=getfield(CH,streamID);
else
    disp('UNKNOWN DIGITIZER or CHANNEL ID')
    chconv=27./((2^24)/2);
end
return