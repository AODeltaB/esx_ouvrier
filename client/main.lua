ESX                             = nil
local PlayerData                = {}
local GUI                       = {}
GUI.Time                        = 0
local HasAlreadyEnteredMarker   = false
local LastZone                  = nil
local CurrentAction             = nil
local CurrentActionMsg          = ''
local CurrentActionData         = {}
local OnJob                     = false
local TargetCoords              = nil
local JobBlips                = {}
local publicBlip = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function OpenOuvrierVehicleMenu()

	local elements = {
		{label = 'Véhicule de fonction', value = 'TipTruck'}				
	}



		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'spawn_vehicle',
			{
				title    = 'Choisis ton véhicule',
				elements = elements
			},
			function(data, menu)
				for i=1, #elements, 1 do							
					if Config.MaxInService == -1 then
						local playerPed = GetPlayerPed(-1)
						local coords    = Config.Zones.VehicleSpawnPoint.Pos
							if data.current.value == "TipTruck" then
								ESX.Game.SpawnVehicle(data.current.value, coords, 270.0, function(vehicle)
								TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
								plate = GetVehicleNumberPlateText(vehicle)
								plate = string.gsub(plate, " ", "")
								TriggerEvent('esx_vehiclemenu:updatePlayerCars', "add", plate)
            					end)
        					end
					break
					else
						ESX.TriggerServerCallback('esx_service:enableService', function(canTakeService, maxInService, inServiceCount)
							if canTakeService then
								local playerPed = GetPlayerPed(-1)
								local coords    = Config.Zones.VehicleSpawnPoint.Pos
								ESX.Game.SpawnVehicle(data.current.value, coords, 270.0, function(vehicle)
									if data.current.trailer ~= "none" then
          									ESX.Game.SpawnVehicle(data.current.rem, coords, 90.0, function(trailer)
	   									end)
   									end
									TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
								end)
							else
								ESX.ShowNotification('Service complet : ' .. inServiceCount .. '/' .. maxInService)
							end
						end, 'Ouvrier')
						break
					end
				end						
				menu.close()		

		end,
	function(data, menu)
		menu.close()
		CurrentAction     = 'spawn_vehicle_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au Garage.'
		CurrentActionData = {}
	end
	)
end

function OpenOuvrierCloakroomtMenu()

	local elements = {
		{label = 'Tenue de travail', value = 'cloakroom'},
		{label = 'Tenue civile', value = 'cloakroom2'}
	}

	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'Ouvrier_cloakroom',
		{
			title    = 'Etabli',
			elements = elements
		},
		function(data, menu)

			if data.current.value == 'cloakroom' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

   				if skin.sex == 0 then
       				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_male)
   				else
       				TriggerEvent('skinchanger:loadClothes', skin, jobSkin.skin_female)
   				end
    
			end)
		end

		if data.current.value == 'cloakroom2' then
			menu.close()
			ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
   				TriggerEvent('skinchanger:loadSkin', skin)
   
			end)
		end

		end,
	function(data, menu)
		menu.close()
		CurrentAction     = 'Ouvrier_cloakroom_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au véstiaire.'
		CurrentActionData = {}
	end
	)
end



RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
	blips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
	deleteBlips()
	blips()
end)

AddEventHandler('esx_ouvrier:hasEnteredMarker', function(zone)

	if zone == 'Cloakroom' then
		CurrentAction     = 'Ouvrier_cloakroom_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au véstiaire.'
		CurrentActionData = {}
	end
	if zone == 'harvest_scraps' then
		CurrentAction     = 'harvest_scraps'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour récupérer des férailles.'
		CurrentActionData = {}
	end
	if zone == 'harvest_palette' then
		CurrentAction     = 'harvest_palette'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour récupérer des palettes.'
		CurrentActionData = {}
	end
	if zone == 'harvest_ciment' then
		CurrentAction     = 'harvest_ciment'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour récupérer du ciments.'
		CurrentActionData = {}
	end
	if zone == 'sell_scraps' then
		CurrentAction     = 'resell_scraps'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vendre de la férailles.'
		CurrentActionData = {}
	end
	if zone == 'sell_palette' then
		CurrentAction     = 'resell_palette'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vendre des palettes.'
		CurrentActionData = {}
	end
	if zone == 'sell_ciment' then
		CurrentAction     = 'resell_ciment'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour vendre du ciments.'
		CurrentActionData = {}
	end
	if zone == 'VehicleSpawner' then
		CurrentAction     = 'spawn_vehicle_menu'
		CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour accéder au garage.'
		CurrentActionData = {}
	end
	if zone == 'VehicleDeleter' then
		local playerPed = GetPlayerPed(-1)
		if IsPedInAnyVehicle(playerPed,  false) then
			CurrentAction     = 'delete_vehicle'
			CurrentActionMsg  = 'Appuyez sur ~INPUT_CONTEXT~ pour ranger le véhicule.'
			CurrentActionData = {}
		end
	end
end)

AddEventHandler('esx_ouvrier:hasExitedMarker', function(zone)

	if zone == 'harvest_scraps' then
		TriggerServerEvent('esx_ouvrier:stopHarvestScraps')
	end
	if zone == 'harvest_palette' then
		TriggerServerEvent('esx_ouvrier:stopHarvestPalette')
	end
	if zone == 'harvest_ciment' then
		TriggerServerEvent('esx_ouvrier:stopHarvestCiment')
	end
	if zone == 'sell_scraps' then
		TriggerServerEvent('esx_ouvrier:stopResellScraps')
	end
	if zone == 'sell_palette' then
		TriggerServerEvent('esx_ouvrier:stopResellPalette')
	end
	if zone == 'sell_ciment' then
		TriggerServerEvent('esx_ouvrier:stopResellCiment')
	end

	CurrentAction = nil
	ESX.UI.Menu.CloseAll()
end)

RegisterNetEvent('esx_phone:loaded')
AddEventHandler('esx_phone:loaded', function(phoneNumber, contacts)
	local specialContact = {
		name       = 'Ouvrier',
		number     = 'ouvrier',
		base64Icon = 'data:image/png;base64,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'
		}
	TriggerEvent('esx_phone:addSpecialContact', specialContact.name, specialContact.number, specialContact.base64Icon)
end)


function deleteBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
		RemoveBlip(JobBlips[i])
		JobBlips[i] = nil
		end
	end
end

-- Create Blips
function blips()
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
	
		local blip = AddBlipForCoord(Config.Zones.Cloakroom.Pos.x, Config.Zones.Cloakroom.Pos.y, Config.Zones.Cloakroom.Pos.z)
		SetBlipSprite (blip, 50)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.0)
		SetBlipColour (blip, 5)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("BTP Los Santos")
		EndTextCommandSetBlipName(blip)
		table.insert(JobBlips, blip)
	end
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip2 = AddBlipForCoord(Config.Zones.harvest_scraps.Pos.x, Config.Zones.harvest_scraps.Pos.y, Config.Zones.harvest_scraps.Pos.z)
		SetBlipSprite (blip2, 17)
		SetBlipDisplay(blip2, 4)
		SetBlipScale  (blip2, 1.0)
		SetBlipColour (blip2, 5)
		SetBlipAsShortRange(blip2, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte Férailles")
		EndTextCommandSetBlipName(blip2)
		table.insert(JobBlips, blip2)
	end
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip3 = AddBlipForCoord(Config.Zones.harvest_palette.Pos.x, Config.Zones.harvest_palette.Pos.y, Config.Zones.harvest_palette.Pos.z)
		SetBlipSprite (blip3, 17)
		SetBlipDisplay(blip3, 4)
		SetBlipScale  (blip3, 1.0)
		SetBlipColour (blip3, 5)
		SetBlipAsShortRange(blip3, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte Palettes")
		EndTextCommandSetBlipName(blip3)
		table.insert(JobBlips, blip3)
	end
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip7 = AddBlipForCoord(Config.Zones.harvest_ciment.Pos.x, Config.Zones.harvest_ciment.Pos.y, Config.Zones.harvest_ciment.Pos.z)
		SetBlipSprite (blip7, 17)
		SetBlipDisplay(blip7, 4)
		SetBlipScale  (blip7, 1.0)
		SetBlipColour (blip7, 5)
		SetBlipAsShortRange(blip7, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Récolte Ciments")
		EndTextCommandSetBlipName(blip7)
		table.insert(JobBlips, blip7)
	end
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip4 = AddBlipForCoord(Config.Zones.sell_scraps.Pos.x, Config.Zones.sell_scraps.Pos.y, Config.Zones.sell_scraps.Pos.z)
		SetBlipSprite (blip4, 18)
		SetBlipDisplay(blip4, 4)
		SetBlipScale  (blip4, 1.0)
		SetBlipColour (blip4, 5)
		SetBlipAsShortRange(blip4, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Revente Férailles")
		EndTextCommandSetBlipName(blip4)
		table.insert(JobBlips, blip4)
	end
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip5 = AddBlipForCoord(Config.Zones.sell_palette.Pos.x, Config.Zones.sell_palette.Pos.y, Config.Zones.sell_palette.Pos.z)
		SetBlipSprite (blip5, 18)
		SetBlipDisplay(blip5, 4)
		SetBlipScale  (blip5, 1.0)
		SetBlipColour (blip5, 5)
		SetBlipAsShortRange(blip5, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Revente Palettes")
		EndTextCommandSetBlipName(blip5)
		table.insert(JobBlips, blip5)
	end
	
	
	if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
		local blip6 = AddBlipForCoord(Config.Zones.sell_ciment.Pos.x, Config.Zones.sell_ciment.Pos.y, Config.Zones.sell_ciment.Pos.z)
		SetBlipSprite (blip6, 18)
		SetBlipDisplay(blip6, 4)
		SetBlipScale  (blip6, 1.0)
		SetBlipColour (blip6, 5)
		SetBlipAsShortRange(blip6, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Revente Ciments")
		EndTextCommandSetBlipName(blip6)
		table.insert(JobBlips, blip6)
	end
end


-- Display markers
Citizen.CreateThread(function()
	while true do		
		Wait(0)		
		if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then

			local coords = GetEntityCoords(GetPlayerPed(-1))
			
			for k,v in pairs(Config.Zones) do
				if(v.Type ~= -1 and GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < Config.DrawDistance) then
					DrawMarker(v.Type, v.Pos.x, v.Pos.y, v.Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, v.Size.x, v.Size.y, v.Size.z, v.Color.r, v.Color.g, v.Color.b, 100, false, true, 2, false, false, false, false)
				end
			end
		end
	end
end)

-- Enter / Exit marker events
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then
			local coords      = GetEntityCoords(GetPlayerPed(-1))
			local isInMarker  = false
			local currentZone = nil
			for k,v in pairs(Config.Zones) do
				if(GetDistanceBetweenCoords(coords, v.Pos.x, v.Pos.y, v.Pos.z, true) < v.Size.x) then
					isInMarker  = true
					currentZone = k
				end
			end
			if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
				HasAlreadyEnteredMarker = true
				LastZone                = currentZone
				TriggerEvent('esx_ouvrier:hasEnteredMarker', currentZone)
			end
			if not isInMarker and HasAlreadyEnteredMarker then
				HasAlreadyEnteredMarker = false
				TriggerEvent('esx_ouvrier:hasExitedMarker', LastZone)
			end
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if CurrentAction ~= nil then
            SetTextComponentFormat('STRING')
            AddTextComponentString(CurrentActionMsg)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
            if IsControlJustReleased(0, 38) and PlayerData.job ~= nil and PlayerData.job.name == 'Ouvrier' then                
				if CurrentAction == 'Ouvrier_cloakroom_menu' then
                    OpenOuvrierCloakroomtMenu()
                end
                if CurrentAction == 'spawn_vehicle_menu' then
                    OpenOuvrierVehicleMenu()
                end
                if CurrentAction == 'harvest_scraps' then
                    TriggerServerEvent('esx_ouvrier:startHarvestScraps')
                end
				if CurrentAction == 'harvest_palette' then
                    TriggerServerEvent('esx_ouvrier:startHarvestPalette')
                end
				if CurrentAction == 'harvest_ciment' then
                    TriggerServerEvent('esx_ouvrier:startHarvestCiment')
                end
                if CurrentAction == 'resell_scraps' then
                    TriggerServerEvent('esx_ouvrier:startResellScraps')
                end
				if CurrentAction == 'resell_palette' then
                    TriggerServerEvent('esx_ouvrier:startResellPalette')
                end
				if CurrentAction == 'resell_ciment' then
                    TriggerServerEvent('esx_ouvrier:startResellCiment')
                end
                if CurrentAction == 'delete_vehicle' then
                    local playerPed = GetPlayerPed(-1)
                    local vehicle   = GetVehiclePedIsIn(playerPed,  false)
                    local hash      = GetEntityModel(vehicle)
                    if hash == GetHashKey('TipTruck')then
                        if Config.MaxInService ~= -1 then
                            TriggerServerEvent('esx_service:disableService', 'ouvrier')
                        end
                        local vehicle = GetVehiclePedIsIn(playerPed, false)
						local plate = GetVehicleNumberPlateText(vehicle)
						plate = string.gsub(plate, " ", "")
						TriggerEvent('esx_vehiclelock:updatePlayerCars', "remove", plate)                     
                        DeleteVehicle(vehicle)
                    else
                        ESX.ShowNotification('Vous ne pouvez ranger que des ~b~véhicules d\'ouvrier~s~.')
                    end
                end
                CurrentAction = nil               
            end
        end

    end
end)