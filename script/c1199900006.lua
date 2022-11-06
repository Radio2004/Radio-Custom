--Attackers and Blockers - Dark Warrior
local s,id=GetID()
function s.initial_effect(c)
	--Immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(s.econ)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--Double damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e2:SetCondition(s.dcon)
	e2:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e2)
end
s.listed_series={0x132}
function s.econ(e)
	return e:GetHandler():IsInExtraMZone()
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x14f1)
end
function s.dcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget()~=nil and re and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x14f1)
end