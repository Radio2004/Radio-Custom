--Nyss, The Mother of Toxic Chimeras
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,aux.FilterBoolFunctionEx(Card.IsSetCard,0x22B),3)
	c:SetUniqueOnField(1,0,id)
	-- SPSUMMON
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
	end
	function s.filter(c,e,tp)
	return c:IsSetCard(0x22B) and not c:IsType(TYPE_FUSION)  and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	function s.sfilter(c,e)
	return c:IsFaceup() and c:IsCode(id) and c:GetSequence()>4
end
	function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

	function s.desop(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if lc<=0 then return end
		if c:GetSequence()>4 and lc>2 then lc=2 end
		if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then lc=1 end
		local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,lc,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)	
		if #g~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
end
	
