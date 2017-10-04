# BioSIMI
BioSIMI Modeling framework serving for input/output modeling of interconnected biomolecular systems

BioSIMI (Biomolecular Subsystems Interconnection Modeling Instrument) is a tool that enables creation of complex biomolecular networks 
using bottom-up, modular approach. 

Modules can be created either in TX-TL modeling toolbox, they can be created by the user,
or they can be added from the library of pre-existing subsystems.

The motivation for creation of the BioSIMI is to provide an analytical tool for modeling artificial cells. 
These biomolecular circuits would exhibit significant complexity and contain variety of pathways and subsystems, 
such as sensing, signaling, computational/regulatory, metabolic, etc.

Currently, BioSIMI is compatible with TX-TL modeling toolbox, but it can also function on its own, with pre-build subsystems (which contain arbitrary reaction rates and values of parameters at this time).
BioSIMI is built in MATLAB, using provided MATLAB SimBiology module.

NOTE: TX-TL modeling toolbox files must be in the same folder as BioSIMI's 'Subroutines','Subsystems', etc. for them to work together!

To initialize the BioSIMI and TX-TL, just run 'BioSIMI_init'.
