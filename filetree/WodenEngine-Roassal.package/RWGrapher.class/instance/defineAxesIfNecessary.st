as yet unclassified
defineAxesIfNecessary
	
	self isXAxisDefined ifFalse: [ self axisX ].
	self isYAxisDefined ifFalse: [ self axisY ].
	self isZAxisDefined ifFalse: [ self axisZ ].	