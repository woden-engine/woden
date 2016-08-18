initialization
initialize
	super initialize.
	scale := WMVector2D x: 1.0 y: 1.0.
	offset := WMVector2D new.
	rotation := 0.0.
	lock := false.