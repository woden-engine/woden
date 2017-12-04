accessing
dataSource: anObject
	dataSource := anObject.
	dataSource ifNotNil: [ dataSource applyOnSource: self ]