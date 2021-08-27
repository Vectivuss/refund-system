do end



/* Fonts */
for i=16, 100 do surface.CreateFont( "ui1."..i, { font = "Arial", size = i } ) end
for i=16, 100 do surface.CreateFont( "ui2."..i, { font = "Bebas Neue", size = i } ) end
for i=16, 100 do surface.CreateFont( "ui3."..i, { font = "Roboto", size = i, weight = 100, antialias = true, shadow = true } ) end

/* ScrW ScrH /*
function ScrWH() return ScrW(), ScrH() end
scrwh=ScrWH Scrwh=ScrWH SCRWH=ScrWH

/* PlaySounds */
function qrex_PlaySound( s )
	surface.PlaySound( "vectivus/vgui/" .. s )
end

/* Instance */
function util.instance( f )
	if !f or TypeID(f) != TYPE_FUNCTION then return end
	timer.Simple( 0, f )
end
instance = util.instance
