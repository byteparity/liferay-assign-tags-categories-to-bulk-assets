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
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@ include file="/init.jsp" %>

<c:set var="now" value="<%=new Date()%>"/>
<fmt:formatDate var="temp" pattern="s" type = "time"  value = "${now}" />

<!-- common.js -->
<script src="/o/com.byteparity.common.component-1.0.0/js/common.js?${temp}"></script> 


<%
String searchContainerId = ParamUtil.getString(request, "searchContainerId");

//Add new menu in menu items
List iconList = journalDisplayContext.getActionDropdownItems();
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
	clearResultsURL="<%= journalDisplayContext.getClearResultsURL() %>"
	componentId="journalWebManagementToolbar"
	creationMenu="<%= journalDisplayContext.getCreationMenu() %>"
	disabled="<%= journalDisplayContext.isDisabled() %>"
	filterDropdownItems="<%= journalDisplayContext.getFilterDropdownItems() %>"
	infoPanelId="infoPanelId"
	itemsTotal="<%= journalDisplayContext.getTotalItems() %>"
	searchActionURL="<%= journalDisplayContext.getSearchActionURL() %>"
	searchContainerId="<%= searchContainerId %>"
	searchFormName="fm1"
	showCreationMenu="<%= journalDisplayContext.isShowAddButton() %>"
	showInfoButton="<%= journalDisplayContext.isShowInfoButton() %>"
	showSearch="<%= journalDisplayContext.isShowSearch() %>"
	sortingOrder="<%= journalDisplayContext.getOrderByType() %>"
	sortingURL="<%= journalDisplayContext.getSortingURL() %>"
	viewTypeItems="<%= journalDisplayContext.getViewTypeItems() %>"
/>
   
<aui:script sandbox="<%= true %>">
	var assignTags = function() {
		<liferay-portlet:renderURL  var="tagCategoriesSelectorURL" plid="<%= themeDisplay.getPlid() %>" 
			portletName="AssignTagCategoryToAssets"  windowState="<%=LiferayWindowState.POP_UP.toString() %>">
			 		<liferay-portlet:param  name="mvcRenderCommandName" value="/assign_metadata"/>
		</liferay-portlet:renderURL>
		openTagCategorySelectDialog('#<portlet:namespace />assignSelectedArticles',document.<portlet:namespace />fm,"<%= JournalArticle.class.getName() %>","rowIdsJournalFolder","${tagCategoriesSelectorURL}", "_AssignTagCategoryToAssets_");
	}
	var deleteEntries = function() {
		if (<%= trashHelper.isTrashEnabled(scopeGroupId) %> || confirm(' <%= UnicodeLanguageUtil.get(request, "are-you-sure-you-want-to-delete-the-selected-entries") %>')) {
			Liferay.fire(
				'<%= renderResponse.getNamespace() %>editEntry',
				{
					action: '<%= trashHelper.isTrashEnabled(scopeGroupId) ? "moveEntriesToTrash" : "deleteEntries" %>'
				}
			);
		}
	}

	var expireEntries = function() {
		Liferay.fire(
			'<portlet:namespace />editEntry',
			{
				action: 'expireEntries'
			}
		);
	};

	var moveEntries = function() {
		Liferay.fire(
			'<portlet:namespace />editEntry',
			{
				action: 'moveEntries'
			}
		);
	};

	<portlet:renderURL var="viewDDMStructureArticlesURL">
		<portlet:param name="navigation" value="structure" />
		<portlet:param name="folderId" value="<%= String.valueOf(JournalFolderConstants.DEFAULT_PARENT_FOLDER_ID) %>" />
		<portlet:param name="showEditActions" value="<%= String.valueOf(journalDisplayContext.isShowEditActions()) %>" />
	</portlet:renderURL>

	var openStructuresSelector = function() {
		Liferay.Util.selectEntity(
			{
				dialog: {
					constrain: true,
					modal: true
				},
				eventName: '<portlet:namespace />selectStructure',
				title: '<%= UnicodeLanguageUtil.get(request, "structures") %>',
				uri: '<portlet:renderURL windowState="<%= LiferayWindowState.POP_UP.toString() %>"><portlet:param name="mvcPath" value="/select_structure.jsp" /></portlet:renderURL>'
			},
			function(event) {
				var uri = '<%= viewDDMStructureArticlesURL %>';

				uri = Liferay.Util.addParams('<portlet:namespace />ddmStructureKey=' + event.ddmstructurekey, uri);

				location.href = uri;
			}
		);
	}

	var openViewMoreStructuresSelector = function() {
		Liferay.Util.openWindow(
			{
				dialog: {
					destroyOnHide: true,
					modal: true
				},
				id: '<portlet:namespace />selectAddMenuItem',
				title: '<liferay-ui:message key="more" />',

				<portlet:renderURL var="viewMoreURL" windowState="<%= LiferayWindowState.POP_UP.toString() %>">
					<portlet:param name="mvcPath" value="/view_more_menu_items.jsp" />
					<portlet:param name="folderId" value="<%= String.valueOf(journalDisplayContext.getFolderId()) %>" />
					<portlet:param name="eventName" value='<%= renderResponse.getNamespace() + "selectAddMenuItem" %>' />
				</portlet:renderURL>

				uri: '<%= viewMoreURL %>'
			}
		);
	}

	<!-- Added new 'assignTags' action   -->
	var ACTIONS = {
		'assignTags': assignTags,
		'deleteEntries': deleteEntries,
		'expireEntries': expireEntries,
		'moveEntries': moveEntries,
		'openStructuresSelector': openStructuresSelector,
		'openViewMoreStructuresSelector': openViewMoreStructuresSelector
	};

	Liferay.componentReady('journalWebManagementToolbar').then(
		function(managementToolbar) {
			managementToolbar.on(
				['actionItemClicked', 'filterItemClicked'],
				function(event) {
					var itemData = event.data.item.data;

					if (itemData && itemData.action && ACTIONS[itemData.action]) {
						ACTIONS[itemData.action]();
					}
				}
			);

			managementToolbar.on('creationMenuMoreButtonClicked', openViewMoreStructuresSelector);
		}
	);

	<portlet:renderURL var="addArticleURL">
		<portlet:param name="mvcPath" value="/edit_article.jsp" />
		<portlet:param name="redirect" value="<%= currentURL %>" />
		<portlet:param name="groupId" value="<%= String.valueOf(scopeGroupId) %>" />
		<portlet:param name="folderId" value="<%= String.valueOf(journalDisplayContext.getFolderId()) %>" />
	</portlet:renderURL>

	Liferay.on(
		'<portlet:namespace />selectAddMenuItem',
		function(event) {
			var uri = '<%= addArticleURL %>';

			uri = Liferay.Util.addParams('<portlet:namespace />ddmStructureKey=' + event.ddmStructureKey, uri);

			location.href = uri;
		}
	);
	
</aui:script>