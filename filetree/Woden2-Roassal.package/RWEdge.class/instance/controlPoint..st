accessing
controlPoint: at
	controlPoints ifNil: [ self error: 'Not a bezier edge' ].
	^ controlPoints at: at