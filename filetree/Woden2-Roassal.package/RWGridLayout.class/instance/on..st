public
on: elements
	| u v w h  areaVector maxLineItems lineItemCount maxLastLineHeight currentPosition |
	u := self xdirection.
	v := self ydirection.
	areaVector := u + v.
	elements ifEmpty: [ ^ self ].
	elements sort: [ :a :b |
		(a extent dot: areaVector) < (b extent dot: areaVector).
	].
	maxLineItems := elements size sqrt ceiling.

	lineItemCount := 0.
	maxLastLineHeight := 0.0.
	
	currentPosition := WDVector3 zero.
	elements do: [ :el |
		w := u dot: el extent.
		h := v dot: el extent.
		
		el translateTo: currentPosition.
		currentPosition := currentPosition + (u * (w + gap)).
		lineItemCount := lineItemCount + 1.
		maxLastLineHeight := maxLastLineHeight max: h.

		(lineItemCount >= maxLineItems) ifTrue: [
			currentPosition := v * ((v dot: currentPosition) + maxLastLineHeight + gap).
			maxLastLineHeight := 0.0.
			lineItemCount := 0.
		]
	].

	self centerElements: elements