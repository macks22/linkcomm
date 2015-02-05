SHELL = /bin/sh
CC    = g++
FLAGS = -O5
THRESH= 0.5

all: calc clust

calc: calcAndWrite_Jaccards.cpp
	$(CC) $(FLAGS) -o calcJaccards calcAndWrite_Jaccards.cpp

clust: clusterJaccsFile.cpp
	$(CC) $(FLAGS) -o clusterJaccards clusterJaccsFile.cpp

karate: calc clust
	./calcJaccards karate.pairs karate.jaccs
	./clusterJaccards karate.pairs karate.jaccs \
		karate.clusters_$(THRESH) karate.cluster_stats_$(THRESH) $(THRESH)

lesmis: calc clust
	./calcJaccards lesmis.pairs lesmis.jaccs
	./clusterJaccards lesmis.pairs lesmis.jaccs \
		lesmis.clsuters_$(THRESH) lesmis.cluster_stats_$(THRESH) $(THRESH)
