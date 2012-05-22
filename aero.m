clear zeta0;
%aero
aero_input;

iter = 0;
for aero_i = var_start:var_delta:var_end
	iter += 1;
	rpm = aero_i;
	aero_calc;
	aero_result_mat(iter,:) = [aero_i T Q Power eta];
end

%aero_output_fig
