local holdingCar = false
local car
local pickupKey = 38 -- E key
local throwKey = 47 -- G key
local throwForce = 500.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local playerPed = PlayerPedId()
        local pos = GetEntityCoords(playerPed)

        if not holdingCar then
            if IsControlJustPressed(1, pickupKey) then
                local vehicle = GetClosestVehicle(pos.x, pos.y, pos.z, 3.0, 0, 70)
                if DoesEntityExist(vehicle) then
                    holdingCar = true
                    car = vehicle

                    -- Load the animation dictionary
                    RequestAnimDict("anim@heists@box_carry@")
                    while (not HasAnimDictLoaded("anim@heists@box_carry@")) do 
                        Citizen.Wait(100)
                    end

                    AttachEntityToEntity(car, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 1.5, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
                    TaskPlayAnim(playerPed, "anim@heists@box_carry@", "idle", 8.0, -8, -1, 49, 0, false, false, false)
                end
            end
        else
            if IsControlJustPressed(1, throwKey) then
                holdingCar = false
                DetachEntity(car, true, true)
                
                local forwardVector = GetEntityForwardVector(playerPed)
                local throwVelocity = vector3(forwardVector.x * throwForce, forwardVector.y * throwForce, throwForce / 2)
                ApplyForceToEntity(car, 1, throwVelocity.x, throwVelocity.y, throwVelocity.z, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
                
                ClearPedTasksImmediately(playerPed)
                car = nil
            end
        end
    end
end)
