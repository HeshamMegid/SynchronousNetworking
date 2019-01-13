import XCTest

import SynchronousNetworkingTests

var tests = [XCTestCaseEntry]()
tests += SynchronousNetworkingTests.allTests()
XCTMain(tests)