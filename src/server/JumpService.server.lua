local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local Leaderboard = require(ReplicatedStorage.Shared.Leaderboard)
local PlayerData = require(ReplicatedStorage.Shared.PlayerData)

local IncreaseJumpPowerFunction = ReplicatedStorage.Instances.IncreaseJumpPowerFunction

local JUMP_KEY_NAME = PlayerData.JUMP_KEY_NAME
local COIN_KEY_NAME = PlayerData.COIN_KEY_NAME
local JUMP_POWER_INCREMENT = 30
local JUMP_COIN_COST = 5

local function updateJumpPower(player, updateFunciton)
	local newJumpPower = PlayerData.updateValue(player, JUMP_KEY_NAME, updateFunciton) or 0
	
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:FindFirstChildWhichIsA('Humanoid')
	if humanoid then
		humanoid.JumpPower = newJumpPower
		
		Leaderboard.setStat(player, JUMP_KEY_NAME, newJumpPower)
	end
end

local function onPurchaseJumpIncrease(player)
	local coinAmount = PlayerData.getValue(player, COIN_KEY_NAME)
	if coinAmount < JUMP_COIN_COST then
		return false
	end
	
	updateJumpPower(player, function (oldJumpPower)
		oldJumpPower = oldJumpPower or 0
		return oldJumpPower + JUMP_POWER_INCREMENT
	end)
	
	local newCoinAmout = PlayerData.updateValue(player, COIN_KEY_NAME, function(oldCointCount)
		return oldCointCount - JUMP_COIN_COST
	end)
	
	Leaderboard.setStat(player, COIN_KEY_NAME, newCoinAmout)
	return true
end

local function onCharacterAdded(player)
	updateJumpPower(player, function (_)
		return 0
	end)
end

for _, player in Players:GetPlayers() do
	onCharacterAdded(player)
end

local function onPlayerAdded(player)
	player.CharacterAdded:Connect(function ()
		onCharacterAdded(player)
	end)
end

local function onPlayerRemoved(player)
	updateJumpPower(player, function (_)
		return nil
	end)
end

IncreaseJumpPowerFunction.OnServerInvoke = onPurchaseJumpIncrease
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoved)
