# BIKEWeakKeys

This is the supplimentary code used for our research paper entitled "**Weak-Key Analysis for BIKE Post-Quantum Key Encapsulation Mechanism**" (authored by Mohammad Reza Nosouhi, Syed W. Shah, Lei Pan, Yevhen Zolotavkin, Ashish Nanda, Praveen Gauravaram, Robin Doss). The paper is accessible on [IEEE Xplore](https://ieeexplore.ieee.org/document/10091222)

- This paper appears in: IEEE Transactions on Information Forensics and Security
- Print ISSN: 1556-6013
- Online ISSN: 1556-6021
- Digital Object Identifier: 10.1109/TIFS.2023.3264153

Please cite the paper as:
```
@article{nosouhi2023weak,
  title={Weak-Key Analysis for BIKE Post-Quantum Key Encapsulation Mechanism},
  author={Nosouhi, Mohammad Reza and Shah, Syed W and Pan, Lei and Zolotavkin, Yevhen and Nanda, Ashish and Gauravaram, Praveen and Doss, Robin},
  journal={IEEE Transactions on Information Forensics and Security},
  year={2023},
  DOI={10.1109/TIFS.2023.3264153}
}
```

Please follow the below steps:

1. The repository contains three sub-folders - i.e., _Key Generation_, _Encryption_, _Decoding_.

2. For reproducibility, first of all, go to _Key Generation_ folder and run the '**Key_Gen_modified.m**' file [Note that, `r` and `w` parameters need to be set, the sample code sets `r = 10009` and `w = 142`]. This code will autiomatically save the corresponding keys in the same folder (i.e., as 'private_keys.txt' and 'public_keys.txt').

3. Then, generate the ciphertexts by going _Encryption_ folder and running '**Encryption_automated_2.m**' - Note that, the 'public_keys.txt' needs to be copied in this folder for successful generation of ciphertexts. Also note that, 'r' and 't' parameters needs to be set appropriately. The sample code sets `r = 10009` and `t = 134`. The code will automtically save the generated ciphertexts in 'cipher.txt' file.

4. Finally, go to _Decoding_ folder, and run '**BGF_Decoder_Automated_Matrix_Based.m**'. Note that, all the needed function are contained in the same folder. 'cipher.txt' file and 'priavte_keys.txt' generated in previous steps needs to be copied in this folder. `r`, `t`, `w` parameters needs to be set appropriately. The sample code sets `r = 10009`, `w=142` and `t = 134`.


NOTE: The sample *.txt files that contains 'public keys', 'private keys', and 'ciphertexts' are for parameters (`r`, `w`, `t`) specified above. Appropriate changes need to be made to these parameters for analysing the varying values of these parameters. 
