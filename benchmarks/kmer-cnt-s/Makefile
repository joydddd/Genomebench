PIN_HOOK = 1
CXX     = g++
#CXX		 = icpc
#VTUNE_HOME= /opt/intel/vtune_profiler
LIBS= -lz -lm -lbz2 -llzma -ldl -fopenmp
CXXFLAGS   = -O3 -fopenmp
INC = -Ilibcuckoo

ifeq ($(PIN_HOOK),1)
CXXFLAGS += -DPIN_HOOK=1
endif

ifneq ($(VTUNE_HOME),)
CXXFLAGS+= -DVTUNE_ANALYSIS=1
LIBS += -L${VTUNE_HOME}/lib64 -littnotify
INC += -I${VTUNE_HOME}/include
endif


all: sequence_container.cpp sequence.cpp vertex_index.cpp kmer_cnt.cpp
	$(CXX) $(CXXFLAGS) sequence_container.cpp sequence.cpp vertex_index.cpp kmer_cnt.cpp $(INC) $(LIBS) -o kmer-cnt

.PHONY: clean

clean: 
	rm -f kmer-cnt

sequence_container.cpp: sequence_container.h sequence.h logger.h
sequence.cpp: sequence.h
vertex_index.cpp: vertex_index.h parallel.h memory_info.h logger.h config.h sequence_container.h kmer.h
kmer-cnt.cpp: sequence_container.h sequence.h vertex_index.h memory_info.h logger.h utils.h config.h parallel.h
