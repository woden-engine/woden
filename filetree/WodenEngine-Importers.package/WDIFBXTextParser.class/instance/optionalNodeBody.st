accessing
optionalNodeBody
	^ super optionalNodeBody ==> [ :tokens |
		tokens ifNil: [ #() ] ifNotNil: [ tokens second ]
	]