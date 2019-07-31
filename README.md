<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/62184933-ecbe4380-b392-11e9-82dd-802b6b2e8b82.png">
</p>

<br>
<p align="center">
	<a href="http://cocoapods.org/pods/Einstein">
		<image alt="Version" src="https://img.shields.io/cocoapods/v/Einstein.svg?style=flat">
	</a>
	<image alt="CI Status" src="https://img.shields.io/badge/Swift-5.0-orange.svg">
	<a href="http://cocoapods.org/pods/Einstein">
		<image alt="License" src="https://img.shields.io/cocoapods/l/Einstein.svg?style=flat">
	</a>
	<a href="http://cocoapods.org/pods/Einstein">
		<image alt="Platform" src="https://img.shields.io/cocoapods/p/Einstein.svg?style=flat">
	</a>
	<a href="https://travis-ci.org/ZhipingYang/Einstein">
		<image alt="CI Status" src="http://img.shields.io/travis/ZhipingYang/Einstein.svg?style=flat">
	</a>
</p>

> **Einstein** integrates the business logic across the Project and UITest through [AccessibilityIdentifier](https://github.com/ZhipingYang/Einstein/blob/master/Class/share/AccessibilityIdentifier.swift). And on UITest, useing [EasyPredict](https://github.com/ZhipingYang/Einstein/blob/master/Class/UITest/EasyPredicate.swift) and [Extensions](https://github.com/ZhipingYang/Einstein/tree/master/Class/UITest/extension) to better support UITest code writing

### Comparative sample

in `XCTestCase`, type the phone number to login

```swift
// use Einstein
LoginAccessID.SignIn.phoneNumber.element.waitUntilExists().clearAndType(text: "MyPhoneNumber")

// without Einstein
let element = app.buttons["LoginAccessID_SignIn_phoneNumber"]
let predicate = NSPredicate(format: "exists == true")
let promise = self.expectation(for: predicate, evaluatedWith: element, handler: nil)
XCTWaiter().wait(for: [promise], timeout: timeout)
let stringValue = (value as? String) ?? ""
let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
element.typeText(deleteString)
element.typeText("MyPhoneNumber")
```

### File structures

```
─┬─ Einstein -> `Then`
 ├─┬─ Share: -> `UIKit`
 │ └─── AccessibilityIdentifier.swift
 └─┬─ UITest: -> `UIKit` & `XCTest`
   ├─┬─ Model
   │ └─── EasyPredicate.swift
   └─┬─ Extensions
     ├─── RawRepresentable+helpers.swift
     ├─── XCTestCase+helpers.swift
     ├─── XCUIElement+helpers.swift
     └─── XCUIElementQuery+helpers.swift
```

### Install

> required `iOS >= 9.0` `Swift5.0` with [Cocoapods](https://cocoapods.org/)

```ruby
target 'XXXProject' do

  # in project target
  pod 'Einstein/Share' 
  
  target 'XXXProjectUITests' do
    # in UITest target
    pod 'Einstein' 
  end
end
```

# Using

- AccessibilityIdentifier
	- project target
	- UITest target
- EasyPredicate
- Extensions

## 1. AccessibilityIdentifier

> **Note:** <br>
> all the UIKit's accessibilityIdentifier is a preperty of the protocol `UIAccessibilityIdentification` and all enum's rawValue is default to follow `RawRepresentable`
><blockquote>

<details><summary> Expand for steps details </summary>
<br>
	
- 1.1 Define the enums
	- set rawValue in String
	- append PrettyRawRepresentable if need
- 1.2 set UIKit's accessibilityIdentifier by enums's rawValue
	- method1: infix operator
	- method2: UIAccessibilityIdentification's extension
</details></blockquote>

### 1.1 Define the enums

```swift 
struct LoginAccessID {
    enum SignIn: String {
        case signIn, phoneNumber, password
    }
    enum SignUp: String {
        case signUp, phoneNumber
    }
    enum Forget: String, PrettyRawRepresentable {
        case phoneNumber // and so on
    }
}
```

I highly recommend adding `PrettyRawRepresentable` protocol on enums, then you will get the RawValue string with the property path to avoid accessibilityIdentifier be samed in diff pages.

```swift
// for example:

let str1 = LoginAccessID.SignIn.phoneNumber
let str2 = LoginAccessID.SignUp.phoneNumber
let str3 = LoginAccessID.Forget.phoneNumber // had add PrettyRawRepresentable

str1 -> "phoneNumber"
str2 -> "phoneNumber" 
str3 -> "LoginAccessID_Forget_phoneNumber"
```
[see more: PrettyRawRepresentable](https://github.com/ZhipingYang/Einstein/blob/master/Class/share/AccessibilityIdentifier.swift#L45)

### 1.2 set UIKit's accessibilityIdentifier by enums's rawValue

```swift
// system way
signInPhoneTextField.accessibilityIdentifier = "LoginAccessID_SignIn_phoneNumber"

// method1: define infix operator >>>
signInPhoneTextField >>> LoginAccessID.SignIn.phoneNumber

// method2: extension the protocol UIAccessibilityIdentification
forgetPhoneTextField.accessibilityID(LoginAccessID.Forget.phoneNumber)

print(signInPhoneTextField.accessibilityIdentifier)
// "phoneNumber"

print(forgetPhoneTextField.accessibilityIdentifier)
// "LoginAccessID_Forget_phoneNumber"
```

## 2. Apply in UITest target

> **Note:** <br>
> extension the protocol RawRepresentable and limited it's RawValue == String

```swift
typealias SignInPage = LoginAccessID.SignIn

// type the phone number
SignInPage.phoneNumber.element.waitUntilExists().clearAndType(text: "myPhoneNumber")

// type passward
SignInPage.password.element.clearAndType(text: "******")

// start login
SignInPage.signIn.element.assert(predicate: .isEnabled(true)).tap()
```

## 3. EasyPredicate
> **Note:** <br>
> EasyPredicate's RawValue is `PredicateRawValue` (a another enum to manage logic and convert NSPredicate). <br>
><blockquote>

<details><summary> Expand for EasyPredicate's cases </summary>
<br>

```swift
public enum EasyPredicate: RawRepresentable {   
    case exists(_ exists: Bool)
    case isEnabled(_ isEnabled: Bool)
    case isHittable(_ isHittable: Bool)
    case isSelected(_ isSelected: Bool)
    case label(_ comparison: Comparison, _ value: String)
    case identifier(_ identifier: String)
    case type(_ type: XCUIElement.ElementType)
    case other(_ ragular: String)
}
```
</details></blockquote>

Although `NSPredicate` is powerfull but the developer interface is not good enough, We can try to convert the hard code style into the object-oriented style. and this is what EasyPredicate do

```swift
// use EasyPredicate
let element = query.element(predicates: [.type(.button), .exists(true), .label(.beginsWith, "abc")])

// use NSPredicate
let element = query.element(matching: NSPredicate(format: "elementType == 0 && exists == true && label BEGINSWITH 'abc'"))
```

```swift
// use EasyPredicate
let element = query.element(predicates: [.type(.button), .exists(true), .label(.beginsWith, "abc")])

// use NSPredicate
let element = query.element(matching: NSPredicate(format: "elementType == 0 && exists == true && label BEGINSWITH 'abc'"))
```

## 4. UITest Extensions

### 3.1 extension String

```swift
/*
 Note: string value can be a RawRepresentable and String at the same time
 for example:
 `let element: XCUIElement = "SomeString".element`
 */
extension String: RawRepresentable {
    public var rawValue: String { return self }
    public init?(rawValue: String) {
        self = rawValue
    }
}
```
<br>

### 3.2 extension RawRepresentable

<details open>
  <summary> Expand for RawRepresentable extension </summary>

```swift
/*
 Get the `XCUIElement` from RawRepresentable's RawValue which also been used as accessibilityIdentifier
 */
public extension RawRepresentable where RawValue == String {
    var element: XCUIElement {}
    var query: XCUIElementQuery {}
    var count: Int {}
    subscript(i: Int) -> XCUIElement {}   
    func queryFor(identifier: Self) -> XCUIElementQuery {}
}
```
</details>

<details>
  <summary> Expand for Sequence<RawRepresentable, Element.RawValue == String> </summary>

```swift
public extension Sequence where Element: RawRepresentable, Element.RawValue == String {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - subpredicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func anyElements(subpredicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [XCUIElement] {}
    
    /// get the first element was matched predicate
    func anyElements(predicate: EasyPredicate) -> XCUIElement? {}
}
```
</details>
<br>

### 3.3 extension XCUIElement

<details open>
  <summary> Expand for XCUIElement (Base) </summary>

```swift
// MARK: - Base
public extension XCUIElement {
    
    @discardableResult
    func waitUntil(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {}
    @discardableResult
    func waitUntil(predicate: EasyPredicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {}
    @discardableResult
    func waitUntilExists(timeout: TimeInterval = 10) -> XCUIElement {}
    @discardableResult
    func wait(_ s: UInt32 = 1) -> XCUIElement {}
    
    // MARK: - assert
    func assert(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {}
    func assert(predicate: EasyPredicate) -> XCUIElement {}
    @discardableResult
    func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {}
}
```
</details>

<details>
  <summary> Expand for XCUIElement extensioin </summary>

```swift
// MARK: - Extension
public extension XCUIElement {
    
    /// Wait until it's available and then type a text into it.
    @discardableResult
    func tapAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {}
    
    /// Wait until it's available and clear the text, then type a text into it.
    @discardableResult
    func clearAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {}
    
    @discardableResult
    func hidenKeyboard(inApp: XCUIApplication) -> XCUIElement {}
    
    @discardableResult
    func setSwitch(on: Bool, timeout: TimeInterval = 10) -> XCUIElement  {}
    
    @discardableResult
    func forceTap(timeout: TimeInterval = 10) -> XCUIElement {}
    
    @discardableResult
    func tapIfExists(timeout: TimeInterval = 10) -> XCUIElement {}
}
```
</details>

<details>
  <summary> Expand for Sequence<XCUIElement> extension </summary>

```swift
extension Sequence where Element: XCUIElement {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - subpredicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func anyElements(subpredicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [Element] {}
    
    /// get the first element was matched predicate
    func anyElements(predicate: EasyPredicate) -> Element? {}
}
```
</details>

<br>

### 3.4 extension XCUIElementQuery

<details open>
  <summary> Expand for XCUIElementQuery extension </summary>

```swift
extension XCUIElementQuery {
    
    func matching(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        return matching(NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }
    
    func element(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        return element(matching: NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }
    
    func element(predicate: EasyPredicate) -> XCUIElement {
        return element(predicates: [predicate], logic: .and)
    }
}
```
</details>
<br>

### 3.5 extension XCTestCase

<details open>
  <summary> Expand for XCTestCase (runtime) </summary>

```swift
/**
 associated object
 */
public extension XCTestCase {
    
    private struct XCTestCaseAssociatedKey {
        static var app = 0
    }
    
    var app: XCUIApplication {
        set {
            objc_setAssociatedObject(self, &XCTestCaseAssociatedKey.app, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let _app = objc_getAssociatedObject(self, &XCTestCaseAssociatedKey.app) as? XCUIApplication
            guard let app = _app else { return XCUIApplication().then { self.app = $0 } }
            return app
        }
    }
}
```
</details>

<details>
  <summary> Expand for XCTestCase extension </summary>

```swift

public extension XCTestCase {
    
    // MARK: - methods
    func isSimulator() -> Bool {}
    func takeScreenshot(activity: XCTActivity, name: String = "Screenshot") {}
    func takeScreenshot(groupName: String = "--- Screenshot ---", name: String = "Screenshot") {}
    func group(text: String = "Group", closure: (_ activity: XCTActivity) -> ()) {}
    func hideAlertsIfNeeded() {}
    func setAirplane(_ value: Bool) {}
    func deleteMyAppIfNeed() {}
    
    /// Try to force launch the application. This structure tries to ovecome the issues described at https://forums.developer.apple.com/thread/15780
    func tryLaunch<T: RawRepresentable>(arguments: [T], count counter: Int = 10, wait: UInt32 = 2) where T.RawValue == String {}
    
    func tryLaunch(count counter: Int = 10) {}
    
    func killAppAndRelaunch() {}
    
    /// Try to force closing the application
    func tryTearDown(wait: UInt32 = 2) {}
}
```
</details>
<br>

## Author

XcodeYang, xcodeyang@gmail.com

## License

Einstein is available under the MIT license. See the LICENSE file for more info.

