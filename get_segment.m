function [ duration_D ] = get_segment( D,SR,ST,Duration )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    origin_length = length(D);
    start_pos = SR*ST+1;
    end_pos = start_pos + Duration*SR;
    if (origin_length < start_pos)
        fprintf(2,'Origin signal length < start time pos');
        pos = max(origin_length, Duration*SR);
        duration_D = D(1 : pos);
    elseif(origin_length < end_pos-3*SR)
        fprintf(2,'Origin signal length < end time pos');
        duration_D = D(start_pos : end);
    else
        duration_D = D(start_pos : end_pos);
    end
end

