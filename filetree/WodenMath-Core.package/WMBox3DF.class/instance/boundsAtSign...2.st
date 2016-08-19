accessing
boundsAtSign: sign
	<returnType: #(WMVector3F object)>
	sign = 0 ifTrue: [ ^ min ] ifFalse: [ ^ max ]