transformation building
translateByZ: z
	<argument: #z type: #float>
	self translation: (WMVector3F x: translation x y: translation y z: z + translation z)