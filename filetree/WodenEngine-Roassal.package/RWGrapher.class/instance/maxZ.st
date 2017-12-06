accessing
maxZ
	^ self hasDataSet 
		ifTrue: [ maxZ max: self maxYFromDataSets ]
		ifFalse: [ maxZ ] 