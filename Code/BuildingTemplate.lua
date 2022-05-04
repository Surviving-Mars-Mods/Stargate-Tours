--see Info/LICENSE for license and copyright info

--wrapper logging function for this file
local function Log(...)
    FF.LogMessage(CurrentModDef.title, "BuildingTemplate", ...)
end

function OnMsg.ClassesPostprocess()
    Log("Adding BT")
    if not BuildingTemplates.Stargate then
        PlaceObj('BuildingTemplate', {
            'comment', "Stargate",
            'Group', "Infrastructure",
            'Id', "Stargate",
            'template_class', "Stargate",
            'construction_cost_Concrete', 42000,
            'construction_cost_Metals', 6900,
            'construction_cost_Electronics', 1111,
            'construction_cost_MachineParts', 3165,
            'build_points', 5000,
            'is_tall', true,
            'dome_forbidden', true,
            'maintenance_resource_type', "Electronics",
            'maintenance_resource_amount', 1750,
            'maintenance_threshold_base', 75000,
            'max_electricity_charge', 750000,
            'max_electricity_discharge', 500000,
            'conversion_efficiency', 69,
            'capacity', 10000000,
            'sight_category', "Additional Buildings",
            'sight_satisfaction', 7,
            'display_name', FF.Funcs.Translate("Stargate"),
            'display_name_pl', FF.Funcs.Translate("Stargates"),
            'description', FF.Funcs.Translate("Allows tourists to travel instantly to Mars, receiving a satisfaction bonus. Also functions as a high-performance capacitor."),
            'build_category', "Infrastructure",
            'display_icon', "UI/Icons/Buildings/black_cube_monolith.tga",
            'build_pos', 1,
            'entity', "BlackCubeMonolith",
            'encyclopedia_id', "Stargate",
            'encyclopedia_text', FF.Funcs.Translate("Allows instantaneous travel between Earth and Mars."),
            'encyclopedia_image', "UI/Encyclopedia/ResearchLab.tga",
            'label1', "InsideBuildings",
            'palette_color1', "inside_accent_1",
            'palette_color2', "inside_base",
            'palette_color3', "inside_accent_research",
            'demolish_sinking', range(1, 5),
            'demolish_debris', 85,
            'max_workers', 4,
            'specialist', "engineer",
            'pin_rollover_context', "electricity",
            'pin_progress_value', "current_storage",
            'pin_progress_max', "storage_capacity",
        })
    end
end