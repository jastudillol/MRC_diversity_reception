# MRC_diversity_reception

***OptimalParameters.m

	The MRC approximation has been implemented using MATLAB.  We have considered multiple parameters such as transmission power, distance of the link, frequency, transmission gain, and reception gain. Then, two equivalent parameters, m and $\Omega$, are generated, calculated, and evaluated using a MATLAB script through the MLE technique. Therefore, the resulting binary file contains a parameter array with the $\Omega$ and m equivalent parameters for different distances.

	Note that a resulting file is generated for each order of diversity. For instance, in the OptimalParameters.m, a 'parameters_naka.bin' binary file is generated for a diversity order of 4. If you want to modify the diversity order, the 'N' MATLAB variable has to modified.

***ns-3 Implementation.

1. Overwrite the 'src/propagation/model/' inside the ns-3 folder with following files:

	propagation-loss-model.cc
	propagation-loss-model.h

2.  The resulting binary file has to be imported into the ns-3 simulator only once at the beginning of the simulation. The idea here is that when a packet is received, the distance is checked, and from this distance, we map the equivalent parameters. Thus, there are equivalent values of m and $\Omega$ for a given distance, and with these equivalent values, the power value that simulates the diversity reception is generated.

For this purpose, 'ns-3.27/Nakagami/' folder has different binary files for four diversity orders.

To import the binary files, you have to use the following code in your main function inside the ns-3 script:

	ifstream inStream;
	int mysize = 0;
	inStream.open("./Nakagami/1/parameters_naka.bin", std::ios::binary);
	inStream.read(reinterpret_cast<char*> (&mysize), sizeof (int));
	double* p_m_equivalente = new double [mysize];
	double* p_omega_equivalente = new double [mysize];

	inStream.read(reinterpret_cast<char*> (p_m_equivalente), mysize * sizeof (double));
	inStream.read(reinterpret_cast<char*> (p_omega_equivalente), mysize * sizeof (double));

	uint32_t int_p_m= (uint32_t) p_m_equivalente;
	uint32_t int_p_omega= (uint32_t) p_omega_equivalente;
	uint32_t a_max_distance= (uint32_t) mysize;
  
*** ns-3 Building

The wireless channel model has been implemented in ns3. However, the Nakami-m model has been modeled with its new parameters (m and Ω) in MATLAB. Therefore, since these two tools work together, some flags must be enabled when building and compiling the ns-3 in order to avoid errors in execution.

	./build.py --enable-examples --enable-tests CXXFLAGS_EXTRA = "- fpermissive -Wno-error"


