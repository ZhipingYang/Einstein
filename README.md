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

<br>

> **UITestHelper** integrates the business logic across the Project and UITest through AccessibilityIdentified. On UITest, useing EasyPredict and Extensions to better support test code writing

### File structures

```
─┬─ UITestHelper: dependency `Then`
 ├─┬─ Share: dependency `UIKit`
 │ └─── AccessibilityIdentifier.swift
 └─┬─ UITest: dependency `UIKit` & `XCTest`
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

### 1. AccessibilityIdentifier

> all the UIKit's accessibilityIdentifier proprety is follow the protocol `UIAccessibilityIdentification `

#### - Define the enums

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

// method1: define infix operator >>>
signInButton >>> LoginAccessID.SignIn.phoneNumber

// method2: extension the protocol UIAccessibilityIdentification
getMessageBtn.accessibilityID(LoginAccessID.Forget.phoneNumber)

print(signInButton.accessibilityIdentifier)
// "phoneNumber"

print(getMessageBtn.accessibilityIdentifier)
// "LoginAccessID_Forget_phoneNumber"
```

I highly recommend adding `PrettyRawRepresentable` protocol on enums, then you will get the RawValue string with the property path to avoid accessibilityIdentifier be samed in diff pages.

```swift
// for example:

let str1 = LoginAccessID.SignIn.phoneNumber
let str2 = LoginAccessID.SignUp.phoneNumber
let str3 = LoginAccessID.Forget.phoneNumber

str1 -> "phoneNumber"
str2 -> "phoneNumber" 
str3 -> "LoginAccessID_Forget_phoneNumber"
```
[see more: PrettyRawRepresentable](https://github.com/ZhipingYang/UITestHelper/blob/master/Class/share/AccessibilityIdentifier.swift#L45)

#### - apply in UITest target

> extension the protocol RawRepresentable and limited it's RawValue == String

```swift
typealias SignInPage = LoginAccessID.SignIn

// type the phone number
SignInPage.phoneNumber.element.waitUntilExists().clearAndType(text: "myPhoneNumber")

// type passward
SignInPage.password.element.waitUntilExists().type(text: "******")

// start login
SignInPage.signIn.element.waitUntil(predicate: .isEnabled(true))
```

### 2. EasyPredicate




## Author

XcodeYang, xcodeyang@gmail.com

## License

UITestHelper is available under the MIT license. See the LICENSE file for more info.

