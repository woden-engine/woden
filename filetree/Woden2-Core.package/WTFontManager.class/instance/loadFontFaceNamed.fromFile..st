as yet unclassified
loadFontFaceNamed: faceName fromFile: fileReference
	| extension |
	extension := fileReference extension.
	extension = 'lodenfnt' ifTrue: [ 
		^ self loadLodenFontFaceNamed: faceName fromFile: fileReference
	].

	"Transcript show: faceName , ' -> ' , fileReference printString; cr;
		show: extension; cr."
	^ nil.