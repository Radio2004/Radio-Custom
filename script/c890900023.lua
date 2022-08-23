--Future of Melirria - Mena Sakamotou
	local s,id=GetID()
	function s.initial_effect(c)
	c:EnableCounterPermit(0x382)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),2,2,s.lcheck)
	c:EnableReviveLimit()
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.ctcon)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Remove counters
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1,{id,1})
	e4:SetRange(LOCATION_MZONE)
	e4:SetCost(s.spcost)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end
s.counter_place_list={0x382}
	function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x38d,lc,sumtype,tp)
end
	function s.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsSetCard(0x3dd) and c:IsFaceup() and ec:GetLinkedGroup():IsContains(c)
	else
		return c:IsPreviousSetCard(0x3dd) and c:IsPreviousPosition(POS_FACEUP)
			and bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,e:GetHandler())
end
function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x382,1)
end
   function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	c:RemoveCounter(tp,0x382,c:GetCounter(0x382),REASON_COST)
end
	function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x382)
	local b1=Duel.RemoveCounter(tp,1,0,0x382,5,REASON_COST)
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x382,7,REASON_COST)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil)
	if chk==0 then return ct>0 and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(id,1))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.RemoveCounter(tp,1,0,0x35,5,REASON_COST)
		Duel.SetTargetPlayer(1-tp)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
	else
		e:SetCategory(CATEGORY_REMOVE)
		Duel.RemoveCounter(tp,1,0,0x35,7,REASON_COST)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD+LOCATION_GRAVE)
	end
end