clc;
clear;
bit_count = 3*100000; %no. of random bits to be generated for a single shot of BER calculation
SNR = 0: 1: 10; %Range of SNR over which to simulate
gen_matrix=[1 0 1 1 1 0 0;0 1 1 1 0 1 0;1 1 0 1 0 0 1]; %generator matrix

H_transpose =[1 0 0 0;0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1; 1 1 0 1];    

%parity check matrix

%coset leader
coset	=[0	0 0	0 0 0 0;0 0	0 1	0 0	0;0	0 1	0 0	0 0;0 0	1 1 0 0 0;0 1 0 0 0 0 0; 
            1 0	0 0	0 0	1;0	1 1	0 0	0 0;0 0 0 0	0 1	0;1	0 0 0 0 0 0;1 0 0 1 0 0 0; 
            0 0 0 0 0 1 1;0 0 0 0 1 0 0;0 0 0 0 1 1 0;0 0 0 0 0 0 1;
            0 0 1 1 0 0 1;1 0 0 0 0 1 0]; 

%calculating error vectors with respect to the four bit syndrome from 0000 to 1111

S = mod((coset*H_transpose) , 2); %syndrome = error * parity check matrix 

rand_bits = round(rand(1,bit_count)); %generate random bits

codeword_block = mod((reshape(rand_bits,length(rand_bits)/3,3)*gen_matrix),2);
%generating codewords by multiplying generator matrix 

Numoferror=zeros(size(SNR,1));
for k = 1:1:11
    uncoded_totalerror = 0; %total error bits 
    uncoded_totalbits = 0; %total bits 
    totalerror = 0; %total error bits 
    totalbits = 0; %total bits
    encoded_row = reshape(codeword_block,1,[]); %reshaping codeblock again into an array
    tx_bits = -2*(encoded_row-0.5); %BPSK Modulation: Directly to Bipolar NRZ 
    uncode_rx = awgn(tx_bits,k); %Passing uncoded modulated message bits through AWGN channel for different SNR values
    uncode_rx2 = uncode_rx < 0; %BPSK demodulator logic at the Receiver 
    uncode_diff = encoded_row - uncode_rx2; %Calculate Bit Errors 
    uncoded_totalerror = uncoded_totalerror + sum(abs(uncode_diff)); %Total errors observed after passing uncoded messages through the channel
    uncoded_totalbits = uncoded_totalbits + length(rand_bits); %Total bits generated
    rx = awgn(tx_bits,k); %Passing encoded modulated message bits through AWGN channel for different SNR values
    rx2 = rx < 0; % BPSK demodulator logic at the Receiver 
    rx2=reshape(rx2,100000,[]); %reshaping recieved vector into size of codeword block
    Neg_Error =zeros(100000,7); %initializing error matrix 
    S_matrix=mod((rx2*H_transpose),2); %Calculating syndrome for recieved
    for i = 1:size(codeword_block,1) %Calculating error vectors with respect to the syndrome calculated
        for j = 1 : size(S,1)
            if S_matrix(i,:) == S(j,:)
                Neg_Error(i,:)=coset(j,:); 
            end
        end
    end
    rx3=zeros(size(codeword_block));%initializing final recieved codeblock

    for i = 1 : size(codeword_block,1) %final recieved vector = recieved vector - error calculated with syndrome
        rx3(i,:) = xor(rx2(i,:),Neg_Error(i,:));
    end

    rx3=reshape(rx3,1,[]); %reshaping final recieved vector into an array 
    diff = encoded_row - rx3; %Calculate Bit Errors
    totalerror = totalerror + sum(abs(diff)); %total errors 
    Numoferror(k) = totalerror;
    totalbits = totalbits + length(rand_bits); %total bits generate
    uncode_BER(k) = uncoded_totalerror / uncoded_totalbits; % Calculate Bit Error Rate
    BER(k) = totalerror / totalbits; % Calculate Bit Error Rate for respective SNR  
end

%plotting SNR vs BER on semilog graph 

semilogy(SNR,BER,'--*','LineWidth',2); 
hold on;
xlabel('SNR (dB)');
ylabel('BER');
title('SNR Vs BER plot for BPSK Modualtion in AWGN Channel'); semilogy(SNR,uncode_BER);
grid on;
legend('SNR vs BER for Encoded Codeblock Curve', 'SNR vs BER for Codeblock without encoding Curve');

