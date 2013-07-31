# HyperlinkingTextView

Add hyperlink-like behaviour to substrings in a UITextView. 

## What This Is

A demonstration of how to implement hyperlinks in a UITextView using methods found in the UITextInput protocol. A UITextView subclass provides a callback whenever a touch is detected within its bounds.

## What This Isn't

A library. Read the code, pick out the parts that are relevant to you, rock on.

## The Juicy Bits

The "magic" happens in `rectForSubstring:startingFromPosition:inTextView:` in GIKViewController.m. 

`firstRectForRange:` is a method on the `UITextInput` protocol which `UITextView` adopts. The documentation states that this rect might be used to draw a correction rectangle. In our case, we'll use it to determine if a touch was detected within the bounds of the rect which encompasses our substring.

One caveat about `firstRectForRange:` - in the case where a substring spans multiple lines, the rect that is returned encloses only text on the first line. You can see examples of this in the demo app.

`firstRectForRange:` takes a `UITextRange` argument which is defined by two `UITextPosition` objects. Why `UITextRange` and not more familiar primitives such as `NSRange`? According to the documentation, "some documents contain nested elements (for example, HTML tags and embedded objects) and you need to track both absolute position and position in the visible text," and "the WebKit framework, which the [iOS] text system is based on, requires that text indexes and offsets be represented by objects."

Once we have the `CGRect` encompassing our text, we set the next startPosition as the ending `UITextPosition` of our `UITextRange` object.

## //TODO:

- find a way to make the rectangle span multiple lines where necessary.

## Contact

[Gordon Hughes](https://github.com/gik/)

[@gordonhughes](http://twitter.com/gordonhughes)
