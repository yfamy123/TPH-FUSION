addpath('scr\TP-Filter');
addpath('data');
addpath('scr\plot');
addpath('scr\HFusion');

clc;clear;

% Load data. 
% smallpox is the California Smallpox Data.
% measel is the New York measle data.
load toy
% load smallpox
events = toycount;


% Parameter. 
% Lambdas is the H-FUSION Lagrangian multiplier. 
% alpha is the ratio of smoothness and periodicity.
% gama is the parameter of Cost function in Iterative method.
% threshold is the cut-off in Fourier Filter.
% L is the Annilhilating length.
% iterationTime is the constant iteration time without stop criteria.
lambdas = 1;
alpha = 0.5;
gama = 0.1;
threshold = 52;
L = 3;
iterationTime = 10;


% set the report configuration, config_rep_dur is RD(report duration),
% config_rep_over is shift.
config_rep_dur = 1:2:60;
config_rep_over = 1:2:60;
xdim = length(config_rep_dur);
ydim = length(config_rep_over);

% First Phase: reconstruct sequence by H-Fusion.
Out = hfusion(events, lambdas, alpha, config_rep_dur, config_rep_over);

% Annilhilating Filter Method 
Out_A = annihilating(Out, L, events);
% Fourier Filter Method
Out_F = fourier(Out, threshold, events);

% Iterative Method
[Inc_A,Out_A1,Out_A10] = iteration(Out, L, events, 'annihilating', iterationTime, gama);
[Inc_F,Out_F1,Out_F10] = iteration(Out, threshold, events, 'fourier', iterationTime, gama);

% Plot special cases and the trend of iteration
special_cases_plot(events, Out, Out_A1, Out_F1, Inc_A, Inc_F, 611, 'RD = 41,Shift = 21', 327, ...
    'RD = 21,Shift = 53', 611, 742, 'RD = 41,Shift = 21', 'RD = 49,Shift = 43');

% Plot the iteration performance criteria Interrupt
% increase/degredation/inactivity
iteration_uninterrupt_plot(Out, Inc_A, xdim, ydim, iterationTime, 'TPH-FUSION(A)')
iteration_uninterrupt_plot(Out, Inc_F, xdim, ydim, iterationTime, 'TPH-FUSION(F)')

% Plot the L/G ratio
LG_ratio_plot(Inc_A, Out, xdim, ydim, gama, 'TPH-FUSION(A)')
LG_ratio_plot(Inc_F, Out, xdim, ydim, gama, 'TPH-FUSION(F)')
