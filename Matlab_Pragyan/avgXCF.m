function out = avgXCF(x, y, frame_size, overlap, winType)
	%{
		Inputs: 
			x:			(array)     :	1D time sequence 
			frame_size:	(int)		:	size of one frame
            overlap:    (int)       :   size of frame overlap
		Returns:
			out: short time fourier transform
	%}
    if length(x) > length(y)
        y = [y zeros(1, length(x)-length(y))];
    elseif length(y) > length(x)
        x = [x zeros(1, length(y)-length(x))];
    end
    
	N = length(x);
    if rem(N,frame_size) > 0
		x = [x, zeros(1, frame_size - rem(N,frame_size))];
        y = [y, zeros(1, frame_size - rem(N,frame_size))];
    end
	N = length(x);
    
    window = ones(1, frame_size);
    % Blackman-Harris Window
    if strcmp(winType, "Blackman-Harris")
        a0=0.35875; a1=0.48829; a2=0.14128; a3=0.01168;
        n = 2*pi*(0:frame_size-1)/frame_size;
        window = a0 - a1*cos(n) + a2*cos(2*n) - a3*cos(3*n);
    % Hamming Window
    elseif strcmp(winType, "Hamming")
        a0=25/46;
        n = 2*pi*(0:frame_size-1)/frame_size;
        window = a0 - (1-a0)*cos(n);
    end
    
	out = zeros(1, frame_size);
    NN = floor(N/(frame_size - overlap));
	step = frame_size - overlap;
	i = 1;
	while i <= N - frame_size
        a1 = fft(x(i:i+frame_size-1).*window).*conj(fft(window.*y(i:i+frame_size-1)));
		out = out + a1/NN/frame_size;
		i = i + step;
    end
    out = fftshift(out);
end
