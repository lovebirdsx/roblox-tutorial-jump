local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Players = game:GetService('Players')

local player = Players.LocalPlayer
local playerGui = player.PlayerGui

local IncreaseJumpPowerFunction = ReplicatedStorage.Instances.IncreaseJumpPowerFunction
local jumpPurchaseGui = ReplicatedStorage.Instances.JumpPurchaseGui
local jumpButton = jumpPurchaseGui.JumpButton

local function onButtonClicked()
	local success, purchased = pcall(IncreaseJumpPowerFunction.InvokeServer, IncreaseJumpPowerFunction)
	if not success then
		error(purchased)
	elseif success and not purchased then
		warn('硬币不足')
	end
end

jumpButton.Activated:Connect(onButtonClicked)
jumpPurchaseGui.Parent = playerGui
