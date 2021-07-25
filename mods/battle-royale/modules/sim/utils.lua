
local ScenarioFramework = import('/lua/ScenarioFramework.lua');

--- Sends an announcement to all the players.
-- @param title The title of the announcement.
-- @param subtitle The subtitle of the announcement.
-- @param delay The amount of seconds to wait before the announcement should take place.
function SendAnnouncement(title, subtitle, delay)
    ScenarioFramework.CreateTimerTrigger(
        function() 
            Sync.SendAnnouncement = { title = title, subTitle = subtitle }; 
        end,
        delay,
        true
    );
end

--- Sends an announcement to all the players along with a voice over.
-- @param title The title of the announcement.
-- @param subtitle The subtitle of the announcement.
-- @param delay The amount of seconds to wait before the announcement should take place.
-- @param bank The audio bank to use
-- @param cue The cue (sound) of the audio bank to use
function SendAnnouncementWithVoice(title, subtitle, delay, bank, cue)
    ScenarioFramework.CreateTimerTrigger(
        function() 
            local sound = { cue = cue, bank = bank}
            Sync.SendAnnouncement = { title = title, subTitle = subtitle, sound = sound }; 
        end,
        delay,
        true
    );
end