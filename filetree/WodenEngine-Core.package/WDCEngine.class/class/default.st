accessing
default
	^ DefaultEngine ifNil: [ DefaultEngine := self new ]