% 3.1. Read the sound file
[file, path] = uigetfile('*.wav', 'Select an audio file');
filename = fullfile(path, file);
[audioData, Fs] = audioread(filename);

% Display the sampling rate
fprintf('Sampling rate: %d Hz\n', Fs);

% 3.2. Check if the audio is stereo (2 channels)
[numSamples, numChannels] = size(audioData);

if numChannels == 2
    % If stereo, convert to mono by averaging the two channels
    audioData = mean(audioData, 2);
    fprintf('Audio was stereo, converted to mono.\n');
else
    fprintf('Audio is already mono.\n');
end

% 3.3. Play the sound
sound(audioData, Fs);

% 3.4. Write the modified sound to a new file
newFilename = fullfile(path, 'modified_audio.wav');
audiowrite(newFilename, audioData, Fs);
fprintf('Modified audio saved as %s\n', newFilename);

% 3.5. Plot the waveform of the sound
figure;
plot(audioData);
title('Waveform of the Audio');
xlabel('Sample Number');
ylabel('Amplitude');

% 3.6. Resample the audio if the sampling rate is not 16 kHz

if Fs ~= 16000
    % Resample the audio
    audioData = resample(audioData, 16000, Fs);
    Fs = targetFs;
    fprintf('Audio resampled to 16000');
else
    fprintf('Audio is already at 16000');
end

% 3.7. Generate a 1 kHz cosine signal with the same duration and array length as the input signal
duration = numSamples / Fs; % Duration in seconds
t = linspace(0, duration, numSamples); % Time vector

% Generate the 1 kHz cosine wave
freq = 1000; % 1 kHz
cosineSignal = cos(2 * pi * freq * t)';

% Play the cosine signal
sound(cosineSignal, Fs);

% Plot two cycles of the cosine waveform as a function of time
figure;
cyclesToPlot = 2; % Number of cycles to plot
samplesPerCycle = Fs / freq;
numSamplesToPlot = round(cyclesToPlot * samplesPerCycle);

plot(t(1:numSamplesToPlot), cosineSignal(1:numSamplesToPlot));
title('Two Cycles of the 1 kHz Cosine Wave');
xlabel('Time (seconds)');
ylabel('Amplitude');



