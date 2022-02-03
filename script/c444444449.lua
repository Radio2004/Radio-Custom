--Saber Hunter Ly, Novella Girl--
Duel.LoadScript("customutility.lua")
local s,id=GetID()
function s.initial_effect(c)
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1BC),1,1)
	--SS
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sstg)
	e1:SetOperation(s.ssop(c))
	c:RegisterEffect(e1)
end

function s.lcheck(g,lc,sumtype,tp)
	return g:IsExists(Card.IsSetCard,1,nil,0x1bc,lc,sumtype,tp)
end
function merge(t1, t2, filter)
	filter=filter or false
	if filter==true then
		local dup=false
		for _, i in ipairs(t2) do
			for _, j in ipairs(t1) do
				dup = (i == j)
				if dup then break end
			end
			if not dup then
				table.insert(t1, i)
			end
		end
	else
		for _, i in ipairs(t2) do
			table.insert(t1, i)
		end
	end
end
--SS

function s.filter(c,e,tp)
	return c:IsSetCard(0x1BC)and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_GRAVE)
end
function s.sfilter(c,e,tp)
	return c:IsSetCard(0x1BC) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function s.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function s.ssop(c)
	return function(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		local effs,acteffs={},{}
		local desc={}
		for tc in aux.Next(g) do
			merge(effs,{tc:GetCardEffect(id)},true)
		end
		local cost,con,tg
		for _,eff in ipairs(effs) do
			con,tg=eff:GetCondition(),eff:GetTarget()
			if (not con or con(e,tp,eg,ep,ev,re,r,rp)) and (not cost or cost(e,tp,eg,ep,ev,re,r,rp,0)) and (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
				table.insert(acteffs,eff:GetLabelObject())
				table.insert(desc,eff:GetLabelObject():GetDescription())
			end
		end
		while #acteffs>0 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) do
			local i=Duel.SelectOption(tp,table.unpack(desc))
			local eff=acteffs[i+1]
			if cost then cost(e,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
			local op=eff:GetOperation()
			op(e,tp,eg,ep,ev,re,r,rp)
			table.remove(acteffs)
			table.remove(desc)
		end
	end