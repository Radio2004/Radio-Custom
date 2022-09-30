--Gaiden Melirria - Kaede & Naoki
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,s.tfilter,1,1,s.sfilter,1,1)
	c:EnableReviveLimit()
	--atk up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
end
s.material={890900035,890900036}
s.listed_names={890900035,890900036,890900017,890900025,890900034}
s.material_setcode=0x3dd
s.listed_series={0x3dd}
function s.tfilter(c,scard,sumtype,tp)
	return c:IsSummonCode(scard,sumtype,tp,890900035) or c:IsHasEffect(890900032)
end
function s.sfilter(c,scard,sumtype,tp)
	return c:IsSummonCode(scard,sumtype,tp,890900036) or c:IsHasEffect(890900032)
end
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0x3dd)*200
end
