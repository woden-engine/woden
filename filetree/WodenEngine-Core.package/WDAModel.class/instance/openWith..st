opening
openWith: aView
	Smalltalk os isMacOSX ifTrue: [
		^ self openInMorphicWith: aView
	].
 
	^ self openInOSWindowWith: aView