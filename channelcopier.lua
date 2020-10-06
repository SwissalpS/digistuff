minetest.register_tool("digistuff:channelcopier",{
	description = "Digilines Channel Copier (sneak-click to copy, click to paste)",
	inventory_image = "digistuff_channelcopier.png",
	on_use = function(itemstack,player,pointed)
		if not (pointed and pointed.under) then return itemstack end
		if not (player and player:get_player_name()) then return end
		local pos = pointed.under
		local name = player:get_player_name()
		local node = minetest.get_node(pos)
		if not node then return itemstack end
		if minetest.registered_nodes[node.name]._digistuff_channelcopier_fieldname then
			if player:get_player_control().sneak then
				local channel = minetest.get_meta(pointed.under):get_string(minetest.registered_nodes[node.name]._digistuff_channelcopier_fieldname)
				if type(channel) == "string" and channel ~= "" then
					local stackmeta = itemstack:get_meta()
					stackmeta:set_string("channel",channel)
					stackmeta:set_string("description","Digilines Channel Copier, set to: "..channel)
					if player and player:get_player_name() then minetest.chat_send_player(player:get_player_name(),"Digilines channel copier set to "..minetest.colorize("#00FFFF",channel)..". Click another node to paste this channel there.") end
				end
			else
				if minetest.is_protected(pos,name) and not minetest.check_player_privs(name,{protection_bypass=true}) then
					minetest.record_protection_violation(pos,name)
					return itemstack
				end
				if minetest.registered_nodes[node.name]._digistuff_channelcopier_fieldname then
					local channel = itemstack:get_meta():get_string("channel")
					if type(channel) ~= "string" or channel == "" then
						minetest.chat_send_player(name,minetest.colorize("#FF5555","Error:").." No channel has been set yet. Sneak-click to copy one.")
						return itemstack
					end
					local oldchannel = minetest.get_meta(pos):get_string(minetest.registered_nodes[node.name]._digistuff_channelcopier_fieldname)
					minetest.get_meta(pos):set_string(minetest.registered_nodes[node.name]._digistuff_channelcopier_fieldname,channel)
					if type(oldchannel) == "string" and oldchannel ~= "" then
						if channel == oldchannel then
							minetest.chat_send_player(name,"Channel of target node is already "..minetest.colorize("#00FFFF",oldchannel)..".")
						else
							minetest.chat_send_player(name,string.format("Channel of target node changed from %s to %s.",minetest.colorize("#00FFFF",oldchannel),minetest.colorize("#00FFFF",channel)))
						end
					else
						minetest.chat_send_player(name,"Channel of target node set to "..minetest.colorize("#00FFFF",channel)..".")
					end
					if type(minetest.registered_nodes[node.name]._digistuff_channelcopier_onset) == "function" then
						minetest.registered_nodes[node.name]._digistuff_channelcopier_onset(pos,node,player,channel,oldchannel)
					end
				end
			end
		end
		return itemstack
	end,
})

minetest.register_craft({
	output = "digistuff:channelcopier",
	recipe = {
		{"mesecons_fpga:programmer"},
		{"digilines:wire_std_00000000"}
	}
})


--NOTE: Asking to have your own mod added to here is not the right way to add compatibility with the channel copier.
--Instead, include a _digistuff_channelcopier_fieldname field in your nodedef set to the name of the metadata field that contains the channel.
--If you need an action to occur after the channel is set, place a function in _digistuff_channelcopier_onset.
--Function signature is _digistuff_channelcopier_onset(pos,node,player,new_channel,old_channel)

-- SwissalpS disagrees with above statement. Compatibility should not be forced upon other mods. There is no reason not to just default to
-- "channel" no matter if the node actually is a digiline node.

local additionalnodes = {
	["digiline_global_memory:controller"] = "channel",
	["digiline_routing:filter"] = "channel",
	["digilines:chest"] = "channel",
	["digilines:lcd"] = "channel",
	["digilines:lightsensor"] = "channel",
	["digilines:rtc"] = "channel",
	["digiterms:beige_keyboard"] = "channel",
	["digiterms:black_keyboard"] = "channel",
	["digiterms:cathodic_beige_monitor"] = "channel",
	["digiterms:cathodic_black_monitor"] = "channel",
	["digiterms:cathodic_white_monitor"] = "channel",
	["digiterms:lcd_monitor"] = "channel",
	["digiterms:scifi_glassscreen"] = "channel",
	["digiterms:scifi_keysmonitor"] = "channel",
	["digiterms:scifi_tallscreen"] = "channel",
	["digiterms:scifi_widescreen"] = "channel",
	["digiterms:white_keyboard"] = "channel",
	["drawers:controller"] = "digilineChannel",
	["jumpdrive:engine"] = "channel",
	["jumpdrive:fleet_controller"] = "channel",
	["monitoring_digilines:metric_controller"] = "channel",
	["pipeworks:digiline_detector_tube_1"] = "channel",
	["pipeworks:digiline_detector_tube_2"] = "channel",
	["pipeworks:digiline_detector_tube_3"] = "channel",
	["pipeworks:digiline_detector_tube_4"] = "channel",
	["pipeworks:digiline_detector_tube_5"] = "channel",
	["pipeworks:digiline_detector_tube_6"] = "channel",
	["pipeworks:digiline_detector_tube_7"] = "channel",
	["pipeworks:digiline_detector_tube_8"] = "channel",
	["pipeworks:digiline_detector_tube_9"] = "channel",
	["pipeworks:digiline_detector_tube_10"] = "channel",
	["pipeworks:digiline_filter"] = "channel",
	["technic:forcefield_emitter_off"] = "channel",
	["technic:forcefield_emitter_on"] = "channel",
	["technic:hv_battery_box0"] = "channel",
	["technic:hv_battery_box1"] = "channel",
	["technic:hv_battery_box2"] = "channel",
	["technic:hv_battery_box3"] = "channel",
	["technic:hv_battery_box4"] = "channel",
	["technic:hv_battery_box5"] = "channel",
	["technic:hv_battery_box6"] = "channel",
	["technic:hv_battery_box7"] = "channel",
	["technic:hv_battery_box8"] = "channel",
	["technic:hv_nuclear_reactor_core"] = "remote_channel",
	["technic:hv_nuclear_reactor_core_active"] = "remote_channel",
	["technic:lv_battery_box0"] = "channel",
	["technic:lv_battery_box1"] = "channel",
	["technic:lv_battery_box2"] = "channel",
	["technic:lv_battery_box3"] = "channel",
	["technic:lv_battery_box4"] = "channel",
	["technic:lv_battery_box5"] = "channel",
	["technic:lv_battery_box6"] = "channel",
	["technic:lv_battery_box7"] = "channel",
	["technic:lv_battery_box8"] = "channel",
	["technic:mv_battery_box0"] = "channel",
	["technic:mv_battery_box1"] = "channel",
	["technic:mv_battery_box2"] = "channel",
	["technic:mv_battery_box3"] = "channel",
	["technic:mv_battery_box4"] = "channel",
	["technic:mv_battery_box5"] = "channel",
	["technic:mv_battery_box6"] = "channel",
	["technic:mv_battery_box7"] = "channel",
	["technic:mv_battery_box8"] = "channel",
	["technic:quarry"] = "channel",
	["textline:lcd"] = "channel",
}

for name,field in pairs(additionalnodes) do
	if minetest.registered_nodes[name] and not minetest.registered_nodes[name]._digistuff_channelcopier_fieldname then
		minetest.override_item(name,{_digistuff_channelcopier_fieldname = field})
	end
end


