# linear_-block_codes
To set-up MONTE CARLO SIMULATION to determine the performance of (7,3) Linear Block Code over an AWGN channel.

Linear Block codes are effective way of reducing bit error rate/Improving the SNR (Signal to
noise ratio) over a noisy channel (white Noise). Linear block codes are defined in terms of
generator and parity-check matrices. Syndrome vector are used for error detection. <br>

**DESIGN APPROACH: (TOOL: MATLAB)** : <br>
To calculate the reduction in the SNR using Linear block codes-<br>
<br>
**(BER vs SNR) without linear block encoder/decoder:**<br>
Here, we consider (3*10^6) Message bits (Binary data) divide them in blocks
of 3 (Binary message block) and convert it into message block (BPSK modulation+1/-
1). This is sent through a channel having white noise (AWGN) with different SNR
and the received vector is converted to binary vector block (3 bits). Now distance
between transmitted and received vectors is calculated for each block (3 bits). Total
errors are estimated by adding all the distances. BER (total errors/Message Bits) is
obtained and is plotted for various SNR.<br>
<br>
**(BER vs SNR)) with linear block encoder/decoder:**<br>
Here, we consider (3*10^6) Message bits (Binary data) divide them in blocks
of 3 bits (Binary message block-M) and convert it to a Codeword (C=M*G) using
Generator matrix(G). Now each codeword (7 bits) has 4 parity bits.
Where, G = [1 0 1 1 1 0 0;0 1 1 1 0 1 0;1 1 0 1 0 0 1]<br>
Codeword is BPSK Modulated (+1, -1) and sent through a channel having
AWGN with different SNR .Now, the received vector is converted to binary vector (7
bits) using BPSK demodulation. Now received vector(R-7 bits) is multiplied by parity
check matrix (H-Transpose) to get syndrome vector (S=R*HT).
Where, HT= [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1; 1 0 1 1; 0 1 1 1; 1 1 0 1] <br>
Now error vector(E) corresponding to syndrome vector(S) is obtained, is added to
received vector (R+E). Now distance between transmitted and received vectors is
calculated for each block of 7 bits. Total errors are estimated by adding distances of
all blocks. BER (total errors/Message Bits) is obtained and is plotted for various SNR.

