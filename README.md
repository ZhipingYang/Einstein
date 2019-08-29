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

> **Einstein** integrates the business logic across the Project and UITest through [AccessibilityIdentifier](https://github.com/ZhipingYang/Einstein/blob/master/Class/Identifier/AccessibilityIdentifier.swift). And on UITest, using [EasyPredict](https://github.com/ZhipingYang/Einstein/blob/master/Class/UITest/Model/EasyPredicate.swift) and [Extensions](https://github.com/ZhipingYang/Einstein/tree/master/Class/UITest/Extensions) to better support UITest code writing

### Comparative sample

in `XCTestCase`, type the phone number to login

> 👍 Use Einstein ↓
>
> ```swift
> LoginAccessID.SignIn.phoneNumber.element
>	.assertBreak(predicate: .exists(true))?
>	.clearAndType(text: "MyPhoneNumber")
> ```
> 😵 without Einstein ↓
> 
> ```swift 
> let element = app.buttons["LoginAccessID_SignIn_phoneNumber"]
> let predicate = NSPredicate(format: "exists == true")
> let promise = self.expectation(for: predicate, evaluatedWith: element, handler: nil)
> let result = XCTWaiter().wait(for: [promise], timeout: 10)
> if result == XCTWaiter.Result.completed {
>     let stringValue = (element.value as? String) ?? ""
>     let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
>     element.typeText(deleteString)
>     element.typeText("MyPhoneNumber")
> } else {
>     assertionFailure("LoginAccessID_SignIn_phoneNumber element is't existe")
> }
> ```

### File structures

```
─┬─ Einstein
 ├─┬─ Identifier: -> `UIKit`
 │ └─── AccessibilityIdentifier.swift
 │
 └─┬─ UITest: -> `Einstein/Identifier` & `XCTest` & `Then`
   ├─┬─ Model
   │ ├─── EasyPredicate.swift
   │ └─── Springboard.swift
   └─┬─ Extensions
     ├─── RawRepresentable+helpers.swift
     ├─── PrettyRawRepresentable+helpers.swift
     ├─── XCTestCase+helpers.swift
     ├─── XCUIElement+helpers.swift
     └─── XCUIElementQuery+helpers.swift
```

### Install

> required `iOS >= 9.0` `Swift5.0` with [Cocoapods](https://cocoapods.org/)

```ruby
target 'XXXProject' do

  # in project target
  pod 'Einstein/Identifier' 
  
  target 'XXXProjectUITests' do
    # in UITest target
    pod 'Einstein'
  end
end
```

# Using

- AccessibilityIdentifier
	- Project target
	- UITest target
	- Apply in UITest
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
- 1.3 Apply in UITest target
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

str1 == "phoneNumber"
str2 == "phoneNumber" 
str3 == "LoginAccessID_Forget_phoneNumber"
```
[see more: PrettyRawRepresentable](https://github.com/ZhipingYang/Einstein/blob/master/Class/share/AccessibilityIdentifier.swift#L45)

### 1.2 set UIKit's accessibilityIdentifier by enums's rawValue

```swift
// system way
signInPhoneTextField.accessibilityIdentifier = "LoginAccessID_SignIn_phoneNumber"

// define infix operator <<<
forgetPhoneTextField <<< LoginAccessID.Forget.phoneNumber

print(forgetPhoneTextField.accessibilityIdentifier)
// "LoginAccessID_Forget_phoneNumber"
```

### 1.3. Apply in UITest target

> **Note:** <br>
> Firstly
> Import the defined enums file in UITest
> 
> - Method 1: Set it's `target membership` as true both in XXXProject and XXXUITest
> - Method 2: Import project files in UITest with @testable [Link: how to set](https://stackoverflow.com/questions/32008403/no-such-module-when-using-testable-in-xcode-unit-tests)
> 
> ```swift
> @testable import XXXPreject
> ```

```swift
// extension the protocol RawRepresentable and it's RawValue == String

typealias SignInPage = LoginAccessID.SignIn

// type the phone number
SignInPage.phoneNumber.element.waitUntilExists().clearAndType(text: "myPhoneNumber")

// type passward
SignInPage.password.element.clearAndType(text: "******")

// start login
SignInPage.signIn.element.assert(predicate: .isEnabled(true)).tap()
```

## 2. EasyPredicate
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

Although `NSPredicate` is powerful, the developer program interface is not good enough, we can try to convert the hard code style into the object-oriented style. and this is what EasyPredicate do

```swift
// use EasyPredicate
let targetElement = query.filter(predicate: .label(.beginsWith, "abc")).element

// use NSPredicate
let predicate = NSPredicate(format: "label BEGINSWITH 'abc'")
let targetElement = query.element(matching: predicate).element
```

EasyPredicate Merge

```swift
// "elementType == 0 && exists == true && label BEGINSWITH 'abc'"
let predicate: EasyPredicate = [.type(.button), .exists(true), .label(.beginsWith, "abc")].merged()

// "elementType == 0 || exists == true || label BEGINSWITH 'abc'"
let predicate: EasyPredicate = [.type(.button), .exists(true), .label(.beginsWith, "abc")].merged(withLogic: .or)

```


## 3. UITest Extensions

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
  <summary> Expand for Sequence where Element: RawRepresentable </summary>

```swift
public extension Sequence where Element: RawRepresentable, Element.RawValue == String {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - predicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func elements(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [XCUIElement] {}
    
    /// get the first element was matched predicate
    func anyElement(predicate: EasyPredicate) -> XCUIElement? {}
}
```
</details>

<details>
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
<br>

### 3.3 extension XCUIElement

<details open>
  <summary> Expand for XCUIElement (Base) </summary>

```swift
public extension PredicateBaseExtensionProtocol where Self == T {

    /// create a new preicate with EasyPredicates and LogicalType to judge is it satisfied on self
    ///
    /// - Parameters:
    ///   - predicates: predicates rules
    ///   - logic: predicates relative
    /// - Returns: tuple of result and self
    @discardableResult
    func waitUntil(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> (result: XCTWaiter.Result, element: T) {
        if predicates.count <= 0 { fatalError("predicates cannpt be empty!") }
        
        let test = XCTestCase().then { $0.continueAfterFailure = true }
        let promise = test.expectation(for: predicates.toPredicate(logic), evaluatedWith: self, handler: handler)
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        return (result, self)
    }
    
    /// assert by new preicate with EasyPredicates and LogicalType, if assert is passed then return self or return nil
    ///
    /// - Parameters:
    ///   - predicates: rules
    ///   - logic: predicates relative
    /// - Returns: self or nil
    @discardableResult
    func assertBreak(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> T? {
        if predicates.first == nil { fatalError("❌ predicates can't be empty") }
        
        let filteredElements = ([self] as NSArray).filtered(using: predicates.toPredicate(logic))
        if filteredElements.isEmpty {
            let predicateStr = predicates.map { "\n <\($0.rawValue.regularString)>" }.joined()
            assertionFailure("❌ \(self) is not satisfied logic:\(logic) about rules: \(predicateStr)")
        }
        return filteredElements.isEmpty ? nil : self
    }
}
```
</details>

<details>
  <summary> Expand for XCUIElement base extensioin </summary>

```swift

// MARK: - wait
@discardableResult
func waitUntil(predicate: EasyPredicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> (result: XCTWaiter.Result, element: XCUIElement) {}

@discardableResult
func waitUntilExists(timeout: TimeInterval = 10) -> (result: XCTWaiter.Result, element: XCUIElement) {}

@discardableResult
func wait(_ s: UInt32 = 1) -> XCUIElement {}

// MARK: - assert
@discardableResult
func assertBreak(predicate: EasyPredicate) -> XCUIElement? {}

@discardableResult
func assert(predicate: EasyPredicate) -> XCUIElement {}

@discardableResult
func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {}

@discardableResult
func assert(predicate: EasyPredicate, timeout: TimeInterval = 10) -> XCUIElement {}
```
</details>

<details>
  <summary> Expand for XCUIElement custom extensioin </summary>

```swift
// MARK: - Extension
public extension XCUIElement {
    
    /// search child element by predicate
    @discardableResult
    func childElement(predicate: EasyPredicate) -> XCUIElement? {}
    
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
  <summary> Expand for Sequence: XCUIElement <XCUIElement> extension </summary>

```swift
extension Sequence where Element: XCUIElement {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - predicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func elements(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [Element] {}
    
    /// get the first element was matched predicate
    func anyElement(predicate: EasyPredicate) -> Element? {}
}
```
</details>

<br>

### 3.4 extension XCUIElementQuery

<details open>
  <summary> Expand for XCUIElementQuery extension </summary>

```swift
public extension XCUIElementQuery {
    
    /// get ElementQuery of all child elements and child's child elements and so on
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate' rules
    ///   - logic: rules relate
    /// - Returns: ElementQuery
    func childrenFilter(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {}
    
    /// get target element of all child elements and child's child elements and so on
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: result target
    func childrenFirst(predicate: EasyPredicate) -> XCUIElement {}
    
    /// filter the query by rules to create new query
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: ElementQuery
    func filter(predicate: EasyPredicate) -> XCUIElementQuery {}
    
    /// filter the target element by rules to create new query
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: the target XCUIElement
    func first(predicate: EasyPredicate) -> XCUIElement {}
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

## Author

XcodeYang, xcodeyang@gmail.com

## License

Einstein is available under the MIT license. See the LICENSE file for more info.

