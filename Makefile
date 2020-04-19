all :
	mkdir -p bin
	swiftc -o bin/patch-defaults src/*.swift
clean :
	rm -r bin
test-run :
	./test/run.sh 1
	./test/run.sh 2
	./test/run.sh 3
#	./test/run.sh 3
  
