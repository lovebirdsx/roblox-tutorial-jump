-- 初始化服务和变量
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Leaderboard = require(ReplicatedStorage.Shared.Leaderboard)
local PlayerData = require(ReplicatedStorage.Shared.PlayerData)

local coinsFolder = Workspace.World.Coins
local coins = coinsFolder:GetChildren()

local COIN_KEY_NAME = PlayerData.COIN_KEY_NAME
local COOLDOWN = 20
local COIN_AMOUNT_TO_ADD = 1

local function updatePlayerCoins(player, updateFunction)
	local newCointCount = PlayerData.updateValue(player, COIN_KEY_NAME, updateFunction) or 0
	Leaderboard.setStat(player, COIN_KEY_NAME, newCointCount)
end

-- 定义事件处理程序
local function onCoinTouched(otherPart, coin)
	if coin:GetAttribute("Enabled") then
		local character = otherPart.Parent
		local player = Players:GetPlayerFromCharacter(character)
		if player then
			-- 玩家触碰了金币
			coin.Transparency = 1
			coin:SetAttribute("Enabled", false)
			updatePlayerCoins(player, function(oldCointAmount)
				oldCointAmount = oldCointAmount or 0
				return oldCointAmount + COIN_AMOUNT_TO_ADD
			end)
			print("玩家收集了金币")
			task.wait(COOLDOWN)
			coin.Transparency = 0
			coin:SetAttribute("Enabled", true)
		end
	end
end

-- 设置事件监听器
for _, coin in coins do
	coin:SetAttribute("Enabled", true)
	coin.Touched:Connect(function(otherPart)
		onCoinTouched(otherPart, coin)
	end)
end

local function onPlayerAdded(player)
	updatePlayerCoins(player, function (_)
		return 0
	end)
	
	player.CharacterAdded:Connect(function (character)
		task.spawn(function ()
			character:WaitForChild('Humanoid').Died:Connect(function ()
				updatePlayerCoins(player, function (_) 
					return 0 
				end)
			end)
		end)
	end)
end

for player in Players:GetPlayers() do
	onPlayerAdded(player)
end

local function onPlayerMoved(player)
	updatePlayerCoins(player, function(_)
		return nil
	end)
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerMoved)
