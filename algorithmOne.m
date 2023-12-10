function outputImage = algorithmOne(b2, b3, b4, b5, b6, b7)
    % Ensure the input bands are in double precision
    b2 = double(b2); % Red band
    b3 = double(b3); % Green band
    b4 = double(b4); % Blue band
    b5 = double(b5); % NIR band
    b6 = double(b6); % SWIR1 band
    b7 = double(b7); % SWIR2 band
    
    % Calculate AWEI without shadows
    AWEI_ns = 4 * (b3 - b6) - (0.25 * b5 + 2.75 * b7);
    
    % Calculate AWEI with shadows
    AWEI_sh = b4 + 2.5 * b3 - 1.5 * (b5 + b6) - 0.25 * b7;
    
    % Define a threshold for water
    % You may need to adjust the threshold based on the specific characteristics of your imagery
    waterThreshold_ns = 0; % Example threshold for AWEI_ns
    waterThreshold_sh = 0; % Example threshold for AWEI_sh
    
    % Create binary masks for water bodies using both AWEI indices
    waterMask_ns = AWEI_ns > waterThreshold_ns;
    waterMask_sh = AWEI_sh > waterThreshold_sh;
    
    % Combine both masks (logical OR) to get a more accurate water body detection
    waterMask = waterMask_ns | waterMask_sh;
    
    % Initialize the output image
    % For visualization, create a 3-channel (RGB) image where water is blue
    outputImage = zeros(size(b4, 1), size(b4, 2), 3, 'uint8');
    
    % Use the Red band (b4) for the non-water parts of the image
    for channel = 1:3
        outputImage(:,:,channel) = uint8(b2); % Assuming b4 is a grayscale image
    end
    
    % Set water pixels to blue
    outputImage(:,:,3) = uint8(waterMask * 255); % Blue channel
    outputImage(repmat(waterMask, [1, 1, 3])) = 0; % This sets the water pixels to black
    outputImage(:,:,3) = outputImage(:,:,3) + uint8(waterMask * 255); % This sets the water pixels to bluey
    % Return the output image
end
