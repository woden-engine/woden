as yet unclassified
initialize
	super initialize.
	
	ScriptCodeEnvironment := SystemDictionary new.
	#(
		Vector2 WMVector2D
		Vector3 WMVector3D
		Vector4 WMVector4D
		Complex WMComplexD
		Quaternion WMQuaternionD

		Color Color
		ReversibleAffineTransform WMReversibleAffineTransformD
	) pairsDo: [ :k :v |
		ScriptCodeEnvironment at: k put: (Smalltalk at: v)
	]
	