accessing
optionalAttributes
	^ super optionalAttributes ==> [ :attr | attr ifNil: [ #() ] ]