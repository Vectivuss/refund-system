do end



concommand.Add( "p.refund.menu", function( p )

	local p, w, h = LocalPlayer(), ScrW(), ScrH()
	local selectedPlayer = nil
	local refund = true

	if ( IsValid( frame ) ) then return end

	local function isClosing( s )
		if s.CLOSING then return end
		s.CLOSING = true
		timer.Simple( 2, function() if IsValid( s ) then s:Remove() end end )
		s:SizeTo( 0, 0, 0, 0, .1, function() s:Remove() end )
		s:SetMouseInputEnabled( false )
		s:SetKeyboardInputEnabled( false )
	end

	local frame = vgui.Create( "DFrame" )
	frame:Center()
	frame:MakePopup()
	frame:SetTitle( "" )
	frame:SizeTo( w*.52, h*.5, 0, 0, .1, function()
		refund = false
	end )
	frame.Close = function( s ) isClosing( s ) end
	frame.Think = function( s ) s:Center() if input.IsKeyDown( KEY_TAB ) then s:Close() end
	end
	frame.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 46, 46, 46, 250 ) )
		draw.RoundedBox( 0, 0, 0, w, h*.12, Color( 34, 34, 34, 128 ) )
		draw.RoundedBox( 0, 0, h*.13, w, h*.08, Color( 26, 26, 26, 155 ) )
		draw.RoundedBox( 0, 0, h*.22, w, h, Color( 34, 34, 34, 155 ) )
		surface.SetDrawColor( 67, 67, 67, 240 )
		surface.DrawOutlinedRect( 0, 0, w, h, 3 )
		draw.SimpleText( "Refund Player", "ui2.40", w*.02, h*.023, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

		// progress bar
		local x, y = w*.7, h*.145
		local wide, tall = w*.285, h*.05
		local f = #player.GetAll() / game.MaxPlayers()

		draw.RoundedBox( 0, x, y, wide, tall, Color( 26, 26, 26, 155 ) )
		draw.RoundedBox( 0 , x, y, wide*f, tall, Color( 87, 39, 210, 200 ) )
		surface.SetDrawColor( 87, 39, 210, 200 )
		surface.DrawOutlinedRect( x, y, wide, tall, 1 )
		draw.SimpleText( #player.GetAll() .. " of " .. game.MaxPlayers(), "ui1.21", w*.842, h*.165, Color( 200, 200, 200, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		// progress bar
	end

	local filter = ""
	local populate

	local close = vgui.Create( "DButton", frame )
	close:SetPos( w*.48, h*.006 )
	close:SetSize( w*.04, h*.05 )
	close:SetText( "" )
	close.Paint = function( self, w, h )
		if ( self:IsHovered() ) then
			surface.SetDrawColor( 218, 70, 70 )
		else
			surface.SetDrawColor( 255, 255, 255 )
		end
		surface.SetMaterial( Material( "vectivus/refund/ui/close.png", "noclamp smooth" ) )
		surface.DrawTexturedRectRotated( w/2, h/2, h*.65, h*.65, 0 )
	end
	close.DoClick = function()
		qrex_PlaySound( "click.wav" )
		frame:Close()
	end
	frame:ShowCloseButton( false )

	local refresh = vgui.Create( "DButton", frame )
	refresh:SetPos( w*.452, h*.006 )
	refresh:SetSize( w*.04, h*.05 )
	refresh:SetText( "" )
	refresh.Paint = function( self, w, h )
		if ( self:IsHovered() ) then
			surface.SetDrawColor( 218, 70, 70 )
		else
			surface.SetDrawColor( 255, 255, 255 )
		end
		surface.SetMaterial( Material( "vectivus/refund/ui/refresh.png", "noclamp smooth" ) )
		surface.DrawTexturedRectRotated( w/2, h/2, h*.58, h*.58, 0 )
	end
	refresh.DoClick = function()
		surface.PlaySound( "buttons/button14.wav" )
		timer.Create( "refund.populate", .5, 1, populate )
	end

	local search = vgui.Create( "DTextEntry", frame )
	search:SetPos( w*.008, h*.073 )
	search:SetSize( w*.35, h*.025 )
	search:SetFont( "ui1.21" )
	search.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 38, 38, 38, 160 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 26, 26, 26, 155 ) )
		end
		surface.SetDrawColor( 87, 39, 210, 200 )
		surface.DrawOutlinedRect( 0, 0, w, h, 1 )
		self:DrawTextEntryText( color_white, Color( 20, 100, 210 ), Color( 100, 100, 100 ) )
		if ( self:GetText() == "" and !self:HasFocus() ) then
			draw.SimpleText( "Search", "ui1.21", w*.02, h*0.45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end
	search.OnChange = function( s )
		filter = s:GetValue()
		timer.Create( "refund.populate", .5, 1, populate )
	end

	local playerPanel = vgui.Create( "DPanel", frame )
	playerPanel:SetPos( w*.01, h*.126 )
	playerPanel:SetSize( w*.335, h*.358 )
	playerPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 34, 34, 34, 195 ) )
	end

	local infoPanel = vgui.Create( "DPanel", frame )
	infoPanel:SetPos( w*.35, h*.126 )
	infoPanel:SetSize( w*.16, h*.358 )
	infoPanel.Paint = function( self, w, h )
		draw.RoundedBox( 0, 0, 0, w, h, Color( 34, 34, 34, 195 ) )
		if ( selectedPlayer ) then
			draw.DrawText( "Name: " .. selectedPlayer:Nick() .. "\n\n" .. "SteamID: " .. selectedPlayer:SteamID() .. "\n\n" .. "Rank: " .. selectedPlayer:GetUserGroup(), "ui1.21", w*.05, h*.46, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
		else
			draw.SimpleText( "NO PLAYER SELECTED", "ui2.45", w*.5, h*.47, Color( 200, 200, 200 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
		end
	end

	local activeUser = vgui.Create( "AvatarImage", infoPanel )
	activeUser:SetSize( h*.14, h*.14 )
	activeUser:SetPos( w*.008, h*.015 )
	activeUser:SetVisible( false )
	draw.SimpleText( selectedPlayer, "ui1.21", w*.05, h*.4, Color( 200, 200, 200 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )

	local item = vgui.Create( "DTextEntry", infoPanel )
	item:SetPos( w*.005, h*.283 )
	item:SetSize( w*.15, h*.028 )
	item:SetVisible( false )
	item:SetFont( "ui1.21" )
	item.Paint = function( self, w, h )
		if self:IsHovered() then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 38, 38, 38, 160 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 26, 26, 26, 155 ) )
		end
		surface.SetDrawColor( 87, 39, 210, 200 )
		surface.DrawOutlinedRect( 0, 0, w, h, 1 )
		self:DrawTextEntryText( color_white, Color( 20, 100, 210 ), Color( 100, 100, 100 ) )
		if ( self:GetText() == "" and !self:HasFocus() ) then
			draw.SimpleText( "Give item", "ui1.21", w*.02, h*0.45, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER )
		end
	end

	local enter = vgui.Create( "DButton", infoPanel )
	enter:SetPos( w*.005, h*.32 )
	enter:SetSize( w*.15, h*.032 )
	enter:SetText( "Spawn" )
	enter:SetFont( "ui3.25" )
	enter:SetVisible( false )
	enter:SetTextColor( color_white )
	enter.Paint = function( self, w, h )
		if ( self:IsHovered() ) then
			draw.RoundedBox( 0, 0, 0, w, h, Color( 100, 59, 230, 225 ) )
		else
			draw.RoundedBox( 0, 0, 0, w, h, Color( 87, 39, 210, 200 ) )
		end
		surface.SetDrawColor( 33, 33, 33, 255 )
		surface.DrawOutlinedRect( 0, 0, w, h, 2 )
	end
	enter.DoClick = function()
		surface.PlaySound( "buttons/button14.wav" )

		net.Start( "p.refund" )
			net.WriteEntity( selectedPlayer )
			net.WriteString( item:GetValue() )
		net.SendToServer()
	end

	local scroll = vgui.Create( "DScrollPanel", playerPanel )
	scroll:Dock( FILL )
	local sbar = scroll:GetVBar()
	sbar.Paint = function( _, w, h )
		draw.RoundedBox( 8, 0, 0, w, h, Color( 27, 27, 27, 200 ) )
	end
	sbar.btnUp.Paint = function( _, w, h )
		draw.RoundedBox( 8, 2, 0, w - 4, h - 2, Color( 27, 27, 27, 200 ) )
	end
	sbar.btnDown.Paint = function( _, w, h )
		draw.RoundedBox( 8, 2, 2, w - 4, h - 2, Color( 27, 27, 27, 200 ) )
	end
	sbar.btnGrip.Paint = function( self, w, h )
		draw.RoundedBox( 8, 2, 0, w - 4, h, Color( 87, 39, 210, 200 ) )
		if ( self:IsHovered() ) then
			draw.RoundedBox( 8, 2, 0, w - 4, h, Color( 100, 59, 230, 225 ) )
		end
	end

	populate = function()
		if ( !IsValid( scroll ) ) then return end
		scroll:Clear()

		for k, v in SortedPairs( player.GetAll(), true ) do

			local name = v:Nick()

			if ( !string.find( string.lower( name ), string.lower ( filter ) ) ) then continue end

			local players = vgui.Create( "DPanel", scroll )
			players:Dock( TOP )
			players:DockMargin( 12, 12, 12, 12 )
			players:SetTall( h*.08 )
			players.Paint = function( self, w, h )
				draw.RoundedBox( 0, 0, 0, w, h, Color( 16, 15, 17, 128 ) )
				surface.SetDrawColor( 80, 80, 80, 155 )
				surface.DrawOutlinedRect( 0, 0, w, h, 2 )
				draw.SimpleText( name, "ui3.20", w*.2, h*.148, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
				draw.SimpleText( v:SteamID(), "ui3.20", w*.2, h*.55, Color( 200, 200, 200, 255 ), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP )
			end
			players.OnMousePressed = function( self, k )
				if k != MOUSE_LEFT then return end
				qrex_PlaySound( "click.wav" )
				selectedPlayer = v
				activeUser:SetVisible( true )
				item:SetVisible( true )
				enter:SetVisible( true )
				activeUser:SetPlayer( selectedPlayer, 128 )
			end

			local playerProfile = vgui.Create( "AvatarImage", players )
			playerProfile:Dock( LEFT )
			playerProfile:DockMargin( 8, 8, 8, 8 )
			playerProfile:SetWide( h*.08 )
			playerProfile:SetTall( h*.08 )
			playerProfile:SetPlayer( v, 128 )

			local playersInfo = vgui.Create( "DButton", players )
			playersInfo:Dock( RIGHT )
			playersInfo:DockMargin( 12, 12, 15, 12 )
			playersInfo:SetWide( w*.06 )
			playersInfo:SetText( "Select User" )
			playersInfo:SetFont( "ui3.20" )
			playersInfo:SetTextColor( color_white )
			playersInfo.Paint = function( self, w, h )
				if ( self:IsHovered() ) then
					draw.RoundedBox( 0, 0, 0, w, h, Color( 40, 40, 40, 200 ) )
				else
					draw.RoundedBox( 0, 0, 0, w, h, Color( 33, 33, 33, 200 ) )
				end
				surface.SetDrawColor( 66, 66, 66, 155 )
				surface.DrawOutlinedRect( 0, 0, w, h, 2 )
			end
			playersInfo.DoClick = function()
				qrex_PlaySound( "click.wav" )
				selectedPlayer = v
				activeUser:SetVisible( true )
				item:SetVisible( true )
				enter:SetVisible( true )
				activeUser:SetPlayer( selectedPlayer, 128 )
			end
		end
	end

	util.instance( populate() )

end )
