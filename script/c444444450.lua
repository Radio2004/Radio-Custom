--Shizuka Tiba, Novella Girl
	local s,id=GetID()
	function s.initial_effect(c)
		--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)	
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.tg)  
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	end
	s.listed_series={0x1BC}
function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1BC)
end
function s.thfilter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)and c:IsAbleToHand()
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
local c=e:GetHandler()
	local g1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local g2=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	local g=(op==1 and g1 or g2)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end 
	else   
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
	if ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,ct,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
		 end
	end

