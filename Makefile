ASSIMP_DIR=3rdparty/assimp
CASSIMP_DIR=Sources/CAssimp
lint:
	swiftlint autocorrect --format
	swiftlint lint --quiet

lintErrorOnly:
	@swiftlint lint --quiet | grep error

genLinuxTests:
	swift test --generate-linuxmain
	swiftlint autocorrect --format --path Tests/

test: genLinuxTests
	swift test

submodule:
	git submodule update --init --recursive
	
clean:
	swift package reset
	rm -rdf .swiftpm/xcode
	rm -rdf .build/
	rm Package.resolved
	rm .DS_Store

cleanArtifacts:
	swift package clean

latest:
	swift package update

resolve:
	swift package resolve

genXcode:
	swift package generate-xcodeproj --enable-code-coverage --skip-extra-files 

genXcodeOpen: genXcode
	open *.xcodeproj

precommit: lint genLinuxTests

testReadme:
	markdown-link-check -p -v ./README.md
	
pkgConfigDebug:
	pkg-config --libs --cflags assimp

printBrewAssimpVersion:
	@echo `brew info assimp | head -1 | awk '{ print $$3; }'`

copyMacPkgConfig500:
	sudo cp ${PWD}/assimp5.0.0.mac.pc /usr/local/lib/pkgconfig/assimp.pc

copyMacPkgConfig501:
	sudo cp ${PWD}/assimp5.0.1.mac.pc /usr/local/lib/pkgconfig/assimp.pc

build: copyMacPkgConfig pkgConfigDebug
	swift build

buildAssimpLib:
	cd $(ASSIMP_DIR); cmake CMakeLists.txt; make -j8

copyAssimpDependencies:
	mkdir -p $(CASSIMP_DIR)/bin; \
	mkdir -p $(CASSIMP_DIR)/include/assimp; \
	mkdir -p $(CASSIMP_DIR)/include/assimp/Compiler; \
	mkdir -p $(CASSIMP_DIR)/lib; \
	cp -r $(ASSIMP_DIR)/bin/* $(CASSIMP_DIR)/bin; \
	cp $(ASSIMP_DIR)/include/assimp/*.h $(CASSIMP_DIR)/include/assimp; \
	cp $(ASSIMP_DIR)/include/assimp/*.inl $(CASSIMP_DIR)/include/assimp; \
	cp $(ASSIMP_DIR)/include/assimp/Compiler/*.h $(CASSIMP_DIR)/include/assimp/Compiler; \
	cp -r $(ASSIMP_DIR)/lib/* $(CASSIMP_DIR)/lib