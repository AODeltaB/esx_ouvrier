ESX                		= nil
local PlayersHarvestingScraps 		 = {}
local PlayersReselling_scraps		 = {}
local PlayersHarvestingPalette		 = {}
local PlayersReselling_palette		 = {}
local PlayersHarvestingCiment		 = {}
local PlayersReselling_ciment		 = {}


TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'ouvrier', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'ouvrier', 'Client ouvrier', false, false)

-----------------------------Recolte Scraps---------------------------------------------
local function HarvestScraps(source)


	SetTimeout(3000, function()

		if PlayersHarvestingScraps[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local scrapsQuantity = xPlayer.getInventoryItem('scraps').count

			if scrapsQuantity >= 20 then
				TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de matériaux !')
			else
					
				xPlayer.addInventoryItem('scraps', 1)
				HarvestScraps(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startHarvestScraps')
AddEventHandler('esx_ouvrier:startHarvestScraps', function()
	local _source = source
	PlayersHarvestingScraps[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Ramassage en cours...')
	HarvestScraps(source)
end)

RegisterServerEvent('esx_ouvrier:stopHarvestScraps')
AddEventHandler('esx_ouvrier:stopHarvestScraps', function()
	local _source = source
	PlayersHarvestingScraps[_source] = false
end)

-----------------------------Recolte Palette---------------------------------------------
local function HarvestPalette(source)


	SetTimeout(3000, function()

		if PlayersHarvestingPalette[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local paletteQuantity = xPlayer.getInventoryItem('palette').count

			if paletteQuantity >= 20 then
				TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de matériaux !')
			else
					
				xPlayer.addInventoryItem('palette', 1)
				HarvestPalette(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startHarvestPalette')
AddEventHandler('esx_ouvrier:startHarvestPalette', function()
	local _source = source
	PlayersHarvestingPalette[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Ramassage en cours...')
	HarvestPalette(source)
end)

RegisterServerEvent('esx_ouvrier:stopHarvestPalette')
AddEventHandler('esx_ouvrier:stopHarvestPalette', function()
	local _source = source
	PlayersHarvestingPalette[_source] = false
end)

-----------------------------Recolte Ciment---------------------------------------------
local function HarvestCiment(source)


	SetTimeout(3000, function()

		if PlayersHarvestingCiment[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local cimentQuantity = xPlayer.getInventoryItem('ciment').count

			if cimentQuantity >= 20 then
				TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez plus rammasser de matériaux !')
			else
					
				xPlayer.addInventoryItem('ciment', 1)
				HarvestCiment(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startHarvestCiment')
AddEventHandler('esx_ouvrier:startHarvestCiment', function()
	local _source = source
	PlayersHarvestingCiment[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Ramassage en cours...')
	HarvestCiment(source)
end)

RegisterServerEvent('esx_ouvrier:stopHarvestCiment')
AddEventHandler('esx_ouvrier:stopHarvestCiment', function()
	local _source = source
	PlayersHarvestingCiment[_source] = false
end)

----------------Revente Scraps---------------------------
local function Resell_scraps(source)

	SetTimeout(500, function()

		if PlayersReselling_scraps[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local scrapsQuantity = xPlayer.getInventoryItem('scraps').count

			if scrapsQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de matériaux à vendre')
			else
					
				xPlayer.removeInventoryItem('scraps', 1)
				local total 	   = 15
				local playerMoney  = total
	  				xPlayer.addMoney(playerMoney)
	  				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez gagné ~g~$'.. playerMoney)
					
				Resell_scraps(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startResellScraps')
AddEventHandler('esx_ouvrier:startResellScraps', function()
	local _source = source
	PlayersReselling_scraps[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Vente en cours...')
	Resell_scraps(source)
end)

RegisterServerEvent('esx_ouvrier:stopResellScraps')
AddEventHandler('esx_ouvrier:stopResellScraps', function()
	local _source = source
	PlayersReselling_scraps[_source] = false
end)

----------------Revente Palettes---------------------------
local function Resell_palette(source)

	SetTimeout(500, function()

		if PlayersReselling_palette[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local paletteQuantity = xPlayer.getInventoryItem('palette').count

			if paletteQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de matériaux à vendre')
			else
					
				xPlayer.removeInventoryItem('palette', 1)
				local total 	   = 12
				local playerMoney  = total
	  				xPlayer.addMoney(playerMoney)

	  				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez gagné ~g~$'.. playerMoney)
					
				Resell_palette(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startResellPalette')
AddEventHandler('esx_ouvrier:startResellPalette', function()
	local _source = source
	PlayersReselling_palette[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Vente en cours...')
	Resell_palette(source)
end)

RegisterServerEvent('esx_ouvrier:stopResellPalette')
AddEventHandler('esx_ouvrier:stopResellPalette', function()
	local _source = source
	PlayersReselling_palette[_source] = false
end)


----------------Revente Ciments---------------------------
local function Resell_ciment(source)

	SetTimeout(500, function()

		if PlayersReselling_ciment[source] == true then

			local xPlayer  = ESX.GetPlayerFromId(source)

			local cimentQuantity = xPlayer.getInventoryItem('ciment').count

			if cimentQuantity <= 0 then
				TriggerClientEvent('esx:showNotification', source, 'Vous n\'avez plus de matériaux à vendre')
			else
					
				xPlayer.removeInventoryItem('ciment', 1)
				local total 	   = 20
				local playerMoney  = total
	  				xPlayer.addMoney(playerMoney)

	  				TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez gagné ~g~$'.. playerMoney)
					
				Resell_ciment(source)
			end

		end
	end)
end

RegisterServerEvent('esx_ouvrier:startResellCiment')
AddEventHandler('esx_ouvrier:startResellCiment', function()
	local _source = source
	PlayersReselling_ciment[_source] = true
	TriggerClientEvent('esx:showNotification', _source, 'Vente en cours...')
	Resell_ciment(source)
end)

RegisterServerEvent('esx_ouvrier:stopResellCiment')
AddEventHandler('esx_ouvrier:stopResellCiment', function()
	local _source = source
	PlayersReselling_ciment[_source] = false
end)



ESX.RegisterServerCallback('esx_ouvrier:getPlayerInventory', function(source, cb)

	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})

end)