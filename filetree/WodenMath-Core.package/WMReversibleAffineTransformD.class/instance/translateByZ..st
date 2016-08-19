transformation building
translateByZ: z
	<argument: #z type: #double>
	self translation: (WMVector3D x: translation x y: translation y z: z + translation z)