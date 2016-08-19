transformation building
translateByX: x
	<argument: #x type: #double>
	self translation: (WMVector3D x: x + translation x y: translation y z: translation z)