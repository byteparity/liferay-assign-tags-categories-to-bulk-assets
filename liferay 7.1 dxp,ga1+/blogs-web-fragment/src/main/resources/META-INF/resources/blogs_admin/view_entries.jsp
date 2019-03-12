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
<%@ include file="/blogs_admin/init.jsp" %>

<c:set var="now" value="<%=new Date()%>"/>
<fmt:formatDate var="temp" pattern="s" type = "time"  value = "${now}" />

<!-- common.js -->
<script src="/o/com.byteparity.common.component-1.0.0/js/common.js?${temp}"></script> 


<%
String entriesNavigation = ParamUtil.getString(request, "entriesNavigation");

int delta = ParamUtil.getInteger(request, SearchContainer.DEFAULT_DELTA_PARAM);
String orderByCol = ParamUtil.getString(request, "orderByCol", "title");
String orderByType = ParamUtil.getString(request, "orderByType", "asc");

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("mvcRenderCommandName", "/blogs/view");

if (delta > 0) {
	portletURL.setParameter("delta", String.valueOf(delta));
}

portletURL.setParameter("orderBycol", orderByCol);
portletURL.setParameter("orderByType", orderByType);

portletURL.setParameter("entriesNavigation", entriesNavigation);

SearchContainer entriesSearchContainer = new SearchContainer(renderRequest, PortletURLUtil.clone(portletURL, liferayPortletResponse), null, "no-entries-were-found");

entriesSearchContainer.setOrderByComparator(BlogsUtil.getOrderByComparator(orderByCol, orderByType));

BlogEntriesDisplayContext blogEntriesDisplayContext = new BlogEntriesDisplayContext(liferayPortletRequest);

blogEntriesDisplayContext.populateResults(entriesSearchContainer);

BlogEntriesManagementToolbarDisplayContext blogEntriesManagementToolbarDisplayContext = new BlogEntriesManagementToolbarDisplayContext(liferayPortletRequest, liferayPortletResponse, request, currentURLObj, trashHelper);

String displayStyle = blogEntriesManagementToolbarDisplayContext.getDisplayStyle();

// Add new menu in menu items
List iconList = blogEntriesManagementToolbarDisplayContext.getActionDropdownItems();
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
	clearResultsURL="<%= blogEntriesManagementToolbarDisplayContext.getSearchActionURL() %>"
	componentId="blogEntriesManagementToolbar"
	creationMenu="<%= blogEntriesManagementToolbarDisplayContext.getCreationMenu() %>"
	disabled="<%= entriesSearchContainer.getTotal() <= 0 %>"
	filterDropdownItems="<%= blogEntriesManagementToolbarDisplayContext.getFilterDropdownItems() %>"
	itemsTotal="<%= entriesSearchContainer.getTotal() %>"
	searchActionURL="<%= blogEntriesManagementToolbarDisplayContext.getSearchActionURL() %>"
	searchContainerId="blogEntries"
	searchFormName="searchFm"
	showInfoButton="<%= false %>"
	sortingOrder="<%= blogEntriesManagementToolbarDisplayContext.getOrderByType() %>"
	sortingURL="<%= String.valueOf(blogEntriesManagementToolbarDisplayContext.getSortingURL()) %>"
	viewTypeItems="<%= blogEntriesManagementToolbarDisplayContext.getViewTypes() %>"
/>

<portlet:actionURL name="/blogs/edit_entry" var="restoreTrashEntriesURL">
	<portlet:param name="<%= Constants.CMD %>" value="<%= Constants.RESTORE %>" />
</portlet:actionURL>

<liferay-trash:undo
	portletURL="<%= restoreTrashEntriesURL %>"
/>

<div class="container-fluid-1280 main-content-body">
	<aui:form action="<%= portletURL.toString() %>" method="get" name="fm">
		<aui:input name="<%= Constants.CMD %>" type="hidden" />
		<aui:input name="redirect" type="hidden" value="<%= portletURL.toString() %>" />
		<aui:input name="deleteEntryIds" type="hidden" />

		<liferay-asset:categorization-filter
			assetType="entries"
			portletURL="<%= portletURL %>"
		/>

		<liferay-ui:search-container
			id="blogEntries"
			rowChecker="<%= new EmptyOnClickRowChecker(renderResponse) %>"
			searchContainer="<%= entriesSearchContainer %>"
		>
			<liferay-ui:search-container-row
				className="com.liferay.blogs.model.BlogsEntry"
				escapedModel="<%= true %>"
				keyProperty="entryId"
				modelVar="entry"
			>
				<liferay-portlet:renderURL varImpl="rowURL">
					<portlet:param name="mvcRenderCommandName" value="/blogs/edit_entry" />
					<portlet:param name="redirect" value="<%= entriesSearchContainer.getIteratorURL().toString() %>" />
					<portlet:param name="entryId" value="<%= String.valueOf(entry.getEntryId()) %>" />
				</liferay-portlet:renderURL>

				<%@ include file="/blogs_admin/entry_search_columns.jspf" %>
			</liferay-ui:search-container-row>

			<liferay-ui:search-iterator
				displayStyle="<%= displayStyle %>"
				markupView="lexicon"
			/>
		</liferay-ui:search-container>
	</aui:form>
</div>

<aui:script>
	<!-- Start : Open popup window to select Tags and Category   -->
	var assignTags = function() {
		<liferay-portlet:renderURL  var="tagCategoriesSelectorURL" plid="<%= themeDisplay.getPlid() %>" 
			portletName="AssignTagCategoryToAssets"  windowState="<%=LiferayWindowState.POP_UP.toString() %>">
			 		<liferay-portlet:param  name="mvcRenderCommandName" value="/assign_metadata"/>
		</liferay-portlet:renderURL>
		
		openTagCategorySelectDialog('#<portlet:namespace />assignSelectedBlogs',document.<portlet:namespace />fm,"<%= BlogsEntry.class.getName() %>","allRowIds","${tagCategoriesSelectorURL}", "_AssignTagCategoryToAssets_");
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
				}

				var deleteEntryIds = form.querySelector('#<portlet:namespace />deleteEntryIds');

				if (deleteEntryIds) {
					deleteEntryIds.setAttribute('value', Liferay.Util.listCheckedExcept(form, '<portlet:namespace />allRowIds'));
				}

				submitForm(form, '<portlet:actionURL name="/blogs/edit_entry" />');
			}
		}
	};

	<!-- Added new 'assignTags' action   -->
	var ACTIONS = {
		'assignTags': assignTags,
		'deleteEntries': deleteEntries
	};

	Liferay.componentReady('blogEntriesManagementToolbar').then(
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