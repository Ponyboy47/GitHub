# GitHub

A Swift library for interacting with the GitHub v3 REST APIs

## Installation:

This library support installation via the Swift Package Manager. Simply add this as a dependency in your Package.swift:
```swift
.package(url: "https://github.com/Ponyboy47/GitHub.git", from: "0.1.0")
```

## Usage:
To make gitHub API requests you must first create a GitHub object:
```swift
// Unauthenticated
let gh = GitHub()

// Username/password authentication
let gh = GitHub(username: "ponyboy47", password: "my$up3r5ecureP@ssw0rd")

// Token authentication
let gh = GitHub(token: "MY_TOKEN")
```

Then you use the GitHub object to make API calls:
```swift
let response: [Code] = try gh.search.code.query(keywords: "addClass", qualifiers: [.in(.file), .language("js"), .repo("jquery", user: "jquery")])
```

## Authorizing GitHub:

Follow the steps (here)[https://help.github.com/en/articles/creating-a-personal-access-token-for-the-command-line] to create an access token.

## To do:
- [ ] More tests
- [ ] Implement missing APIs
- [ ] Cache APIs which will infrequently change
- [ ] Use stored URLs to make subsequent API calls
- [ ] Error handling
  - [ ] Give the relevant GitHub error message instead of just `fatalError`ing on unsuccessful calls
- [ ] Use the new `Callable` API once/if (SE-0253)[https://github.com/apple/swift-evolution/blob/master/proposals/0253-callable.md] becomes officially implemented and release (ie: Drop `.query` from search APIs, etc)

## License:
MIT
(c) 2019 Jacob Williams
