accessing
dataSource: newDataSource
	newDataSource == dataSource ifTrue: [ ^ self ].
	dataSource := newDataSource.
	self hasValidHandle ifTrue: [
		handle dataSource: dataSource validHandle
	]