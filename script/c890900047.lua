--Cyberse Melirria
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3dd))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--summon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCondition(s.sumcon)
	e3:SetOperation(s.sumsuc)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(s.indtg)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4)
end
s.listed_series={0x3dd,0x22cd}
function s.lkfilter(c,oc)
	return c:GetLinkedGroup():IsContains(oc)
end
function s.indtg(e,c)
	local oc=Duel.GetMatchingGroup(s.lkfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	return c:IsSetCard(0x3dd) and oc
end
function s.limfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_LINK and c:IsSetCard(0x3dd)
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.limfilter,1,nil)
end
function s.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(aux.FALSE)
end