shapes
onePyramid
	" 
	self new onePyramid
	"
	| v |
	v := RWView new.
	v add: RWPyramid element.
	v  @ RWMouseKeyControl.
	v open