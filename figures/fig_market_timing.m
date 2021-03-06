%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fig_market_timing
%
% :draw the relation between M/B ratio before refinancing and leverage
% after refinancing
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;
clear;
clear global;
clear gcf;

dbstop if error;
dbstop if warning;

addpath ../model


% first by alpha
scenarios = [(12:-1:1) (13:18)];

print_outputs(scenarios, 'fig_market_timing_alpha.csv');

% then, by m
scenarios = [(23:-1:19) 1 (24:28)];

print_outputs(scenarios, 'fig_market_timing_m.csv');



function print_outputs(scenarios, filename)

	global alpha m
	global X_U capital B0 S0

	no_scenarios = length(scenarios);

	% outputs: alpha, m, M/B before refinancing, leverage after refinancing
	outputs = zeros(no_scenarios, 4);

	for i = 1:no_scenarios

		load_scenario( scenarios(i) );

		outputs(i, 1) = alpha;
		outputs(i, 2) = m;

		% M/B ratio before refinancing
		S = equity_price(X_U(2,2), 2);
		B = debt_price(X_U(2,2), 2);

		firm_value = S(2) + B(2);

		Q = firm_value / capital(2);
		outputs(i, 3) = Q;

		% leverage after refinancing
		leverage = B0 ./ (B0 + S0);

		outputs(i, 4) = leverage(2);

	end

	dlmwrite(filename, outputs, 'delimiter', '\t');
	
end


