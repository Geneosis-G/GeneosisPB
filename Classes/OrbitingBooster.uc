class OrbitingBooster extends Actor;

var ParticleSystem mShockWaveParticleTemplate;
var SoundCue mForceSoundEffect;
var StaticMeshComponent boosterMesh;
var StaticMeshComponent auraMesh;
var float boosterRadius;

event PostBeginPlay()
{
	Super.PostBeginPlay();

	AttachComponent(boosterMesh);
	AttachComponent(auraMesh);
}

function Boost()
{
	PlaySound( mForceSoundEffect, true, true, , Location );
	WorldInfo.MyEmitterPool.SpawnEmitter( mShockWaveParticleTemplate, Location, Rotator(-Normal(Vector(Rotation))) );
}

DefaultProperties
{
	bNoDelete=false
	bStatic=false
	bIgnoreBaseRotation=true

	boosterRadius=50.f

	mShockWaveParticleTemplate=ParticleSystem'MMO_Effects.Effects.Effects_Xcalibur_01'
	mForceSoundEffect=SoundCue'MMO_SFX_SOUND.Cue.SFX_Excalibur_Explosion_Cue'

	Begin Object class=StaticMeshComponent Name=StaticMeshComp1
		StaticMesh=StaticMesh'MMO_Castle.Mesh.Crystal_01'
		Scale3D=(X=0.1, Y=0.1, Z=0.1)
		Rotation=(Pitch=16384, Yaw=0, Roll=0)
	End Object
	boosterMesh=StaticMeshComp1

	Begin Object class=StaticMeshComponent Name=StaticMeshComp2
		StaticMesh=StaticMesh'MMO_GravitationGoat.Mesh.GravitationSphere'
		Scale3D=(X=0.1, Y=0.1, Z=0.1)
		Rotation=(Pitch=-16384, Yaw=0, Roll=0)
	End Object
	auraMesh=StaticMeshComp2

	//StaticMesh'MMO_Props_02.Mesh.Fisheye_01'
}