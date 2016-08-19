transformation building
translateBy: vector3
	<argument: #vector3 type: #(WMVector3D object)>
	self translation: (WMVector3D x: translation x + vector3 x y: translation y + vector3 y z: translation z + vector3 z)