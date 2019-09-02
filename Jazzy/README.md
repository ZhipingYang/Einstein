<p align="center">
<img width=150 src="https://user-images.githubusercontent.com/9360037/62184933-ecbe4380-b392-11e9-82dd-802b6b2e8b82.png">
</p>


<br>
<p align="center">
	<a href="https://zhipingyang.github.io/Einstein">
        <img alt="Documentation" src="http://img.shields.io/badge/read_the-docs-2196f3.svg">
	</a>
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

> **Einstein** is an UITest framework which integrates the business logic across the Project and UITest through [AccessibilityIdentifier](https://github.com/ZhipingYang/Einstein/blob/master/Class/Identifier/AccessibilityIdentifier.swift). And on UITest, using [EasyPredict](https://github.com/ZhipingYang/Einstein/blob/master/Class/UITest/Model/EasyPredicate.swift) and [Extensions](https://github.com/ZhipingYang/Einstein/tree/master/Class/UITest/Extensions) to better support UITest code writing

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
	
- 1.1 Define the enums
	- set rawValue in String
	- append PrettyRawRepresentable if need
- 1.2 set UIKit's accessibilityIdentifier by enums's rawValue
	- method1: infix operator
	- method2: UIAccessibilityIdentification's extension
- 1.3 Apply in UITest target


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

## Author

XcodeYang, xcodeyang@gmail.com

## License

Einstein is available under the MIT license. See the LICENSE file for more info.

