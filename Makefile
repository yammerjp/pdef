all :
	mkdir -p bin
	swiftc -o bin/patch-defaults src/*.swift
clean :
	rm -r bin
test-run :
	./test/run.sh 1-shallow
	./test/run.sh 2-array-dict-add
	./test/run.sh 3-deep-without-data-date
	./test/run.sh 4-deep-without-data
	./test/run.sh 5-deep
	./test/run.sh 6-shallow-data-long
	./test/run.sh 7-deep-data-long
  
