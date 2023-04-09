--Novella: Calmness
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to Light
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1bc))
	e2:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e2)
	--attack up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--effects
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,4))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,{id,1})
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
s.listed_series={0x1bc}
	function s.val(e,c)
	return Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)*100
end
		function s.filter1(c)
	return c:IsFaceup()and c:IsSetCard(0x1BC)
	end

	function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil)
end

	function s.filter(c)
	return c:IsSetCard(0x1bc) and c:IsAbleToDeck()
end

	function s.spfilter(c,e,tp)
	return c:IsSetCard(0x1bc) and not c:IsLinkMonster() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_GRAVE,0,1,nil)
	local g2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
		else
	   e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	   Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
end
	else
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		Duel.Recover(tp,tc:GetAttack()/2,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		--Cannot be used as link material
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(3312)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
		e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e3:SetValue(1)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3,true)
		end
		Duel.SpecialSummonComplete()
	end
end