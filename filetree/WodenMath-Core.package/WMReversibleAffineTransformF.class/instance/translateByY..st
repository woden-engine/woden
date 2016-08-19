transformation building
translateByY: y
	<argument: #y type: #float>
	self translation: (WMVector3F x: translation x y: y + translation y z: translation z)