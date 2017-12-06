actions
doUnhighlightElement: anElement
	(anElement attributes includesKey: #originalColor)
		ifFalse: [ ^ self ].
	anElement trachelShape color: (anElement attributes at: #originalColor).
	anElement attributes removeKey: #originalColor.
	"anElement view ifNotNil: [ anElement view signalUpdate ]."
	anElement signalUpdate.
	