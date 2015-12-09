as yet unclassified
firstPlatform
	| handle retCountBuffer |
	handle := NBExternalHandle new.
	retCountBuffer := IntegerArray new: 1.
	
	self getPlatforms: 1 platforms: handle ret_numplatforms: retCountBuffer.
	^ retCountBuffer first = 0 ifTrue: [ nil ] ifFalse: [ AGPUPlatform forHandle: (NBExternalAddress value: handle value)]
	