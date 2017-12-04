rendering
buildRigidBody: rigidBody
	| collisionShape localInertia motionState rigidBodyHandle |
	collisionShape := self validateCollisionShapeHandle: rigidBody shape.
	localInertia := collisionShape computeLocalInertia: rigidBody mass.
	motionState := handle createDefaultMotionState.
	rigidBodyHandle := handle createSimpleRigidBody: rigidBody mass motion_state: motionState collision_shape: collisionShape local_inertia: localInertia.
	
	rigidBody handle: { rigidBodyHandle . motionState }.