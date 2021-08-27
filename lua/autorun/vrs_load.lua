do end



if ( !SERVER ) then return end

refund = refund or {}
refund.cfg = refund.cfg or {}

local resource_AddWorkshop = resource.AddWorkshop
local resource_AddFile = resource.AddFile

function refund:Download( vfile )
    local files, dirs = file.Find( vfile .. "*", "THIRDPARTY" )

    for _, afile in ipairs( files ) do
        if ( string.match( afile, "." ) ) then
            print( "[    Vectivus Refunds - Initialize:    ] " .. afile )

            if ( refund.cfg.Workshop )then
                resource_AddWorkshop( "2584048701" )
            else
                resource_AddFile( vfile .. afile )
            end
        end
    end

	for _, dir in ipairs( dirs ) do
		refund:Download( vfile .. dir .. "/" )
	end
end 

refund:Download( "materials/vectivus/refund/ui/" )
refund:Download( "sound/vectivus/vgui/" )
refund:Download( "resource/fonts/bebasneue" )