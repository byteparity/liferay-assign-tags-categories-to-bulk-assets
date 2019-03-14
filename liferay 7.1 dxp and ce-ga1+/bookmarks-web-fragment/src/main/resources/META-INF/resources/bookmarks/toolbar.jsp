<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@page import="java.util.Date"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@ include file="/bookmarks/init.jsp" %>
<c:set var="now" value="<%=new Date()%>"/>
<fmt:formatDate var="temp" pattern="s" type = "time"  value = "${now}" />

<!-- common.js -->
<script src="/o/com.byteparity.common.component-1.1.0/js/common.js?${temp}"></script> 

<%
BookmarksManagementToolbarDisplayContext bookmarksManagementToolbarDisplayContext = new BookmarksManagementToolbarDisplayContext(liferayPortletRequest, liferayPortletResponse, request, bookmarksGroupServiceOverriddenConfiguration, portalPreferences, trashHelper);
// Add new menu in menu items
 List iconList = bookmarksManagementToolbarDisplayContext.getActionDropdownItems();
 Map<String,Object> newIcon = new HashMap<String,Object>();
 Map<String,String> actionMap = new HashMap<String,String>();
 actionMap.put("action", "assignTags");
 newIcon.put("data", actionMap);
 newIcon.put("icon", "tag");
 newIcon.put("label", "Assign Tags Or Categories");
 newIcon.put("type", "item");
 newIcon.put("quickAction", true);
 iconList.add(newIcon);
%>

<clay:management-toolbar
	actionDropdownItems="<%= iconList %>"
	clearResultsURL="<%= bookmarksManagementToolbarDisplayContext.getClearResultsURL() %>"
	componentId="bookmarksManagementToolbar"
	creationMenu="<%= bookmarksManagementToolbarDisplayContext.getCreationMenu() %>"
	disabled="<%= bookmarksManagementToolbarDisplayContext.isDisabled() %>"
	filterDropdownItems="<%= bookmarksManagementToolbarDisplayContext.getFilterDropdownItems() %>"
	infoPanelId="infoPanelId"
	itemsTotal="<%= bookmarksManagementToolbarDisplayContext.getTotalItems() %>"
	searchActionURL="<%= String.valueOf(bookmarksManagementToolbarDisplayContext.getSearchActionURL()) %>"
	searchContainerId="<%= bookmarksManagementToolbarDisplayContext.getSearchContainerId() %>"
	selectable="<%= bookmarksManagementToolbarDisplayContext.isSelectable() %>"
	showInfoButton="<%= true %>"
	showSearch="<%= bookmarksManagementToolbarDisplayContext.isShowSearch() %>"
	viewTypeItems="<%= bookmarksManagementToolbarDisplayContext.getViewTypes() %>"
/>

<aui:script>
	<!-- Start : Open popup window to select Tags and Category   -->
	var assignTags = function() {
		<liferay-portlet:renderURL  var="tagCategoriesSelectorURL" plid="<%= themeDisplay.getPlid() %>" 
			portletName="AssignTagCategoryToAssets"  windowState="<%=LiferayWindowState.POP_UP.toString() %>">
			 		<liferay-portlet:param  name="mvcRenderCommandName" value="/assign_metadata"/>
		</liferay-portlet:renderURL>
		
		openTagCategorySelectDialog('#<portlet:namespace />assignSelectedBookmarks',document.<portlet:namespace />fm,"<%= BookmarksEntry.class.getName() %>","rowIdsBookmarksEntry","${tagCategoriesSelectorURL}", "_AssignTagCategoryToAssets_");
	}
	<!-- End : Open popup window to select Tags and Category   -->
	var deleteEntries = function() {
		if (<%= trashHelper.isTrashEnabled(scopeGroupId) %> || confirm('<liferay-ui:message key="are-you-sure-you-want-to-delete-the-selected-entries" />')) {
			var form = document.getElementById('<portlet:namespace />fm');

			if (form) {
				form.setAttribute('method', 'post');

				var cmd = form.querySelector('#<portlet:namespace /><%= Constants.CMD %>');

				if (cmd) {
					cmd.setAttribute('value', '<%= trashHelper.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE %>');

					submitForm(form, '<portlet:actionURL name="/bookmarks/edit_entry" />');
				}
			}
		}
	};

	<!-- Added new 'assignTags' action   -->
	var ACTIONS = {
		'assignTags': assignTags,
		'deleteEntries': deleteEntries
	};

	Liferay.componentReady('bookmarksManagementToolbar').then(
		function(managementToolbar) {
			managementToolbar.on(
				'actionItemClicked',
				function(event) {
					var itemData = event.data.item.data;

					if (itemData && itemData.action && ACTIONS[itemData.action]) {
						ACTIONS[itemData.action]();
					}
				}
			);
		}
	);
</aui:script>