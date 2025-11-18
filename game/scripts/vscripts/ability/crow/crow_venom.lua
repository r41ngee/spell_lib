crow_venom = class({})
function crow_venom:GetIntrinsicModifierName()
    return "modifier_crow_venom"
end

modifier_crow_venom = class({})
function modifier_crow_venom:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_crow_venom:OnTakeDamage(event)
    local caster = self:GetCaster()
    local ability = self:GetAbility()

    if event.attacker ~= caster or event.inflictor == ability or caster:GetTeamNumber() == event.unit:GetTeamNumber() then return end

    event.unit:AddNewModifier(
        caster,
        ability,
        "modifier_crow_venom_poison",
        {
            duration = ability:GetSpecialValueFor("duration")
        }
    )
end

modifier_crow_venom_poison = class({})
function modifier_crow_venom_poison:OnCreated()
    local ability = self:GetAbility()

    self:StartIntervalThink(ability:GetSpecialValueFor("tickrate"))
end

function modifier_crow_venom_poison:OnIntervalThink()
    local ability = self:GetAbility()
    local caster = self:GetCaster()
    local target = self:GetParent()

    ApplyDamage({
        victim = target,
        attacker = caster,
        damage = ability:GetSpecialValueFor("damage"),
        ability = ability,
        damage_type = DAMAGE_TYPE_MAGICAL
    })
end

LinkLuaModifier("modifier_crow_venom", "ability/crow/crow_venom.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_crow_venom_poison", "ability/crow/crow_venom.lua", LUA_MODIFIER_MOTION_NONE)
