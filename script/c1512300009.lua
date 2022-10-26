--G.E.C. Swordmaster
local s,id=GetID()
function s.initial_effect(c)
	--Enable pendulum summon
	Pendulum.AddProcedure(c)
	--Tribute summon "G.E.C" monster without tributing
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ntcon)
	e1:SetTarget(aux.FieldSummonProcTg(s.nttg))
	c:RegisterEffect(e1)
end
s.listed_series={0x3b13}
function s.cfilter(c)
	return c:IsFacedown() or not c:IsRace(RACE_ROCK)
end
function s.ntcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.nttg(e,c)
	return c:IsSetCard(0x3b13)
end
