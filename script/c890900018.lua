--Power of Melirria EX - Fire Dragon
	local s,id=GetID()
	function s.initial_effect(c)
	c:EnableReviveLimit()
	--Can only be 1 copy of this card on the field
	c:SetUniqueOnField(1,1,id)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--unaffected by opponent card effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.tgcon)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.tgcon)
	e4:SetValue(1)
	c:RegisterEffect(e4)
end
	function s.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1fa3)
end
	function s.tgcon(e)
	return Duel.IsExistingMatchingCard(s.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
	function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
	function s.rfilter(c,tp)
	return c:IsSetCard(0x3dd) and c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsControler(tp) or c:IsFaceup())
end
	function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	return aux.SelectUnselectGroup(rg,e,tp,5,5,aux.ChkfMMZ(1),0)
end
	function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetReleaseGroup(tp):Filter(s.rfilter,nil,tp)
	local mg=aux.SelectUnselectGroup(rg,e,tp,5,5,aux.ChkfMMZ(1),1,tp,HINTMSG_RELEASE,nil,nil,true)
	if #mg==5 then
		mg:KeepAlive()
		e:SetLabelObject(mg)
		return true
	end
	return false
end
	function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end