instance creation
identity
	<var: #identity type: #WMMatrix4F>
	<var: #identity3 type: #WMMatrix3F>
	| identity identity3 | 
	identity := WMMatrix4F identity.
	identity3 := WMMatrix3F identity.
	^ self new
		modelMatrix: identity;
		inverseModelMatrix: identity;
		normalMatrix: identity3;
		inverseNormalMatrix: identity3