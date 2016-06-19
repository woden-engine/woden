accessing
colorRamp: aRamp
	colorRamp removeAll.
	aRamp do: [ :assoc |
		colorRamp add: (WTColorRampEntry new
			edge: assoc key asFloat;
			color: assoc value asWMVector4F;
			yourself)
	]