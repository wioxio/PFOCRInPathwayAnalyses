If the following cannot install rhdf5 due to data.table issue


#packages <- c("rhdf5")
#if (length(setdiff(packages, rownames(installed.packages()))) > 0) {
#  BiocManager::install("rhdf5")
#}


Make 

~/.R/Makevars  

in your computer and add the following (remove # in the beginning of each line)

#From here                                     
LDFLAGS= -L/usr/local/clang4/lib
FLIBS=-L/usr/local/gfortran/lib/gcc/x86_64-apple-darwin16/6.3.0 -L/usr/local/gfortran/lib -lgfortran -lquadmath -lm
CC=/usr/local/clang4/bin/clang
CXX=/usr/local/gfortran/bin/g++
CXX1X=/usr/local/gfortran/bin/g++
CXX98=/usr/local/gfortran/bin/g++
CXX11=/usr/local/gfortran/bin/g++
CXX14=/usr/local/gfortran/bin/g++
CXX17=/usr/local/gfortran/bin/g++
   
LLVM_LOC = /usr/local/opt/llvm
CC=/usr/local/gfortran/bin/gcc -fopenmp
CXX=/usr/local/gfortran/bin/g++ -fopenmp
# -O3 should be faster than -O2 (default) level optimisation ..
CFLAGS=-g -O3 -Wall -pedantic -std=gnu99 -mtune=native -pipe
CXXFLAGS=-g -O3 -Wall -pedantic -std=c++11 -mtune=native -pipe
LDFLAGS=-L/usr/local/opt/gettext/lib -L$(LLVM_LOC)/lib -Wl,-rpath,$(LLVM_LOC)/lib
CPPFLAGS=-I/usr/local/opt/gettext/include -I$(LLVM_LOC)/include -I/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
#To here
                                        
Add this path to your mac:  /usr/local/gfortran/bin
                                        
                                        
                                        
After doing the above, I got error when I ran another R pacakge so I had to follow the instructions in the following link:
                                 
https://github.com/Rdatatable/data.table/wiki/Installation#openmp-enabled-compiler-for-mac
                                        
I still had an error when trying to install data.table, so I had to install pkg-config using brew following the instructed in the bottom of the website.                                        
                                        


