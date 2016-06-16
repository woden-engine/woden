accessing
defaultMaterial
	defaultMaterial ifNil: [ self createDefaultMaterial ].
	^ defaultMaterial