% Phase 3: Final Product Integration

clear
[inputSignal, fs] = audioread('Child_Noisy_Environment.wav');

% Convert stereo to mono
if size(inputSignal, 2) == 2
    inputSignal = sum(inputSignal, 2) / 2;
    disp('Stereo detected, converted to mono.');
else
    disp('Mono audio detected.');
end

total_bands = 22;

% Bandpass Filter
fmin = 100; % Minimum frequency
fmax = 8000; % Maximum frequency
band_edges = fmin * (fmax / fmin).^((0:total_bands) / total_bands);
filteredSignalCollection = cell(1, total_bands);

for i = 1:total_bands
    Hd = BandPassFunc(band_edges(i), band_edges(i+1), fs);
    filteredSignal = filter(Hd, inputSignal);
    filteredSignalCollection{i} = filteredSignal;
end

% Rectification
rectified_signals = cell(1, total_bands);
for i = 1:total_bands
    rectified_signals{i} = abs(filteredSignalCollection{i});
end

% Lowpass Filter for Envelope Extraction
N = 20;   % Order
Fc = 400; % Cutoff Frequency
h = fdesign.lowpass('N,F3dB', N, Fc, fs);
Hd = design(h, 'butter');

final_signal_collection = cell(1, total_bands);
for i = 1:total_bands
    final_signal_collection{i} = filter(Hd, rectified_signals{i});
end

% Phase 3: Cosine Signal Generation and Amplitude Modulation
output_signal = zeros(size(inputSignal));
central_frequencies = (band_edges(1:end-1) + band_edges(2:end)) / 2; % Central frequencies

%Task 10&11
for i = 1:total_bands
    t = (0:length(final_signal_collection{i})-1) / fs; % Time vector
    cosine_signal = cos(2 * pi * central_frequencies(i) * t); % Generate cosine signal
    modulated_signal = final_signal_collection{i} .* cosine_signal'; % Amplitude modulation
    output_signal = output_signal + modulated_signal; % Add to output
end

% Task 12: Normalize the Output Signal
output_signal = output_signal / max(abs(output_signal)); % Normalize

% Task 13: Play and Save Output
sound(output_signal, fs);
audiowrite('output_signal.wav', output_signal, fs);

% Plot the Final Output Signal
t = (0:length(output_signal)-1) / fs; % Time vector
figure;
plot(t, output_signal);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Final Synthesized Output Signal');
grid on;

disp('Phase 3 processing complete!');

% Function for Bandpass Filter
function Hd = BandPassFunc(Fpass1, Fpass2, fs)
    N = 20; % Order
    h = fdesign.bandpass('N,F3dB1,F3dB2', N, Fpass1, Fpass2, fs);
    Hd = design(h, 'butter');
end
