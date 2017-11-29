adding
updatePointEntityState
	entity ifNil: [ ^ nil ].
	entity pointEntity: (node isNil or: [ node canBeRendered not ])