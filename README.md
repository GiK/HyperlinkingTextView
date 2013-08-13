# HyperlinkingTextView

Add hyperlink-like behaviour to substrings in a UITextView. 

![](http://d1zjcuqflbd5k.cloudfront.net/files/acc_92690/em4Q?response-content-disposition=inline;%20filename=iOS%20Simulator%20Screen%20shot%20Aug%2013%20%202013%20%2012.04.16%20PM.png;%20filename*=UTF-8%27%27iOS%20Simulator%20Screen%20shot%20Aug%2013%20%202013%20%2012.04.16%20PM.png&Expires=1376411727&Signature=HhjUbhcS6qgnWjfmKvRZ0mwWuMlrpzJ9-5B1qm4hoElqMvWjPoil8D0VTUFA63Mi-oa1IBt1txzp-p08NjBtwJdAkoPsvyt1RVOJpLjHBpJGv5JgrTufZST99K2QyT~5vf2wKA2VVRerae0ozYGAG4H7HfFF-Ma0PMdhIdyPfgs_&Key-Pair-Id=APKAJTEIOJM3LSMN33SA)

## What This Is

A simple implementation of hyperlinks in a UITextView using methods found in the UITextInput protocol. A UITextView subclass provides a callback whenever a touch is detected within its bounds.

## What This Isn't

A library. Grok the code, pick out the parts that are relevant to you, rock on.

## The Juicy Bits

The "magic" happens in `rectForSubstring:startingFromPosition:inTextView:` in GIKViewController.m. 

`firstRectForRange:` is a method on the `UITextInput` protocol which `UITextView` adopts. The documentation states that this rect might be used to draw a correction rectangle. In our case, we'll use it to determine if a touch was detected within the bounds of the rect which encompasses our substring.

One caveat about `firstRectForRange:` - in the case where a substring spans multiple lines, the rect that is returned encloses only text on the first line. You can see examples of this in the demo app.

`firstRectForRange:` takes a `UITextRange` argument which is defined by two `UITextPosition` objects. Why `UITextRange` and not more familiar primitives such as `NSRange`? According to the documentation:

> some documents contain nested elements (for example, HTML tags and embedded objects) and you need to track both absolute position and position in the visible text

and 

> the WebKit framework, which the [iOS] text system is based on, requires that text indexes and offsets be represented by objects

Once we have the `CGRect` encompassing our text, we set the next startPosition as the ending `UITextPosition` of our `UITextRange` object.

## Gestures

This latest commit replaces basic UIView touch handling in `GIKTextView` with gesture recognizers. This lets us respond differently to single and double taps, and long presses; the example provided shows the shared `UIMenuController` with options to copy or open the link's underlying URL.

## //TODO:

- find a way to make the rectangle span multiple lines where necessary.

## Contact

[Gordon Hughes](https://github.com/gik/)

[@gordonhughes](http://twitter.com/gordonhughes)
