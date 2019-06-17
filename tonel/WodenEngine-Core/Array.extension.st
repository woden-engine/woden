Extension { #name : #Array }

{ #category : #'*WodenEngine-Core' }
Array >> closureDescriptionForCaching [
	^ ByteString streamContents: [ :out |
		out << ${.
		self doWithIndex: [ :element :index |
			index > 1 ifTrue: [ 
				out nextPut: $|
			].
			out nextPutAll: element closureDescriptionForCaching
		].
		out << $}.
	]
]
