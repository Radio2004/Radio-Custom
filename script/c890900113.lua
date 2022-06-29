--Melirria, Episode of Fire and Ice - The Great Witch
	local s,id=GetID()
	function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),5,5)
	c:EnableReviveLimit()
	--summon proc
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(id)
	c:RegisterEffect(e3)
	aux.GlobalCheck(s,function()
		--summon proc
		local ge1=Effect.CreateEffect(c)
		ge1:SetDescription(aux.Stringid(id,0))
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_SPSUMMON_PROC)
		ge1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		ge1:SetCondition(s.sumcon)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x3dd),s.sumtg)
		ge1:SetOperation(s.sumop)
		ge1:SetValue(SUMMON_TYPE_TRIBUTE)
		Duel.RegisterEffect(ge1,0)
	end)
end
	function s.castlefilter(c,tp,mi,ma)
	return c:IsHasEffect(id) and c:GetOverlayCount()>=mi and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsReleasable()
end
	function s.sumcon(e,c,minc)
	if c==nil then return true end
	local mi,ma=c:GetTributeRequirement()
	if mi<minc then mi=minc end
	if ma<mi then return false end
	return ma>0 and Duel.IsExistingMatchingCard(s.castlefilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetControler(),mi,ma)
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	tp=c:GetControler()
	local mi,ma=c:GetTributeRequirement()
	local sg=Duel.SelectMatchingCard(tp,s.castlefilter,tp,LOCATION_MZONE,0,1,1,true,nil,tp,mi,ma)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	if not sg then return end
	Duel.Release(sg,REASON_COST)
	sg:DeleteGroup()
end