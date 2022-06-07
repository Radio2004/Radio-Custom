--Gaiden Melirria - Sagiri Tiba
	local s,id=GetID()
	function s.initial_effect(c)
	--negate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
end
s.listed_series={0x22cd}
	function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetActivateLocation()==LOCATION_HAND and re:IsActiveType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and Duel.IsChainDisablable(ev)
		and (Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))and Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1bc),tp,LOCATION_MZONE,0,1,nil)
		end
		function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
			local rc=re:GetHandler()
		if chk==0 then return not re:GetHandler():IsStatus(STATUS_DISABLED)
		and Duel.GetLocationCount(tp,LOCATION_HAND)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false)
		and rc:IsLocation(LOCATION_HAND) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)   
	end
	function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	local c=e:GetHandler()
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)~=0 then
		c:CompleteProcedure()
	end
end 



