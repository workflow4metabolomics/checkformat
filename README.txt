Tool: Check Format

I. Date: 2015-03-16

II. Author and maintainer:

	Etienne Thevenot, MetaboHUB Paris, CEA (etienne.thevenot@cea.fr)

III. Funding

	Developed within MetaboHUB, The French Infrastructure in Metabolomics and Fluxomics (www.metabohub.fr/en)

IV. Usage restrictions

	Use of this tool is restricted to the service conditions of the MetaboHUB-IFB infrastructures.
	For any question regarding the use of these services, please contact: etienne.thevenot@cea.fr

V. Installation

	5 files are required for installation:

	1) 'README.txt'
		Instructions for installation
   
	2) 'checkFormat_config.xml'
		Configuration file; to be put into the './galaxy-dist/tools' directory ('Quality Control' subdirectory)
		
	3) 'checkFormat_wrapper.R'
		Wrapper code written in R aimed at launching the checkFormat_script.R given the arguments entered by the user through the Galaxy interface		
		 
	4) 'checkFormat_script.R
		R script containing the computational function(s)

	5) 'checkFormat_workflowPositionImage.png'
         Image for the workflow position section of the 'checkFormat_config.xml' file; to be put into the './galaxy-dist/static/images' directory

VI. License

	CeCILL
