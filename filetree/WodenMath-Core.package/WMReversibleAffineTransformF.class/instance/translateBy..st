transformation building
translateBy: vector3
	<argument: #vector3 type: #(WMVector3F object)>
	self translation: (WMVector3F x: translation x + vector3 x y: translation y + vector3 y z: translation z + vector3 z)