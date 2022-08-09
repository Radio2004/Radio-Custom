--Future of Melirria - Shizuka Tiba
 local s,id=GetID()
	function s.initial_effect(c)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x3dd),2,2,s.lcheck)
	c:EnableReviveLimit()
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,{id,0})
	e1:SetCondition(s.thcon)
	e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
end
	function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x38d,lc,sumtype,tp)
end
	function s.thfilter(c,tp,code)
	return c:IsSetCard(0x3dd) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and not c:IsCode(code)
end
  
	function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

	function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if chkc then return false end
	if chk==0 then return tc and tc:IsFaceup() and tc:IsSetCard(0x3dd) and tc:IsAbleToGraveAsCost() and Duel.SendtoGrave(tc,REASON_COST) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,tp,tc:GetCode()) end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,tc,1,0,0)
end

	function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end

	function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoGrave(tc,REASON_COST)~=0 and tc:IsLocation(LOCATION_GRAVE) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local fc=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tp,tc:GetCode()):GetFirst()
	aux.PlayFieldSpell(fc,e,tp,eg,ep,ev,re,r,rp)
end
	end