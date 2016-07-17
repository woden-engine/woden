rendering
modelForSubMode: submode
	| engine |
	engine := entity scene engine.
	engine ifNil: [ ^ self ].
	
	submode = #solid ifTrue: [ ^ self solidModelFor: engine ].
	submode = #wire ifTrue: [ ^ self wireModelFor: engine ].
	^ self solidModelFor: engine