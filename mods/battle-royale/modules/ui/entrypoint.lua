
local function _CreateInterface(isReplay)

    local window = WindowConstruct("battle-royale", "docked-left", 350, 700)

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
                        interface = import("/mods/battle-royale/modules/ui/view.lua")
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
            local count = 10
            while count > 0 do 
                WaitSeconds(1.0)

                -- are we there yet?
                found = _G.DearWindow and _G.DearWindowVersion
                if found then 
                    LOG("Found Dear Windowing version (" .. tostring(_G.DearWindowVersion) .. ")")
                    _CreateInterface(isReplay)
                    break
                end

                count = count - 1
            end

            -- woopsie
            if not found then 
                WARN("Cannot initialize battle-royale: can not find Dear Windowing UI mod.")
            end
        end
    )
end