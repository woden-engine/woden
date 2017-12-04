class initialization
initialize
	super initialize.
	
	JsonTypeMap := Dictionary new.
	self allSubclassesDo: [ :sc |
		sc jsonTypeName ifNotNil: [ JsonTypeMap at: sc jsonTypeName put: sc ]
	]