--Novella: Friendship Forever
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to EARTH
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(s.tg)
	e2:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e2)
	--destruction replacement
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DESTROY_REPLACE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.reptg)
	e3:SetValue(s.repval)
	e3:SetOperation(s.repop)
	c:RegisterEffect(e3)
end
s.listed_series={0x1bc}
	function s.tg(e,c,tp)
	if not c:IsSetCard(0x1BC) then return false end
	if c:GetFlagEffect(1)==0 then
		c:RegisterFlagEffect(1,0,0,0)
		local eff
		if c:IsLocation(LOCATION_MZONE) then
			eff={Duel.GetPlayerEffect(c:GetControler(),EFFECT_NECRO_VALLEY)}
		else
			eff={c:GetCardEffect(EFFECT_NECRO_VALLEY)}
		end
		c:ResetFlagEffect(1)
		for _,te in ipairs(eff) do
			local op=te:GetOperation()
			if not op or op(e,c) then return false end
		end
	end
	return true
end

function s.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x1bc) and c:IsType(TYPE_MONSTER) and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetDestination()==LOCATION_REMOVED 
		and c:IsReason(REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(e:GetHandlerPlayer(),69832741)
		and eg:IsExists(s.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(id,2))
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
end