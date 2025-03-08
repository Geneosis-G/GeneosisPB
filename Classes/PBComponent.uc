class PBComponent extends GGMutatorComponent;

var GGGoat gMe;
var GGMutator myMut;

var bool forwardPressed;
var bool backPressed;
var bool leftPressed;
var bool rightPressed;
var bool jumpPressed;

var StaticThruster	sThruster;
var orbitingBooster	orbBooster;

/**
 * See super.
 */
function AttachToPlayer( GGGoat goat, optional GGMutator owningMutator )
{
	super.AttachToPlayer(goat, owningMutator);

	if(mGoat != none)
	{
		gMe=goat;
		myMut=owningMutator;
	}
}

/**
 * See super.
 */
function OnChangeState( Actor actorInState, name newStateName )
{
	super.OnChangeState( actorInState, newStateName );

	if(gMe.mIsRagdoll && actorInState == gMe)
	{
		if(newStateName == 'AbilityHorn' || newStateName == 'AbilityKick')
		{
			Boost();
		}
	}
}

function KeyState( name newKey, EKeyState keyState, PlayerController PCOwner )
{
	local GGPlayerInputGame localInput;

	if(PCOwner != gMe.Controller)
		return;

	localInput = GGPlayerInputGame( PCOwner.PlayerInput );

	if( keyState == KS_Down )
	{
		if(localInput.IsKeyIsPressed("GBA_Forward", string( newKey )))
		{
			forwardPressed=true;
		}
		if(localInput.IsKeyIsPressed("GBA_Back", string( newKey )))
		{
			backPressed=true;
		}
		if(localInput.IsKeyIsPressed("GBA_Left", string( newKey )))
		{
			leftPressed=true;
		}
		if(localInput.IsKeyIsPressed("GBA_Right", string( newKey )))
		{
			rightPressed=true;
		}
		if(localInput.IsKeyIsPressed("GBA_Jump", string( newKey )))
		{
			jumpPressed=true;
		}
	}
	else if( keyState == KS_Up )
	{
		if(localInput.IsKeyIsPressed("GBA_Forward", string( newKey )))
		{
			forwardPressed=false;
		}
		if(localInput.IsKeyIsPressed("GBA_Back", string( newKey )))
		{
			backPressed=false;
		}
		if(localInput.IsKeyIsPressed("GBA_Left", string( newKey )))
		{
			leftPressed=false;
		}
		if(localInput.IsKeyIsPressed("GBA_Right", string( newKey )))
		{
			rightPressed=false;
		}
		if(localInput.IsKeyIsPressed("GBA_Jump", string( newKey )))
		{
			jumpPressed=false;
		}
	}
}

function Boost()
{
	orbBooster.Boost();
	sThruster.Boost();
}

function Tick( float delta )
{
	ManageBooster();
}

function ManageBooster()
{
	local vector desiredLocation, camLocation, socketLocation, desiredDirection2D, desiredBoostDirection;
	local rotator camRotation;
	local float radius, height,currentBaseY, currentStrafe;

	if(orbBooster == none)
	{
		orbBooster = gMe.Spawn( class'OrbitingBooster' );
	}

	if(sThruster == none)
	{
		sThruster = gMe.Spawn( class'StaticThruster' );
		sThruster.SetBase( gMe,, gMe.mesh, 'JetPackSocket' );
	}

	gMe.GetBoundingCylinder( radius, height );
	if(gMe.Controller != none)
	{
		GGPlayerControllerGame( gMe.Controller ).PlayerCamera.GetCameraViewPoint( camLocation, camRotation );
	}
	else
	{
		camLocation=gMe.Location;
		camRotation=gMe.Rotation;
	}
	gMe.mesh.GetSocketWorldLocationAndRotation( 'JetPackSocket', socketLocation );
	if(IsZero(socketLocation))
	{
		socketLocation=gMe.Location;
	}

	if(gMe.Controller != none)
	{
		if(GGLocalPlayer(PlayerController( gMe.Controller ).Player).mIsUsingGamePad)
		{
			currentBaseY=PlayerController( gMe.Controller ).PlayerInput.aBaseY;
			currentStrafe=PlayerController( gMe.Controller ).PlayerInput.aStrafe;
			//myMut.WorldInfo.Game.Broadcast(myMut, "currentBaseY=" $ currentBaseY);

			if(abs(currentBaseY) > 0.2f)
			{
				desiredDirection2D.X=currentBaseY;
			}
			if(abs(currentStrafe) > 0.2f)
			{
				desiredDirection2D.Y=currentStrafe;
			}
		}
		else
		{
			if(forwardPressed)
			{
				desiredDirection2D.X += 1.f;
			}
			if(backPressed)
			{
				desiredDirection2D.X += -1.f;
			}
			if(leftPressed)
			{
				desiredDirection2D.Y += -1.f;
			}
			if(rightPressed)
			{
				desiredDirection2D.Y += 1.f;
			}
		}
	}
	desiredDirection2D=Normal(desiredDirection2D);
	if(jumpPressed)
	{
		desiredDirection2D.Z = 1.f;
	}

	desiredBoostDirection = Vector(camRotation);
	if(desiredDirection2D != vect(0, 0, 0))
	{
		desiredBoostDirection.Z=0;
		desiredBoostDirection=desiredDirection2D >> Rotator(desiredBoostDirection);
	}
	desiredLocation=socketLocation + Normal(desiredBoostDirection)*-(orbBooster.boosterRadius+sqrt(radius*radius + height*height));

	orbBooster.SetRotation( Rotator(desiredBoostDirection) );
	orbBooster.SetLocation( desiredLocation );

	sThruster.SetRotation( Rotator(-Normal(desiredBoostDirection)) );
}

defaultproperties
{

}