build :
	mkdir -p bin
	swiftc -o bin/pdef src/*.swift
	md5 -q src/*.swift > .src-md5
install :
	make build
	cp bin/pdef /usr/local/bin/pdef
uninstall :
	rm /usr/local/bin/pdef
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
  
