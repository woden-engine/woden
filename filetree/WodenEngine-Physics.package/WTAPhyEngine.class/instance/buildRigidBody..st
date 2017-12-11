rendering
buildRigidBody: rigidBody
	| collisionShape localInertia motionState rigidBodyHandle |
	collisionShape := self validateCollisionShapeHandle: rigidBody shape.
	localInertia := APHYVector3 new.
	collisionShape computeLocalInertiaInto: rigidBody mass result: localInertia.
	
	motionState := handle createDefaultMotionState.
	rigidBodyHandle := handle createSimpleRigidBodyFrom: rigidBody mass motion_state: motionState collision_shape: collisionShape local_inertia: localInertia.
	
	rigidBody handle: { rigidBodyHandle . motionState }.