as yet unclassified
validHandleOf: anObject
	^ anObject ifNil: [ NBExternalAddress null ] ifNotNil: [ anObject validHandle ]