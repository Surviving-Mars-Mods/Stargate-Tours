-- See license.md for copyright info
--FF.Lib.Debug = true

--wrapper logging function for this file
local function Log(...)
    FF.LogMessage("Stargate", "Code", ...)
end

local function Init()
    if not IsDlcAccessible("contentpack3") and ClassTemplates.Building.Stargate then
            Log("WARNING", "Downgrading stargate entity to Academy")
            ClassTemplates.Building.FFHydrolysisReactor.entity = Academy

        for _, Stargate in pairs(MainCity.labels.Stargate) do
            Stargate:ChangeEntity("Academy")
        end

    end
end

OnMsg.MapGenerated = Init
OnMsg.ClassesPostProcess = Init