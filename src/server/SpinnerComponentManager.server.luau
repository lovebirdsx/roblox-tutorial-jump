local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local SpinnerComponent = require(ReplicatedStorage.Shared.SpinerComponent)

local activeComponents = {}

local function setupComponent(instance)
    if not activeComponents[instance] then
        print("Setting up SpinnerComponent for", instance:GetFullName())
        local component = SpinnerComponent.new(instance)
        activeComponents[instance] = component
        component:Start()
    end
end

local function cleanupComponent(instance)
    local component = activeComponents[instance]
    if component then
        print("Cleaning up SpinnerComponent for", instance:GetFullName())
        component:Destroy()
        activeComponents[instance] = nil
    end
end

for _, instance in ipairs(CollectionService:GetTagged("Spinner")) do
    setupComponent(instance)
end

CollectionService:GetInstanceAddedSignal("Spinner"):Connect(setupComponent)
CollectionService:GetInstanceRemovedSignal("Spinner"):Connect(cleanupComponent)
