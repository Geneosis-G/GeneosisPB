class PBMutator extends GGMutator;

var array< PBComponent > mComponents;

/**
 * See super.
 */
function ModifyPlayer(Pawn Other)
{
	local GGGoat goat;
	local PBComponent pbComp;

	super.ModifyPlayer( other );

	goat = GGGoat( other );
	if( goat != none )
	{
		pbComp=PBComponent(GGGameInfo( class'WorldInfo'.static.GetWorldInfo().Game ).FindMutatorComponent(class'PBComponent', goat.mCachedSlotNr));
		if(pbComp != none && mComponents.Find(pbComp) == INDEX_NONE)
		{
			mComponents.AddItem(pbComp);
		}
	}
}

simulated event Tick( float delta )
{
	local int i;

	for( i = 0; i < mComponents.Length; i++ )
	{
		mComponents[ i ].Tick( delta );
	}
	super.Tick( delta );
}

DefaultProperties
{
	mMutatorComponentClass=class'PBComponent'
}