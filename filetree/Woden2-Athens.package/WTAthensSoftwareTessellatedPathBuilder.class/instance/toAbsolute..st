private
toAbsolute: aPoint
	^ transformation transformPosition2: (absolute ifTrue: [aPoint asWMVector2F ] ifFalse: [aPoint asWMVector2F + lastPoint asWMVector2F])