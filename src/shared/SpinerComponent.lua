local RunService = game:GetService("RunService")
local SpinnerComponent = {}
SpinnerComponent.__index = SpinnerComponent

function SpinnerComponent.new(part)
	local self = setmetatable({}, SpinnerComponent)
	
	self.part = part
	self.spinSpeed = part:GetAttribute("SpinSpeed") or 50 -- 每秒旋转角度
	self.connection = nil

	self.attributeChangedConnection = part:GetAttributeChangedSignal("SpinSpeed"):Connect(function()
		self.spinSpeed = part:GetAttribute("SpinSpeed") or 50
	end)
	
	return self
end

function SpinnerComponent:Start()
	if self.connection then return end
	
	self.connection = RunService.Heartbeat:Connect(function(deltaTime)
		local angle = self.spinSpeed * deltaTime
		self.part.CFrame = self.part.CFrame * CFrame.Angles(0, math.rad(angle), 0)
	end)
end

function SpinnerComponent:Stop()
	if self.connection then
		self.connection:Disconnect()
		self.connection = nil
	end
end

function SpinnerComponent:Destroy()
	self:Stop()

	self.attributeChangedConnection:Disconnect()
	-- 清理引用，帮助垃圾回收
	self.part = nil
end

return SpinnerComponent
