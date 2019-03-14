<%@page import="com.liferay.blogs.kernel.model.BlogsEntry"%>
<%@ include file="init.jsp"%>
<%

	String assetIds = ParamUtil.getString(request, "assetIds");
	String assetType = ParamUtil.getString(request, "assetType");
	String nodeId = "0" ;
	if(assetType.equals(WikiPage.class.getName()) ) {
		 nodeId = ParamUtil.getString(request, "nodeId");
	}
	
	String[] assetIDsArray = assetIds.split(",");
	String className ="";
	int count =0;
	String warning="" ;
	if(assetType.equals(JournalArticle.class.getName())) {
		className = JournalArticle.class.getName();
		warning = "Action applied to Web Contents only.";
	}else if(assetType.equals(BookmarksEntry.class.getName())) {
		className = BookmarksEntry.class.getName();
		warning = "Action applied to Bookemarks only.";
	} else if(assetType.equals(MBThread.class.getName())) {
		className = MBThread.class.getName();
		warning = "Action applied to Threads only.";
	} else if(assetType.equals(DLFileEntry.class.getName())) {
		className = DLFileEntry.class.getName();
		warning = "Action applied to Documents only.";
	} else if(assetType.equals(BlogsEntry.class.getName())) {
		className = BlogsEntry.class.getName();
		warning = "Action applied to Blogs only.";
	}
%>

<portlet:resourceURL id="/assignEntries" var="assignTagsCategoryURL">
</portlet:resourceURL>

<div class="container">
	<div id="msgDiv"></div>
	<div id="successDiv"></div>
	<liferay-asset:asset-categories-error />
	<liferay-asset:asset-tags-error />
	<aui:form name="metadataForm">
		<c:if test="<%= !assetType.equals(MBThread.class.getName()) %>">
			<div>
				<liferay-ui:message key="categories" />
			</div>
			<aui:field-wrapper>
				<liferay-asset:asset-categories-selector>
				</liferay-asset:asset-categories-selector>
			</aui:field-wrapper>
		</c:if>
		<aui:field-wrapper>
			<liferay-asset:asset-tags-selector
				className="<%= className %>"
			/>
		</aui:field-wrapper>
		<hr/>
		<aui:button type="button" cssClass="btn btn-primary" name="button" value="submit" onClick="asssignCategoriesOrTags()"/>
	</aui:form>
</div>
	
<script>
	var assets = "<%= assetIds %>" ;
	var assetType = "<%= assetType %>" ;
	var nodeId = "<%= nodeId %>" ; 
	var assetcount = "<%= count %>" ;
	var warning = "<%= warning %>" ;
	if(warning != "") {
		showNotificationMsg("#msgDiv","warning",warning);
	}
	
	//Submit assign tags and categories
	function asssignCategoriesOrTags(){
		//_AssignTagCategoryToAssets_assetCategoryIds
		var categories = document.getElementById("<portlet:namespace/>assetCategoryIds");
		var assetTagNames = document.getElementById("<portlet:namespace/>assetTagNames");
		var categoryIDs = 0;
		if (categories == null) {
			categoryIDs = 0;
		} else {
			categoryIDs = categories.value;
		}
		if(categoryIDs == "" && assetTagNames.value == "") {
			alert("Please Select Category or Tag ");
		} else {
			setAssetsData(categoryIDs, assetTagNames.value, assets, assetType, nodeId);							
		}
	}
	
	// Assign Tag and Category resource call
	function setAssetsData(categoryIds, tagNames, assets, assetType, nodeId) {
		$.ajax({
			type : "POST",
			url : "${assignTagsCategoryURL}&<portlet:namespace/>assetCategoryIds="
					+ categoryIds
					+ "&<portlet:namespace/>assetTagNames="
					+ tagNames
					+ "&<portlet:namespace/>assetIds="
					+ assets
					+ "&<portlet:namespace/>assetType="
					+ assetType
					+ "&<portlet:namespace/>nodeId=" + nodeId,
			dataType : 'json',
			contentType : 'application/json',
			success : function(data) {
				showNotificationMsg("#msgDiv", "success", "Your request completed successfully.");
			},
			error :  function(error) {
				showNotificationMsg("#successDiv", "danger", "Failed to Complete your request.");
			} 
		});
	}
</script>



