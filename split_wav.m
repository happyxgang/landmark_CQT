function [ split_music,fs,nbits ] = split_wav( filename, start_time, end_time )
%SPLIT_WAV Summary of this function goes here
%   Detailed explanation goes here
    [music, fs, nbits] = wavread(filename);
    split_music = music(((fs*start_time+1):fs*end_time),:);
end

