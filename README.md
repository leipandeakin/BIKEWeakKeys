# BIKEWeakKeys

This is the supplimentary code used for our research paper entitled "Weak-Key Analysis for BIKE Post-Quantum Key Encapsulation Mechanism" (authored by Mohammad Reza Nosouhi, Syed W. Shah, Lei Pan, Yevhen Zolotavkin, Ashish Nanda, Praveen Gauravaram, Robin Doss)

Please follow the below steps:

1. The repository contains three sub-folders - i.e., `Key Generation`, `Encryption`, `Decoding`.

2. For reproducibility, first of all, go to 'Key Generation' folder and run the 'Key_Gen_modified.m' [Note that, `r` and `w` parameters need to be set, the sample code sets `r = 10009` and `w = 142`]. This code will autiomatically save the corresponding keys in the same folder (i.e., as 'private_keys.txt' and 'public_keys.txt').

3. Then, generate the ciphertexts by going 'Encryption' folder and running 'Encryption_automated_2.m' - Note that, the 'public_keys.txt' needs to be copied in this folder for successful generation of ciphertexts. Also note that, 'r' and 't' parameters needs to be set appropriately. The sample code sets `r = 10009` and `t = 134`.
The code will automtically save the generated ciphertexts in 'cipher.txt' file.

4. Finally, go to 'Decoding' folder, and run 'BGF_Decoder_Automated_Matrix_Based.m'. Note that, all the needed function are contained in the same folder. 'cipher.txt' file 
and 'priavte_keys.txt' generated in previous steps needs to be copied in this folder. `r`, `t`, `w` parameters needs to be set appropriately. The sample code
sets `r = 10009`, `w=142` and `t = 134`.


NOTE: The sample *.txt files that contains 'public keys', 'private keys', and 'ciphertexts' are for parameters (r, w, t) specified above. Appropriate changes need to be made to these parameters for analysing the varying values of these parameters. 
