.PHONY: ALL
ALL: autotester bayeselo pgnstats

.PHONY: autotester
autotester:
	cd autotester && $(MAKE)

.PHONY: pgnstats
pgnstats:
	cd pgnstats && $(MAKE)

.PHONY: bayeselo
bayeselo:
	cd BayesElo && $(MAKE)

.PHONY: clean
clean:
	cd autotester && $(MAKE) clean
	cd BayesElo && $(MAKE) clean
	cd pgnstats && $(MAKE) clean

TEST_FILE := ../tests/basic.txt
.PHONY: test
test: autotester bayeselo referee
	java -jar ./autotester/lauto.jar ./referee $(TEST_FILE)
	cd pgn/ && ./pgnrate.tcl ../$(TEST_FILE:.txt=.pgn)
