accessing
boundsAtSign: sign
	<returnType: #(WMVector3D object)>
	sign = 0 ifTrue: [ ^ min ] ifFalse: [ ^ max ]