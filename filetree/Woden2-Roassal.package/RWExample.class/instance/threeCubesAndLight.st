as yet unclassified
threeCubesAndLight
	" 
	self new threeCubesAndLight
	"
	| v |
	v := RWView new.
	v add: (RWCube element).
	v add: (RWPointLight new color: WDColor red).
	v add: (RWCube element).
	v add: (RWCube element).
	RWXLineLayout on: v elements.
	v addInteraction: RWMouseKeyControl.
	^ v