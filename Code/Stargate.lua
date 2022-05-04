--see Info/LICENSE for license and copyright info
--wrapper logging function for this file
local function Log(...)
    FF.Funcs.LogMessage(CurrentModDef.title, "Stargate", ...)
end

--class def
DefineClass.Stargate = {
    __parents = { "ElectricityStorage", "Workplace" },

    MinimumCharge = 100,
    TouristsTransported = 0
}

function Stargate:BuildingUpdate(Delta, ...)
       local ElectricityTarget = self.MinimumCharge * (150 - self.performance) * const.ResourceScale
        Log("Target = ", ElectricityTarget)
        if self:GetStoredPower() >= ElectricityTarget then
            for k,v in ipairs(_G['g_ApplicantPool']) do
                for trait,_ in pairs(v[1].traits) do
                    if trait == "Tourist" then
                        Log("Victim (#"..k..") Selected! >=)")
                        local Victim = _G['g_ApplicantPool'][k][1]
                        table.remove(_G['g_ApplicantPool'], k)

                        Log("Stargate firing!")
                        self.electricity.current_storage = self.electricity.current_storage - ElectricityTarget
                        self.mode = "charging"

                            Log("Colonist Arriving...")
                            local Bob = Colonist:new(GenerateColonistData(MainCity, nil, nil, { gender = Victim.gender, entity_gender = Victim.entity_gender }))  -- from Canada, eh?
                            Bob:SetPos(GetRandomPassableAroundOnMap(self:GetMapID(), self:GetPos(), 10 * guim))

                        if self.working then
                            Log("Updating Colonist")
                            Bob.name = Victim.name
                            MakeTourist(Bob)
                            Bob:SetSpecialization("Tourist", true)
                            Bob:ChangeSatisfaction(10000, "Stargate Entry")
                        else
                            Bob:SetCommand("Die", "Stargate Malfunction")
                            Log("Victim terminated! Muahahahaha!!!")
                        end
                        Log("SUCCESS!")
                        return
                end
            end
            Log("No victims available :(")
        end
    end
end