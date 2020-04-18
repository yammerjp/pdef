all :
	mkdir -p bin
	swiftc -o bin/patch-defaults src/*.swift
clean :
	rm -r bin
test-run :
	./test/test.sh net.basd4g.debug
test-init :
	./test/init.sh net.basd4g.debug
  
