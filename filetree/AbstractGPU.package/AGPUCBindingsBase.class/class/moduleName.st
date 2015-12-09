library name
moduleName
	ModuleSession ~~ Smalltalk session ifTrue: [
		ModuleName := self findAgpu.
		ModuleSession := Smalltalk session
	].
	^ ModuleName