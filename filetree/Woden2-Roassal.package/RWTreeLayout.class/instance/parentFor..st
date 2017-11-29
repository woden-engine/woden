private
parentFor: anElement
	^ parents at: anElement ifAbsent: [ ^ nil ]