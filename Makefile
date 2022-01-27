SWIFT_PACKAGE_VERSION := $(shell swift package tools-version)
SOURCES_DIR="${PWD}/Sources"
FILEHEADER="\n{file}\nSwiftAssimp\n\nCopyright © 2019-{year} Christian Treffs. All rights reserved.\nLicensed under BSD 3-Clause License. See LICENSE file for details."

.PHONY: clean
clean: 
	swift package clean

# Lint fix and format code.
.PHONY: lint-fix
lint-fix:
	mint run swiftlint --fix --quiet
	mint run swiftformat ${SOURCES_DIR} --swiftversion ${SWIFT_PACKAGE_VERSION} --header ${FILEHEADER}

.PHONY: pre-push
pre-push: lint-fix

# Build debug version
.PHONY: build-debug
build-debug:
	swift build -c debug

# Build release version 
.PHONY: build-release
build-release:
	swift build -c release --skip-update

# Reset the complete cache/build directory and Package.resolved files
.PHONY: reset
	swift package reset
	-rm Package.resolved
	-rm rdf *.xcworkspace/xcshareddata/swiftpm/Package.resolved
	-rm -rdf .swiftpm/xcode/*

.PHONY: resolve
resolve:
	swift package resolve

.PHONY: open-proj-xcode
open-proj-xcode:
	open -b com.apple.dt.Xcode Package.swift

.PHONY: open-proj-vscode
open-proj-vscode:
	code .

PHONY: setup-brew
setup-brew:
	@which -s brew || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	@brew update

.PHONY: setup-project
setup-project: setup-brew
	brew install mint
	mint bootstrap

.PHONY: install-dependencies-macOS
install-dependencies-macOS: setup-project
	brew install assimp

.PHONY: pkg-config-assimp
pkg-config-assimp:
	pkg-config --libs --cflags assimp

.PHONY: brew-assimp-version
brew-assimp-version:
	@echo `brew info assimp | head -1 | awk '{ print $$3; }'`

.PHONY: copyMacPkgConfig500
copyMacPkgConfig500:
	sudo cp ${PWD}/assimp5.0.0.mac.pc /usr/local/lib/pkgconfig/assimp.pc

.PHONY: copyMacPkgConfig501
copyMacPkgConfig501:
	sudo cp ${PWD}/assimp5.0.1.mac.pc /usr/local/lib/pkgconfig/assimp.pc
