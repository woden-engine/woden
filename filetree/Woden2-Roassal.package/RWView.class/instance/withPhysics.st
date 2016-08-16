scene
withPhysics
"	dynamicsWorld := WDPhysicsEngine current createDynamicsWorld.
	dynamicsWorld gravity: (WDVector3 x: 0.0 y: -9.8 z: 0.0).
	scene attach: dynamicsWorld.
"