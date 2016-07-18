rendering
modelForSubMode: submode
	| engine |
	engine := entity scene engine.
	engine ifNil: [ ^ self ].
	
	submode = #solid ifTrue: [ ^ self solidModelFor: engine ].
	submode = #wire ifTrue: [ ^ self wireModelFor: engine ].
	submode = #textured ifTrue: [ ^ self texturedModelFor: engine ].
	^ self solidModelFor: engine