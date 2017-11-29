accessing
maxY
	^ self hasDataSet 
		ifTrue: [ maxY max: self maxYFromDataSets ]
		ifFalse: [ maxY ] 