# SynchronousNetworking

[![CircleCI](https://circleci.com/gh/HeshamMegid/SynchronousNetworking.svg?style=svg)](https://circleci.com/gh/HeshamMegid/SynchronousNetworking)

Simple synchronous cross-platform networking for Swift CLI apps.

## Installation

### Swift Package Manager

```swift
dependencies: [
    .package(url: "https://github.com/HeshamMegid/SynchronousNetworking", .upToNextMajor(from: "0.0.1")
]
```

## Usage

```swift
let networking = SynchronousNetworking(baseUrl: URL(string: "http://example.com/")!)
let parameters = ["param1": "value1"]
let networkResponse = networking.getSynchronously(path: "path/to/endpoint/", parameters: parameters)
if let data = networkResponse.data {
    // Use data
}
```
