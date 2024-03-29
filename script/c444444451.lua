--Novella: Happiness
local s,id=GetID()
function s.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCountLimit(1,{id,1})
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Change Attribute to EARTH
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1bc))
	e2:SetValue(ATTRIBUTE_EARTH)
	c:RegisterEffect(e2)	
	--cannot destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1bc))
	e3:SetValue(s.indct)
	c:RegisterEffect(e3)
		--def up
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1BC))
	e4:SetValue(s.val)
	c:RegisterEffect(e4)
		--effects
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCountLimit(1,id)
	e5:SetCondition(s.spcon)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
end
s.listed_series={0x1BC}
	function s.indct(e,re,r,rp)
	if (r&REASON_BATTLE)~=0 then
		return 1
	else return 0 end
end

	function s.val(e,c)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)*200
end



	function s.filter1(c)
	return c:IsFaceup()and c:IsSetCard(0x1BC)
	end


	function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.filter1,1,nil)
end


	function s.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x1BC) 
	end


	function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0x1BC),tp,LOCATION_MZONE,0,nil)*300
	local g2=Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
	local b1=g1
	local b2=g2
	if chk==0 then return b1>0 or b2 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
	e:SetCategory(CATEGORY_RECOVER)
	e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(b1)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,b1)
	else
	e:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end


function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
	local rec=Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,0x1bc),tp,LOCATION_MZONE,0,nil)*300
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,rec,REASON_EFFECT)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end