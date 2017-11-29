public
initialize
	super initialize.
	children := IdentityDictionary new.
	parents := IdentityDictionary new.
	subtreeBounds := IdentityDictionary new.
	gap := self class defaultGap 