shapes
oneCone
	" 
	self new oneCone
	"
	| v |
	v := RWView new.
	v add: RWCone element.
	v camera translateByZ: 3.0. 
	v  @ RWMouseKeyControl.
	v open