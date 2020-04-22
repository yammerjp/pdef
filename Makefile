all :
	mkdir -p bin
	swiftc -o bin/patch-defaults src/*.swift
clean :
	rm -r bin
test-run :
	./test/run.sh 1-add-shallow
	./test/run.sh 2-add-array-dict-add
	./test/run.sh 3-add-deep-without-data-date
	./test/run.sh 4-add-deep-without-data
	./test/run.sh 5-add-deep
	./test/run.sh 6-add-shallow-data-long
	./test/run.sh 7-add-deep-data-long
	./test/run.sh 8-update-deep-without-array
	./test/run.sh 9-update-deep-data-long
	./test/run.sh 10-update-deep-without
  
