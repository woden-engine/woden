Extension { #name : #LogicalFont }

{ #category : #'*Woden2-Athens' }
LogicalFont >> asLodenFontFor: anEngine [
	^ anEngine fontCache default normal pointSize: pointSize
]
