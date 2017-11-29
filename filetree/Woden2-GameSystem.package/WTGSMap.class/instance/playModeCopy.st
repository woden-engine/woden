as yet unclassified
playModeCopy
	| result copiedDictionary |
	result := self class new.
	copiedDictionary := Dictionary new.
	entities do: [ :ent | result addEntity: (ent playModeCopyWith: copiedDictionary) ].
	^ result