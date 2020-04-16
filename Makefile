all :
	mkdir -p bin
	swiftc -o bin/patch-defaults src/main.swift
clean :
	rm -r bin

