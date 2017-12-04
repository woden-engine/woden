adding
ensureRenderingModels
	| nodes |
	nodes := components at: #renderingModels ifAbsentPut: [ OrderedCollection new ].
	nodes isEmpty ifTrue: [
		self addComponent: WTGSRenderingModels new.
	]