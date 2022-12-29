
local function _CreateInterface(isReplay)

    local window = WindowConstruct("Battle Royale", "docked-left", 390, 700)

    local function toDearWindowing()

        local ok = false 
        local message = ""
        local interfaceOld = nil
        local interface = nil

        while true do 

            WaitSeconds(0.2)

            -- import it every loop to allow re-loading the file
            if not window:IsHidden() then 

                -- perform a safe call
                ok, message = pcall (
                    function () 
                        -- load in interface to receive updates
                        interface = import("/mods/Battle-Royale-by-Dark-Horse/modules/ui/view.lua")
                        interface.CreateInterface( window, isReplay) 
                    end
                )

                -- if we not ok and the interface is different then we warn us with the message
                if not ok then

                    -- first time crash, tell us what went wrong
                    if  (interfaceOld != interface) then 
                        WARN(message)            
                    end

                    -- keep track of changes
                    interfaceOld = interface
                else 
                    -- if we didn't crash, keep going
                    interfaceOld= nil
                end
            end
        end
    end

    ForkThread(toDearWindowing)
end

function Entrypoint(isReplay)

    ForkThread(
        function()

            -- we cannot fully rely on the game handling the mod ordering, hence we wait a bit to make sure
            -- that Dear Windowing is loaded in. Otherwise we go in empty handed :)

            local found = false
            for k, mod in __active_mods do 
                if mod.name == "Dear Windowing" then
                    found = true 
                    break
                end
            end

            if found then 
                LOG("Found Dear Windowing!")

                -- wait for hooks to finish
                WaitSeconds(1.0)

                -- launch the interface
                _CreateInterface(isReplay)

            else
                WARN("Cannot initialize battle-royale: missing Dear Windowing UI mod.")
            end
        end
    )
end