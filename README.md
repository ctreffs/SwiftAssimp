# Swift Assimp

[![Build Status](https://travis-ci.com/ctreffs/SwiftAssimp.svg?branch=master)](https://travis-ci.com/ctreffs/SwiftAssimp)
[![license](https://img.shields.io/badge/license-BSD3-brightgreen.svg)](LICENSE)
[![swift version](https://img.shields.io/badge/swift-5.0+-brightgreen.svg)](https://swift.org/download)
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
* [Swiftlint](https://github.com/realm/SwiftLint) for linting - (optional)
* [SwiftEnv](https://swiftenv.fuller.li/) for Swift version management - (optional)

### 💻 Installing

Swift Assimp is available for all platforms that support [Swift 5.0](https://swift.org/) and higher and the [Swift Package Manager (SPM)](https://github.com/apple/swift-package-manager).

Extend the following lines in your `Package.swift` file or use it to create a new project.

```swift
// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "YourPackageName",
    dependencies: [
        .package(url: "https://github.com/ctreffs/SwiftAssimp.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "YourTargetName",
            dependencies: ["Assimp"])
    ]
)

```

Since it's a system library wrapper you need to install the assimp library either via

```sh
brew install assimp
```

or 

```sh
apt-get install libassimp-dev
```

depending on you platform.

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

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](/releases). 

## ✍️ Authors

* [Christian Treffs](https://github.com/ctreffs)

See also the list of [contributors](https://github.com/ctreffs/SwiftAssimp/contributors) who participated in this project.

## 🔏 Licenses

This project is licensed under the 3-Clause BSD License - see the [LICENSE](LICENSE) file for details.

* assimp licensed under [3-clause BSD license](https://github.com/assimp/assimp/blob/master/LICENSE)


## 🙏 Original code

Since Swift Assimp is merely a wrapper around [**assimp**](https://github.com/assimp/assimp) it obviously depends on it.       
Support them if you can!

### imgui

##### From [assimp/assimp/Readme.md](https://github.com/assimp/assimp/blob/master/Readme.md):

A library to import and export various 3d-model-formats including scene-post-processing to generate missing render data.

One-off donations via PayPal:
<br>[![PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=4JRJVPXC4QJM4)

## ☮️ Alternatives

* [dmsurti/AssimpKit](https://github.com/dmsurti/AssimpKit)
* [eugenebokhan/AssetImportKit](https://github.com/eugenebokhan/AssetImportKit)
* [troughton/CAssimp](https://github.com/troughton/CAssimp)
