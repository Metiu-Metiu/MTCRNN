# paramManager

A python module for managing json parameter files.
paramManager writes and reads parameter files for data file sets, one structured parameter dictionary per data file.
Also able to do automatic resampling of parameters.

This is what parameter files look like:
~~~~
    {'meta': {'filename' : foo,
               whatever_else},
     'param_name' : {'times' : [], 
                     'values' : [],
                     'units' : (categorical, frequency, amplitude, power, pitch, ...), default: None
                     'nvals' : number of potential values, defualt: 0 (means continuous real)
                     'minval: default: 0
                     'maxval: default: 1},
     ...
     } 
~~~~
The parameter files can then be read by dataLoaders, etc. 


## Getting Started
~~~~
from paramManager import paramManager

datapath= 'data/audio'  #datapath can also take a single file instead of a directory
parampath= 'data/params'

pm=paramManager(datapath, parampath)  #initialize ParamManager class

pm.initParamFiles(overwrite=True)  #create param files

pm.checkIntegrity()  #check 1-to-1 correspondence of data and param files

pm.addParam(fname, "pitch", time_array, value_array, units="frequency", nvals=0, minval=0, maxval=1)  #add new parameter to param file

foo=pm.getParams(filename)  #print parameter keywords in param file
pitchparam=fooparams['pitch']
~~~~

Consult ProcessFiles.ipynb for more examples on usage.

### Folder structure
The permissable folder structure for data/paramfiles under datapath and parampath is very flexible. Even nested folders are allowed in which case the paramfiles will be created following the same folder structure as datapath.

### Prerequisites

- Scipy  
- json

## Authors

* Muhammad Huzaifah
* Lonce Wyse  [lonce.org](http://lonce.org)






