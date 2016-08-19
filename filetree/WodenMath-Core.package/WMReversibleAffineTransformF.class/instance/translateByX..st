transformation building
translateByX: x
	<argument: #x type: #float>
	self translation: (WMVector3F x: x + translation x y: translation y z: translation z)