transformation building
translateByX: x y: y z: z
	<argument: #(x y z) type: #float>
	self translation: (WMVector3F x: x + translation x y: y + translation y z: z + translation z)