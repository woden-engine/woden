clipping
containsBrush: aBrush
	aBrush positions do: [ :vert | (self containsPoint: vert) ifFalse: [^ false ] ].
	^ true