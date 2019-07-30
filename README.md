<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/62135060-256b0800-b314-11e9-8f67-3e1b09da77e7.png">

</p>

<br>
<p align="center">
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="Version" src="https://img.shields.io/cocoapods/v/VerticalTree.svg?style=flat">
	</a>
	<image alt="CI Status" src="https://img.shields.io/badge/Swift-5.0-orange.svg">
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="License" src="https://img.shields.io/cocoapods/l/VerticalTree.svg?style=flat">
	</a>
	<a href="http://cocoapods.org/pods/VerticalTree">
		<image alt="Platform" src="https://img.shields.io/cocoapods/p/VerticalTree.svg?style=flat">
	</a>
	<a href="https://travis-ci.org/ZhipingYang/VerticalTree">
		<image alt="CI Status" src="http://img.shields.io/travis/ZhipingYang/VerticalTree.svg?style=flat">
	</a>
</p>

> **UITestHelper** integrates the business logic across the Project and UITest through AccessibilityIdentified. And on UITest, useing EasyPredict and Extensions to better support test code writing

### Comparative sample

in `XCTestCase`, type the phone number to login

```swift
// use UITestHelper
LoginAccessID.SignIn.phoneNumber.element.waitUntilExists().clearAndType(text: "MyPhoneNumber")

// without UITestHelper
let element = app.buttons["Login_SignIn_phoneNumber"]
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
─┬─ UITestHelper -> `Then`
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
  pod 'UITestHelper/Share' 
  
  target 'XXXProjectUITests' do
    # in UITest target
    pod 'UITestHelper' 
  end
end
```

## Using

- AccessibilityIdentifier
- EasyPredicate
- Extensions

### 1. AccessibilityIdentifier

> **Note:** all the UIKit's accessibilityIdentifier is a preperty of the protocol `UIAccessibilityIdentification` and all enum's rawValue is default to follow `RawRepresentable`

- 1.1 Define the enums
	- set rawValue in String
	- append PrettyRawRepresentable if need
- 1.2 set UIKit's accessibilityIdentifier by enums's rawValue
	- method1: infix operator
	- method2: UIAccessibilityIdentification's extension

#### 1.1 Define the enums

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
[see more: PrettyRawRepresentable](https://github.com/ZhipingYang/UITestHelper/blob/master/Class/share/AccessibilityIdentifier.swift#L45)

#### 1.2 set UIKit's accessibilityIdentifier by enums's rawValue

```
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

### 2. Apply in UITest target

> **Note:** extension the protocol RawRepresentable and limited it's RawValue == String

```swift
typealias SignInPage = LoginAccessID.SignIn

// type the phone number
SignInPage.phoneNumber.element.waitUntilExists().clearAndType(text: "myPhoneNumber")

// type passward
SignInPage.password.element.clearAndType(text: "******")

// start login
SignInPage.signIn.element.tap().assert(predicate: .isEnabled(true))
```

### 2. EasyPredicate
> **Note:** <br>
> EasyPredicate's RawValue is `PredicateRawValue` (a another enum to manage logic and convert NSPredicate). <br>
> there's the often used cases I'd listed below.

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
> Although `NSPredicate` is powerfull but the developer interface is not good enough, We can try to convert the hard code style into the object-oriented style as below

```swift
// use EasyPredicate
let element = query.element(predicates: [.type(.button), .exists(true), .label(.beginsWith, "abc")])

// use NSPredicate
let element = query.element(matching: NSPredicate(format: "elementType == 0 && exists == true && label BEGINSWITH 'abc'"))
```

### 3. UITest Extensions

- RawRepresentable
	- extension RawRepresentable where RawValue == String
	- extension Sequence where Element: RawRepresentable, Element.RawValue == String
- XCUIElement
	- extension XCUIElement
	- extension Sequence where Element: XCUIElement
- XCTestCase
- XCUIElementQuery


## Author

XcodeYang, xcodeyang@gmail.com

## License

UITestHelper is available under the MIT license. See the LICENSE file for more info.

