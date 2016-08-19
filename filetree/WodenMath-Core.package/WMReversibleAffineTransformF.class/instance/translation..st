accessing
translation: vector3
	<argument: #vector3 type: #(WMVector3F object)>
	translation x: vector3 x.
	translation y: vector3 y.
	translation z: vector3 z.
	inverseTranslation := inverseMatrix transformVector4: translation negatedVec3.
	