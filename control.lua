--control.lua
script.on_event(defines.events.on_built_entity, function(e)
   on_drop_car(e)
end)

script.on_event(defines.events.on_player_driving_changed_state, function(x)
   on_exit_car(x)
end)

function on_drop_car(e)
   if e.created_entity.name == "car" then
      local player = game.players[e.player_index]
      --put the player in the car
      e.created_entity.set_driver(player)

      --Grab fuel from the player inventory and insert it into the car
      if player.get_item_count("nuclear-fuel") > 0 then
         if player.get_item_count("nuclear-fuel")>= 50 then
            e.created_entity.insert{name="nuclear-fuel", count = 50}
            player.remove_item{name = "nuclear-fuel", count = 50}
         else
            e.created_entity.insert{name="nuclear-fuel", count = player.get_item_count("nuclear-fuel")}
            player.remove_item{name = "nuclear-fuel", count = player.get_item_count("nuclear-fuel")}
         end
      elseif player.get_item_count("rocket-fuel") > 0 then
         if player.get_item_count("rocket-fuel")>= 50 then
            e.created_entity.insert{name="rocket-fuel", count = 50}
            player.remove_item{name = "rocket-fuel", count = 50}
         else
            e.created_entity.insert{name="rocket-fuel", count = player.get_item_count("rocket-fuel")}
            player.remove_item{name = "rocket-fuel", count = player.get_item_count("rocket-fuel")}
         end
      elseif player.get_item_count("solid-fuel") > 0 then
         if player.get_item_count("solid-fuel")>= 50 then
            e.created_entity.insert{name="solid-fuel", count = 50}
            player.remove_item{name = "solid-fuel", count = 50}
         else
            e.created_entity.insert{name="solid-fuel", count = player.get_item_count("solid-fuel")}
            player.remove_item{name = "solid-fuel", count = player.get_item_count("solid-fuel")}
         end
      elseif player.get_item_count("coal") > 0 then
         if player.get_item_count("coal")>= 50 then
            e.created_entity.insert{name="coal", count = 50}
            player.remove_item{name = "coal", count = 50}
         else
            e.created_entity.insert{name="coal", count = player.get_item_count("coal")}
            player.remove_item{name = "coal", count = player.get_item_count("coal")}
         end
      elseif player.get_item_count("wood") > 0 then
         if player.get_item_count("wood")>= 50 then
            e.created_entity.insert{name="wood", count = 50}
            player.remove_item{name = "wood", count = 50}
         else
            e.created_entity.insert{name="wood", count = player.get_item_count("wood")}
            player.remove_item{name = "wood", count = player.get_item_count("wood")}
         end
      else
         game.print("No fuel in player inventory")
      end
   end
end

function on_exit_car(x)
   if x.entity.get_driver() == nil and x.entity.get_passenger() == nil and x.entity.name == "car" then
      local player = game.players[x.player_index]
      --give the player a replacement car
      player.insert{name="car", count = 1}

      --Get all the stuff out of the car
      local storageDic = x.entity.get_inventory(defines.inventory.car_trunk).get_contents()
      local ammoDic = x.entity.get_inventory(defines.inventory.car_trunk).get_contents()
      local fuelDic = x.entity.get_fuel_inventory().get_contents()

      for key,val in pairs(fuelDic) do
         player.insert{name = key, count = fuelDic[key]}
      end

      for key,val in pairs(storageDic) do
         player.insert{name = key, count = storageDic[key]}
      end

      for key,val in pairs(ammoDic) do
         player.insert{name = key, count = ammoDic[key]}
      end

      --destroy the car and everything in it
      x.entity.destroy()
   end
end