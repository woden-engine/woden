as yet unclassified
bestModel
	entity scene ifNil: [
		self halt.
	].

	^ self texturedModelFor: entity scene engine