AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel( "models/h4_prop_h4_art_pant_01a.mdl" ) 
    self:PhysicsInit( SOLID_VPHYSICS ) 
    self:SetMoveType( MOVETYPE_VPHYSICS ) 
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )
    local phys = self:GetPhysicsObject() 
    if phys:IsValid() then 
        phys:Wake()
    end
end

function ENT:Think()
    local entities = player.GetAll()

    for k, v in ipairs(entities) do
        if v:IsValid() and v:Alive() and v:GetPos():Distance(self:GetPos()) <= 175 and not self.player_table[v] then
            self.player_table[v] = true
            v.original_scale = v:GetModelScale()
            v.original_model = v:GetModel()
        end
    end

    for k, v in pairs(self.player_table) do      
        local rand1 = math.random(0, 61)
        local scale = 0.7 + (rand1 / 100) -- Scales the player between 70% and 130%

        local rand2 = math.random(1, #self.model_table * 10)
        
        -- Change the player's model:
        if rand2 > #self.model_table then
            k:SetModel(k.original_model)
        else
            k:SetModel(self.model_table[rand2])
        end

        -- Make sure the player doesn't get bigger than 200% or smaller than 40%
        if k:GetModelScale() * scale >= 1.7 or k:GetModelScale() * scale <= 0.3 then continue end

        k:SetModelScale(k:GetModelScale() * scale, 2)

        if k:GetPos():Distance(self:GetPos()) >= 175 then
            self.player_table[k] = nil
            table.RemoveByValue(entities, k)
            k:SetModelScale(k.original_scale, 3)
            k:SetModel(k.original_model)
        end
    end

    self:NextThink(CurTime() + 5)
    return true
end