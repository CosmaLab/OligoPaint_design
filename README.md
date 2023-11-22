# OligoPaint_design
This repository describes how to combine OligoMiner and OligoLego to design oligopaint probes.

## Homology design - OligoMiner
1. Select region(s) of interest. In the UCSC Genome Browser, go to View -> DNA and introduce the desired region. If possible, use hard-masked sequences (repetitive regions masked by Ns). This will depend on the labelling density after OligoMiner design. The sequences are in FASTA file and should be saved in a text file with .fasta extension.
2. Use the OligoMiner to design the homology region of the probes. http://oligominerapp.org. For individual probes, go to Input-Single and upload the `.fasta file`. Tune the parameters as required and run analysis.
3. When done, download the `.csv file` corresponding to the RESULTS – Probes Set and RESULTS- Experimental Parameters for future reference.

## Mainstreet and backstreet assembly - OligoLego
1. Download the OligoLego repository from GitHub: https://github.com/gnir/OligoLego. Follow the indications for installation in the `README.md` file, namely:
- Add appending folder to MATLAB `startup.m` file. The startup.m file should be in C:\Users\$username\MATLAB. To check the exact path open MATLAB and type userpath in the command line.
- If the file is not present, copy the `AppendingStartup.m` in the location described above, then change its name to `startup.m`. Then, modify the path location to that where the Appending filder from the GitHub repository is located.

2. Design intersected text files for MS and BS containing homology regions. There are three possibilities of design requiring different combinations of intersected text files.

![image](https://github.com/CosmaLab/OligoPaint_design/assets/93983592/c3024e5f-a448-4e56-a7b3-917871a4e8a9)

  - Case 1: MS contains a universal primer and a locus-specific primer, as well as the street for the labelled secondary probe. BS only contains universal primer, so cannot be used for imaging / barcoding.

  - Case 2: MS and BS contain locus-specific primers and streets. These can be used for further barcoding or for stronger signal if the same sequences are added in the MS and BS.

  - Case 3: like case 2, also including a toehold sequence to allow sequential hybridization imaging.

The intersected files (`Main_isected.txt` and `Back_isected.txt`) are BED-like files containing 9 tab-separated columns, corresponding to information in the .csv derived using OligoMiner:

chr12&nbsp;&nbsp;&nbsp;&nbsp;7180500&nbsp;&nbsp;&nbsp;&nbsp;7214499&nbsp;&nbsp;&nbsp;&nbsp;region1_PEX5&nbsp;&nbsp;&nbsp;&nbsp;chr12&nbsp;&nbsp;&nbsp;&nbsp;7180812&nbsp;&nbsp;&nbsp;&nbsp;7180851&nbsp;&nbsp;&nbsp;&nbsp;AACTCATGACTTGGATATCGTTACCAAGTGGAGGAAATGG&nbsp;&nbsp;&nbsp;&nbsp;42.06

chr12&nbsp;&nbsp;&nbsp;&nbsp;7180500&nbsp;&nbsp;&nbsp;&nbsp;7214499&nbsp;&nbsp;&nbsp;&nbsp;region1_PEX5&nbsp;&nbsp;&nbsp;&nbsp;chr12&nbsp;&nbsp;&nbsp;&nbsp;7181016&nbsp;&nbsp;&nbsp;&nbsp;7181056&nbsp;&nbsp;&nbsp;&nbsp;AAACTTGACTTACCTGAGTCAGTAAATTTGCCTTGCAGAGA&nbsp;&nbsp;&nbsp;&nbsp;42.13

chr12&nbsp;&nbsp;&nbsp;&nbsp;7180500&nbsp;&nbsp;&nbsp;&nbsp;7214499&nbsp;&nbsp;&nbsp;&nbsp;region1_PEX5&nbsp;&nbsp;&nbsp;&nbsp;chr12&nbsp;&nbsp;&nbsp;&nbsp;7181272&nbsp;&nbsp;&nbsp;&nbsp;7181306&nbsp;&nbsp;&nbsp;&nbsp;ACCATTGCTGATCACCACTGTTGTAGACCTGCTGC&nbsp;&nbsp;&nbsp;&nbsp;44.58

chr12&nbsp;&nbsp;&nbsp;&nbsp;7180500&nbsp;&nbsp;&nbsp;&nbsp;7214499&nbsp;&nbsp;&nbsp;&nbsp;region1_PEX5&nbsp;&nbsp;&nbsp;&nbsp;chr12&nbsp;&nbsp;&nbsp;&nbsp;7181641&nbsp;&nbsp;&nbsp;&nbsp;7181675&nbsp;&nbsp;&nbsp;&nbsp;ACCAGTAAGATTTGGTGGCCTATACGGGGATTCTC&nbsp;&nbsp;&nbsp;&nbsp;42.07

- Col 1:	Chromosome where locus is located.

- Col 2:	Starting coordinate of locus of interest.

- Col 3:	Ending coordinate of locus of interest.

- Col 4:	ID of that specific locus. Different IDs within a single run will result in different locus-specific primers, but all probes labelled with the same street (same colour).

- Col 5:	Chromosome where locus is located (same as first column).

- Col 6:	Starting coordinate of each single probe within the library. This results from adding the start column in the OligoMiner output.csv to the second column of the current BED file and subtracting 1 (first location in OligoMiner.csv is 0).

- Col 7:	Ending coordinate of each single probe. Like previous column, but using the Stop column in the OligoMiner output.csv

- Col 8:	Sequence of each probe (third column in OligoMiner output.csv).

- Col 9:	Tm of each probe (Tm column in OligoMiner output.csv).

This step can be directly done using the custom script `OligoMiner_to_OligoLego.m`, and specifying the OligoMiner output as well as the characteristics of the region in the Custom inputs section.

3. Get streets pool, in this case already available in Streets folder.

4. If aiming for case 3, get toeholds, also available in Streets folder.

5. Get penalty table, again available in Streets folder. This is required to add MS and BS that can be used as PCR primers

6. Use **ApOPs MATLAB** function as follows:

ApOPs(
	‘MS’, `MS_intersected_file_path.txt`,
	‘BS’, `BS_intersected_file_path.txt`,
	‘Toes’, `Toes_file_path.txt`,
	‘Streets’, `Streets_file_path.txt`,
	‘PTable’, `Penalty_table_file_path.txt`,
	‘SavePath’, `Output_file_path.txt`,
	‘MaxAvoid’, `Number_to_avoid`,
	‘SameUniversal’, `Path_to_universal.txt`                                                    );

**MaxAvoid** avoids streets that have already been used for other loci to allow simultaneous imaging in different colours. If let’s say “MaxAvoid” “28” is used, then the included streets will be 29 and 30. It also affects the sequences used as Universal primers unless “SameUniversal” is specified.

**SameUniversal** flags the usage of universal primers to amplify an entire library at once. Can be used after a first run has already been done, specifying the path to the `Universal.txt` file from that previous run. Alternatively, the seeding `Universal.txt` file can be manually created specifying the street numbers and sequences from the streets file.

Sequences to order can be extracted from output of OligoLego as follows:
1. `Oligopaints.txt`: Entire oligopaints library.
2. `MS_IDs.txt`:
•	6th column: Forward primer
•	4th / 5th column: Identical in cases #1 and #2. This is the secondary oligo to order, add fluorescent labeled if required.
3.  `BS_IDs.txt`:
•	6th column: Reverse primer
•	Remaining columns relevant if more complicate designs for the library are desired.
4. `Universal.txt`:
•	2nd column: Forward universal primer.
•	4th column: Reverse universal primer.


More information can be found in the OligoMiner web (http://oligominerapp.org/) and OligoLego GitHub (https://github.com/gnir/OligoLego).
