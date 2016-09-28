%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% table_reg_investment_summary
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function table_reg_investment_summary()

	clc;
	clear;

	no_machiens = 20;

	total_outputs = [];

	for machine = 1:no_machiens

		filename = sprintf('simulation_outputs/table_reg_investment%04d.csv', machine);

		this_output = dlmread(filename, '\t');

		total_outputs = [total_outputs; this_output];

	end


	no_simultaions = size(total_outputs,1);

	fprintf(1, '\n');
	fprintf(1, '# simulations: %d\n', no_simultaions);

	pctile05 = prctile( total_outputs, 5 );
	pctile50 = prctile( total_outputs, 50 );
	pctile95 = prctile( total_outputs, 95 );

	pval = sum( (total_outputs < 0), 1) / no_simultaions;
	pval = min( pval, 1 - pval );

	outputs = [pctile05' pctile50' pctile95' pval'];


	% Print the output
	fprintf(1, '\n* Q alone\n\n');
	print_item( outputs, [3 1] );
	
	fprintf(1, '\n* Q and cashflow\n\n');
	print_item( outputs, [12 13 10] );
	
	fprintf(1, '\n* Q and leverage\n\n');
	print_item( outputs, [16 17 14] );
	
	fprintf(1, '\n* All three\n\n');
	print_item( outputs, [20 21 22 18] );
	
end




function print_item(outputs, ids)

	for i = ids
		
		fprintf(1, '%.3f', outputs(i, 2));
		
		if i ~= ids(end)
			if outputs(i, 4) < 0.01
				fprintf(1, '***');
			elseif outputs(i, 4) < 0.05
				fprintf(1, '**');
			elseif outputs(i, 4) < 0.10
				fprintf(1, '*');
			end
		end
		
		fprintf(1, '\n');
		
		fprintf(1, '[%.3f, %.3f]\n', outputs(i,1), outputs(i,3));
			
	end
end

