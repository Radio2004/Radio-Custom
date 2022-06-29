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