clc
function process_sound_file(inputFile, outputFile)
    % Task 3.1: Read the input sound file and get its sampling rate
    if isfile(inputFile)
        [audioData, fs] = audioread(inputFile);
        disp(['Original Sampling Rate: ', num2str(fs), ' Hz']);
    else
        error('Input file does not exist.');
    end
    
    % Task 3.2: Check if the sound is stereo or mono
    if size(audioData, 2) == 2
        audioData = sum(audioData, 2) / 2; % Convert stereo to mono
        disp('Stereo detected, converted to mono.');
    else
        disp('Mono audio detected.');
    end
    
    % Task 3.3: Play the sound
    disp('Playing original sound...');
    sound(audioData, fs);
    pause(length(audioData)/fs); % Wait for the sound to finish playing
    
    % Task 3.4: Write the processed sound to a new file
    audiowrite(outputFile, audioData, fs);
    disp(['Processed sound saved to: ', outputFile]);
    
    % Task 3.5: Plot the waveform of the sound
    figure;
    plot(audioData);
    title('Waveform of the Sound');
    xlabel('Sample Number');
    ylabel('Amplitude');
    grid on;
    
    % Task 3.6: Check if sampling rate is not 16 kHz, downsample if necessary
    if fs ~= 16000
        % Resample using interp1
        t_original = (0:length(audioData)-1) / fs;  % Original time vector
        t_new = (0:1/16000:max(t_original));  % New time vector for 16 kHz
        audioData = interp1(t_original, audioData, t_new, 'linear');  % Resample
        fs = 16000; % Update the sampling rate
        disp('Downsampled to 16 kHz.');
    end
    
    % Task 3.7: Generate a cosine signal at 1 kHz
    t = (0:length(audioData)-1)/fs; % Time vector
    cosineSignal = cos(2 * pi * 1000 * t); % 1 kHz cosine signal
    
    % Play the generated cosine signal
    disp('Playing 1 kHz cosine signal...');
    sound(cosineSignal, fs);
    pause(length(cosineSignal)/fs); % Wait for the sound to finish playing
    
    % Plot two cycles of the 1 kHz cosine signal
    figure;
    plot(t(1:2*fs/1000), cosineSignal(1:2*fs/1000));
    title('Two Cycles of 1 kHz Cosine Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    grid on;
    
    disp('Task 3 completed successfully.');
end


process_sound_file('IMG_8599.wav', 'outputSound.wav');
