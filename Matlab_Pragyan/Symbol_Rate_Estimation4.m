function symbol_rate=Symbol_Rate_Estimation4(x2,fs,freq_res,SNR_conditions)

% fs=str2double(fs);
% freq_res=str2double(freq_res);
% % 
% %Cyclostationarity Input Parameters 
% f1 = fopen(filename, 'rb'); 
% 
% %Aquiring samples from USRP FILE 
 N_fft= ceil((2*fs)/freq_res);
% 
% %Reading the iq file
% file_size_var=fread(f1,'float');
% file_size_var=file_size_var';
% 
% x1=file_size_var;
% 
% x=zeros(1,size(x1,2)/2);
% for loop1=1:size(x1,2)/2
%     x(1,loop1)=x1(1,2*loop1-1)+j*x1(1,2*loop1);
% end
% x=smooth(x,10);
% x=x';
% x=abs(x).^4;
% size_of_file= length(x2);
%SNR Condition of 2 means high SNR 0 means low SNR and 1 means mid range
%SNR. Depending on the SNR conditions, the amount of data needed varies.
%High SNRs require lesser data and therefore reswukt in fast program
%execution
 size_of_file = length(x2);
if(SNR_conditions==2)
x1=x2(1,1:min(2*N_fft*N_fft,size_of_file));
elseif(SNR_conditions==1)
x1=x2(1,1:min(10*N_fft*N_fft,size_of_file));
else
x1=x2(1,1:min(20*N_fft*N_fft,size_of_file));
end

 
x=(smooth(x1,10))';
x=abs(x).^4;

%Cyclostationarity algorithm
alpha_res=(fs)/N_fft;
frames=ceil(size(x,2)/N_fft);
alpha_max=floor(N_fft/2)-2;
alpha=-alpha_max:2:alpha_max;
cyclic_freq=alpha_res.*alpha;

%Splitting data in equal sized fames
% if(mod(size(x,2),frames)~=0)
% Z1=zeros(1,frames-(mod(size(x,2),frames)));
% x=[x Z1];   %Zero Padding
% end
% X=reshape(x,[N_fft,frames])';
L=size(x,2)-(mod(size(x,2),N_fft));
x=x(1:L);
frames = floor(L/N_fft);
X=reshape(x,[N_fft,frames])';


%PSD of signal
PSD=zeros(frames,N_fft);
for loop1=1:frames
    PSD(loop1,:)=abs(fftshift(fft(X(loop1,:),N_fft))).^2;
end
PSD=(sum(PSD)/frames);

%Finding SCF
X=(fftshift(fft(X'),1))';
Y=zeros(size(alpha,2),N_fft);

for loop1=1:size(alpha,2)
    y1=X;
    y1=circshift(y1,(-alpha(1,loop1)/2),2).*conj(circshift(y1,(alpha(1,loop1)/2),2));   
    Y(loop1,:)=sum(y1)/frames;
end

% Smoothening using Moving Average filter
for loop1=1:size(alpha,2)
    Y(loop1,:)=smooth(Y(loop1,:),ceil(0.25*N_fft));
end

%PSD(1,:)=smooth(PSD(1,:),ceil(0.25*N_fft));

%Finding SCC
SCC=zeros(size(alpha,2),N_fft);
for loop1=1:size(alpha,2)
    SCC(loop1,:)=Y(loop1,:)./(sqrt(circshift(PSD,-alpha(1,loop1)/2).*conj(circshift(PSD,alpha(1,loop1)/2))));
end

%Finding CDEP
C=abs(SCC);
G=sum(C,2);
G=G';

%Calculating differential CDEP
G2=zeros(1,size(G,2));
if(G(1,1)-G(1,2)>0)
G2(1,1)=G(1,1)-G(1,2);
end
for loop1=2:size(G2,2)-1
    if(loop1~=((size(G2,2)+1)/2)-1&&loop1~=(size(G2,2)+1)/2&&loop1~=((size(G2,2)+1)/2)+1)
        if((G(1,loop1)-G(1,loop1-1))>=0&&(G(1,loop1)-G(1,loop1+1))>=0)
    G2(1,loop1)=0.5.*((G(1,loop1)-G(1,loop1-1))+(G(1,loop1)-G(1,loop1+1)));
        end
    end
end
if(G2(1,size(G2,2))-G2(1,size(G2,2)-1)>0)
G2(1,size(G2,2))=G(1,size(G2,2))-G(1,size(G2,2)-1);
end
if(G(1,(size(G2,2)+1)/2+1)-G(1,(size(G2,2)+1)/2+2)>0)
G2(1,(size(G2,2)+1)/2+1)=G(1,(size(G2,2)+1)/2+1)-G(1,(size(G2,2)+1)/2+2);
end
if(G(1,(size(G2,2)+1)/2-1)-G(1,(size(G2,2)+1)/2-2)>0)
G2(1,(size(G2,2)+1)/2-1)=G(1,(size(G2,2)+1)/2-1)-G(1,(size(G2,2)+1)/2-2);
end

%Finding symbol rate
symbol_rate=find(G2==max(G2));
for loop1=1:size(symbol_rate,2)
    symbol_rate(1,loop1)=alpha(1,symbol_rate(1,loop1))*alpha_res;
end

%Displaying obtained symbol rate
symbol_rate=abs(symbol_rate(1,1));
%fprintf("Symbol Rate=%d",symbol_rate);

end