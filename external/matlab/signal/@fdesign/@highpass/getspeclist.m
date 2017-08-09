function [specListSPT, specListDST] = getspeclist()
%GETSPECLIST Get list of spec strings

%   Copyright 2013 The MathWorks, Inc.

% List for SPT
specListSPT = {...
    'Fst,Fp,Ast,Ap', ...
    'N,F3dB', ...
    'Nb,Na,F3dB',...
    'N,Fc', ...
    'N,Fc,Ast,Ap', ...
    'N,Fp,Ap', ...
    'N,Fp,Ast,Ap', ...
    'N,Fst,Ast', ...
    'N,Fst,Fp'};

% List for DST
specListDST = {...
    'Fst,Fp,Ast,Ap', ...
    'N,F3dB', ...
    'Nb,Na,F3dB',...
    'N,F3dB,Ap', ...
    'N,F3dB,Ast', ...
    'N,F3dB,Ast,Ap', ...
    'N,F3dB,Fp', ...
    'N,Fc', ...
    'N,Fc,Ast,Ap', ...
    'N,Fp,Ap', ...
    'N,Fp,Ast,Ap', ...
    'N,Fst,Ast', ...
    'N,Fst,Ast,Ap', ...
    'N,Fst,F3dB', ...
    'N,Fst,Fp', ...
    'N,Fst,Fp,Ap', ...
    'N,Fst,Fp,Ast', ...
    'Nb,Na,Fst,Fp'};

