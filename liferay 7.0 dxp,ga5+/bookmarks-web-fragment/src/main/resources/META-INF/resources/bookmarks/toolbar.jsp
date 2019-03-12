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

<%@ include file="/bookmarks/init.jsp" %>

<%
String searchContainerId = ParamUtil.getString(request, "searchContainerId");

int total = GetterUtil.getInteger((String)request.getAttribute("view.jsp-total"));

PortletURL portletURL = renderResponse.createRenderURL();

portletURL.setParameter("categoryId", StringPool.BLANK);
portletURL.setParameter("tag", StringPool.BLANK);
%>

<liferay-frontend:management-bar
	disabled="<%= total == 0 %>"
	includeCheckBox="<%= !user.isDefaultUser() %>"
	searchContainerId="<%= searchContainerId %>"
>
	<liferay-frontend:management-bar-buttons>
		<liferay-frontend:management-bar-sidenav-toggler-button
			icon="info-circle"
			label="info"
		/>

		<liferay-util:include page="/bookmarks/display_style_buttons.jsp" servletContext="<%= application %>" />
	</liferay-frontend:management-bar-buttons>

	<liferay-frontend:management-bar-filters>

		<%
		String[] navigationKeys = null;

		if (themeDisplay.isSignedIn()) {
			navigationKeys = new String[] {"all", "recent", "mine"};
		}
		else {
			navigationKeys = new String[] {"all", "recent"};
		}
		%>

		<liferay-frontend:management-bar-navigation
			navigationKeys="<%= navigationKeys %>"
			portletURL="<%= PortletURLUtil.clone(portletURL, liferayPortletResponse) %>"
		/>
	</liferay-frontend:management-bar-filters>

	<liferay-frontend:management-bar-action-buttons>
		<liferay-frontend:management-bar-sidenav-toggler-button
			icon="info-circle"
			label="info"
		/>

		<liferay-frontend:management-bar-button href='<%= "javascript:" + renderResponse.getNamespace() + "deleteEntries();" %>' icon='<%= TrashUtil.isTrashEnabled(scopeGroupId) ? "trash" : "times" %>' label='<%= TrashUtil.isTrashEnabled(scopeGroupId) ? "recycle-bin" : "delete" %>' />
		
		<!-- Start : Added icon for assign Tag and Category --> 
		<liferay-frontend:management-bar-button href="javascript:;" icon="tag" id="assignSelectedBookmarks" label="Assign Tags Or Categories" />	
		<!-- End : Added icon for assign Tag and Category  --> 
		
	</liferay-frontend:management-bar-action-buttons>
</liferay-frontend:management-bar>


<!-- Start : Open popup window to select Tags and Category   -->
	<liferay-portlet:renderURL  var="tagCategoriesSelectorURL" plid="<%= themeDisplay.getPlid() %>" 
		portletName="AssignTagCategoryToAssets"  windowState="<%=LiferayWindowState.POP_UP.toString() %>">
		 		<liferay-portlet:param  name="mvcRenderCommandName" value="/assign_metadata"/>
	</liferay-portlet:renderURL>
	
	<aui:script>
		openTagCategorySelectDialog('#<portlet:namespace />assignSelectedBookmarks',document.<portlet:namespace />fm,"<%= BookmarksEntry.class.getName() %>","rowIdsBookmarksEntry","${tagCategoriesSelectorURL}", "_AssignTagCategoryToAssets_") ;
	</aui:script>
<!-- End : Open popup window to select Tags and Category   -->	

<aui:script>
	function <portlet:namespace />deleteEntries() {
		if (<%= TrashUtil.isTrashEnabled(scopeGroupId) %> || confirm(' <%= UnicodeLanguageUtil.get(request, "are-you-sure-you-want-to-delete-the-selected-entries") %>')) {
			var form = AUI.$(document.<portlet:namespace />fm);

			form.attr('method', 'post');
			form.fm('<%= Constants.CMD %>').val('<%= TrashUtil.isTrashEnabled(scopeGroupId) ? Constants.MOVE_TO_TRASH : Constants.DELETE %>');

			submitForm(form, '<portlet:actionURL name="/bookmarks/edit_entry" />');
		}
	}
		
</aui:script>


<!-- Start : Include Java Script  -->
	<script src="/o/com.byteparity.common.component-1.0.0/js/common.js"></script>
<!-- End : Include Java Script  -->