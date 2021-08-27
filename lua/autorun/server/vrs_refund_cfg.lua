do end



--[[

	@package	: Refund System
	@author		: Vectivus[http://steamcommunity.com/id/vectivuss]
	@contact	: vectivus099@gmail.com
	@license	: MIT

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.

]]


refund.cfg = {

	--[[
		Download :: WorkshopDL

		This will make players download the content from the workshop
		setting this to false will use fastdl instead
	]]

	Workshop = true,

	--[[
		RankBypass :: UserGroup

		Ranks that are in this table can spawn in any weapon or entity
		they're excluded from the BlackList and can spawn items reguardless
	]]

	RankBypass = {

		[ "superadmin" ] = true,

	},


	--[[
		Ranks :: UserGroup

		This will allow the Ranks to spawn in weapons and entities
		that are NOT in the BlackList table.
	]]


	Ranks = {

		[ "superadmin" ] = true,
		[ "admin" ] = true,

	},


	--[[
		SteamBypass :: UserGroup

		This is similar to RankBypass however you can whitelist
		certain steamid64s for spawning items and entites
	]]


	SteamBypass = {

		-- Use this format to add users, feel free to remove me
		[ "76561198371018204" ] = true,

	},


	--[[
		Blacklist :: ENTS

		This will prevent admins from spawning certain
		weapons and entities you forbid them from using
		Requires classname like example below
	]]

	BlackList = {

		[ "weapon_base" ] = true,
		[ "weapon_rpg" ] = true,

	}

}

-- CONFIG ENDS HERE --