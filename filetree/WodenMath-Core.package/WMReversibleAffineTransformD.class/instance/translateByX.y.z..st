transformation building
translateByX: x y: y z: z
	<argument: #(x y z) type: #double>
	self translation: (WMVector3D x: x + translation x y: y + translation y z: z + translation z)