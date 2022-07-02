--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,1)
	c:EnableReviveLimit()
		--summon proc
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ADJUST)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetOperation(s.op)
		Duel.RegisterEffect(e1)
end
	function s.filter(c)
	return c:IsCode(890900018) 
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.filter,0,LOCATION_HAND,LOCATION_HAND,nil)
	local tc=g1:GetFirst()
	while tc do
			local e2=Effect.CreateEffect(tc)
			e2:SetDescription(aux.Stringid(64382841,3))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SPSUMMON_PROC)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e2:SetRange(LOCATION_HAND)
			e2:SetCondition(s.plasmacon)
			e2:SetOperation(s.plasmaop)
			tc:RegisterEffect(e2)
			end
		end
function s.plasmacon(e,c)
	if c==nil then return true end
	local g=Duel.GetReleaseGroup(c:GetControler())
	local d2=g:FilterCount(Card.IsHasEffect,nil,id)
	local d3=g:FilterCount(Card.IsHasEffect,nil,id+1)
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	return (ft>-2 and #g>1 and d2>0) or (ft>-1 and d3>0)
end
function s.plasmaop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetReleaseGroup(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg1=g:FilterSelect(tp,Card.IsHasEffect,1,1,nil,id)
	if not sg1:GetFirst():IsHasEffect(id+1) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg2=g:Select(tp,1,1,sg1:GetFirst())
		sg1:Merge(sg2)
	end
	Duel.Release(sg1,REASON_COST)
end
