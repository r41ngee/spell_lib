abaddon_death_coil = class({})
function abaddon_death_coil:OnSpellStart()
    local target = self:GetCursorTarget()
    local caster = self:GetCaster()

    local ally = target:GetTeamNumber() == caster:GetTeamNumber()

    local damage = ally and self:GetSpecialValueFor("heal_amount") or self:GetSpecialValueFor("target_damage")
    local self_dmg = ally and self:GetSpecialValueFor("self_damage") * damage / 100 or self:GetSpecialValueFor("self_damage_enemy_target")

    ApplyDamage({
        victim = caster,
        attacker = caster,
        damage = self_dmg,
        damage_type = DAMAGE_TYPE_PURE,
        damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL,
        ability = self
    })

    local projectile_name = "particles/units/heroes/hero_abaddon/abaddon_death_coil.vpcf"
    local projectile_speed = self:GetSpecialValueFor("missile_speed")

    ProjectileManager:CreateTrackingProjectile({
        EffectName = projectile_name,
        Ability = self,
        Source = self:GetCaster(),
        bProvidesVision = false,
        Target = target,
        iMoveSpeed = projectile_speed,
        bDodgeable = not ally,
    })
end

function abaddon_death_coil:OnProjectileHit(target)
    local caster = self:GetCaster()
    local ally = target:GetTeamNumber() == caster:GetTeamNumber()

    local damage = self:GetSpecialValueFor("target_damage")
    local heal = self:GetSpecialValueFor("heal_amount")

    if ally then
        target:Heal(heal, self)
        SendOverheadEventMessage(
            nil,
            OVERHEAD_ALERT_HEAL,
            target,
            heal,
            nil
        )
    else
        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        })
    end
end