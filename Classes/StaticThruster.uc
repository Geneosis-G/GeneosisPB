class StaticThruster extends RB_Thruster;

function Boost()
{
	bThrustEnabled = true;
	SetTimer( 0.1f,false,NameOF(StopRecoil));
}

function StopRecoil()
{
	bThrustEnabled = false;
}

DefaultProperties
{
	bNoDelete=false
	bStatic=false
	bIgnoreBaseRotation=true
	
	ThrustStrength=32000.0f
}