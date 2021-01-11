# Swift Assimp

[![Build Status](https://travis-ci.com/ctreffs/SwiftAssimp.svg?branch=master)](https://travis-ci.com/ctreffs/SwiftAssimp)
[![license](https://img.shields.io/badge/license-BSD3-brightgreen.svg)](LICENSE)
[![swift version](https://img.shields.io/badge/swift-5.1+-brightgreen.svg)](https://swift.org/download)
[![platforms](https://img.shields.io/badge/platforms-%20macOS%20-brightgreen.svg)](#)
[![platforms](https://img.shields.io/badge/platforms-linux-brightgreen.svg)](#)

This is a  **thin** Swift wrapper around the popular and excellent [**Open Asset Import Library**](http://assimp.org) library.  
It provides a **swifty** and **typesafe** API. 

> Open Asset Import Library (short name: Assimp) is a portable Open Source library to import various well-known 3D model formats in a uniform manner. The most recent version also knows how to export 3d files and is therefore suitable as a general-purpose 3D model converter.
> Loads 40+ 3D file formats into one unified and clean data structure.    
> ~ [www.assimp.org](http://www.assimp.org)

## 🚀 Getting Started

These instructions will get your copy of the project up and running on your local machine and provide a code example.

### 📋 Prerequisites

* [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager)
* [Open Asset Import Library (Assimp)](http://assimp.org)
* [SwiftEnv](https://swiftenv.fuller.li/) for Swift version management - (optional)
* [Swiftlint](https://github.com/realm/SwiftLint) for linting - (optional)

### 💻 Installing

Swift Assimp is available for all platforms that support [Swift 5.1](https://swift.org/) and higher and the [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager).

Extend your `Package.swift` file with the following lines or use it to create a new project.

For package manifests using the Swift 5.1 toolchain use:

```swift
// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/ctreffs/SwiftAssimp.git", from: "1.3.1")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["Assimp"])
    ]
)

```
or for package manifests using the Swift 5.2+ toolchain use:

```swift
// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(name: "Assimp", url: "https://github.com/ctreffs/SwiftAssimp.git", from: "1.3.1")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["Assimp"])
    ]
)

```

Since it's a system library wrapper you need to install the assimp library (>=5.0.0) either via

```sh
brew install assimp
```

or 

```sh
apt-get install libassimp-dev
```

depending on you platform.

### ⚠️ Caution macOS homebrew users

Swift package manager relies on the [pkg-config](http://pkg-config.freedesktop.org) tool to find system installed libraries.
Assimp version 5 contains a regression, which provides a broken pkg-config file (assimp.pc). 
Therefore SPM is not able to find the include headers out of the box resulting in the error:
`shims.h:1:10: error: 'assimp/cimport.h' file not found`.
This is a known bug and is tracked here <https://github.com/assimp/assimp/issues/3174> and here <https://github.com/assimp/assimp/issues/2804>.
However there is a fix that requires one manual step.

Depending on your assimp version run the following command in your Terminal:

- print the currently installed assimp version: `printBrewAssimpVersion`
    - for version 5.0.0:  `make copyMacPkgConfig500`
    - for version 5.0.1:  `make copyMacPkgConfig501`

This will copy a corrected pkg-config file to the appropriate library location. You will need to repeat this step when updating assimp via homebrew until a fix is provided by the assimp developers.
Be sure to close Xcode before retrying to build.

## 📝 Code Example


```swift
import Assimp

let scene: AiScene = try AiScene(file: <path/to/model/file.obj>, 
                                 flags: [.removeRedundantMaterials, .genSmoothNormals]))

// get meshes
let meshes: [AiMesh] = scene.meshes

// get materials
let matrials: [AiMaterial] = scene.materials

// get the root node of the scene graph
let rootNode: [AiNode] = scene.rootNode

```

See the unit tests for more examples.

## 💁 Help needed

This project is in an early stage and needs a lot of love.
If you are interested in contributing, please feel free to do so!

Things that need to be done are, among others:

- [ ] Wrap more assimp functions and types
- [ ] Support for [Cocoapods](https://cocoapods.org) packaging
- [ ] Support for [Carthage](https://github.com/Carthage/Carthage) packaging
- [ ] Write some additional tests to improve coverage

## 🏷️ Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/ctreffs/SwiftAssimp/tags). 

## ✍️ Authors

* [Christian Treffs](https://github.com/ctreffs)

See also the list of [contributors](https://github.com/ctreffs/SwiftAssimp/contributors) who participated in this project.

## 🔏 Licenses

This project is licensed under the 3-Clause BSD License - see the [LICENSE](LICENSE) file for details.

* assimp licensed under [3-clause BSD license](https://github.com/assimp/assimp/blob/master/LICENSE)


## 🙏 Original code

Since Swift Assimp is merely a wrapper around [**assimp**](https://github.com/assimp/assimp) it obviously depends on it.       
Support them if you can!

### Open Asset Import Library (assimp)

##### From [assimp/assimp/Readme.md](https://github.com/assimp/assimp/blob/master/Readme.md):

A library to import and export various 3d-model-formats including scene-post-processing to generate missing render data.

One-off donations via PayPal:
<br>[![PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4JRJVPXC4QJM4)

## ☮️ Alternatives

* [dmsurti/AssimpKit](https://github.com/dmsurti/AssimpKit)
* [eugenebokhan/AssetImportKit](https://github.com/eugenebokhan/AssetImportKit)
* [troughton/CAssimp](https://github.com/troughton/CAssimp)
