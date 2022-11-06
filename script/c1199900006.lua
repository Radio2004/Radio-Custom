--Attackers and Blockers - Dark Warrior
local s,id=GetID()
function s.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.regcon)
	e1:SetOperation(s.regop)
	c:RegisterEffect(e1)
end
s.listed_series={0x132}
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x14f1)
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local c=e:GetHandler()
	--Double damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e1)
	if rc:IsSummonLocation(LOCATION_EXTRA) then
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2)
	end
end
function s.regcon2(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc:IsSetCard(0x14f1) and rc:IsSummonLocation(LOCATION_EXTRA)
end
function s.regop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
end
function s.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x14f1)
end