as yet unclassified
eventHandling
	"
	self new eventHandling
	"

	| v cube |
	v := RWView new.
	cube := RWCube element.
	v add: cube.

	cube when: RWMouseEnter do: [ :evt |
		evt element color: Color blue.
		evt signalUpdate.
	].

	cube when: RWMouseLeave do: [ :evt |
		evt element color: Color gray.
		evt signalUpdate.
	].

	cube when: RWMouseButtonDown do: [ :evt |
		evt element color: Color random.
		evt signalUpdate.
	].

	v addInteraction: OrbitController new.
	^ v