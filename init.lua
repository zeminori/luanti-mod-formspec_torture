fstorturing_interval = 0.1

fstorturing = {}

local lagfs = {"size[20,12]"}
for x=0, 20, 0.1 do
	for y=0, 12, 0.1 do
		table.insert(lagfs, string.format("label[%s,%s;::]", x, y))
	end
end
lagfs = table.concat(lagfs)

local flashfs = "size[160,90]background[0,0;160,90;\\[fill:160x90:#FFF]"

core.register_chatcommand("lagfst",{
	description = "Torture player using laggy formspec",
	privs = {server=true},
	func = function(name, param)
		if not param or param == "" then return false, "Missing param" end
		if fstorturing[param] then
			fstorturing[param] = nil
			return true, "Torturing disabled for "..param
		else
			if core.get_player_by_name(param) then
				core.show_formspec(param, "fstorture", lagfs)
			end
			fstorturing[param] = "lagfs"
			return true, "Torturing enabled for "..param
		end
end})

core.register_chatcommand("flashfst",{
	description = "Torture player using flashy formspec",
	privs = {server=true},
	func = function(name, param)
		if not param or param == "" then return false, "Missing param" end
		if fstorturing[param] then
			fstorturing[param] = nil
			return true, "Torturing disabled for "..param
		else
			if core.get_player_by_name(param) then
				core.show_formspec(param, "fstorture", flashfs)
			end
			fstorturing[param] = "flashfs"
			return true, "Torturing enabled for "..param
		end
end})

local timer = 0
local opened
core.register_globalstep(function(dtime)
	timer = timer + dtime
	if timer >= fstorturing_interval then
		for pname, ttype in pairs(fstorturing) do
			if ttype == "flashfs" and core.get_player_by_name(pname) then
				if opened then
					core.close_formspec(pname, "fstorturing")
					opened = nil
				else
					core.show_formspec(pname, "fstorturing", flashfs)
					opened = true
				end
			end
		end
		timer = 0
	end
end)

core.register_chatcommand("fstorturing",{
	description = "View torturing players list",
	privs = {server=true},
	func = function(name, param)
		local out = {}
		for pname, ttype in pairs(fstorturing) do
			table.insert(out, string.format("%s(%s)", pname, ttype))
		end
		table.sort(out)
		return true, "Torturing players: "..table.concat(out, ", ")
end})

core.register_on_player_receive_fields(function(player, fname, fields)
	if fname == "fstorture" then
		local name = player and player:get_player_name()
		if name and fstorturing[name] == "lagfs" then
			core.show_formspec(name, "fstorture", lagfs)
		end
	end
end)

core.register_on_joinplayer(function(player)
	local name = player and player:get_player_name()
	if fstorturing[name] == "lagfs" then
		core.show_formspec(name, "fstorture", lagfs)
	end
end)
