private
extractRoots
	roots := nodes select: [ :n | (self parentFor: n) isNil ]