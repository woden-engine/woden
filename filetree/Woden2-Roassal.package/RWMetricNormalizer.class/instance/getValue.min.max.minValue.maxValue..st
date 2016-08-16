utility
getValue: t min: min max: max minValue: minValue maxValue: maxValue
	maxValue = minValue ifTrue: [ ^ min ].
	^ min + ((max - min) * ( (t - minValue) / (maxValue - minValue)))