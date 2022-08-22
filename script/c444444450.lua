--Shizuka Tiba, Novella Girl
	local s,id=GetID()
	function s.initial_effect(c)
		--effect
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)	
	e1:SetCountLimit(1,id)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.tg)  
	e1:SetOperation(s.op)
	c:RegisterEffect(e1,false,REGISTER_FLAG_NOVELLA)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	end
s.listed_series={0x1BC}
s.listed_names={id}
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
	local g1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
	local g2=Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,nil)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	else
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		local ct=Duel.GetMatchingGroupCount(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,0,LOCATION_SZONE,1,ct,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)  
	end 
end

function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
	local sc=Duel.GetFirstMatchingCard(s.thfilter,tp,LOCATION_DECK,0,nil,e,tp)
	if sc~=nil then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			Duel.ShuffleDeck(tp)
		else
			Duel.Destroy(sc,REASON_EFFECT)
		end
   else   
   local g=Duel.GetTargetCards(e)
   if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end
	end