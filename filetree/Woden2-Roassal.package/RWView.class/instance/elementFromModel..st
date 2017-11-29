accessing
elementFromModel: aModel
	^ elements detect: [ :el | el model == aModel ] ifNone: [ nil ]