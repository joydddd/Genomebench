CXX=g++
CC=gcc
ARCH=native
PIN_HOOK=1
#VTUNE_HOME=/opt/intel/oneapi/vtune/2021.1.1
MKLROOT=/opt/intel/oneapi/mkl/2021.1.1
MKL_IOMP5_DIR=/opt/intel/oneapi/compiler/2021.1.2/linux/compiler/lib/intel64_lin
CUDA_LIB=/usr/local/cuda

.PHONY: clean
	
all: fmi bsw bsw-s dbg dbg-s chain pileup pileup-s kmer-cnt kmer-cnt-s
	# $(info Starting build..this may take a while..)
	# phmm, poa are not used because of small memory footprint
	# cd tools/GKL; ./gradlew test 
	# cd benchmarks/phmm; $(MAKE) CC=$(CC) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME)
	# cd tools/spoa; mkdir build; cd build; cmake -DCMAKE_BUILD_TYPE=Release ..; $(MAKE)
	# cd benchmarks/poa; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) 
	# TODO: fix. need MKL
	# cd benchmarks/grm/2.0/build_dynamic; $(MAKE) CC=$(CC) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) MKLROOT=$(MKLROOT) MKL_IOMP5_DIR=$(MKL_IOMP5_DIR) #needs MKL


tools/bwa-mem2/bwa-mem2: 
	$(info building tool: bwa-mem2) 
	cd tools/bwa-mem2; $(MAKE) CXX=$(CXX) arch=$(ARCH) PIN_HOOK=$(PIN_HOOK)

tools/htslib/libhts.so tools/htslib/libhts.a:
	$(info building tool: htslib)
	cd tools/htslib && autoreconf -i && ./configure && $(MAKE)

build-tools: 
	$(info Starting building tools: htslib and bwa-mem2. This might take a while...)
	$(info Requires gcc and g++ 8/9/10. Current version: )
	g++ --version
	gcc --version
	cd tools/htslib && autoreconf -i && ./configure && $(MAKE)
	cd tools/bwa-mem2; $(MAKE) CXX=$(CXX) arch=$(ARCH) PIN_HOOK=$(PIN_HOOK)
fmi: tools/bwa-mem2/bwa-mem2
	cd benchmarks/fmi; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
fmi-l: tools/bwa-mem2/bwa-mem2
	cd benchmarks/fmi-l; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
bsw: 
	cd input-datasets; ./organize_data.py
	cd benchmarks/bsw; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK) 
bsw-s: 
	cd benchmarks/bsw-s; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
dbg: tools/htslib/libhts.so
	cd benchmarks/dbg; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
dbg-s: tools/htslib/libhts.so
	cd benchmarks/dbg-s; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
chain:
	cd tools/minimap2; $(MAKE)
	cd benchmarks/chain; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
pileup: tools/htslib/libhts.a
	cd benchmarks/pileup; $(MAKE) CC=$(CC) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
pileup-s: tools/htslib/libhts.a
	cd benchmarks/pileup-s; $(MAKE) CC=$(CC) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
kmer-cnt:
	cd benchmarks/kmer-cnt; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
kmer-cnt-s:
	cd benchmarks/kmer-cnt-s; $(MAKE) CXX=$(CXX) arch=$(ARCH) VTUNE_HOME=$(VTUNE_HOME) PIN_HOOK=$(PIN_HOOK)
	

gpu:
	cd benchmarks/abea; $(MAKE) CUDA_LIB=$(CUDA_LIB)

clean:
	cd tools/bwa-mem2; $(MAKE) clean
	cd tools/htslib; $(MAKE) clean
	cd benchmarks/fmi; $(MAKE) clean
	cd benchmarks/fmi-l; $(MAKE) clean
	cd benchmarks/bsw; $(MAKE) clean
	cd benchmarks/bsw-s; $(MAKE) clean
	cd benchmarks/dbg; $(MAKE) clean
	cd benchmarks/dbg-s; $(MAKE) clean
	cd tools/GKL; ./gradlew clean
	cd benchmarks/phmm; $(MAKE) clean
	cd tools/minimap2; $(MAKE)
	cd benchmarks/chain; $(MAKE) clean
	cd benchmarks/poa; $(MAKE) clean
	cd benchmarks/pileup; $(MAKE) clean
	cd benchmarks/pileup-s; $(MAKE) clean
	cd benchmarks/kmer-cnt; $(MAKE) clean
	cd benchmarks/kmer-cnt-s; $(MAKE) clean
	cd benchmarks/grm/2.0/build_dynamic; $(MAKE) clean
