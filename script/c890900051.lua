--Power of Melirria - Fire Phoenix
local s,id=GetID()
function s.initial_effect(c)
	c:SetUniqueOnField(1,1,id)
	c:EnableUnsummonable()
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
end
function s.splimit(e,se,sp,st)
	local sc=se:GetHandler()
	return sc:IsSetCard(0x3dd) or ((st&SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM)
end