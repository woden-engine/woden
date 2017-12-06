rendering process stages
updateCompositionState
	| extent |
	compositionStateBinding ifNil: [ self createCompositionStateBinding ].
	
	extent := view window drawingSurfaceExtent.
	compositionState screenExtents: (WMVector4F x: extent x asFloat y: extent y asFloat z: extent x reciprocalFloatQuiet w: extent y reciprocalFloatQuiet)