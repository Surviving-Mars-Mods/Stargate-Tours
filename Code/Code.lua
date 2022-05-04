-- See license.md for copyright info
--FF.Lib.Debug = true

--wrapper logging function for this file
local function Log(...)
    FF.LogMessage("Stargate", "Code", ...)
end

--add a message handler to generating applicants
local _GenerateApplicants = GenerateApplicants
local TouristCount = 0

function GenerateApplicants(...)
    _GenerateApplicants(...)
    Msg("ApplicantGenerated")
end

local function UpdateTouristCount()
    local Count = 0
    for k,v in ipairs(_G['g_ApplicantPool']) do
        for trait,_ in pairs(v[1].traits) do
            if trait == "Tourist" then
                Count = Count + 1
            end
        end
    end
    TouristCount = Count
end

CreateGameTimeThread(function()
    while true do
        WaitMsg("ApplicantGenerated")
        UpdateTouristCount()
    end
end)

-- setup info panel for stargate
local function GetTouristsWaiting()
    return TouristCount
end

local function GetTouristETA(self)
    local ElectricityTarget = self.MinimumCharge * (150 - self.performance) * const.ResourceScale
    local Charge = self.electricity.grid.current_storage_change
    if Charge <= 0 then
        return "INFINITY"
    else
        local ETA = (ElectricityTarget / Charge) * 8 -- 8 hours per shift roughly
        Log("ETA, Target, Charge = ", ETA, ", ", ElectricityTarget, ", ", Charge)
        return FormatDuration(ETA)
    end
end

local function GetTouristsTransported(self)
    return self.TouristsTransported
end

local function SetupIP()
    XTemplate = XTemplates.ipBuilding[1][1]
    if #XTemplate < 2 then
        Log("ERROR", "Building InfoPanel template is not valid")
        return
    end

    --recreate it when necessary
    if XTemplates.sectionStargate then
        XTemplates.sectionStargate = nil
    end

    --add the info 2do
    PlaceObj("XTemplate", {
        group = "Infopanel Sections",
        id = "sectionStargate",
        PlaceObj("XTemplateGroup", {
            "__context_of_kind", "Stargate",
        },{
            PlaceObj("XTemplateTemplate", {
                "__template", "InfopanelSection",
                "Icon", "UI/Icons/Sections/theory_3.dds",
                "RolloverText", FF.Translate('Stargate\'s Tourist Info'),
                "Title", FF.Translate("Tourist Info"),
            },{
                PlaceObj("XTemplateTemplate", {
                    "__template", "InfopanelText",
                    "Text", T{"<str>: <WaitCount>",
                              str = FF.Translate("Tourists Waiting"), WaitCount = GetTouristsWaiting, -- can't call a function with arguments here
                    },
                }),
                PlaceObj("XTemplateTemplate", {
                    "__template", "InfopanelText",
                    "Text", T{"<str>: <ETA>",
                              str = FF.Translate("Next ETA"), ETA = GetTouristETA, -- can't call a function with arguments here
                    },
                }),
                PlaceObj("XTemplateTemplate", {
                    "__template", "InfopanelText",
                    "Text", T{"<str>: <TransportCount>",
                              str = FF.Translate("Tourists Transported"), TransportCount = GetTouristsTransported, -- can't call a function with arguments here
                    },
                }),
            })
        })
    })

    --add/update the section
    if XTemplate[2].Id == "sectionStargate" then
        table.remove(XTemplate, 2)
    end

    table.insert(XTemplate, 2, PlaceObj("XTemplateTemplate", {
        "__template", "sectionStargate",
        "Id", "sectionStargate"
    }))

    --this shit still doesn't work
    --not sure what I need to force the game to update the IP
end

local function Init()
    UpdateTouristCount()
    SetupIP()
end

OnMsg.MapGenerated = Init
OnMsg.ClassesPostProcess = Init