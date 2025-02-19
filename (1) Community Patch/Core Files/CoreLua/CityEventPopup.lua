-------------------------------------------------
-- Goody Hut Popup
-------------------------------------------------
include("FLuaVector.lua")
local m_PopupInfo = nil;

-------------------------------------------------
-- On Display
-------------------------------------------------
local g_pCity = nil
local tChoiceOverrideStrings = {}
function OnPopup( popupInfo )

	if( popupInfo.Type ~= ButtonPopupTypes.BUTTONPOPUP_MODDER_7 ) then
		return;
	end

	m_PopupInfo = popupInfo;

    local iEventChoiceType = popupInfo.Data1;

	local IsSpy = popupInfo.Option1;
    local pEventChoiceInfo = GameInfo.CityEventChoices[iEventChoiceType];

	-- Top Art
	local pEventInfo = nil
	for row in GameInfo.CityEvent_ParentEvents("CityEventChoiceType = '" .. pEventChoiceInfo.Type .. "'") do
		pEventInfo = GameInfo.CityEvents[row.CityEventType]
		break
	end
	if pEventInfo then
		local pEventArt = pEventInfo.CityEventArt or "cityeventdefaultbackground.dds"
		Controls.EventArt:SetTexture(pEventArt);
		Controls.EventArt:SetSizeVal(350,100);
		
		-- Event Audio
		local pEventAudio = pEventInfo.CityEventAudio
		if pEventAudio then
			Events.AudioPlay2DSound(pEventAudio)
		end
	end
	if(IsSpy)then
		local spyID = popupInfo.Data3;
		local spyOwnerID = popupInfo.Data2;
		local SpyOwner = Players[spyOwnerID];

		local city = SpyOwner:GetCityWithSpy(spyID);	
		if(city ~= nil) then
			g_pCity = city;
			local cityName = city:GetNameKey();
			local localizedCityName = Locale.ConvertTextKey(cityName);

			local szTitleString;
			local szHelpString;

			szTitleString = Locale.Lookup("TXT_KEY_CITY_EVENT_TITLE", localizedCityName, pEventChoiceInfo.Description);
			szHelpString = Locale.Lookup("TXT_KEY_CITY_EVENT_HELP", localizedCityName, city:GetScaledEventChoiceValue(iEventChoiceType, false, spyID, spyOwnerID));
			-- Test for any Override Strings
			tChoiceOverrideStrings = {}
			LuaEvents.EventChoice_OverrideTextStrings(city:GetOwner(), city:GetID(), pEventChoiceInfo, tChoiceOverrideStrings)
			for _,str in ipairs(tChoiceOverrideStrings) do
				szTitleString = str.Description or szTitleString
				szHelpString = str.Help or szHelpString
			end
	
			Controls.TitleLabel:SetText(szTitleString);
			Controls.TitleLabel:SetToolTipString(szTitleString);
			Controls.DescriptionLabel:SetText(szHelpString);
	
			-- Recalculate grid size
			local mainGridSizeY = 400
			local sizeYDiff = math.max((Controls.DescriptionLabel:GetSizeY()-Controls.EventBox:GetSizeY()),1)
			Controls.MainGrid:SetSizeY(mainGridSizeY + sizeYDiff)
			--	SpyOwner:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, szHelpString, Locale.ConvertTextKey("TXT_KEY_CITY_EVENT_NOTIFICATION") .. szTitleString, city:Plot():GetX(), city:Plot():GetY())
			UIManager:QueuePopup( ContextPtr, PopupPriority.InGameUtmost );
		else
			local capitalCity = SpyOwner:GetCapitalCity();
			g_pCity = capitalCity;

			local cityName = capitalCity:GetNameKey();
			local localizedCityName = Locale.ConvertTextKey(cityName);

			local szTitleString;
			local szHelpString;

			szTitleString = Locale.Lookup("TXT_KEY_CITY_EVENT_FLED_TITLE", localizedCityName, pEventChoiceInfo.Description);
			szHelpString = Locale.Lookup("TXT_KEY_CITY_EVENT_FLED_HELP", localizedCityName, capitalCity:GetScaledEventChoiceValue(iEventChoiceType, false, spyID, spyOwnerID));
			-- Test for any Override Strings
			tChoiceOverrideStrings = {}
			LuaEvents.EventChoice_OverrideTextStrings(capitalCity:GetOwner(), capitalCity:GetID(), pEventChoiceInfo, tChoiceOverrideStrings)
			for _,str in ipairs(tChoiceOverrideStrings) do
				szTitleString = str.Description or szTitleString
				szHelpString = str.Help or szHelpString
			end
	
			Controls.TitleLabel:SetText(szTitleString);
			Controls.TitleLabel:SetToolTipString(szTitleString);
			Controls.DescriptionLabel:SetText(szHelpString);
	
			-- Recalculate grid size
			local mainGridSizeY = 400
			local sizeYDiff = math.max((Controls.DescriptionLabel:GetSizeY()-Controls.EventBox:GetSizeY()),1)
			Controls.MainGrid:SetSizeY(mainGridSizeY + sizeYDiff)
			--	SpyOwner:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, szHelpString, Locale.ConvertTextKey("TXT_KEY_CITY_EVENT_NOTIFICATION") .. szTitleString, city:Plot():GetX(), city:Plot():GetY())
			UIManager:QueuePopup( ContextPtr, PopupPriority.InGameUtmost );
		end
	else
	
		local cityID = popupInfo.Data2;
		local ownerID = popupInfo.Data3;
		local owner = Players[ownerID];
		local city = owner:GetCityByID(cityID);
	
		if(city ~= nil) then
			g_pCity = city;
			local cityName = city:GetNameKey();
			local localizedCityName = Locale.ConvertTextKey(cityName);

			local szTitleString;
			local szHelpString;

			szTitleString = Locale.Lookup("TXT_KEY_CITY_EVENT_TITLE", localizedCityName, pEventChoiceInfo.Description);
			szHelpString = Locale.Lookup("TXT_KEY_CITY_EVENT_HELP", localizedCityName, city:GetScaledEventChoiceValue(iEventChoiceType));
			-- Test for any Override Strings
			tChoiceOverrideStrings = {}
			LuaEvents.EventChoice_OverrideTextStrings(ownerID, cityID, pEventChoiceInfo, tChoiceOverrideStrings)
			for _,str in ipairs(tChoiceOverrideStrings) do
				szTitleString = str.Description or szTitleString
				szHelpString = str.Help or szHelpString
			end
	
			Controls.TitleLabel:SetText(szTitleString);
			Controls.TitleLabel:SetToolTipString(szTitleString);
			Controls.DescriptionLabel:SetText(szHelpString);
	
			-- Recalculate grid size
			local mainGridSizeY = 400
			local sizeYDiff = math.max((Controls.DescriptionLabel:GetSizeY()-Controls.EventBox:GetSizeY()),1)
			Controls.MainGrid:SetSizeY(mainGridSizeY + sizeYDiff)
			owner:AddNotification(NotificationTypes.NOTIFICATION_GENERIC, szHelpString, Locale.ConvertTextKey("TXT_KEY_CITY_EVENT_NOTIFICATION") .. szTitleString, city:Plot():GetX(), city:Plot():GetY())
			UIManager:QueuePopup( ContextPtr, PopupPriority.InGameUtmost );
		end
	end
end
Events.SerialEventGameMessagePopup.Add( OnPopup );


----------------------------------------------------------------        
-- Input processing
----------------------------------------------------------------        
function OnCloseButtonClicked ()
    UIManager:DequeuePopup( ContextPtr );
end
Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButtonClicked );


-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function InputHandler( uiMsg, wParam, lParam )
    if uiMsg == KeyEvents.KeyDown then
        if wParam == Keys.VK_ESCAPE or wParam == Keys.VK_RETURN then
            OnCloseButtonClicked();
            return true;
        end
    end
end
ContextPtr:SetInputHandler( InputHandler );

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function OnFindOnMapButtonClicked()
	if (g_pCity) then
		local plot = g_pCity:Plot();
		if plot then
			UI.LookAt(plot, 0);
			local hex = ToHexFromGrid(Vector2(plot:GetX(), plot:GetY()))
			Events.GameplayFX(hex.x, hex.y, -1) 
		end
	end
end
Controls.FindOnMapButton:RegisterCallback( Mouse.eLClick, OnFindOnMapButtonClicked );
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
function ShowHideHandler( bIsHide, bInitState )

    if( not bInitState ) then
        if( not bIsHide ) then
        	UI.incTurnTimerSemaphore();
        	Events.SerialEventGameMessagePopupShown(m_PopupInfo);
        else
            UI.decTurnTimerSemaphore();
            Events.SerialEventGameMessagePopupProcessed.CallImmediate(ButtonPopupTypes.BUTTONPOPUP_MODDER_7, 0);
        end
    end
end
ContextPtr:SetShowHideHandler( ShowHideHandler );

----------------------------------------------------------------
-- 'Active' (local human) player has changed
----------------------------------------------------------------
function OnActivePlayerChanged( iActivePlayer, iPrevActivePlayer )
	if (not ContextPtr:IsHidden()) then
		ContextPtr:SetHide(true);
	end
end
Events.GameplaySetActivePlayer.Add(OnActivePlayerChanged);
