accessing
to: anElement
	[ anElement class == RWElement ] assert.
	to := anElement.
	anElement addConnectedEdge: self