transformation building
translateByY: y
	<argument: #y type: #double>
	self translation: (WMVector3D x: translation x y: y + translation y z: translation z)