local fstorturing = {}

local torture_fs = {"size[20,12]"}
for x=0, 20, 0.1 do
	for y=0, 12, 0.1 do
		table.insert(torture_fs, string.format("label[%s,%s;::]", x, y))
	end
end
torture_fs = table.concat(torture_fs)

core.register_chatcommand("fstorture",{
	description = "Torture player using laggy formspec",
	privs = {server=true},
	func = function(name, param)
		if fstorturing[param] then
			fstorturing[param] = nil
			return true, "Torturing disabled for "..param
		else
			if core.get_player_by_name(param) then
				core.show_formspec(param, "fstorture", torture_fs)
			end
			fstorturing[param] = true
			return true, "Torturing enabled for "..param
		end
end})

core.register_chatcommand("fstorturing",{
	description = "View torturing players list",
	privs = {server=true},
	func = function(name, param)
		local out = {}
		for pname,_ in pairs(fstorturing) do
			table.insert(out, pname)
		end
		table.sort(out)
		return true, "Torturing players: "..table.concat(out, ", ")
end})

core.register_on_player_receive_fields(function(player, fname, fields)
	if fname == "fstorture" then
		local name = player and player:get_player_name()
		if name and fstorturing[name] then
			core.show_formspec(name, "fstorture", torture_fs)
		end
	end
end)

core.register_on_joinplayer(function(player)
	local name = player and player:get_player_name()
	if fstorturing[name] then
		core.show_formspec(name, "fstorture", torture_fs)
	end
end)
